import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:shambadunia/ui/summary.dart';
import 'package:shambadunia/utils/settingUtils.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';
import 'dart:io';

import 'package:google_maps_webservice/places.dart';

const kGoogleApiKey = "AIzaSyB4v6BVOSbEOKdKj4IpAiRd14pTQVG0gDM";

// to get places detail (lat/lng)
GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);
final searchScaffoldKey = GlobalKey<ScaffoldState>();

class ChooseDelivery extends StatefulWidget {
  final String productRegion;
  final String productLocation;
  final String productLatitude;
  final String productLongitude;
  final String vendorid;

  const ChooseDelivery(
      {Key key,
      this.productRegion,
      this.productLocation,
      this.productLatitude,
      this.productLongitude,
      this.vendorid})
      : super(key: key);

  @override
  _ChooseDeliveryState createState() => _ChooseDeliveryState();
}

class _ChooseDeliveryState extends State<ChooseDelivery> {
  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Mode _mode = Mode.fullscreen;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  bool isLoading = false;

  Position _currentPosition;
  String _currentAddress = '';
  String _anotherAddress = '';
  String _name = "";
  String _thoroughfare = "";
  String _subLocality = "";
  String _subAdministrativeArea = "";
  String _locality = "";
  String _country = "";
  String deliveryCost = '0';
  bool _isLoading = false;
  bool _loadCost = false;
  bool _showRegionDoentMatchError = false;
  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex;

  _getAddressFromLatLng(var a, var b) async {
    try {
      setState(() {
        _isLoading = true;
        _showRegionDoentMatchError = false;
      });
      List<Placemark> p = await geolocator.placemarkFromCoordinates(a, b);

      Placemark place = p[0];

      String reg = place.administrativeArea.toLowerCase();
      if (reg == 'dar es salam') {
        reg = "dar es salaam";
      }


      bool isRegionMatch =
          reg.contains(new RegExp(widget.productRegion, caseSensitive: false));
      if (isRegionMatch) {
        setState(() {
          _showRegionDoentMatchError = false;
          _getCost(a.toString() + ', ' + b.toString(), widget.productLocation);
        });
      } else {
        setState(() {
          _showRegionDoentMatchError = true;
        });
      }

      setState(() {
        _currentAddress =
        "${place.thoroughfare},${place.subLocality},${place.subAdministrativeArea}, ${place.locality}, ${place.country}";
        _name = place.name;
        _thoroughfare = place.thoroughfare;
        _subLocality = place.subLocality;
        _subAdministrativeArea = place.subAdministrativeArea;
        _locality = place.locality;
        _country = place.country;
        _isLoading = false;
      });
    } catch (e) {
      print(e);
    }
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    setState(() {
      _isLoading = true;
    });
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
          await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;
      _getAddressFromLatLng(lat, lng);
      setState(() {
        _anotherAddress = p.description;
      });
      //_goToTheLake();
      //print(p.description);

      /*scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );*/
    }
  }

  _getCurrentLocation() {
    setState(() {
      _isLoading = true;
      _showRegionDoentMatchError = false;
    });
    geolocator
        .getCurrentPosition(desiredAccuracy: LocationAccuracy.best)
        .then((Position position) async {
      setState(() {
        _currentPosition = position;
      });

      String from = _currentPosition.latitude.toString() +
          ', ' +
          _currentPosition.longitude.toString();

      List<Placemark> p = await geolocator.placemarkFromCoordinates(
          _currentPosition.latitude, _currentPosition.longitude);

      Placemark place = p[0];
      String reg = place.administrativeArea.toLowerCase();
      if (reg == 'dar es salam') {
        reg = "dar es salaam";
      }

      setState(() {
        _currentAddress =
        "${place.thoroughfare},${place.subLocality},${place.subAdministrativeArea}, ${place.locality}, ${place.country}";
        _anotherAddress =
        "${place.name}, ${place.administrativeArea}, ${place.country}";
        _name = place.name;
        _thoroughfare = place.thoroughfare;
        _subLocality = place.subLocality;
        _subAdministrativeArea = place.subAdministrativeArea;
        _locality = place.locality;
        _country = place.country;
      });

      bool isRegionMatch =
          reg.contains(new RegExp(widget.productRegion, caseSensitive: false));
      if (isRegionMatch) {
        _showRegionDoentMatchError = false;
        _getCost(from, widget.productLocation);
      } else {
        setState(() {
          _showRegionDoentMatchError = true;
        });
      }

      setState(() {
        _isLoading = false;
      });
    }).catchError((e) {
      print(e);
    });
  }

  _getCost(String from, String to) async {
    setState(() {
      _loadCost = true;
      deliveryCost = '0';
    });
    var responseJson = await NetworkUtils.getCost(from, to);
    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
    } else if (responseJson['status'] == 202) {
      NetworkUtils.showSnackBar(_scaffoldKey, responseJson['message']);
    } else if (responseJson['status'] == 200) {
      setState(() {
        deliveryCost = responseJson['bodacost'].toString();
      });
    }
    setState(() {
      _loadCost = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Delivery', style: TextStyle(fontSize: 16.0)),
        backgroundColor: Colors.teal,
      ),
      body: Container(
        padding: EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Text(
                'NOTE : Turn On your GPS',
                style: TextStyle(
                    fontWeight: FontWeight.bold, fontStyle: FontStyle.italic),
              ),
            ),
            InkWell(
              onTap: () => _getCurrentLocation(),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.teal[900]),
                child: Center(
                  child: Text(
                    'USE YOUR CURRENT LOCATION',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Container(
              height: 8.0,
            ),
            InkWell(
              onTap: () => _handlePressButton(),
              child: Container(
                padding: EdgeInsets.all(10.0),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5.0),
                    color: Colors.teal[800]),
                child: Center(
                  child: Text(
                    'SELECT DELIVERY LOCATION',
                    style: TextStyle(fontSize: 14.0, color: Colors.white),
                  ),
                ),
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  _isLoading
                      ? Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        )
                      : _currentAddress == ''
                          ? Container()
                          : Container(
                              padding: EdgeInsets.all(16.0),
                              margin: EdgeInsets.only(top: 16.0),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.green[900], width: 2.0),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      'DELIVERY LOCATION',
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Divider(
                                    color: Colors.orange,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Text(
                                      _currentAddress,
                                      style: TextStyle(
                                          fontSize: 14.0,
                                          fontWeight: FontWeight.bold,
                                          height: 1.5),
                                    ),
                                  ),
                                  _anotherAddress == ''
                                      ? Container()
                                      : Divider(),
                                  _anotherAddress == ''
                                      ? Container()
                                      : Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Text(
                                            _anotherAddress,
                                            style: TextStyle(
                                                fontSize: 14.0,
                                                fontWeight: FontWeight.bold,
                                                height: 1.5),
                                          ),
                                        ),
                                ],
                              ),
                            ),
                ],
              ),
            ),
            _isLoading
                ? SizedBox() : _showRegionDoentMatchError
                ? Container(
              padding: EdgeInsets.all(16.0),
                    decoration: BoxDecoration(color: Colors.red[900], borderRadius: BorderRadius.circular(8.0)),
                    child: Text(
                        'Sorry! This Vendor is currently deliver to '+widget.productRegion+' Only.', style: TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold,color: Colors.white),),
                  )
                : Container(),
            _showRegionDoentMatchError ? Container() : _isLoading
                ? SizedBox()
                : _loadCost
                    ? Container()
                    : deliveryCost == '0'
                        ? Container()
                        : Center(
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                'DELIVERY COST : ' +
                                    SettingsUtils.formatCurrency(
                                        double.parse(deliveryCost)) +
                                    ' Tsh',
                                style: TextStyle(
                                    fontSize: 18.0,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.teal[900]),
                              ),
                            ),
                          ),
            _showRegionDoentMatchError ? Container() : _isLoading
                ? SizedBox()
                : _loadCost
                    ? Container(
                        height: 45.0,
                        margin: EdgeInsets.all(4.0),
                        decoration: BoxDecoration(
                            color: Colors.teal[900],
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0))),
                        child: Center(
                            child: Container(
                                height: 20.0,
                                width: 20.0,
                                child: CircularProgressIndicator())),
                      )
                    : deliveryCost == '0'
                        ? Container()
                        : InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => Summary(
                                            deliveryLocation: _currentAddress,
                                            anotherdeliveryLocation: _anotherAddress,
                                            deliveryCost: deliveryCost,
                                            deliveryLat: widget.productLatitude,
                                            deliveryLong:
                                                widget.productLongitude,
                                            productLocation:
                                                widget.productLocation,
                                            vendorid: widget.vendorid,
                                          )));
                            },
                            child: Container(
                              height: 45.0,
                              margin: EdgeInsets.all(4.0),
                              decoration: BoxDecoration(
                                  color: Colors.teal[900],
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(5.0))),
                              child: Center(
                                  child: Text(
                                "CONTINUE",
                                style: TextStyle(color: Colors.white),
                              )),
                            ),
                          )
          ],
        ),
      ),
    );
  }

  Future<void> _goToTheLake() async {
    final GoogleMapController controller = await _controller.future;
    controller.animateCamera(CameraUpdate.newCameraPosition(_kGooglePlex));
  }

  void onError(PlacesAutocompleteResponse response) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<void> _handlePressButton() async {
    // show input autocomplete with selected mode
    // then get the Prediction selected
    Prediction p = await PlacesAutocomplete.show(
      context: context,
      apiKey: kGoogleApiKey,
      onError: onError,
      mode: _mode,
      language: "en",
      components: [Component(Component.country, "tz")],
    );

    displayPrediction(p, _scaffoldKey.currentState);
  }
}

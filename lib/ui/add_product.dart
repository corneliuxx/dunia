import 'dart:async';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_google_places/flutter_google_places.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_maps_webservice/places.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shambadunia/utils/settingUtils.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductState createState() => _AddProductState();
}

class _AddProductState extends State<AddProduct> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _descriptionController = TextEditingController();

  TextEditingController _quantityController = TextEditingController();
  TextEditingController _priceController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _subcategoryController = TextEditingController();

  final Geolocator geolocator = Geolocator()..forceAndroidLocationManager;
  Mode _mode = Mode.fullscreen;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  bool isLoading = false;
  String photoPath;
  String photoPath2;
  String _photo = "";
  double _latitude;
  double _longitude;
  String _location = "";


  List<String> _units = ['Kgs', 'Tons', 'Items', 'Machines', 'Packets']; // Option 2
  String _selectedUnit; // Option 2

  File _image;
  File _image2;

  Future getImage() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image = image;
      photoPath = SettingsUtils.getBase64Image(_image);
    });
  }  Future getImage2() async {
    var image = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _image2 = image;
      photoPath2 = SettingsUtils.getBase64Image(_image2);
    });
  }

  static const kGoogleApiKey = "AIzaSyA96UsHhm5e35tTQyL9Bi-IdJgc5aYIiuE";
  GoogleMapsPlaces _places = GoogleMapsPlaces(apiKey: kGoogleApiKey);

  Completer<GoogleMapController> _controller = Completer();

  CameraPosition _kGooglePlex;

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

  void onError(PlacesAutocompleteResponse response) {
    _scaffoldKey.currentState.showSnackBar(
      SnackBar(content: Text(response.errorMessage)),
    );
  }

  Future<Null> displayPrediction(Prediction p, ScaffoldState scaffold) async {
    if (p != null) {
      // get detail (lat/lng)
      PlacesDetailsResponse detail =
      await _places.getDetailsByPlaceId(p.placeId);
      final lat = detail.result.geometry.location.lat;
      final lng = detail.result.geometry.location.lng;

      setState(() {
        _kGooglePlex = CameraPosition(
          target: LatLng(lat, lng),
          zoom: 15.2,
        );
        _location = p.description;
        _latitude = detail.result.geometry.location.lat;
        _longitude = detail.result.geometry.location.lng;
      });

      scaffold.showSnackBar(
        SnackBar(content: Text("${p.description} - $lat/$lng")),
      );
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Add Product',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: ListView(
          children: <Widget>[
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Title"),
                  ),
                ),
              ],
            ),
            Container(
              height: 16.0,
            ),
            TextField(
              controller: _descriptionController,
              minLines: 1,
              maxLines: 5,
              decoration: InputDecoration(labelText: "Description"),
            ),
            Container(
              height: 8.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _quantityController,
                    decoration: InputDecoration(labelText: "Quantity"),
                  ),
                ),
                Container(
                  width: 16.0,
                ),
                Expanded(
                  child: Container(
                    margin: EdgeInsets.only(top: 24.0),
                    child: DropdownButton(
                      hint: Text('Choose a Unit'), // Not necessary for Option 1
                      value: _selectedUnit,
                      onChanged: (newValue) {
                        setState(() {
                          _selectedUnit = newValue;
                        });
                      },
                      items: _units.map((val) {
                        return DropdownMenuItem(
                          child: new Text(val),
                          value: val,
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 16.0,
            ),
            InkWell(
              onTap: () => _handlePressButton(),
              child: Container(
                height: 45.0,
                color: Colors.blueGrey[100],
                child: Center(
                  child: _location == '' ? Text('Select Product Location') : Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(_location),
                  ),
                ),
              ),
            ),
            Container(
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    keyboardType: TextInputType.number,
                    controller: _priceController,
                    decoration: InputDecoration(labelText: "Price"),
                  ),
                ),
                Container(
                  width: 16.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _weightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "Weight per Unit"),
                  ),
                ),
              ],
            ),
            Container(
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  flex: 4,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () => getImage(),
                    child: Container(
                      height: 140.0,
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300], width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: _image == null
                              ? Text('Product Photo 1')
                              : Image.file(_image),
                        ),
                      ),
                    ),
                  ),
                ),
                Container(width: 8.0,),
                Expanded(
                  flex: 4,
                  child: FlatButton(
                    padding: EdgeInsets.all(0.0),
                    onPressed: () => getImage(),
                    child: Container(
                      height: 140.0,
                      margin: EdgeInsets.only(top: 8.0, bottom: 8.0),
                      decoration: BoxDecoration(
                          border:
                              Border.all(color: Colors.grey[300], width: 1.0),
                          borderRadius: BorderRadius.all(Radius.circular(5.0))),
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: _image == null
                              ? Text('Product Photo 2')
                              : Image.file(_image2),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Container(
              height: 16.0,
            ),
            Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _categoryController,
                    decoration: InputDecoration(labelText: "Category"),
                  ),
                ),
                Container(
                  width: 16.0,
                ),
                Expanded(
                  child: TextField(
                    controller: _subcategoryController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(labelText: "SubCategory"),
                  ),
                ),
              ],
            ),
            Container(
              height: 16.0,
            ),
            isLoading
                ? Container(
                    padding: EdgeInsets.all(16.0),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  )
                : Container(),
            FlatButton(
                padding: EdgeInsets.all(0.0),
                onPressed: () {},
                child: Container(
                  height: 50.0,
                  child: Center(
                      child: Text(
                    "Add",
                    style: TextStyle(color: Colors.white),
                  )),
                  decoration: BoxDecoration(
                      color: Colors.teal,
                      borderRadius: BorderRadius.all(Radius.circular(8.0))),
                )),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_dialog/flutter_custom_dialog.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shambadunia/models/demandModel.dart';
import 'package:shambadunia/network/auth_utils.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:shambadunia/ui/about.dart';
import 'package:shambadunia/ui/account.dart';
import 'package:shambadunia/ui/blog.dart';
import 'package:shambadunia/ui/help.dart';
import 'package:shambadunia/ui/regions.dart';
import 'package:shambadunia/ui/settings.dart';
import 'package:shambadunia/utils/Fcm.dart';
import 'package:shambadunia/utils/NotificationManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Demands extends StatefulWidget {
  @override
  _DemandsState createState() => _DemandsState();
}

class _DemandsState extends State<Demands> {
  List<DemandModel> _demands = List();
  var isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String _phone = '0';
  bool _isLoggedin = false;

  String _name = "";
  String _photo = "";
  String _phonee = "";
  String _email = "";

  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      ///init Notification Manger
      NotificationManager.init(context: context);

      ///init FCM Configure
      Fcm.initConfigure();

    });
    _getDemands();
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);

    if (authToken != null) {
      setState(() {
        _isLoggedin = true;
        _name = AuthUtils.getName(_sharedPreferences);
        _phonee = AuthUtils.getPhone(_sharedPreferences);
        _email = AuthUtils.getEmail(_sharedPreferences);
        _photo = AuthUtils.getPhoto(_sharedPreferences);
      });
    }
  }

  _refresh() {
    _demands = List();
    _getDemands();
  }

  _getDemands() async {
    setState(() {
      isLoading = true;
    });
    var responseJson = await NetworkUtils.getDemands();
    print(responseJson);
    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
    } else if (responseJson['status'] == 404) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Try Again Later');
    } else if (responseJson['status'] == 200) {
      var demands = responseJson['content'];
      _demands =
          (demands as List).map((data) => DemandModel.fromJson(data)).toList();
    }
    setState(() {
      isLoading = false;
    });
  }

  _offerDemand(String phone, String demandid) async {
    setState(() {
      isLoading = true;
    });
    if (phone == '0') {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Please Enter your phone number');
    } else {
      var responseJson = await NetworkUtils.demandoffer(phone, demandid);
      print(responseJson);
      if (responseJson == null) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
      } else if (responseJson['status'] == 404) {
        NetworkUtils.showSnackBar(_scaffoldKey, 'Try Again Later');
      } else if (responseJson['status'] == 200) {
        NetworkUtils.showSnackBar(_scaffoldKey, responseJson['message']);
      }
    }

    setState(() {
      isLoading = false;
    });
  }

  YYDialog YYAlertDialogHeadAndBody(
      String photo, String description, String id) {
    return YYDialog().build()
      ..width = 260
      ..borderRadius = 4.0
      ..text(
        padding: EdgeInsets.all(18.0),
        text: "Je! una hii bidhaa??",
        color: Colors.black,
        fontSize: 18.0,
        fontWeight: FontWeight.w500,
      )
      ..widget(Padding(
        padding: EdgeInsets.all(16.0),
        child: Image.network(
          photo,
          height: 150.0,
        ),
      ))
      ..text(
        padding: EdgeInsets.only(left: 18.0, right: 18.0),
        text: description,
        fontSize: 15.0,
      )
      ..widget(Padding(
        padding: EdgeInsets.all(16.0),
        child: TextField(
          maxLength: 10,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(hintText: 'Enter Phone no'),
          onChanged: (item) {
            setState(() {
              _phone = item;
            });
          },
        ),
      ))
      ..doubleButton(
        padding: EdgeInsets.only(top: 20.0),
        gravity: Gravity.right,
        text1: "CANCEL",
        color1: Colors.deepPurpleAccent,
        fontSize1: 14.0,
        onTap1: () {
          print("Cancelled");
        },
        text2: "SEND",
        color2: Colors.deepPurpleAccent,
        fontSize2: 14.0,
        onTap2: () {
          _offerDemand(_phone, id);
        },
      )
      ..show();
  }

  @override
  Widget build(BuildContext context) {
    YYDialog.init(context);
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'DEMANDS',
          style: TextStyle(fontSize: 14.0),
        ),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
              icon: Icon(
                Icons.refresh,
                color: Colors.white,
              ),
              onPressed: () => _refresh())
        ],
      ),
      drawer: Drawer(
          child: ListView(
            children: <Widget>[
              _isLoggedin
                  ? UserAccountsDrawerHeader(
                accountName: Text(_name),
                accountEmail: Text(_phonee),
                currentAccountPicture: ClipRRect(
                    borderRadius: BorderRadius.circular(50.0),
                    child: Image.asset('assets/images/about.png')),
                decoration: BoxDecoration(color: Colors.teal),
              )
                  : UserAccountsDrawerHeader(
                accountName: Text("Login"),
                accountEmail: null,
                decoration: BoxDecoration(color: Colors.teal),
              ),
              ListTile(
                leading: Icon(Icons.person),
                title: Text('Account'),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Account())),
              ),
              ListTile(
                leading: Icon(Icons.fiber_new),
                title: Text('Blog & News'),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Blog())),
              ),
              ListTile(
                leading: Icon(Icons.location_on),
                title: Text('Regions'),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => Regions())),
              ),
              Divider(),
              ListTile(
                title: Text('About Us'),
                leading: Icon(Icons.info),
                onTap: () => Navigator.push(
                    context, MaterialPageRoute(builder: (context) => About())),
              ),
            ],
          )),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : Container(
              color: Color(0xff707070).withOpacity(0.1),
              padding: EdgeInsets.all(16.0),
              child: _demands.length == 0
                  ? Center(
                      child: Text(
                        'No Demands.',
                        style: TextStyle(fontSize: 12.0),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _demands.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () => YYAlertDialogHeadAndBody(
                              NetworkUtils.imageHost +
                                  'images/demands/thumbnails/' +
                                  _demands[index].photo,
                              _demands[index].description,
                              _demands[index].id.toString()),
                          child: Container(
                            margin: EdgeInsets.only(bottom: 8.0),
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(8.0))),
                            child: Row(
                              children: <Widget>[
                                Expanded(
                                    flex: 3,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Image.network(
                                          NetworkUtils.imageHost +
                                              'images/demands/thumbnails/' +
                                              _demands[index].photo),
                                    )),
                                Expanded(
                                    flex: 7,
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: <Widget>[
                                        Text(
                                          _demands[index].title,
                                          style: TextStyle(
                                              fontSize: 18.0,
                                              fontWeight: FontWeight.w500),
                                        ),
                                        Container(
                                          height: 4.0,
                                        ),
                                        Text(
                                          'Quantity needed: ' +
                                              _demands[index]
                                                  .quantity
                                                  .toString() +
                                              ' ' +
                                              _demands[index].unit,
                                          style: TextStyle(fontSize: 12.0),
                                        ),
                                        Container(
                                          height: 4.0,
                                        ),
                                        Text('Location: ' +
                                            _demands[index].location)
                                      ],
                                    )),
                              ],
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }
}

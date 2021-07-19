import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shambadunia/network/auth_utils.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:shambadunia/ui/login.dart';
import 'package:shambadunia/ui/my_investments.dart';
import 'package:shambadunia/ui/my_orders.dart';
import 'package:shambadunia/ui/settings.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Account extends StatefulWidget {
  @override
  _AccountState createState() => _AccountState();
}

class _AccountState extends State<Account> {
  UserObject user;
  bool logoutUser = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color gridColor = Colors.blueGrey[100];

  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  bool isLoading = false;
  String accountType = "Buyer";
  String photoPath;
  String _name = "";
  String _type = "";
  String _phone = "";
  String _photo = "";


  @override
  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    setState(() {
      isLoading = true;
    });
    _sharedPreferences = await _prefs;
    String authToken = AuthUtils.getToken(_sharedPreferences);

    if (authToken != null) {
      setState(() {
        _name = AuthUtils.getName(_sharedPreferences);
        _type = AuthUtils.getType(_sharedPreferences);
        _phone = AuthUtils.getPhone(_sharedPreferences);
        _photo = AuthUtils.getPhoto(_sharedPreferences);
      });
    }

    setState(() {
      isLoading = false;
    });
  }

  _logout() async {
    await NetworkUtils.logoutUser();
    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => Login()), (route) => false);
  }

  Color appColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Scaffold(
        appBar: AppBar(
          title: Text(
            "Account",
            style: TextStyle(fontSize: 16.0),
          ),
          backgroundColor: appColor,
        ),
        floatingActionButton: FloatingActionButton.extended(onPressed: _logout,backgroundColor: Colors.teal[800],icon: Icon(Icons.arrow_back), label: Text('Logout')),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(
                  strokeWidth: 1.0,
                ),
              )
            : Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: ClipRRect(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)),
                                child: CachedNetworkImage(
                                  imageUrl: NetworkUtils.imageHost +
                                      'images/vendors/' +
                                      _photo,
                                  placeholder: (context, url) => Container(
                                    height: 80.0,
                                    width: 80.0,
                                    color: Colors.grey,
                                    child: Center(),
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Text(
                                  "Welcome, " + _name,
                                  style: TextStyle(height: 1.5),
                                ),
                                Text(
                                  'Phone no: ' + _phone,
                                  style: TextStyle(height: 1.5),
                                ),
                                Text(
                                  'Account Type: ' + _type,
                                  style: TextStyle(height: 1.5),
                                ),
                              ],
                            )
                          ],
                        ),
                        Divider(),
                        Container(
                          padding: EdgeInsets.only(top: 8.0, bottom: 8.0),
                          color: Colors.grey[200],
                          child: Center(child: Text('MY SHAMBADUNIA ACCOUNT')),
                        ),
                        Container(
                          height: 16.0,
                        ),
                        Expanded(
                            child: ListView(
                          children: <Widget>[
                            Row(
                              children: <Widget>[
                                Expanded(
                                    child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => MyOrders())),
                                  child: Container(
                                    height: 100.0,
                                    margin: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(color: gridColor,borderRadius: BorderRadius.circular(10.0)),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(Icons.reorder)),
                                          Text(
                                            'My Orders',
                                            style: TextStyle(fontSize: 12.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                /*
                                    Expanded(
                                        child: InkWell(
                                          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (context) => MyProducts())),
                                          child: Container(
                                            height: 100.0,
                                            color: gridColor,
                                            margin: EdgeInsets.all(2.0),
                                            child: Center(
                                              child: Column(
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                      padding:
                                                      const EdgeInsets.all(4.0),
                                                      child: Icon(Icons.apps)),
                                                  Text('My Products', style: TextStyle(fontSize: 12.0),)
                                                ],
                                              ),
                                            ),
                                          ),
                                        )),*/

                                Expanded(
                                    child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              MyInvestments())),
                                  child: Container(
                                    height: 100.0,
                                    margin: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(color: gridColor,borderRadius: BorderRadius.circular(10.0)),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(Icons.apps)),
                                          Text(
                                            'My Investments',
                                            style: TextStyle(fontSize: 12.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                                Expanded(
                                    child: InkWell(
                                  onTap: () => Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Settings())),
                                  child: Container(
                                    height: 100.0,
                                    margin: EdgeInsets.all(2.0),
                                    decoration: BoxDecoration(color: gridColor,borderRadius: BorderRadius.circular(10.0)),
                                    child: Center(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          Padding(
                                              padding:
                                                  const EdgeInsets.all(4.0),
                                              child: Icon(Icons.settings)),
                                          Text(
                                            'Settings',
                                            style: TextStyle(fontSize: 12.0),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                )),
                              ],
                            ),
                          ],
                        ))
                      ],
                    ),
                  )

        /*floatingActionButton: _isLoggedin
            ? FloatingActionButton.extended(
                onPressed: () => _logout(),
                label: Text("Logout"),
                icon: Icon(Icons.arrow_back),
                backgroundColor: Colors.teal,
              )
            : SizedBox(),*/
      ),
    );
  }
}

class UserObject {
  String firstName, lastName, email;

  UserObject({this.firstName, this.lastName, this.email});
}

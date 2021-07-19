import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shambadunia/network/auth_utils.dart';
import 'package:shambadunia/ui/login.dart';
import 'package:shambadunia/ui/regions.dart';
import 'package:shambadunia/ui/welcome.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
  SharedPreferences _sharedPreferences;
  bool _isLoggedin = false;
  bool _regionDone = false;
  bool _isLoading = false;

  void initState() {
    super.initState();
    _fetchSessionAndNavigate();
  }

  _fetchSessionAndNavigate() async {
    setState(() {
      _isLoading = true;
    });
    _sharedPreferences = await _prefs;
    String region = AuthUtils.getRegion(_sharedPreferences);
    String authToken = AuthUtils.getToken(_sharedPreferences);

    if (region != null) {
      setState(() {
        _regionDone = true;
      });
    }

    if (authToken != null) {
      setState(() {
        _isLoggedin = true;
      });
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Shambadunia",
      color: Color(0xff083508),
      debugShowCheckedModeBanner: false,
      home: _isLoading
          ? Container(
              color: Colors.white,
              child: Center(
                child: CircularProgressIndicator(),
              ),
            )
          : _regionDone ? _isLoggedin ? Welcome() : Login() : Regions(),
    );
  }
}

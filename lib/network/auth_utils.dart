import 'package:shared_preferences/shared_preferences.dart';

class AuthUtils {
  static final endPoint = "oauth/token";

  // Keys to store and fetch data from SharedPreferences
  static final String authTokenKey = 'token';
  static final String name = 'name';
  static final String type = 'type';
  static final String email = 'email';
  static final String phone = 'phone';
  static final String photo = 'photo';
  static final String region = 'region';
  static final String token = 'fcmtoken';

  static String getToken(SharedPreferences prefs) {
    return prefs.getString(authTokenKey);
  }

  static String getName(SharedPreferences prefs) {
    return prefs.getString(name);
  }

  static String getType(SharedPreferences prefs) {
    return prefs.getString(type);
  }

  static String getEmail(SharedPreferences prefs) {
    return prefs.getString(email);
  }

  static String getPhone(SharedPreferences prefs) {
    return prefs.getString(phone);
  }

  static String getPhoto(SharedPreferences prefs) {
    return prefs.getString(photo);
  }

  static String getRegion(SharedPreferences prefs) {
    return prefs.getString(region);
  }

  static insertDetails(var response) async {
    var tokenType = response['token_type'];
    var token = response['access_token'];
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(authTokenKey, tokenType + ' ' + token);
    prefs.setString(name, response['name']);
    prefs.setString(type, response['type']);
    prefs.setString(email, response['email']);
    prefs.setString(phone, response['phone']);
    prefs.setString(photo, response['photo']);
  }

  static insertEmail(String email) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(email, email);
  }

  static insertRegion(String reg) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(region, reg);
  }

  static insertToken(String newtoken) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(token, newtoken);
  }
}

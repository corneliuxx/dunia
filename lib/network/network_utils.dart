import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shambadunia/network/auth_utils.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NetworkUtils {
  static final String productionHost = 'https://shambadunia.co.tz/api/';
  static final String imageHost = 'https://shambadunia.co.tz/';
  //static final String productionHost = 'http://192.168.43.242/shambadunia/public/api/';
  //static final String imageHost = 'http://192.168.43.242/shambadunia/public/';
  static final String host = productionHost;
  static final String signupAPI = 'register';
  static final String resetPasswordAPI = 'reset/password';
  static final String resetAPI = 'reset';
  static final String signoutAPI = 'signout';
  static final String getUserAPI = 'user';
  static final String productsApi = 'products';
  static final String vendorsApi = 'vendors';
  static final String categoryVendorsApi = 'vendors/category';
  static final String vendorProductsApi = 'vendors/products';
  static final String demandsApi = 'demands';
  static final String demandofferApi = 'demandoffer';
  static final String categoriesApi = 'categories';
  static final String projectsApi = 'projects';
  static final String newsApi = 'news';
  static final String searchprojectApi = 'searchproject';
  static final String searchnewsApi = 'searchnews';
  static final String searchproductApi = 'search/product';
  static final String imagesApi = 'images/product';
  static final String payApi = 'pay';
  static final String paycashApi = 'paycash';
  static final String myordersApi = 'myorders';
  static final String myinvestmentsApi = 'myinvestments';
  static final String projectProgressApi = 'viewproject';
  static final String investApi = 'invest';
  static final String verifyTokenApi = 'verifytoken';
  static final String verifyInvestmentTokenApi = 'verifyinvestmenttoken';
  static final String cancelTokenApi = 'canceltoken';
  static final String cancelinvestmentTokenApi = 'cancelinvestmenttoken';
  static final String subcategoryApi = 'subcategory/products/';
  static final String getCostApi = 'getcost';

  static dynamic authenticateUser(String username, String password) async {
    var uri = imageHost + AuthUtils.endPoint;
    print(uri);

    try {
      Map<String, String> headers = {"Accept": "application/json"};

      final response = await http.post(uri, headers: headers, body: {
        'grant_type': 'password',
        'client_id': '2',
        'client_secret': "C3onxsj0e6MGwCrcI1UNrgkAEv83v0dkY4yq8Iji",
        'username': username,
        'password': password
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic resetPassword(String phone) async {
    var uri = host + NetworkUtils.resetPasswordAPI;
    print(uri);
    try {
      Map<String, String> headers = {"Accept": "application/json"};

      final response = await http.post(uri, headers: headers, body: {
        'phone': phone
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic reset(String phone,String password,String password_confirmation,String code) async {
    var uri = host + NetworkUtils.resetAPI;
    try {
      Map<String, String> headers = {"Accept": "application/json"};

      final response = await http.post(uri, headers: headers, body: {
        'phone': phone,
        'password': password,
        'password_confirmation': password_confirmation,
        'code': code,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic registerUser(String name, String phone, String signature, String firebaseToken, String password) async {
    Uri uri = Uri.parse(host + NetworkUtils.signupAPI);

    print(uri);

    try {
      Map<String, String> headers = {
        "Accept": "application/json",
      };

      final request = new http.MultipartRequest('POST', uri);
      request.fields['name'] = name;
      request.fields['phone'] = phone;
      request.fields['password'] = password;
      request.fields['signature'] = signature;
      request.fields['firebasetoken'] = firebaseToken;
      request.headers.addAll(headers);

          var response = await request.send();
      final responseJson = json.decode(await response.stream.bytesToString());
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic logoutUser() async {
    //var uri = host + NetworkUtils.signoutAPI;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    _sharedPreferences.clear();
    return true;
  }


  static dynamic getVendors() async {
    var uri = host + NetworkUtils.vendorsApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences = await _prefs;
    String region = AuthUtils.getRegion(_sharedPreferences);
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'region': region
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getCategoryVendors(var categoryID) async {
    var uri = host + NetworkUtils.categoryVendorsApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences = await _prefs;
    String region = AuthUtils.getRegion(_sharedPreferences);
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'region': region,
        'category_id': categoryID
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getVendorProducts(String vendorID) async {
    var uri = host + NetworkUtils.vendorProductsApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'vendor_id': vendorID
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getDemands() async {
    var uri = host + NetworkUtils.demandsApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic demandoffer(String phone, String demandid) async {
    var uri = host + NetworkUtils.demandofferApi;
    print(uri);
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'phone': phone,
        'demand_id': demandid
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getCategories() async {
    var uri = host + NetworkUtils.categoriesApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getProjects() async {
    var uri = host + NetworkUtils.projectsApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
  static dynamic getNews() async {
    var uri = host + NetworkUtils.newsApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic searchProject(String query) async {
    var uri = host + NetworkUtils.searchprojectApi+'/'+query;
    print(uri);

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
  static dynamic searchNews(String query) async {
    var uri = host + NetworkUtils.searchnewsApi+'/'+query;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic searchProduct(String query) async {
    var uri = host + NetworkUtils.searchproductApi;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String region = AuthUtils.getRegion(_sharedPreferences);
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'search': query,
        'region': region
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getCost(String from, String to) async {
    var uri = host + NetworkUtils.getCostApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers,body: {
        'product_location': from,
        'delivery_location': to,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getsubCatProducts(String id) async {
    var uri = host + NetworkUtils.subcategoryApi + id;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic getproductImages(int productid) async {
    var uri = host + NetworkUtils.imagesApi;
    print(uri);

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'product_id': productid.toString(),
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic payNow(String products, String sellerlocation,String buyerlocation,String deriverycost, String amount, String method,String provider, String phone, String vendorid) async {
    var uri = host + NetworkUtils.payApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'products': products,
        'sellerlocation': sellerlocation,
        'buyerlocation': buyerlocation,
        'deliverycost': deriverycost,
        'amount': amount,
        'paymentmethod': method,
        'provider': provider,
        'phone': phone,
        'vendorid': vendorid,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic paycashNow(String products, String sellerlocation,String buyerlocation,String deriverycost, String amount, String vendorid) async {
    var uri = host + NetworkUtils.paycashApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    String phoneno = AuthUtils.getPhone(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'products': products,
        'sellerlocation': sellerlocation,
        'buyerlocation': buyerlocation,
        'deliverycost': deriverycost,
        'amount': amount,
        'phone': phoneno,
        'vendorid': vendorid,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic investNow(int projectid, String projecttitle, String roi, String amount, String method,String provider, String phone) async {
    var uri = host + NetworkUtils.investApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    String username = AuthUtils.getName(_sharedPreferences);
    print(username);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'username': username,
        'projectid': projectid.toString(),
        'projecttitle': projecttitle,
        'roi': roi,
        'amount': amount,
        'paymentmethod': method,
        'provider': provider,
        'phone': phone,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic verifyToken(String token) async {
    var uri = host + NetworkUtils.verifyTokenApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'token': token,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic verifyInvestmentToken(String token) async {
    var uri = host + NetworkUtils.verifyInvestmentTokenApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'token': token,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic cancelToken(String token) async {
    var uri = host + NetworkUtils.cancelTokenApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'token': token,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic cancelinvestmentToken(String token) async {
    var uri = host + NetworkUtils.cancelinvestmentTokenApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.post(uri, headers: headers, body: {
        'token': token,
      });

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic myorders() async {
    var uri = host + NetworkUtils.myordersApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    print(token);
    Map<String, String> headers = {
      "Authorization": token,
      "Accept": "application/json",
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }
  static dynamic myinvestments() async {
    var uri = host + NetworkUtils.myinvestmentsApi;
    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Authorization": token,
      "Accept": "application/json",
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }

  static dynamic projectProgress(String query) async {
    var uri = host + NetworkUtils.projectProgressApi+'/'+query;

    Future<SharedPreferences> _prefs = SharedPreferences.getInstance();
    SharedPreferences _sharedPreferences;
    _sharedPreferences = await _prefs;
    String token = AuthUtils.getToken(_sharedPreferences);
    Map<String, String> headers = {
      "Accept": "application/json",
      "Authorization" : token
    };

    try {
      final response = await http.get(uri, headers: headers);

      final responseJson = json.decode(response.body);
      return responseJson;
    } catch (exception) {
      print(exception);
      if (exception.toString().contains('SocketException')) {
        return 'NetworkError';
      } else {
        return null;
      }
    }
  }


  static showSnackBar(GlobalKey<ScaffoldState> scaffoldKey, String message) {
    scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: new Text(message ?? 'You are offline'),
    ));
  }
}

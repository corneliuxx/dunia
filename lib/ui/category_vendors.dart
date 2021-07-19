import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:shambadunia/models/vendorsModel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shambadunia/ui/vendor_products.dart';
import 'package:shambadunia/utils/Fcm.dart';
import 'package:shambadunia/utils/NotificationManager.dart';
import 'package:flutter/cupertino.dart';
import 'package:shambadunia/database/database_helper.dart';
import 'package:shambadunia/network/auth_utils.dart';
class CategoryVendor extends StatefulWidget {
  final String categoryId;
  final String name;
  final String photo;
  final List subcategory;

  const CategoryVendor({Key key, this.name, this.subcategory, this.categoryId, this.photo})
      : super(key: key);
  @override
  _CategoryVendorState createState() => _CategoryVendorState();
}

class _CategoryVendorState extends State<CategoryVendor> {
  Color appColor = Colors.teal;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  List<VendorsModel> _vendors = List();
  bool isLoading = false;
  bool _isLoggedin = false;

  String _name = "";
  String _photo = "";
  String _email = "";
  String _phone = "";
  String _region = "";
  bool _search = false;

  _getVendors() async {
    setState(() {
      isLoading = true;
    });
    var responseJson = await NetworkUtils.getCategoryVendors(widget.categoryId);
    print(responseJson);
    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
    } else if (responseJson['status'] == 202) {
      NetworkUtils.showSnackBar(_scaffoldKey, responseJson['message']);
    } else if (responseJson['status'] == 200) {
      var vendors = responseJson['content'];
      _vendors =
          (vendors as List).map((data) => VendorsModel.fromJson(data)).toList();
    }

    setState(() {
      isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();

    Future.delayed(Duration.zero,(){
      NotificationManager.init(context: context);
      Fcm.initConfigure();
    });

    _getVendors();
    _fetchSessionAndNavigate();
    deleteCart();
  }
  int _counter = 0;
  final dbHelper = DatabaseHelper.instance;

  Future<void> deleteCart() async {
    final id = await dbHelper.deleteAll();
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
        _email = AuthUtils.getEmail(_sharedPreferences);
        _phone = AuthUtils.getPhone(_sharedPreferences);
        _photo = AuthUtils.getPhoto(_sharedPreferences);
        _region = AuthUtils.getRegion(_sharedPreferences);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          widget.name + " - VENDORS",
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: isLoading
          ? Center(
        child: Container(height:20.0,width: 20.0,child: CircularProgressIndicator()),
      )
          : _vendors.length == 0
          ? Center(
        child: Text('No vendors from ' + _region),
      )
          : Padding(
            padding: const EdgeInsets.all(8.0),
            child: ListView.builder(
        shrinkWrap: true,
        physics: ScrollPhysics(),
        itemCount: _vendors.length,
        itemBuilder: (context, index) => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              InkWell(
                onTap: () => Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => VendorProducts(
                          id: _vendors[index].id,
                          name: _vendors[index].name,
                          photo: _vendors[index].photo,
                          location:
                          _vendors[index].location,
                          latitude:
                          _vendors[index].latitude,
                          longitude:
                          _vendors[index].longitude,
                        ))),
                child: Container(
                  margin: EdgeInsets.all(8.0),
                  height: 234.0,
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                      BorderRadius.circular(4.0)),
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.stretch,
                    children: <Widget>[
                      ClipRRect(
                        child:
                        CachedNetworkImage(
                          imageUrl: NetworkUtils.imageHost +
                              'images/vendors/' +
                              _vendors[index].photo,fit: BoxFit.fitWidth, height: 170.0,
                          placeholder: (context, url) => Container(
                            height: 100.0,
                            color: Colors.grey,
                            child: Center(),
                          ),
                          errorWidget: (context, url, error) =>
                              Icon(Icons.error),
                        ),
                        borderRadius: BorderRadius.only(
                          topRight: Radius.circular(4.0),
                          topLeft: Radius.circular(4.0),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0),
                        child: Text(_vendors[index].name,maxLines: 1,
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w500)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(
                            top: 8.0, left: 8.0),
                        child: Text(_vendors[index].status,
                            style: TextStyle(
                                fontSize: 14.0,
                                color: Colors.green,
                                fontWeight: FontWeight.w500)),
                      ),
                    ],
                  ),
                ),
              ),
            ],
        ),
      ),
          ),
    );
  }
}

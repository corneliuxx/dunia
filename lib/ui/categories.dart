import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:shambadunia/models/categoryModel.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:shambadunia/ui/about.dart';
import 'package:shambadunia/ui/account.dart';
import 'package:shambadunia/ui/blog.dart';
import 'package:shambadunia/ui/regions.dart';
import 'package:shambadunia/ui/category_vendors.dart';
import 'package:shambadunia/utils/Fcm.dart';
import 'package:shambadunia/utils/NotificationManager.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Color appColor = Colors.teal;
  List<CategoryModel> _categories = [];
  var isLoading = false;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _isLoggedin = false;

  String _name = "";
  String _phone = "";

  _refresh() {
    _categories = List();
    _getCategories();
  }

  @override
  void initState() {
    super.initState();
    Future.delayed(Duration.zero,(){
      NotificationManager.init(context: context);
      Fcm.initConfigure();

    });
    _getCategories();
  }

  _getCategories() async {
    setState(() {
      isLoading = true;
    });
    var responseJson = await NetworkUtils.getCategories();
    print(responseJson);
    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
    } else if (responseJson['status'] == 404) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Try Again Later');
    } else if (responseJson['status'] == 200) {
      var products = responseJson['content'];
      _categories = (products as List)
          .map((data) => CategoryModel.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'CATEGORIES',
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
                accountEmail: Text(_phone),
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
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: isLoading
            ? Center(
                child: CircularProgressIndicator())
            : new StaggeredGridView.countBuilder(
          shrinkWrap: true,
          crossAxisCount: 4,
          itemCount: _categories.length,
          controller:
          new ScrollController(keepScrollOffset: false),
          itemBuilder: (BuildContext context, int index) =>
          new Container(
              padding: const EdgeInsets.all(4.0),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CategoryVendor(
                            categoryId: _categories[index].id.toString(),
                            name: _categories[index].name,
                            subcategory: _categories[index].subcategories,
                            photo: _categories[index].photo,
                          )));
                },
                child: Card(
                  child: Column(
                    crossAxisAlignment:
                    CrossAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          child: ClipRRect(
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(5.0),
                                topRight: Radius.circular(5.0)),
                            child: CachedNetworkImage(
                              imageUrl: _categories[index].photo,
                              placeholder: (context, url) => Container(
                                height: 100.0,
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              ),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            ),
                          ),
                      // descript
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Center(
                          child: Text(
                            _categories[index].name,
                            maxLines: 2,
                            style: TextStyle(
                                fontSize: 12.0,
                                fontWeight: FontWeight.w500),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )),
          staggeredTileBuilder: (int index) =>
          new StaggeredTile.fit(2),
        ),
      ),
    );
  }
}

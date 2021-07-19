import 'package:flutter/material.dart';
import 'package:shambadunia/models/blogModel.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:shambadunia/ui/about.dart';
import 'package:shambadunia/ui/account.dart';
import 'package:shambadunia/ui/blog_details.dart';
import 'package:shambadunia/ui/categories.dart';
import 'package:shambadunia/ui/help.dart';
import 'package:shambadunia/ui/welcome.dart';
import 'package:shambadunia/utils/settingUtils.dart';

class Blog extends StatefulWidget {
  @override
  _BlogState createState() => _BlogState();
}

class _BlogState extends State<Blog> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color appColor = Colors.teal;
  bool _isLoggedin = false;

  List<BlogModel> _projects = List();
  var isLoading = false;

  String _name = "";
  String _photo = "";
  String _email = "";

  _refresh() {
    _projects = List();
    _getProjects();
  }

  _getProjects() async {
    setState(() {
      isLoading = true;
    });
    var responseJson = await NetworkUtils.getNews();
    print(responseJson);
    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
    } else if (responseJson['status'] == 404) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Try Again Later');
    } else if (responseJson['status'] == 200) {
      var projects = responseJson['content'];
      _projects =
          (projects as List).map((data) => BlogModel.fromJson(data)).toList();
      setState(() {
        isLoading = false;
      });
    }
  }

  _searchNews(String item) async {
    setState(() {
      isLoading = true;
    });
    var responseJson = await NetworkUtils.searchNews(item);
    print(responseJson);
    if (responseJson == null) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Something went wrong!');
    } else if (responseJson['status'] == 404) {
      NetworkUtils.showSnackBar(_scaffoldKey, 'Try Again Later');
    } else if (responseJson['status'] == 200) {
      var projects = responseJson['content'];
      _projects =
          (projects as List).map((data) => BlogModel.fromJson(data)).toList();
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _getProjects();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appColor,
        title: Text(
          'NEWS',
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
      body: Container(
        color: new Color(0xff707070).withOpacity(0.1),
        child: Column(
          children: <Widget>[
            Container(
              margin:
                  EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0, bottom: 4.0),
              height: 40.0,
              child: TextField(
                onChanged: (item) {
                  if (item == '') {
                    _refresh();
                  } else {
                    _searchNews(item);
                  }
                },
                decoration: InputDecoration(
                  labelText: 'Search News',
                  labelStyle: TextStyle(fontSize: 14.0, color: Colors.grey),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Colors.grey,
                  ),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          BorderSide(color: Colors.blueGrey[300], width: 1.0)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          BorderSide(color: Colors.blueGrey[300], width: 1.0)),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(4),
                      borderSide:
                          BorderSide(color: Colors.blueGrey[300], width: 1.0)),
                ),
              ),
            ),
            Expanded(
                child: isLoading
                    ? Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 1.0,
                        ),
                      )
                    : _projects.length == 0
                        ? Center(
                            child: Text(
                            'No news',
                            style: TextStyle(color: Colors.grey),
                          ))
                        : _projectList(context)),
          ],
        ),
      ),
    );
  }

  Widget _projectList(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(bottom: 16.0),
      child: ListView.builder(
          itemCount: _projects.length,
          itemBuilder: (context, index) {
            return InkWell(
              onTap:
                  () => Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => BlogDetails(
                        id: _projects[index].id,
                        title: _projects[index].title,
                        date: _projects[index].date,
                        photo: _projects[index].photo,
                        description: _projects[index].description,
                        status: _projects[index].status,
                      ))),
              child: Container(
                margin: EdgeInsets.only(top: 8.0, left: 10.0, right: 10.0),
                decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(width: 1.0, color: Colors.blueGrey[100]),
                    borderRadius: BorderRadius.all(Radius.circular(4.0))),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Expanded(
                      flex: 4,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(4.0),
                          child: FadeInImage(
                            fit: BoxFit.cover,
                            placeholder:
                                AssetImage("assets/images/placeholder.jpg"),
                            image: NetworkImage(NetworkUtils.imageHost +
                                'images/news/' +
                                _projects[index].photo),
                          ),
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 6,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            _projects[index].title,
                            maxLines: 3,
                            style: TextStyle(
                                fontSize: 16.0, fontWeight: FontWeight.w500),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8.0, left: 8.0),
                          child: Text(SettingsUtils.convertDateFromString(_projects[index].date.toString()), style: TextStyle(color: Colors.teal),),
                        ),
                      ],),
                    ),
                  ],
                ),
              ),
            );
          }),
    );
  }
}

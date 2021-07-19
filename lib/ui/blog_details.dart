import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:flutter_html/flutter_html.dart';
class BlogDetails extends StatefulWidget {
  final int id;
  final String title;
  final String date;
  final String photo;
  final String description;
  final String status;

  const BlogDetails({Key key, this.id, this.title, this.date, this.photo, this.description, this.status}) : super(key: key);
  @override
  _BlogDetailsState createState() => _BlogDetailsState();
}

class _BlogDetailsState extends State<BlogDetails> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Color appColor = Colors.teal;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            SliverAppBar(
              expandedHeight: 200.0,
              floating: false,
              pinned: true,
              backgroundColor: appColor,
              leading: IconButton(
                  icon: Icon(CupertinoIcons.back),
                  onPressed: () => Navigator.pop(context)),
              flexibleSpace: FlexibleSpaceBar(
                background: Image.network(
                  NetworkUtils.imageHost + 'images/news/' + widget.photo,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ];
        },
        body: ListView(
          children: <Widget>[
            Container(
                padding: EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
                child: Text(
                  widget.title,
                  style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold),
                )),
            Padding(
              padding: const EdgeInsets.only(left: 16.0),
              child: Row(children: <Widget>[
                Expanded(child: Text('By: Shambadunia LTD', style: TextStyle(color: Colors.teal),)),
              ],),
            ),
            Divider(),
            Container(
                padding: const EdgeInsets.only(left: 16.0, bottom: 8.0),
                child: Divider(
                  color: appColor,
                )),
            Html(
              data: widget.description,
              //Optional parameters:
              padding: EdgeInsets.all(8.0),
              backgroundColor: Colors.white70,
              defaultTextStyle: TextStyle(fontFamily: 'serif'),
              linkStyle: const TextStyle(
                color: Colors.redAccent,
              ),
              onLinkTap: (url) {
                // open url in a webview
              },
              onImageTap: (src) {
                // Display the image in large form.
              },
            ),
          ],
        ),
      ),
      /*floatingActionButton: FloatingActionButton(onPressed: null,child: Icon(Icons.comment),),*/
    );
  }
}

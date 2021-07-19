import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class About extends StatefulWidget {
  @override
  _AboutState createState() => _AboutState();
}

class _AboutState extends State<About> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'About Shambadunia',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Expanded(child: ListView(children: <Widget>[
              Center(child: Image.asset('assets/images/about.png',height: 220.0,)),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Text('SHAMBADUNIA IN FEW WORDS',style: TextStyle(fontWeight: FontWeight.bold),),
              ),
              Divider(),
              Text('1. TO A FARMER/ PROCESSING UNITS',style: TextStyle(fontSize: 14.0, height: 1.3, color: Colors.teal[900]),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('A Reliable market platform which has a potential of reaching over 23 million people',style: TextStyle(fontSize: 14.0, height: 1.3),),
              ),
              Text('2. TO THE FINAL CONSUMER',style: TextStyle(fontSize: 14.0, height: 1.3, color: Colors.teal[900]),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('A convenient market with all supplies and the luxury of delivery to the doorstep',style: TextStyle(fontSize: 14.0, height: 1.3),),
              ),
              Text('3. TO INVESTORS IN AGRICULTURE',style: TextStyle(fontSize: 14.0, height: 1.3, color: Colors.teal[900]),),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text('A reliable investment platform with promised returns',style: TextStyle(fontSize: 14.0, height: 1.3),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text('Reach Out To Us', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
              ),
              Divider(),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text('Msasani Peninsula,', style: TextStyle(fontSize: 16.0),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text('Block 1351 Abiudi street,', style: TextStyle(fontSize: 16.0),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Text('P. o Box 77627 Dar es salaam, Tanzania', style: TextStyle(fontSize: 16.0),),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(children: <Widget>[
                  Text('Phone #: ', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  Text(' +255 754 222 800', style: TextStyle(fontSize: 16.0, color: Colors.teal),),
                ],),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0),
                child: Row(children: <Widget>[
                  Text('Email: ', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  Text(' info@shambadunia.com', style: TextStyle(fontSize: 16.0, color: Colors.teal),),
                ],),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0, left: 8.0, bottom: 8.0),
                child: Row(children: <Widget>[
                  Text('Website: ', style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.bold),),
                  Text(' www.shambadunia.com', style: TextStyle(fontSize: 16.0, color: Colors.teal),),
                ],),
              ),
              Center(child: Image.asset('assets/images/productss.jpg')),
            ],)),
          ],
        ),
      ),
    );
  }
}

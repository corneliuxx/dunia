import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:shambadunia/database/database_helper.dart';
import 'package:shambadunia/models/cartModel.dart';
import 'package:shambadunia/network/network_utils.dart';
import 'package:shambadunia/ui/choose_delivery.dart';
import 'package:shambadunia/utils/settingUtils.dart';

class Cart extends StatefulWidget {
  final String region;
  final String location;
  final String latitude;
  final String longitude;
  final String vendorid;

  const Cart(
      {Key key, this.region,this.location, this.latitude, this.longitude, this.vendorid})
      : super(key: key);

  @override
  _CartState createState() => _CartState();
}

class _CartState extends State<Cart> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final dbHelper = DatabaseHelper.instance;
  List<CartModel> _cartItems = List();
  var isLoading = false;
  double _totalAmount = 0;

  @override
  void initState() {
    super.initState();
    _getCartItems();
  }

  void _getCartItems() async {
    _totalAmount = 0;
    setState(() {
      isLoading = true;
    });
    _cartItems = await dbHelper.queryOrders();

    setState(() {
      for (int i = 0; i < _cartItems.length; i++) {
        _totalAmount += _cartItems[i].subTotal;
        print('total-Amount: $_totalAmount');
      }
      isLoading = false;
    });
  }

  void _updateOrder(int itemId, double amount, int quantity, int type) async {
    int totalQuantity;
    if (type == 1) {
      totalQuantity = quantity + 1;
    } else if (type == 0) {
      totalQuantity = quantity - 1;
      if (totalQuantity < 1) {
        totalQuantity = 1;
      }
    }

    double subTotal = amount * totalQuantity;

    // row to update
    Map<String, dynamic> row = {
      DatabaseHelper.columnId: itemId,
      DatabaseHelper.columnProductQuantity: totalQuantity,
      DatabaseHelper.columnSubTotal: subTotal,
    };

    final id = await dbHelper.update(row);
    print('SubTotal: $subTotal');
    print('updated row id: $id');
    _getCartItems();
  }

  void _deleteItem(int itemId) async {
    final id = await dbHelper.delete(itemId);
    print('Deleted row id: $id');
    _getCartItems();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.teal,
        title: Text(
          'Cart',
          style: TextStyle(fontSize: 16.0),
        ),
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(
                strokeWidth: 1.0,
              ),
            )
          : Column(
              children: <Widget>[
                Expanded(
                  child: Container(
                    color: Color(0xff707070).withOpacity(0.1),
                    padding: EdgeInsets.all(16.0),
                    child: _cartItems.length == 0
                        ? Center(
                            child: Text(
                              'No products in cart.',
                              style: TextStyle(fontSize: 12.0),
                            ),
                          )
                        : ListView.builder(
                            itemCount: _cartItems.length,
                            itemBuilder: (context, index) {
                              return InkWell(
                                onTap: () {},
                                child: Container(
                                    margin: EdgeInsets.only(bottom: 8.0),
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        borderRadius: BorderRadius.all(
                                            Radius.circular(8.0))),
                                    child: Column(
                                      children: <Widget>[
                                        Row(
                                          children: <Widget>[
                                            Expanded(
                                                flex: 3,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: CachedNetworkImage(
                                                    imageUrl: NetworkUtils
                                                        .imageHost +
                                                        'images/products/thumbnails/' +
                                                        _cartItems[index]
                                                            .thumbnail,
                                                    placeholder: (context, url) => Container(
                                                      height: 50.0
                                                    ),
                                                    errorWidget: (context, url, error) =>
                                                        Icon(Icons.error),
                                                  ),
                                                )),
                                            Expanded(
                                                flex: 7,
                                                child: Column(
                                                  crossAxisAlignment:
                                                      CrossAxisAlignment.start,
                                                  children: <Widget>[
                                                    Text(
                                                      _cartItems[index]
                                                          .productName,
                                                      style: TextStyle(
                                                          fontSize: 18.0,
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    Container(
                                                      height: 4.0,
                                                    ),
                                                    Text(
                                                      'Total Cost: ' +
                                                          SettingsUtils.formatCurrency(
                                                              double.parse(
                                                                  _cartItems[
                                                                          index]
                                                                      .subTotal
                                                                      .toString())) +
                                                          ' Tsh',
                                                      style: TextStyle(
                                                          fontSize: 12.0),
                                                    ),
                                                    Container(
                                                      height: 4.0,
                                                    ),
                                                    Text(
                                                      'Quantity: ' +
                                                          _cartItems[index]
                                                              .quantity
                                                              .toString() +
                                                          ' ' +
                                                          _cartItems[index]
                                                              .productUnit,
                                                      style: TextStyle(
                                                          fontSize: 12.0),
                                                    ),
                                                    Container(
                                                      height: 4.0,
                                                    ),
                                                  ],
                                                )),
                                          ],
                                        ),
                                        Divider(
                                          color: Colors.teal,
                                        ),
                                        Container(
                                          padding: const EdgeInsets.only(
                                              left: 16.0,
                                              right: 16.0,
                                              bottom: 8.0,
                                              top: 0.0),
                                          child: Row(
                                            children: <Widget>[
                                              Expanded(
                                                  child: InkWell(
                                                onTap: () {
                                                  _deleteItem(
                                                      _cartItems[index].id);
                                                  NetworkUtils.showSnackBar(
                                                      _scaffoldKey,
                                                      'Product Deleted from Cart');
                                                },
                                                child: Container(
                                                  child: Center(
                                                      child: Text(
                                                          'REMOVE FROM CART',
                                                          style: TextStyle(
                                                              fontSize: 12.0,
                                                              color: Colors
                                                                  .red[800],
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w500))),
                                                ),
                                              )),
                                              Expanded(
                                                  child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: <Widget>[
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: 30.0,
                                                      width: 30.0,
                                                      decoration: BoxDecoration(
                                                          color: Colors.teal,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                      child: InkWell(
                                                        onTap: () => _updateOrder(
                                                            _cartItems[index]
                                                                .id,
                                                            _cartItems[index]
                                                                .productAmount,
                                                            _cartItems[index]
                                                                .quantity,
                                                            0),
                                                        child: new Center(
                                                          child: new Text(
                                                            '-',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 8.0,
                                                  ),
                                                  Container(
                                                    height: 30.0,
                                                    child: Center(
                                                      child: Text(
                                                        _cartItems[index]
                                                            .quantity
                                                            .toString(),
                                                        style: TextStyle(
                                                            fontSize: 12.0,
                                                            fontWeight:
                                                                FontWeight
                                                                    .bold),
                                                      ),
                                                    ),
                                                  ),
                                                  Container(
                                                    width: 8.0,
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            8.0),
                                                    child: Container(
                                                      height: 30.0,
                                                      width: 30.0,
                                                      decoration: BoxDecoration(
                                                          color: Colors.teal,
                                                          borderRadius:
                                                              BorderRadius.all(
                                                                  Radius
                                                                      .circular(
                                                                          8.0))),
                                                      child: InkWell(
                                                        onTap: () => _updateOrder(
                                                            _cartItems[index]
                                                                .id,
                                                            _cartItems[index]
                                                                .productAmount,
                                                            _cartItems[index]
                                                                .quantity,
                                                            1),
                                                        child: new Center(
                                                          child: new Text(
                                                            '+',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .white),
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              )),
                                            ],
                                          ),
                                        )
                                      ],
                                    )),
                              );
                            },
                          ),
                  ),
                ),
                _cartItems.length > 0
                    ? InkWell(
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ChooseDelivery(
                                      productRegion: widget.region,
                                      productLocation: widget.location,
                                      productLatitude: widget.latitude,
                                      productLongitude: widget.longitude,
                                      vendorid: widget.vendorid,
                                    ))),
                        child: Container(
                          height: 45.0,
                          margin: EdgeInsets.all(16.0),
                          decoration: BoxDecoration(
                              color: Colors.teal[900],
                              borderRadius:
                                  BorderRadius.all(Radius.circular(5.0))),
                          child: Center(
                              child: Text(
                            "BUY NOW",
                            style: TextStyle(color: Colors.white),
                          )),
                        ),
                      )
                    : Container()
              ],
            ),
    );
  }
}

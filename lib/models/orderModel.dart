import 'package:shambadunia/models/productModel.dart';

class orderModel {
  final int id;
  final String productname;
  final String productphoto;
  final String productlocation;
  final int cost;
  final String quantity;
  final String delivery;
  final String status;
  final String token;
  final List<ProductsModel> products;

  orderModel(
      {this.id,
      this.productname,
      this.productlocation,
      this.productphoto,
      this.cost,
      this.delivery,
      this.status,this.quantity,
      this.token,this.products});

  factory orderModel.fromJson(Map<String, dynamic> json) {
    return orderModel(
        id: json['id'],
        productname: json['productname'],
        status: json['status'],
        cost: json['total_cost'],
        quantity: json['quantity'],
        delivery: json['buyer_location'],
        productphoto: json['productphoto'],
        productlocation: json['seller_location'],
        token: json['token'],
        products: parseProducts(json));
  }

  static List<ProductsModel> parseProducts(jsonn) {
    var list = jsonn['products'] as List;
    List<ProductsModel> productsList =
    list.map((data) => ProductsModel.fromJson(data)).toList();
    return productsList;
  }
}

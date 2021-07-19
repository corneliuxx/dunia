import 'package:flutter/foundation.dart';

class CartModel extends ChangeNotifier {
  /// Internal, private state of the cart. Stores the ids of each item.
  int id;
  int productId;
  String productName;
  String thumbnail;
  int quantity;
  String productUnit;
  double productAmount;
  String productVendor;
  double subTotal;

  CartModel(
      {this.id,
      this.productId,
      this.productName,
      this.thumbnail,
      this.quantity,
      this.productUnit,
      this.productAmount,
      this.productVendor,
      this.subTotal});

  factory CartModel.fromJson(Map<String, dynamic> json) {
    return CartModel(
        id: json['_id'],
        productId: json['pid'],
        productAmount: json['amount'],
        quantity: json['quantity'],
        productUnit: json['unit'],
        thumbnail: json['image'],
        productVendor: json['vendor'],
        subTotal: json['subtotal']);
  }
 
  Map<String, dynamic> toJson() {
    return {
      "productid": this.productId.toString(),
      "quantity": this.quantity.toString(),
      "price": this.productAmount.toString(),
    };
  }

  static List encondeToJson(List<CartModel> list) {
    List jsonList = List();
    list.map((item) => jsonList.add(item.toJson())).toList();
    return jsonList;
  }

  void calculate() {}

  void clear() {}
}

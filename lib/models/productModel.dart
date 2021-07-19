class ProductModel {
  final String name;
  final List<ProductsModel> products;

  ProductModel( {this.name, this.products});

  factory ProductModel.fromJson(Map<String, dynamic> json) {
    return ProductModel(
        name: json['name'],
        products: parseProducts(json));
  }

  static List<ProductsModel> parseProducts(jsonn) {
    var list = jsonn['products'] as List;
    List<ProductsModel> subcategoryList =
    list.map((data) => ProductsModel.fromJson(data)).toList();
    return subcategoryList;
  }
}

class ProductsModel {
  final int id;
  final String name;
  final String description;
  final int quantity;
  final String unit;
  final int price;
  final int weight;
  final String location;
  final String latitude;
  final String longitude;
  final String photo;
  final int category;
  final int subcategory;
  final int vendor_id;
  int selectedquantity;
  bool inCart;

  ProductsModel(
      {this.id,this.name,
      this.description,
      this.quantity,
      this.unit,
      this.price,
      this.weight,
      this.location,this.latitude, this.longitude,
        this.photo,
      this.category,
      this.subcategory,
      this.selectedquantity,
      this.vendor_id,
      this.inCart});

  factory ProductsModel.fromJson(Map<String, dynamic> json) {
    return ProductsModel(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      category: json['category_id'],
      photo: json['photo'],
      price: json['price'],
      quantity: json['quantity'],
      subcategory: json['subcategory_id'],
      unit: json['unit'],
      weight: json['weight'],
      selectedquantity: json['selectedquantity'],
      vendor_id: json['vendor_id'],
      inCart: false
    );
  }
}

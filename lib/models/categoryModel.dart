class CategoryModel {
  final int id;
  final String name;
  final String photo;
  final List<SubcategoryModel> subcategories;

  CategoryModel( {this.id, this.name, this.subcategories, this.photo});

  factory CategoryModel.fromJson(Map<String, dynamic> json) {
    return CategoryModel(
        id: json['id'],
        name: json['name'],
        photo: json['photo'],
        subcategories: parseSubcategory(json));
  }

  static List<SubcategoryModel> parseSubcategory(jsonn) {
    var list = jsonn['subcategories'] as List;
    List<SubcategoryModel> subcategoryList =
        list.map((data) => SubcategoryModel.fromJson(data)).toList();
    return subcategoryList;
  }
}

class SubcategoryModel {
  final int id;
  final String name;
  final String photo;

  SubcategoryModel( {this.id, this.name,this.photo});

  @override
  String toString() {
    return '{ ${this.id}, ${this.name}, ${this.photo} }';
  }

  factory SubcategoryModel.fromJson(Map<String, dynamic> subjson) {
    return SubcategoryModel(id: subjson['id'], name: subjson['name'], photo: subjson['photo']);
  }
}

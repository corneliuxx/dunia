class DemandModel {
  final int id;
  final String title;
  final String description;
  final String photo;
  final int quantity;
  final String unit;
  final String location;
  final String username;
  final String phone;
  final String status;

  DemandModel(
      {this.id,
      this.title,
      this.description,
      this.photo,
      this.quantity,
      this.unit,
      this.location,
      this.username,
      this.phone,
      this.status});

  factory DemandModel.fromJson(Map<String, dynamic> json) {
    return DemandModel(
        id: json['id'],
        title: json['title'],
        description: json['description'],
        quantity: json['quantity'],
        photo: json['photo'],
        unit: json['unit'],
        location: json['location'],
        status: json['status'],
        phone: json['phone'],
        username: json['username']);
  }
}

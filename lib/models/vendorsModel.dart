class VendorsModel {
  final int id;
  final String name;
  final String region;
  final String location;
  final String latitude;
  final String longitude;
  final String photo;
  final String email;
  final String phone;
  final String status;

  VendorsModel(
      {this.id,
      this.name,
      this.region,
      this.location,
      this.latitude,
      this.longitude,
      this.photo,
      this.email,
      this.phone,
      this.status});

  factory VendorsModel.fromJson(Map<String, dynamic> json) {
    return VendorsModel(
        id: json['id'],
        name: json['name'],
        region: json['region'],
        location: json['location'],
        latitude: json['latitude'],
        longitude: json['longitude'],
        photo: json['photo'],
        email: json['email'],
        phone: json['phone'],
        status: json['status']);
  }
}

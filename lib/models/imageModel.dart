class ImageModel {
  final int userId;
  final String photo;

  ImageModel({this.userId, this.photo});

  factory ImageModel.fromJson(Map<String, dynamic> json) {
    return ImageModel(userId: json['user_id'], photo: json['photo']);
  }
}

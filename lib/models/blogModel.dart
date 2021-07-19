class BlogModel {
  final int id;
  final String title;
  final String photo;
  final String description;
  final String status;
  final String date;

  BlogModel(
      {this.id,
        this.title,
        this.photo,
        this.description,
        this.date,
        this.status});

  factory BlogModel.fromJson(Map<String, dynamic> json) {
    return BlogModel(
      id: json['id'],
      title: json['title'],
      photo: json['photo'],
      description: json['description'],
      date: json['created_at'],
      status: json['status'],
    );
  }
}

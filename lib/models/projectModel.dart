class ProjectModel {
  final int id;
  final String title;
  final String location;
  final String latitude;
  final String longitude;
  final String cost;
  final int roi;
  final String duration;
  final String startdate;
  final String type;
  final String photo;
  final String description;
  final String status;

  ProjectModel(
      {this.id,
      this.title,
      this.location,
      this.latitude,
      this.longitude,
      this.cost,
      this.roi,
      this.duration,
      this.startdate,
      this.type,
      this.photo,
      this.description,
      this.status});

  factory ProjectModel.fromJson(Map<String, dynamic> json) {
    return ProjectModel(
      id: json['id'],
      title: json['title'],
      location: json['location'],
      latitude: json['latitude'],
      longitude: json['longitude'],
      cost: json['cost'],
      roi: json['roi'],
      duration: json['duration'],
      startdate: json['start_date'],
      type: json['type'],
      photo: json['photo'],
      description: json['description'],
      status: json['status'],
    );
  }
}

class ProgressModel {
  final int id;
  final int projectId;
  final String progress;
  final String created;

  ProgressModel(
      {this.id,
        this.projectId,
        this.progress,
        this.created});

  factory ProgressModel.fromJson(Map<String, dynamic> json) {
    return ProgressModel(
      id: json['id'],
      projectId: json['project_id'],
      progress: json['progress'],
      created: json['created_at']);
  }
}

class InvestmentModel {
  final int id;
  final int projectId;
  final String projectTitle;
  final int amount;
  final int roi;
  final String token;
  final String status;
  final String projectphoto;

  InvestmentModel(
      {this.id,
      this.projectId,
      this.projectTitle,
      this.amount,
      this.roi,
      this.token,
      this.status,
      this.projectphoto});

  factory InvestmentModel.fromJson(Map<String, dynamic> json) {
    return InvestmentModel(
        id: json['id'],
        projectId: json['project_id'],
        projectTitle: json['project_title'],
        amount: json['amount'],
        roi: json['roi'],
        token: json['token'],
        status: json['status'],
        projectphoto: json['projectphoto'],);
  }
}

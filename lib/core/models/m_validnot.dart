class ValidNot {
  int? idValidNotif;
  int? idNotif;
  bool? isRead;
  String? nameClient;
  int? idClient;
  String? nameCoach;
  int? idCoach;
  bool? isPopped;

  ValidNot(
      {this.idValidNotif,
      this.idNotif,
      this.isRead,
      this.nameClient,
      this.idClient,
      this.nameCoach,
      this.idCoach,
      this.isPopped});

  ValidNot.fromJson(Map<String, dynamic> json) {
    idValidNotif = json['id_validNotif'];
    idNotif = json['id_notif'];
    isRead = json['is_read'];
    nameClient = json['name_client'];
    idClient = json['client_id'];
    nameCoach = json['name_coach'];
    idCoach = json['coach_id'];
    isPopped = json['is_popped'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_validNotif'] = this.idValidNotif;
    data['id_notif'] = this.idNotif;
    data['is_read'] = this.isRead;
    data['name_client'] = this.nameClient;
    data['client_id'] = this.idClient;
    data['name_coach'] = this.nameCoach;
    data['coach_id'] = this.idCoach;
    data['is_popped'] = this.isPopped;
    return data;
  }
}

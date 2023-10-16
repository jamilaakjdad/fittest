class Notifications {
  int? idNotif;
  String? dateEnvoye;
  int? idAdmin;
  String? sujet;
  String? contenu;

  Notifications(
      {this.idNotif, this.dateEnvoye, this.idAdmin, this.sujet, this.contenu});

  Notifications.fromJson(Map<String, dynamic> json) {
    idNotif = json['id_notif'];
    dateEnvoye = json['date_envoye'];
    idAdmin = json['id_admin'];
    sujet = json['sujet'];
    contenu = json['contenu'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_notif'] = this.idNotif;
    data['date_envoye'] = this.dateEnvoye;
    data['id_admin'] = this.idAdmin;
    data['sujet'] = this.sujet;
    data['contenu'] = this.contenu;
    return data;
  }
}

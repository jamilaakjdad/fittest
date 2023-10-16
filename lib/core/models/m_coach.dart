class Coach {
  int idCoach;
  String civilite;
  String nomCoach;
  String prenomCoach;
  String adresse;
  String tel;
  String mail;
  String cin;
  String? description;
  DateTime? dateNaissance;
  DateTime? datedentree;
  bool statut;
  // String password;
  String image;
  String ville;
  int idVille;
  Coach({
    this.idCoach = 0,
    this.civilite = '',
    this.nomCoach = '',
    this.prenomCoach = '',
    this.adresse = '',
    this.tel = '',
    this.mail = '',
    this.cin = '',
    this.description = '',
    this.dateNaissance,
    this.datedentree,
    this.statut = true,
    // this.password = '',
    this.image = '',
    this.ville = '',
    this.idVille = 0,
  });

  factory Coach.fromJson(Map<String, dynamic> json) {
    return Coach(
      idCoach: json['id_coach'],
      civilite: json['civilite'],
      nomCoach: json['nom_coach'],
      prenomCoach: json['prenom_coach'],
      adresse: json['adresse'],
      tel: json['tel'],
      mail: json['mail'],
      cin: json['cin'],
      description: json['description'],
      dateNaissance: json['date_naissance'] != null
          ? DateTime.parse(json['date_naissance'])
          : null,
      datedentree: json['date_dentree'] != null
          ? DateTime.parse(json['date_dentree'])
          : null,
      statut: json['statut'],
      // password: json['password'],
      image: json['image'],
      ville: json['ville'],
      idVille: json['id_ville'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_coach'] = this.idCoach ?? 0;
    data['civilite'] = this.civilite ?? '';
    data['nom_coach'] = this.nomCoach ?? '';
    data['prenom_coach'] = this.prenomCoach ?? '';
    data['adresse'] = this.adresse ?? '';
    data['tel'] = this.tel ?? '';
    data['mail'] = this.mail ?? '';
    data['cin'] = this.cin ?? '';
    data['description'] = this.description ?? '';
    data['date_naissance'] = this.dateNaissance?.toIso8601String();
    data['date_dentree'] = this.datedentree?.toIso8601String();
    data['statut'] = this.statut ?? true;
    // data['password'] = this.password ?? '';
    data['image'] = this.image ?? '';
    data['ville'] = this.ville ?? '';
    data['id_ville'] = this.idVille ?? 0;

    return data;
  }
}

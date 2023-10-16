// class Client {
//   int idClient;
//   String civilite;
//   String nomClient;
//   String prenomClient;
//   String adresse;
//   String tel;
//   String mail;
//   String password;
//   String cin;
//   int? idVille;
//   DateTime? dateNaissance;
//   DateTime? dateInscription;
//   bool? statut;
//   bool? blackliste;

//   bool? newsletter;
//   String image;

//   Client({
//     this.idClient = 0,
//     this.civilite = '',
//     this.nomClient = '',
//     this.prenomClient = '',
//     this.adresse = '',
//     this.tel = '',
//     this.mail = '',
//     this.password = '',
//     this.cin = '',
//     this.idVille = 0,
//     this.dateNaissance,
//     this.dateInscription,
//     this.statut = true,
//     this.blackliste = true,
//     this.newsletter = true,
//     this.image = '',
//   });

//   factory Client.fromJson(Map<String, dynamic> json) {
//     return Client(
//       idClient: json['id_client'],
//       civilite: json['civilite'],
//       nomClient: json['nom_client'],
//       prenomClient: json['prenom_client'],
//       adresse: json['adresse'],
//       tel: json['tel'],
//       mail: json['mail'],
//       password: json['password'],
//       cin: json['cin'],
//       idVille: json['id_ville'],
//       dateNaissance: json['date_naissance'] != null
//           ? DateTime.parse(json['date_naissance'])
//           : null,
//       dateInscription: json['date_inscription'] != null
//           ? DateTime.parse(json['date_inscription'])
//           : null,
//       statut: json['statut'],
//       blackliste: json['blackliste'],
//       newsletter: json['newsletter'],
//       image: json['image'],
//     );
//   }

//   Map<String, dynamic> toJson() {
//     final Map<String, dynamic> data = new Map<String, dynamic>();
//     data['id_client'] = this.idClient ?? 0;
//     data['civilite'] = this.civilite ?? '';
//     data['nom_client'] = this.nomClient ?? '';
//     data['prenom_client'] = this.prenomClient ?? '';
//     data['adresse'] = this.adresse ?? '';
//     data['tel'] = this.tel ?? '';
//     data['mail'] = this.mail ?? '';
//     data['password'] = this.password ?? '';
//     data['cin'] = this.cin ?? '';
//     data['id_ville'] = this.idVille ?? 0;
//     data['date_naissance'] = this.dateNaissance?.toIso8601String();
//     data['date_inscription'] = this.dateInscription?.toIso8601String();
//     data['statut'] = this.statut ?? true;
//     data['blackliste'] = this.blackliste ?? true;

//     data['newsletter'] = this.civilite ?? true;
//     data['image'] = this.image ?? '';
//     return data;
//   }
// }
class Client {
  int idClient;
  String civilite;
  String nomClient;
  String prenomClient;
  String adresse;
  String tel;
  String mail;
  String? password;
  String cin;
  int? idVille;
  DateTime? dateNaissance;
  DateTime? dateInscription;
  bool? statut;
  bool? blackliste;

  bool? newsletter;
  String image;

  String token = "";

  Client({
    this.idClient = 0,
    this.civilite = '',
    this.nomClient = '',
    this.prenomClient = '',
    this.adresse = '',
    this.tel = '',
    this.mail = '',
    this.password,
    this.cin = '',
    this.idVille = 0,
    this.dateNaissance,
    this.dateInscription,
    this.statut = true,
    this.blackliste = true,
    this.newsletter = true,
    this.image = '',
  });

  factory Client.fromJson(Map<String, dynamic> json) {
    return Client(
      idClient: json['id_client'] ?? 0,
      civilite: json['civilite'] ?? '',
      nomClient: json['nom_client'] ?? '',
      prenomClient: json['prenom_client'] ?? '',
      adresse: json['adresse'] ?? '',
      tel: json['tel'] ?? '',
      mail: json['mail'] ?? '',
      password: json['password'],
      cin: json['cin'] ?? '',
      idVille: json['ville'] ?? 0,
      dateNaissance: json['date_naissance'] != null
          ? DateTime.parse(json['date_naissance'])
          : null,
      dateInscription: json['date_inscription'] != null
          ? DateTime.parse(json['date_inscription'])
          : null,
      statut: json['statut'] ?? true,
      blackliste: json['blackliste'] ?? true,
      newsletter: json['newsletter'] ?? true,
      image: json['image'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_client'] = this.idClient ?? 0;
    data['civilite'] = this.civilite ?? '';
    data['nom_client'] = this.nomClient ?? '';
    data['prenom_client'] = this.prenomClient ?? '';
    data['adresse'] = this.adresse ?? '';
    data['tel'] = this.tel ?? '';
    data['mail'] = this.mail ?? '';
    data['password'] = this.password;
    data['cin'] = this.cin ?? '';
    data['ville'] = this.idVille ?? 0;
    data['date_naissance'] = this.dateNaissance?.toIso8601String();
    data['date_inscription'] = this.dateInscription?.toIso8601String();
    data['statut'] = this.statut ?? true;
    data['blackliste'] = this.blackliste ?? true;

    data['newsletter'] = this.newsletter ?? true;
    data['image'] = this.image ?? '';
    return data;
  }
}

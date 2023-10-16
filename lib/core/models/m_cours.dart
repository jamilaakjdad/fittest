class Cour {
  int idCours;
  String nomCours;
  String description;
  String reglement;
  String genre;
  String image;
  Cour({
    this.idCours = 0,
    this.nomCours = '',
    this.description = '',
    this.reglement = '',
    this.genre = '',
    this.image = '',
  });

  factory Cour.fromJson(Map<String, dynamic> json) {
    return Cour(
      idCours: json['id_cour'],
      nomCours: json['nom_cour'],
      description: json['description'],
      reglement: json['reglement'],
      genre: json['genre'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_cour'] = this.idCours ?? 0;
    data['nom_cour'] = this.nomCours ?? '';
    data['description'] = this.description ?? '';
    data['reglement'] = this.reglement ?? '';
    data['genre'] = this.genre ?? '';
    data['image'] = this.image ?? '';
    return data;
  }
}

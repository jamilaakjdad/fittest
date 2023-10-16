class Etablissement {
  int? idEtablissement;
  String? nomEtablissement;
  String? adresseEtablissement;
  String? ville;
  String? teletablissement;
  String? sitewebetablissement;
  String? mailetablissement;
  String? description;
  String? image;
  String? facebook;
  String? instagram;
  String? wtp;
  // int? nbClients;

  Etablissement({
    this.idEtablissement,
    this.nomEtablissement,
    this.adresseEtablissement,
    this.ville,
    this.teletablissement,
    this.sitewebetablissement,
    this.mailetablissement,
    this.description,
    this.image,
    this.facebook,
    this.instagram,
    this.wtp,
    // this.nbClients
  });

  Etablissement.fromJson(Map<String, dynamic> json) {
    idEtablissement = json['id_etablissement'];
    nomEtablissement = json['nom_etablissement'];
    adresseEtablissement = json['adresse_etablissement'];
    ville = json['ville'];
    teletablissement = json['teletablissement'];
    sitewebetablissement = json['sitewebetablissement'];
    mailetablissement = json['mailetablissement'];
    description = json['description'];
    image = json['image'];
    facebook = json['facebook'];
    instagram = json['instagrame'];
    wtp = json['watsapp'];
    // nbClients = json['nb_clients'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_etablissement'] = this.idEtablissement;
    data['nom_etablissement'] = this.nomEtablissement;
    data['adresse_etablissement'] = this.adresseEtablissement;
    data['ville'] = this.ville;
    data['teletablissement'] = this.teletablissement;
    data['sitewebetablissement'] = this.sitewebetablissement;
    data['mailetablissement'] = this.mailetablissement;
    data['description'] = this.description;
    data['image'] = this.image;
    data['facebook'] = this.facebook;
    data['instagrame'] = this.instagram;
    data['watsapp'] = this.wtp;
    // data['nb_clients'] = this.nbClients;
    return data;
  }
}

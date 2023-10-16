class Contrat {
  int? idContrat;
  int? idClient;
  String? dateDebut;
  String? dateFin;
  String? reste;
  String? numcontrat;
  int? idEtablissement;
  int? idAbn;
  String? etablissemnt;
  String? client;
  String? abonnement;
  String? prenomClient;

  Contrat(
      {this.idContrat,
      this.idClient,
      this.dateDebut,
      this.dateFin,
      this.reste,
      this.numcontrat,
      this.idEtablissement,
      this.idAbn,
      this.etablissemnt,
      this.client,
      this.abonnement,
      this.prenomClient});

  Contrat.fromJson(Map<String, dynamic> json) {
    idContrat = json['id_contrat'];
    idClient = json['id_client'];
    dateDebut = json['date_debut'];
    dateFin = json['date_fin'];
    reste = json['reste'].toString();
    numcontrat = json['numcontrat'];
    idEtablissement = json['id_etablissement'];
    idAbn = json['id_abn'];
    etablissemnt = json['etablissemnt'];
    client = json['client'];
    abonnement = json['abonnement'];
    prenomClient = json['Prenom_client'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_contrat'] = this.idContrat;
    data['id_client'] = this.idClient;
    data['date_debut'] = this.dateDebut;
    data['date_fin'] = this.dateFin;
    data['reste'] = this.reste;
    data['numcontrat'] = this.numcontrat;
    data['id_etablissement'] = this.idEtablissement;
    data['id_abn'] = this.idAbn;
    data['etablissemnt'] = this.etablissemnt;
    data['client'] = this.client;
    data['abonnement'] = this.abonnement;
    data['Prenom_client'] = this.prenomClient;
    return data;
  }
}

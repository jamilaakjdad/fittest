class Reservation {
  int? idReservation;
  int? idClient;
  int? idSeance;
  DateTime? dateOperation;
  DateTime? datePresence;
  bool? status;
  bool? presence;
  String? motifAnnulation;
  String? heureDebut;
  String? heureFin;
  String? client;
  String? cour;

  Reservation({
    this.idReservation,
    this.idClient,
    this.idSeance,
    this.dateOperation,
    this.datePresence,
    this.status = true,
    this.presence = true,
    this.motifAnnulation = '',
    this.heureDebut,
    this.heureFin,
    this.client,
    this.cour,
  });

  // factory Reservation.fromJson(Map<String, dynamic> json) => Reservation(
  //       idReservation: json['id_reservation'],
  //       idClient: json['id_client'],
  //       idSeance: json['id_seance'],
  //       dateOperation: DateTime.parse(json['date_operation']),
  //       datePresence: DateTime.parse(json['date_presence']),
  //       status: json['status'] ?? true,
  //       presence: json['presence'] ?? true,
  //       motifAnnulation: json['motif_annulation'] ?? '',
  //       heureDebut: json['heur_debut'],
  //       heureFin: json['heure_fin'],
  //       client: json['client'],
  //       cour: json['cour'],
  //     );

  factory Reservation.fromJson(Map<String, dynamic>? json) {
    if (json == null) {
      return Reservation();
    }
    return Reservation(
      idReservation: json["id_reservation"],
      idClient: json["id_client"],
      idSeance: json["id_seance"],
      dateOperation: DateTime.parse(json["date_operation"]),
      datePresence: DateTime.parse(json["date_presence"]),
      status: json["status"],
      presence: json["presence"],
      motifAnnulation: json["motif_annulation"],
      heureDebut: json['heur_debut'],
      heureFin: json['heure_fin'],
      client: json['client'],
      cour: json['cour'],
    );
  }
  Map<String, dynamic> toJson() => {
        'id_reservation': idReservation,
        'id_client': idClient,
        'id_seance': idSeance,
        'date_operation': dateOperation!.toIso8601String(),
        'date_presence': datePresence!.toIso8601String(),
        'status': status,
        'presence': presence,
        'motif_annulation': motifAnnulation,
        'heur_debut': heureDebut,
        'heure_fin': heureFin,
        'client': client,
        'cour': cour,
      };
}

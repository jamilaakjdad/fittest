import 'package:intl/intl.dart';

class Seance {
  int idSeance;
  int idCours;
  int idCoach;
  int idSalle;
  int capacity;
  int jour;
  DateTime? heureDebut;
  DateTime? heureFin;
  String cour;
  String genre;
  String coach;
  String salle;
  String dayName;
  int? nb_reservations;

  String? date_reservation;
  Seance(
      {this.idSeance = 0,
      this.idCours = 0,
      this.idCoach = 0,
      this.idSalle = 0,
      this.capacity = 0,
      this.jour = 0,
      this.heureDebut,
      this.heureFin,
      this.cour = '',
      this.genre = '',
      this.coach = '',
      this.salle = '',
      this.dayName = '',
        this.date_reservation,
        this.nb_reservations
      });

  factory Seance.fromJson(Map<String, dynamic> json) {
    return Seance(
        idSeance: json['id_seance'],
        idCours: json['id_cour'],
        idCoach: json['id_coach'],
        idSalle: json['id_salle'],
        capacity: json['capacity'],
        jour: json['jour'],
        heureDebut: json['heure_debut'] != null
            ? DateFormat('HH:mm:ss').parse(json['heure_debut'])
            : null,
        heureFin: json['heure_fin'] != null
            ? DateFormat('HH:mm:ss').parse(json['heure_fin'])
            : null,
        cour: json['cour'],
        genre: json['genre'],
        coach: json['coach'],
        salle: json['salle'],
        dayName: json['day_name'],
        date_reservation : json["date_reservation"] ?? json["date_reservation"],
        nb_reservations : json["nb_reservations"] ?? json["nb_reservations"]
    );

  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id_seance'] = this.idSeance ?? 0;
    data['id_cour'] = this.idCours ?? 0;
    data['id_coach'] = this.idCoach ?? 0;
    data['id_salle'] = this.idSalle ?? 0;
    data['capacity'] = this.capacity ?? 0;
    data['jour'] = this.jour ?? 0;
    data['heure_debut'] = this.heureDebut != null
        ? DateFormat('HH:mm:ss').format(this.heureDebut!)
        : null;
    data['heure_fin'] = this.heureFin != null
        ? DateFormat('HH:mm:ss').format(this.heureFin!)
        : null;
    data['cour'] = this.cour ?? '';
    data['genre'] = this.genre ?? '';
    data['coach'] = this.coach ?? '';
    data['salle'] = this.salle ?? '';
    data['day_name'] = this.dayName ?? '';
    return data;
  }
}

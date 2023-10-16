import 'dart:async';

import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_reservation.dart';
import 'package:fithouse_mobile/core/providers/p_reservation.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:fithouse_mobile/core/providers/p_seance.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
// import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class PlanningPage extends StatefulWidget {
  final Client pclient;
  const PlanningPage({Key? key, required this.pclient}) : super(key: key);

  @override
  _PlanningPageState createState() => _PlanningPageState(paclient: pclient);
}

class _PlanningPageState extends State<PlanningPage> {
  final Client paclient;
  _PlanningPageState({required this.paclient});
  final SeanceController seanceController = SeanceController();
  final reservationController = Get.put(ReservationController());
  final ReservationController _reservationControllera =
      Get.put(ReservationController());

  DateTime dateMax = DateTime.now();

  @override
  void initState() {
    super.initState();
    seanceController.fetchSeances();
    reservationController.fetchReservation();
  }

  Future<void> _refresh() {
    reservationController.fetchReservation();
    seanceController.fetchSeances();
    return Future<void>.delayed(const Duration(seconds: 3));
  }

  int couleurch(int idSeance, DateTime heureDebut, int capacity, int idCours) {
    int j = 0;
    for (Reservation reservation in _reservationControllera.reservations) {
      if (reservation.idSeance == idSeance &&
          DateTime.now().year <= reservation.datePresence!.year &&
          DateTime.now().month <= reservation.datePresence!.month &&
          DateTime.now().day <= reservation.datePresence!.day) {
        j++;
      }
    }
    if (j == capacity) {
      return 0;
    } else
      return idCours;
  }

  @override
  Widget build(BuildContext context) {
    DateTime now = DateTime.now();
    DateTime monday = now.subtract(Duration(days: now.weekday - 1));
    var nextmonday = monday.add(Duration(days: 7));
    DateTime tuesday = now.subtract(Duration(days: now.weekday - 2));
    var nexttuesday = tuesday.add(Duration(days: 7));
    DateTime wednesday = now.subtract(Duration(days: now.weekday - 3));
    var nextwednesday = wednesday.add(Duration(days: 7));
    DateTime thursday = now.subtract(Duration(days: now.weekday - 4));
    var nextthursday = thursday.add(Duration(days: 7));
    DateTime friday = now.subtract(Duration(days: now.weekday - 5));
    var nextfriday = friday.add(Duration(days: 7));
    DateTime saturday = now.subtract(Duration(days: now.weekday - 6));
    var nextsaturday = saturday.add(Duration(days: 7));
    DateTime sunday = now.subtract(Duration(days: now.weekday - 7));
    // var nextsunday = sunday.add(Duration(days: 7));
    return MaterialApp(
      localizationsDelegates: [
        // GlobalMaterialLocalizations.delegate,
        // GlobalWidgetsLocalizations.delegate,
        // GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('fr'),
        // const Locale('ar'),
        // const Locale('ja'),
      ],
      // locale: const Locale('fr'),
      home: Scaffold(
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // Show refresh indicator programmatically on button tap.
            _refresh();
          },
          icon: const Icon(Icons.refresh),
          label: const Text(''),
        ),
        body: Obx(
          () => seanceController.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : SfCalendar(
                  view: CalendarView.day,
                  minDate: DateTime.now(),
                  maxDate: DateTime.now().add(Duration(days: 7)),
                  headerDateFormat: 'MMMM',
                  timeSlotViewSettings: TimeSlotViewSettings(
                      startHour: 7,
                      endHour: 22,
                      dayFormat: 'EEEE',
                      timeFormat: 'HH:mm',
                      dateFormat: 'dd'),
                  firstDayOfWeek: 1,
                  initialDisplayDate: DateTime.now(),
                  dataSource: MeetingDataSource(
                    seanceController.seances.map((seance) {
                      return Meeting(
                          eventName: seance.cour +
                              ' ' +
                              seance.salle +
                              ' ' +
                              seance.genre,
                          from: DateTime.parse("${seance.date_reservation} ${DateFormat("HH:mm:ss").format(seance.heureDebut!)}"),
                          to: DateTime.parse("${seance.date_reservation} ${DateFormat("HH:mm:ss").format(seance.heureFin!)}"),
                          couleur: couleurch(
                              seance.idSeance,
                              seance.heureDebut!,
                              seance.capacity,
                              seance.idCours),
                          idComp: seance.idSeance.toString());
                    }).toList(),
                  ),
                  onTap: (CalendarTapDetails details) {
                    if (details.targetElement == CalendarElement.appointment ||
                        details.targetElement == CalendarElement.agenda) {
                      final Appointment appointmentDetails =
                          details.appointments![0];
                      final seance = seanceController.seances.firstWhere((s) =>
                          s.idSeance.toString() == appointmentDetails.id);
                      final date = appointmentDetails.startTime;
                      print(seance.idSeance);

                      //var date_seance = DateTime.parse("${seance.date_reservation} ${DateFormat("HH:mm:ss").format(seance.heureDebut!);

                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          print(date);

                          int j = 0;
                          int i = 0;
                          int k = 0;
                          for (Reservation reservation
                              in _reservationControllera.reservations) {
                            if (reservation.idSeance == seance.idSeance &&
                                now.month <= reservation.datePresence!.month &&
                                now.day <= reservation.datePresence!.day) {
                              j++;
                            }
                            if (reservation.idSeance == seance.idSeance &&
                                reservation.idClient == paclient.idClient &&
                                date.day == reservation.datePresence!.day &&
                                date.month == reservation.datePresence!.month) {
                              k++;
                            }

                            if (reservation.datePresence?.year == date.year &&
                                reservation.datePresence!.month == date.month &&
                                reservation.datePresence!.day == date.day &&
                                reservation.idClient == paclient.idClient) {
                              i++;
                              print(i);
                            }
                          }
                          print(DateFormat("yyyy-MM-dd").format(DateTime.now()));
                          print(seance.genre);
                          print(paclient.civilite);
                          if (paclient.cin == 'public') {
                            return CupertinoAlertDialog(
                              content: const Text(
                                  'Vous ne pouvez pas reserver une seance, Veuillez contacter l\'administration pour completer l\'enregistrement !'),
                            );
                          }
                          if (seance.date_reservation == DateFormat("yyyy-MM-dd").format(DateTime.now()) && DateTime.now()
                                      .hour
                                      .compareTo(seance.heureDebut!.hour - 4) >
                                  0 &&
                              now.weekday == seance.jour) {
                            return CupertinoAlertDialog(
                              content: Text('Temps ecoulé'),
                            );
                          } else if (paclient.statut == false) {
                            return CupertinoAlertDialog(
                              content: Text(
                                  'Vous ne pouvez pas reserver une seance, Veuillez contacter l\'administration pour reactiver votre comte'),
                            );
                          } else if (paclient.civilite == 'Monsieur' &&
                              seance.genre != 'Homme' &&
                              seance.genre != 'Mixte') {
                            return CupertinoAlertDialog(
                              content: Text('ce n\'est pas votre genre!'),
                            );
                          } else if ((paclient.civilite == 'Madame' &&
                                  seance.genre != 'Femme') &&
                              seance.genre != 'Mixte') {
                            return CupertinoAlertDialog(
                              content: Text('ce n\'est pas votre genre!'),
                            );
                          } else if ((paclient.civilite == 'Mademoiselle' &&
                                  seance.genre != 'Femme') &&
                              seance.genre != 'Mixte') {
                            return CupertinoAlertDialog(
                              content: Text('ce n\'est pas votre genre!'),
                            );
                          } else if (seance.capacity <= j) {
                            return CupertinoAlertDialog(
                              content: Text('seance est plein'),
                            );
                          } else if (k == 1) {
                            return CupertinoAlertDialog(
                              content: Text('Tu as deja reservé cette seance'),
                            );
                          } else if (i >= 2) {
                            return CupertinoAlertDialog(
                              content: Text(
                                  'Tu as deja reservé deux seance ce jour'),
                            );
                          } else
                            return CupertinoAlertDialog(
                              title: Text('Reservation'),
                              content: Align(
                                alignment: Alignment.centerLeft,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    SizedBox(height: 8),
                                    Text('Cours : ' + seance.cour),
                                    SizedBox(
                                        height:
                                            8), // add some spacing between the texts
                                    Text('Salle : ' + seance.salle),
                                    SizedBox(
                                        height:
                                            8), // add some spacing between the texts
                                    Text('Coach : ' + seance.coach),
                                    SizedBox(
                                        height:
                                            8), // add some spacing between the texts
                                    Text('capacité : ' +
                                        (seance.capacity - j).toString()),
                                    SizedBox(
                                        height:
                                            8), // add some spacing between the texts
                                    Text('Commencer à ' +
                                        DateFormat('HH:mm')
                                            .format(seance.heureDebut!)
                                            .toString()),
                                  ],
                                ),
                              ),
                              actions: [
                                CupertinoDialogAction(
                                  onPressed: () async {
                                    // Timer? _timer;
                                    // @override
                                    // void initState() {
                                    //   super.initState();
                                    //   seanceController.fetchSeances();
                                    //   reservationController.fetchReservation();
                                    //   _timer = Timer.periodic(
                                    //       Duration(seconds: 10), (timer) {
                                    //     seanceController.fetchSeances();
                                    //     reservationController
                                    //         .fetchReservation();
                                    //   });
                                    // }

                                    // @override
                                    // void dispose() {
                                    //   // Cancel the timer when the widget is disposed
                                    //   _timer?.cancel();
                                    //   super.dispose();
                                    // }

                                    final newReservation = Reservation(
                                        idClient: paclient.idClient,
                                        idSeance: seance.idSeance,
                                        dateOperation: DateTime.now(),
                                        datePresence: DateTime(
                                          dateMax.year,
                                          dateMax.month,
                                          seance.jour == 1 &&
                                                  now.day <= monday.day
                                              ? monday.day
                                              : seance.jour == 1
                                                  ? nextmonday.day
                                                  : seance.jour == 2 &&
                                                          now.day <= tuesday.day
                                                      ? tuesday.day
                                                      : seance.jour == 2
                                                          ? nexttuesday.day
                                                          : seance.jour == 3 &&
                                                                  now.day <=
                                                                      wednesday
                                                                          .day
                                                              ? wednesday.day
                                                              : seance.jour == 3
                                                                  ? nextwednesday
                                                                      .day
                                                                  : seance.jour ==
                                                                              4 &&
                                                                          now.day <=
                                                                              thursday
                                                                                  .day
                                                                      ? thursday
                                                                          .day
                                                                      : seance.jour ==
                                                                              4
                                                                          ? nextthursday
                                                                              .day
                                                                          : seance.jour == 5 && now.day <= friday.day
                                                                              ? friday.day
                                                                              : seance.jour == 5
                                                                                  ? nextfriday.day
                                                                                  : seance.jour == 6 && now.day <= saturday.day
                                                                                      ? saturday.day
                                                                                      : seance.jour == 6
                                                                                          ? nextsaturday.day
                                                                                          : sunday.day,
                                        ),
                                        status: true,
                                        presence: true,
                                        motifAnnulation: 'none',
                                        heureDebut:
                                            seance.heureDebut.toString(),
                                        heureFin: seance.heureFin.toString(),
                                        client: '',
                                        cour: seance.cour);
                                    var booking = await _reservationControllera
                                        .addReservation(newReservation);
                                    Navigator.pop(context);
                                    print(booking);
                                    if(booking['is_booking']){
                                      _refresh();

                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            content: Text(
                                                'Votre réservation a été ajoutée avec succès !'),
                                          );
                                        },
                                      );
                                    }else{
                                      showDialog(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return CupertinoAlertDialog(
                                            content: Text(booking["msg"]));
                                        },
                                      );
                                    }

                                    // ScaffoldMessenger.of(context).showSnackBar(
                                    //   SnackBar(
                                    //     content: Text(
                                    //         'Votre réservation a été ajoutée avec succès !'),
                                    //   ),
                                    // );
                                  },
                                  child: const Text('Reserver'),
                                ),
                              ],
                            );
                        },
                      );
                    }
                  }),
        ),
      ),
    );
  }
}

class Meeting extends Appointment {
  Meeting(
      {required String eventName,
      required DateTime from,
      required DateTime to,
      required int couleur,
      required String idComp})
      : super(
            startTime: from,
            endTime: to,
            subject: eventName,
            color: Color.fromRGBO(couleur, couleur * 10, couleur * 100, 0.8),
            id: idComp);
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }
}

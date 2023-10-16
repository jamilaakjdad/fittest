import 'dart:ffi';
import 'dart:math';

import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_reservation.dart';
import 'package:fithouse_mobile/core/models/m_seance.dart';
import 'package:fithouse_mobile/core/providers/p_reservation.dart';
import 'package:fithouse_mobile/views/v_planning.dart';
import 'package:flutter/material.dart';
import 'package:flutter_launcher_icons/xml_templates.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import '../core/providers/p_seance.dart';

class ReservationScreen extends StatelessWidget {
  final Client mclient;
  const ReservationScreen({Key? key, required this.mclient}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return CardScreen(
      mclient: mclient,
    );
  }
}

ThemeData appTheme = ThemeData(
  fontFamily: 'Oxygen',
  primaryColor: Colors.purpleAccent,
);

// class CardScreen extends StatelessWidget {
//   final Client mclient;

//   final reservationController = Get.put(ReservationController());

//   CardScreen({required this.mclient});
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Obx(() {
//         Future<void> _refresh() {
//           return reservationController.fetchReservation();
//         }

//         if (reservationController.isLoading.value) {
//           return Center(
//             child: CircularProgressIndicator(),
//           );
//         }
//         int i = 0;
//         return RefreshIndicator(
//           onRefresh: _refresh,
//           child: ListView.builder(
//             itemCount: reservationController.reservations.length,
//             itemBuilder: (context, index) {
//               final Reservation reservation =
//                   reservationController.reservations[index];

//               if (reservation.idClient == mclient.idClient) {
//                 i = i + 1;
//                 bool isGreen = i % 2 == 0;

//                 return CurvedListItem(
//                   title: reservation.cour.toString() +
//                       '  ' +
//                       reservation.datePresence.toString().substring(0, 10),
//                   time: reservation.heureDebut.toString().substring(0, 5) +
//                       ' à ' +
//                       reservation.heureFin.toString().substring(0, 5),
//                   color: isGreen ? Colors.green : Colors.red,
//                   nextColor: isGreen ? Colors.red : Colors.green,
//                 );
//               } else {
//                 return SizedBox
//                     .shrink(); // retourne un conteneur vide pour les éléments qui ne répondent pas à la condition
//               }
//             },
//           ),
//         );
//       }),
//     );
//   }
// }
class CardScreen extends StatefulWidget {
  final Client mclient;

  CardScreen({required this.mclient});

  @override
  _CardScreenState createState() => _CardScreenState(pclient: mclient);
}

class _CardScreenState extends State<CardScreen> {
  final Client pclient;
  _CardScreenState({required this.pclient});
  final reservationController = Get.put(ReservationController());
  final SeanceController seanceController = SeanceController();
  bool showAllReservations = true;
  bool FutureReservation = false;

  final ReservationController _reservationControllera =
  Get.put(ReservationController());

  DateTime now = DateTime.now();
  Future<void> _refresh() {
    seanceController.fetchSeances();
    return reservationController.fetchReservation();
  }

  // List<Widget> _buildFilters() {
  //   return [
  //     ActionChip(
  //       label: Text(
  //         'Afficher tout',
  //         style: TextStyle(
  //           color: showAllReservations ? Colors.white : Colors.black,
  //         ),
  //       ),
  //       backgroundColor: showAllReservations ? Colors.blue : Colors.white,
  //       onPressed: () {
  //         setState(() {
  //           showAllReservations = true;
  //           FutureReservation = false;
  //         });
  //       },
  //     ),
  //     ActionChip(
  //       label: Text(
  //         'Réservations à venir',
  //         style: TextStyle(
  //           color: FutureReservation ? Colors.white : Colors.black,
  //         ),
  //       ),
  //       backgroundColor: FutureReservation ? Colors.blue : Colors.white,
  //       onPressed: () {
  //         setState(() {
  //           showAllReservations = false;
  //           FutureReservation = true;
  //         });
  //       },
  //     ),
  //     // add more filters here
  //   ];
  // }

  // int couleurch(int idSeance) {
  //
  //   List<Seance> seances = seanceController.seances;
  //   for(var seance in seances){
  //     for (Reservation reservation in _reservationControllera.reservations) {
  //       if (seance.idSeance == idSeance) {
  //         break;
  //       }
  //     }
  //   }return idSeance;
  // }

  // List<Color?> colors = [
  //
  //   Colors.orange,
  //   Colors.lightBlueAccent,
  //   Colors.blueGrey
  // ];

  //

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() {
        if (reservationController.isLoading.value) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        DateTime dateIn60Days = DateTime.now().add(Duration(days: -60));
        List<Reservation> reservations = reservationController.reservations
            .where((reservation) => reservation.idClient == pclient.idClient)
            .toList();
        // if (showAllReservations) {
        //   reservations = reservations
        //       .where((reservation) =>
        //           reservation.datePresence!.isAfter(dateIn60Days))
        //       .toList();
        // } else if (FutureReservation) {
        //   reservations = reservations
        //       .where((reservation) =>
        //           reservation.datePresence!.day >= now.day &&
        //           reservation.datePresence!.month >= now.month &&
        //           reservation.datePresence!.year >= now.year)
        //       .toList();
        // }
        // final List<Reservation> reservations = showAllReservations
        //     ? reservationController.reservations
        //         .where((reservation) =>
        //             reservation.idClient == widget.mclient.idClient)
        //         .toList()
        //     : reservationController.reservations
        //         .where((reservation) =>
        //             reservation.idClient == widget.mclient.idClient &&
        //             now.year == reservation.datePresence!.year &&
        //             now.month <= reservation.datePresence!.month &&
        //             now.day <= reservation.datePresence!.day)
        //         .toList();

        return RefreshIndicator(
          onRefresh: _refresh,
          child: Column(
            children: [
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  //children: _buildFilters(),
                ),
              ),
              Expanded(
                  child: reservations.isEmpty
                      ? Center(child: Text('Vous n\'avez pas de reservation'))
                      : SfCalendar(
                    //allowedViews: [CalendarView.day,  CalendarView.week,CalendarView.month, CalendarView.schedule, CalendarView.timelineMonth],
                    view: CalendarView.schedule,
                    scheduleViewSettings: ScheduleViewSettings(
                      hideEmptyScheduleWeek: true,
                      monthHeaderSettings: MonthHeaderSettings(
                          monthFormat: 'MMMM, yyyy',
                          height: 85,
                          textAlign: TextAlign.center,
                          backgroundColor: Colors.lightBlueAccent,
                          monthTextStyle: TextStyle(
                              color: Colors.white,
                              fontSize: 25,
                              fontWeight: FontWeight.w400)),
                      appointmentTextStyle: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w800,
                          color: Colors.black),
                    ),
                    firstDayOfWeek: 1,
                    timeSlotViewSettings: TimeSlotViewSettings(
                      dayFormat: 'EEEE',
                    ),
                    appointmentTimeTextFormat: 'HH:mm',
                    initialDisplayDate: DateTime.now(),
                    dataSource: MeetingDataSource(_getDataSource()),
                  )),
            ],
          ),
        );
      }),
    );
  }

  List<Meeting> _getDataSource() {
    List<Reservation> reservations = reservationController.reservations
        .where((reservation) => reservation.idClient == pclient.idClient)
        .toList();

    final List<Meeting> meetings = <Meeting>[];
    final Random random = new Random();

    reservations.forEach((element) {
      String datePresence = element.datePresence.toString();
      String heureDebut = element.heureDebut.toString();
      String heureFin = element.heureFin.toString();
      DateTime datePresenceDateTime = DateTime.parse(datePresence);
      DateTime datePresenceDateTime2 = DateTime.parse(datePresence);
      List<String> heureDebutParts = heureDebut.split(':');
      int heuresDebut = int.parse(heureDebutParts[0]);
      int minutesDebut = int.parse(heureDebutParts[1]);
      List<String> heureFinParts = heureFin.split(':');
      int heuresFin = int.parse(heureFinParts[0]);
      int minutesFin = int.parse(heureFinParts[1]);
      DateTime resultat1 = datePresenceDateTime
          .add(Duration(hours: heuresDebut, minutes: minutesDebut));
      DateTime resultat2 = datePresenceDateTime2
          .add(Duration(hours: heuresFin, minutes: minutesFin));
      // print("resultat1");

      // for(var i = 0; i <= colors.length; ) {
      //   var color = colors[i];

      //  print(element.cour);

      meetings.add(Meeting(
        eventName: element.cour.toString(),
        from: DateTime.parse("${resultat1}"),
        to: DateTime.parse("${resultat2}"),
        couleur: Colors.orangeAccent,
      ));
    });

    return meetings;
  }
}

class Meeting extends Appointment {
  Meeting({
    required String eventName,
    required DateTime from,
    required DateTime to,
    required Color couleur,
  }) : super(
    startTime: from,
    endTime: to,
    subject: eventName,
    color: couleur,
    // background: colors[random.nextInt(5)]!,Color.fromRGBO(couleur, couleur * 10, couleur * 100, 0.8),
  );
}

class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Meeting> source) {
    appointments = source;
  }
}

class CurvedListItem extends StatelessWidget {
  const CurvedListItem({
    this.title = '',
    this.time = '',
    this.icon,
    this.people,
    this.color,
    this.nextColor,
  });

  final String title;
  final String time;
  final String? people;
  final IconData? icon;
  final Color? color;
  final Color? nextColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: nextColor,
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(80.0),
          ),
        ),
        padding: const EdgeInsets.only(
          left: 32,
          top: 5.0,
          bottom: 5,
        ),
        child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                time,
                style: TextStyle(color: Colors.white, fontSize: 12),
              ),
              const SizedBox(
                height: 2,
              ),
              FittedBox(
                fit: BoxFit.scaleDown,
                child: Text(
                  title,
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold),
                ),
              ),
              Row(),
            ]),
      ),
    );
  }
}

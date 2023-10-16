import 'dart:convert';
import 'dart:math';
import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_notification.dart';
import 'package:fithouse_mobile/core/models/m_validnot.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

import '../core/providers/notification_service.dart';
import '../core/providers/popupnotification.dart';
import '../utilities/env.dart';
import 'dart:async';

import 'Datab.dart';

class NotificationPage extends StatefulWidget {
  final Client? nclient;
  final Function(bool)?
      updateIndicator; // Callback function to update the notification indicator
  const NotificationPage({Key? key, this.nclient, this.updateIndicator})
      : super(key: key);
  @override
  _NotificationPageState createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  List<Notifications> notifications = [];
  List<ValidNot> validNotifs = [];
  bool hasUnreadNotifications = false;
  final NotificationPopService _notificationService = NotificationPopService();

  final inputFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
  final outputFormat = DateFormat('dd, MMMM');

  Future<List<dynamic>> _getNotifications() async {
    final data = await DatabaseHelper.getItems();

    final response =
        await http.get(Uri.parse(API.NOTIFICATIONS_ENDPOINT), headers: {
      'Content-Type':
          'application/json; charset=UTF-8', // Specify the content type and encoding
          "Authorization": "Bearer ${data[0]["token"]}"
    });
    if (response.statusCode == 200) {
      // utf8
      final body =
          utf8.decode(response.bodyBytes); // Decode response using UTF-8
      // print(body);
      return json.decode(body);
    } else {
      throw Exception('Failed to load notifications');
    }
  }

  Future<List<dynamic>> _getValidNotifs() async {
    final data = await DatabaseHelper.getItems();
    final response =
        await http.get(Uri.parse(API.NOTIFICATIONS_VALID_ENDPOINT), headers: {
          'Content-Type':
          'application/json; charset=UTF-8', // Specify the content type and encoding
          "Authorization": "Bearer ${data[0]["token"]}"
        });
    if (response.statusCode == 200) {
      final body =
          utf8.decode(response.bodyBytes); // Decode response using UTF-8
      final notifications = json.decode(body);
      // print(notifications);

      final filteredNotifs = notifications
          .where((validNotif) =>
              validNotif['client_id'] == widget.nclient!.idClient)
          .toList();

// print data

      return filteredNotifs;
    } else {
      throw Exception('Failed to load valid notifications');
    }
  }

  Future<void> markNotificationAsRead(int clientId, int notificationId) async {
    final data = await DatabaseHelper.getItems();
    final url = API.MARK_NOTIFICATION_ENDPOINT;
    final headers = {
      'Content-Type': 'application/json',
      "Authorization": "Bearer ${data[0]["token"]}"
    };
    final body = jsonEncode({
      'client_id': clientId,
      'notification_id': notificationId,
    });

    try {
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Notification marked as read for client $clientId');
        await loadData();
        // Update the indicator
        widget.updateIndicator!(hasUnreadNotifications);
      } else {
        print('Failed to mark notification as read. Error: ${response.body}');
      }
    } catch (e) {
      print('Failed to mark notification as read. Error: $e');
    }
  }

  Future<void> loadData() async {
    final notificationsData = await _getNotifications();
    final validNotifsData = await _getValidNotifs();

    setState(() {
      notifications = notificationsData
          .map((notif) => Notifications.fromJson(notif))
          .toList();
      validNotifs = validNotifsData
          .map((validNotif) => ValidNot.fromJson(validNotif))
          .toList();

      // Sort valid notifications by unread first
      validNotifs.sort((a, b) {
        if (a.isRead == b.isRead) {
          // If both notifications have the same read status, sort by date
          final dateTimeA = inputFormat.parse(notifications
                  .firstWhere((n) => n.idNotif == a.idNotif)
                  .dateEnvoye ??
              '');
          final dateTimeB = inputFormat.parse(notifications
                  .firstWhere((n) => n.idNotif == b.idNotif)
                  .dateEnvoye ??
              '');
          return dateTimeB
              .compareTo(dateTimeA); // Sort in descending order by date
        } else if (a.isRead == false && b.isRead == true) {
          // Sort unread notifications first
          return -1;
        } else {
          // Sort read notifications after unread ones
          return 1;
        }
      });
    });
    // check if there are unpopped notifications and show them using the popupnotification service

    bool hasUnread = false;

    try {
      hasUnread =
          await NotificationService.hasUnreadNotifications(widget.nclient!);
      var hasUnpop =
          await NotificationService.hasUnpoppedNotifications(widget.nclient!);
      if (hasUnpop) {
        for (var notif in notifications) {
          for (var validNotif in validNotifs) {
            // print("name" + "${validNotif.nameClient}");
            if (notif.idNotif == validNotif.idNotif &&
                validNotif.isPopped == false) {
              if (
                  // check date
                  DateTime.now()
                          .isAfter(inputFormat.parse(notif.dateEnvoye!)) &&
                      DateTime.now().isBefore(inputFormat
                          .parse(notif.dateEnvoye!)
                          .add(Duration(days: 1)))) {
                print("vvvvvvvvvvvvvv" + '${validNotif.isPopped}');
                _notificationService.showNotifications(
                  id: notif.idNotif,
                  title: notif.sujet,
                  body: notif.contenu,
                  idClient: widget.nclient!.idClient,
                );
                _notificationService.scheduleNotifications(
                  id: notif.idNotif,
                  title: notif.sujet,
                  body: notif.contenu,
                );

              }
            }
          }
        }
      }

      setState(() {
        hasUnreadNotifications = hasUnread;
      });
      widget.updateIndicator!(hasUnread);
    } catch (e) {
      print('Failed to check notifications: $e');
    }
  }

  Timer? _timer;
  // sort notifications by unread/read

  @override
  void initState() {
    super.initState();
    loadData();
    _startTimer();
  }

  @override
  void dispose() {
    _cancelTimer();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(Duration(seconds: 5), (_) {
      loadData();
    });
  }

  void _cancelTimer() {
    // Cancel the timer if it's active
    _timer?.cancel();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: validNotifs.isEmpty
          ? Center(child: Text('Vous n\'avez pas de notifications '))
          : RefreshIndicator(
              onRefresh: () async {
                await loadData();
              },
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: ListView(
                  children: validNotifs.map((validNotif) {
                    final notif = notifications
                        .firstWhere((n) => n.idNotif == validNotif.idNotif);
                    final dateTime = inputFormat.parse(notif.dateEnvoye ?? '');
                    final formattedDate = outputFormat.format(dateTime);

                    // Check if the notification is a past notification or a future notification with the same date as today
                    if (dateTime.isBefore(DateTime.now()) ||
                        dateTime.year == DateTime.now().year &&
                            dateTime.month == DateTime.now().month &&
                            dateTime.day == DateTime.now().day) {
                      return GestureDetector(
                        onTap: () {
                          if (validNotif.isRead == false) {
                            markNotificationAsRead(
                              widget.nclient!.idClient,
                              notif.idNotif!,
                            );
                            setState(() {
                              validNotif.isRead = true;
                            });
                          }
                        },
                        child: Padding(
                          padding: const EdgeInsets.all(0),
                          child: Card(
                            color: validNotif.isRead!
                                ? Colors.white
                                : Colors.orange[300],
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: <Widget>[
                                      Text(
                                        notif.sujet ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        formattedDate ?? '',
                                        style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 8),
                                  Text(notif.contenu ?? ''),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    } else {
                      return Container(); // Return an empty container for future notifications that don't match the current date
                    }
                  }).toList(),
                ),
              ),
            ),
    );
  }
}

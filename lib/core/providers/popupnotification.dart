// import local notification package
import 'dart:convert';

import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;
// httip
import 'package:flutter/material.dart';

import 'package:http/http.dart' as http;

import '../../utilities/env.dart';
import '../../views/Datab.dart';
import '../../views/v_notification.dart';

class NotificationPopService {
  // constructor

  //instance of FlutterLocalNotificationsPlugin
  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  Future<void> init() async {
    //Initialization Settings for Android
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('drawable/fithouselogo');

    //Initialization Settings for iOS
    const DarwinInitializationSettings initializationSettingsIOS =
        DarwinInitializationSettings(
      requestSoundPermission: false,
      requestBadgePermission: false,
      requestAlertPermission: false,
    );

    //Initializing settings for both platforms (Android & iOS)
    const InitializationSettings initializationSettings =
        InitializationSettings(
            android: initializationSettingsAndroid,
            iOS: initializationSettingsIOS);

    tz.initializeTimeZones();

    await flutterLocalNotificationsPlugin.initialize(initializationSettings,
        onDidReceiveNotificationResponse: onDidReceiveNotificationResponse);
  }

  // onDidReceiveNotificationResponse -> go to NotificationPage
  void onDidReceiveNotificationResponse(NotificationResponse response) {
    // Navigate to the NotificationPage passing the payload
    Get.to(() => const NotificationPage());
  }

  requestIOSPermissions() {
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            IOSFlutterLocalNotificationsPlugin>()
        ?.requestPermissions(
          alert: true,
          badge: true,
          sound: true,
        );

    // request permissions for android
    flutterLocalNotificationsPlugin
        .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin>()
        ?.createNotificationChannel(
          const AndroidNotificationChannel(
              'your channel id', // id
              'Notification Service', // title

              importance: Importance.max,
              showBadge: true,
              ledColor: Colors.amber),
        );
  }

  Future<void> markPoppedNotificationsAsRead(
      int notificationId, int clientId) async {
    final url = API.MARK_NOTIFICATION_POPPED_ENDPOINT;
    final body = jsonEncode({
      'notification_id': notificationId,
      'client_id': clientId,
    });

    try {
      final data = await DatabaseHelper.getItems();
      final headers = {'Content-Type': 'application/json', "Authorization": "Bearer ${data[0]["token"]}",};

      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);
      if (response.statusCode == 200) {
        print('Notification marked as popped: $notificationId');
      } else {
        print('Failed to mark notification as popped. Error: ${response.body}');
      }
    } catch (e) {
      print('Failed to mark notification as popped. Error: $e');
    }
  }

  Future<void> showNotifications({id, title, body, payload, idClient}) async {
    const AndroidNotificationDetails androidPlatformChannelSpecifics =
        AndroidNotificationDetails(
      'your channel id',
      'Notification Service',
      channelDescription: 'Notification Service',
      importance: Importance.high,
      priority: Priority.high,
      ledColor: Colors.amber,
      ticker: 'ticker',
      ledOnMs: 1000, // Specify the duration in milliseconds for LED on
      ledOffMs: 500, // Specify the duration in milliseconds for LED off
      styleInformation: BigTextStyleInformation(''),
    );
    const NotificationDetails platformChannelSpecifics =
        NotificationDetails(android: androidPlatformChannelSpecifics);
    await markPoppedNotificationsAsRead(id, idClient);
    await flutterLocalNotificationsPlugin.show(
      id,
      title,
      body,
      platformChannelSpecifics,
      payload: payload,
    );
  }

  Future<void> scheduleNotifications({id, title, body, time}) async {
    try {
      await flutterLocalNotificationsPlugin.zonedSchedule(
          id,
          title,
          body,
          //tz.TZDateTime.from(time, tz.local),
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          androidAllowWhileIdle: true,
          uiLocalNotificationDateInterpretation:
              UILocalNotificationDateInterpretation.absoluteTime);
      /*await flutterLocalNotificationsPlugin.zonedSchedule(
          0,
          'scheduled title',
          'scheduled body',
          tz.TZDateTime.now(tz.local).add(const Duration(seconds: 5)),
          const NotificationDetails(
              android: AndroidNotificationDetails(
                  'your channel id', 'your channel name',
                  channelDescription: 'your channel description')),
          androidScheduleMode: AndroidScheduleMode.exactAllowWhileIdle,
          uiLocalNotificationDateInterpretation:
          UILocalNotificationDateInterpretation.absoluteTime);*/
    } catch (e) {
      print(e);
    }
  }
}

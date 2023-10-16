import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:fithouse_mobile/views/Datab.dart';
import 'package:fithouse_mobile/views/auth_screen.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
import 'package:fithouse_mobile/views/v_acceuilp.dart';
import 'package:fithouse_mobile/views/v_splash.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_localizations/syncfusion_localizations.dart';
import 'dart:convert';

import 'core/providers/popupnotification.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Permission.notification.isDenied.then((value) {
    if (value) {
      Permission.notification.request();
    }
  });
  await NotificationPopService().init(); //
  await NotificationPopService().requestIOSPermissions();
  final items = await DatabaseHelper.getItems();
  if (items.isEmpty) {
    // Table is empty, create an item
    await DatabaseHelper.createItem(0, '', '', '', '');
  }
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    return MaterialApp(
        localizationsDelegates: [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          SfGlobalLocalizations.delegate
        ],
        supportedLocales: [
          Locale('fr'),
        ],
        locale: Locale('fr'),
        /*localizationsDelegates: [
        ],
        supportedLocales: [
          const Locale('fr'),
        ],*/
        title: 'FITHOUSE APP',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(

          primarySwatch: Colors.orange,
        ),
        home: Splashsc());
  }
}

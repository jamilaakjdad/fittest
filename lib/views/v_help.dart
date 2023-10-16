import 'package:device_info/device_info.dart';
import 'package:fithouse_mobile/views/menu_wideget.dart';
import 'package:flutter/material.dart';

import '../utilities/constant.dart';

class HelpPage extends StatefulWidget {
  @override
  _HelpPageState createState() => _HelpPageState();
}

class _HelpPageState extends State<HelpPage> {
  String namedevi = '';
  String versionde = '';
  Future<String> getDeviceName() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;

    try {
      androidInfo = await deviceInfo.androidInfo;
    } catch (e) {
      // Handle any exceptions that might occur while retrieving device info
      print('Failed to get device info: $e');
      return 'Unknown'; // Return a default value or handle the error accordingly
    }

    print('Running on ${androidInfo.model}');
    return androidInfo.model;
  }

  Future<String> getDeviceVersion() async {
    DeviceInfoPlugin deviceInfo = DeviceInfoPlugin();
    AndroidDeviceInfo androidInfo;

    try {
      androidInfo = await deviceInfo.androidInfo;
    } catch (e) {
      // Handle any exceptions that might occur while retrieving device info
      print('Failed to get device info: $e');
      return 'Unknown'; // Return a default value or handle the error accordingly
    }

    print('Running on ${androidInfo.model}');
    return androidInfo.version.release;
  }

  @override
  void initState() {
    super.initState();
    fetchDeviceName();
  }

  Future<void> fetchDeviceName() async {
    String deviceName = await getDeviceName();
    String deviceversion = await getDeviceVersion();
    setState(() {
      namedevi = deviceName;
      versionde = deviceversion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Aide',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Version de l\'application : ${release_version}',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Nom de l\'appareil :' + namedevi,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Version du système :' + versionde,
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(
              height: 20,
            ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Identifiant de l\'appareil :',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // ),
            // SizedBox(
            //   height: 20,
            // ),
            // Align(
            //   alignment: Alignment.centerLeft,
            //   child: Text(
            //     'Identifiant de l\'application :',
            //     style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            //   ),
            // )
          ],
        ),
      ),
    );
  }
}

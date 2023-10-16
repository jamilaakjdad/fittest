import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/utilities/env.dart';
import 'package:fithouse_mobile/views/Datab.dart';
import 'package:fithouse_mobile/views/auth_screen.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
import 'package:fithouse_mobile/views/v_acceuilp.dart';
import 'package:flutter/material.dart';

import '../utilities/constant.dart';

class Splashsc extends StatefulWidget {
  const Splashsc({super.key});

  @override
  State<Splashsc> createState() => _SplashscState();
}

class _SplashscState extends State<Splashsc> {
  List<Map<String, dynamic>> myData = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    setState(() {
      myData = data;
      _isLoading = false;
    });
  }

  @override
  void initState() {
    super.initState();
    // _checkTableAndNavigate();
    _refreshData();
    // Loading the data when the app starts
  }

//   @override
//   Widget build(BuildContext context) {
//     print(myData);
//     Client? clt = null; // Declare the clt variable here
//     if (myData.isNotEmpty) {
//       final clt = Client(
//           idClient: 47,
//           civilite: 'client.civilite',
//           nomClient: 'client.nomClient',
//           prenomClient: 'client.prenomClient',
//           adresse: 'client.adresse',
//           dateInscription: DateTime.now(),
//           dateNaissance: DateTime.now(),
//           tel: 'client.tel',
//           mail: myData[0]['title'],
//           password: myData[0]['description'],
//           idVille: 5,
//           cin: 'younes',
//           image: 'client.image',
//           statut: true,
//           blackliste: true,
//           newsletter: true);
//       print('object');
//     }
//     return Scaffold(
//       body: _isLoading
//           ? Center(child: CircularProgressIndicator())
//           : myData.isEmpty
//               ? AuthScreen()
//               : HomePage(
//                   client: clt!,
//                   currentItem: MenuItems.acceuil,
//                 ),
//     );
//   }
// }
  @override
  Widget build(BuildContext context) {
    print(myData);

    // Delay duration in seconds
    const delayDuration = Duration(seconds: 1);

    // Navigate to the next screen after the delay
    Future.delayed(delayDuration, () {
      if (myData[0]['description'] == '') {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => AuthScreen()),
        );
      } else {
        Client clt = Client(
          idClient: myData[0]['id'],
          mail: myData[0]['title'],
          password: myData[0]['description'],
          civilite: myData[0]['civilite']
        );
        clt.token = myData[0]["token"];
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => HomePage(
              client: clt,
              currentItem: MenuItems.acceuil,
            ),
          ),
        );
      }
    });

    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ENV == "prod" ?
            Image.asset(
                'assets/images/fithouse_LOGO.png'):
            Image.asset(
                'assets/images/logo_dev.png'),// Replace with your image asset path
            SizedBox(height: 16),
            CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}

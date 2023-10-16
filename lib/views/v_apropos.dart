import 'dart:io';

import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
import 'package:fithouse_mobile/views/menu_wideget.dart';
import 'package:flutter/material.dart';

import 'package:flutter/services.dart';

String first =
    'FIT-HOUSE est une application mobile développée par JYSSR-Connect. Notre application vise à faciliter votre expérience dans notre salle de sport en vous offrant des fonctionnalités pratiques et intuitives pour gérer votre emploi du temps et vos réservations de cours.';
String carct1 =
    'Consultation du planning - Vous pouvez facilement consulter le planning des cours disponibles, avec les horaires, les types de cours et les instructeurs associés. Vous serez toujours informé des dernières mises à jour du planning pour planifier vos entraînements en conséquence.';
String caract2 =
    'Réservation des cours - Grâce à notre fonctionnalité de réservation, vous pouvez réserver vos places pour les cours qui vous intéressent. Cela vous permet de garantir votre participation et de vous assurer une place dans les cours les plus populaires. Vous pouvez également annuler vos réservations si nécessaire.';
String caract3 =
    'Contacter l\'administration - Si vous avez des questions, des préoccupations ou des demandes spécifiques, notre fonction de contact avec l\'administration vous permet d\'entrer en communication directe avec notre équipe. Vous pouvez nous faire part de vos commentaires, suggestions ou demandes d\'assistance, et nous serons ravis de vous aider.';
String second =
    'L\'application FIT-HOUSE est disponible sur les plateformes iOS et Android, offrant une compatibilité maximale avec les appareils mobiles populaires. Nous travaillons constamment à l\'amélioration de l\'application et nous prévoyons de lancer de nouvelles fonctionnalités passionnantes dans les futures mises à jour.';
String third =
    'Notre équipe chez JYSSR-Connect est dévouée à créer une expérience utilisateur exceptionnelle pour nos utilisateurs de FIT-HOUSE. Nous attachons une grande importance à la sécurité de vos données personnelles et utilisons des mesures de sécurité avancées pour protéger vos informations.';
String forth =
    'Nous apprécions énormément vos commentaires, suggestions et questions. Si vous avez des idées pour améliorer l\'application ou si vous rencontrez des problèmes techniques, n\'hésitez pas à nous contacter à l\'adresse support@fit-house.com.';
String conc =
    'Merci d\'utiliser FIT-HOUSE ! Nous espérons que notre application vous aidera à atteindre vos objectifs de remise en forme et à profiter pleinement de votre expérience à la salle de sport.';

class AproposPage extends StatefulWidget {
  final Client aclient;
  const AproposPage({Key? key, required this.aclient}) : super(key: key);
  @override
  _AproposPageState createState() => _AproposPageState();
}

class _AproposPageState extends State<AproposPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'A propos',
            style: TextStyle(color: Colors.black),
          ),
          leading: MenuWidget(),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  client: widget.aclient,
                  currentItem: MenuItems.acceuil,
                ),
              ),
            );
            return true;
          },
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left: 13.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'À propos de FIT-HOUSE',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Text(''),
                  Text(first, style: TextStyle(fontSize: 18)),
                  Text(''),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Caractéristiques principales :',
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                  Text(''),
                  Text('1.' + carct1, style: TextStyle(fontSize: 18)),
                  Text(''),
                  Text('2.' + caract2, style: TextStyle(fontSize: 18)),
                  Text(''),
                  Text('3.' + caract3, style: TextStyle(fontSize: 18)),
                  Text(''),
                  Text(second, style: TextStyle(fontSize: 18)),
                  Text(''),
                  Text(third, style: TextStyle(fontSize: 18)),
                  Text(''),
                  Text(forth, style: TextStyle(fontSize: 18)),
                  Text(''), // Display the fetched device brand
                  Text(conc, style: TextStyle(fontSize: 18))
                ],
              ),
            ),
          ),
        ),
      );
}

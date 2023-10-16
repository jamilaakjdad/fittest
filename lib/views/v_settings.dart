import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
import 'package:fithouse_mobile/views/menu_wideget.dart';
import 'package:fithouse_mobile/views/modifpass.dart';
import 'package:fithouse_mobile/views/v_Help.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  final Client sclient;
  const SettingsScreen({Key? key, required this.sclient});
  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          title: Text(
            'Settings',
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
                  client: sclient,
                  currentItem: MenuItems.acceuil,
                ),
              ),
            );
            return true;
          },
          child: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: ListView(
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.lock),
                  title: Text('Changer mon mot de passe'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ChangePasswordPage(chclient: sclient),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: Icon(Icons.help),
                  title: Text('Aide'),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HelpPage(),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      );
}
// 
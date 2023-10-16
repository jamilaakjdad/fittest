import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_items.dart';
// import 'package:fithouse_mobile/views/auth_screen.dart';
import 'package:fithouse_mobile/views/main_screen.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
// import 'package:fithouse_mobile/views/start_page.dart';
import 'package:fithouse_mobile/views/v_apropos.dart';
import 'package:fithouse_mobile/views/v_contrat.dart';

import 'package:fithouse_mobile/views/v_profil.dart';
import 'package:fithouse_mobile/views/v_settings.dart';
import 'package:flutter/material.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';

class HomePage extends StatefulWidget {
  final Client client;
  final MenuItem currentItem;
  const HomePage({Key? key, required this.client, required this.currentItem})
      : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState(current: currentItem);
}

class _HomePageState extends State<HomePage> {
  MenuItem current;
  _HomePageState({Key? key, required this.current});

  @override
  Widget build(BuildContext context) => ZoomDrawer(
        style: DrawerStyle.Style1,
        borderRadius: 40,
        angle: -10,
        slideWidth: MediaQuery.of(context).size.width * 0.8,
        showShadow: true,
        backgroundColor: Colors.orangeAccent,
        mainScreen: getScreen(),
        menuScreen: Builder(builder: (context) {
          return MenuPage(
              myClient: widget.client,
              currentItem: current,
              onSelectedItem: (item) {
                setState(() => current = item);
                ZoomDrawer.of(context)!.close();
              });
        }),
      );

  Widget getScreen() {
    switch (current) {
      case MenuItems.acceuil:
        return MainScreen(
          client: widget.client,
        );
      case MenuItems.profil:
        return ProfilPage(pclient: widget.client);
      case MenuItems.settings:
        return SettingsScreen(sclient: widget.client);
      case MenuItems.apropos:
        return AproposPage(aclient: widget.client);
      case MenuItems.contrats:
      default:
        return ContratScreen(paclient: widget.client);
    }
  }
}

import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:fithouse_mobile/utilities/icon_path.dart';
import 'package:fithouse_mobile/views/auth_screen.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
import 'package:fithouse_mobile/views/menu_wideget.dart';
import 'package:fithouse_mobile/views/v_notification.dart';

import 'package:fithouse_mobile/views/v_planning.dart';
import 'package:fithouse_mobile/views/v_profil.dart';
import 'package:fithouse_mobile/views/v_acceuil.dart';
import 'package:fithouse_mobile/views/v_reservation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:persistent_bottom_nav_bar/persistent_tab_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../utilities/constant.dart';
import '../utilities/env.dart';
import '../core/providers/notification_service.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:url_launcher/url_launcher.dart';

class MainScreen extends StatefulWidget {
  final Client client;
  const MainScreen({Key? key, required this.client}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

String img = '';
String nom = '';

class _MainScreenState extends State<MainScreen> {
  PersistentTabController? _controller;
  int? selectedIndex;
  // bool notificationHasUnread = false;
  bool showNotificationIndicator = false;

  Future<void> _loadNotificationData() async {
    try {
      final hasUnread =
          await NotificationService.hasUnreadNotifications(widget.client);
      setState(() {
        showNotificationIndicator = hasUnread;
      });
    } catch (e) {
      print('Failed to check notifications: $e');
    }
  }

  void updateNotificationIndicator(bool hasUnreadNotifications) {
    setState(() {
      showNotificationIndicator = hasUnreadNotifications;
    });
  }

  void checkUpdateVersion() async {
    try {
      final response = await http.get(Uri.parse("$HOST/api/mobile_app_version"),
          headers: {
            "Content-Type": "application/json"
          }
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        if(jsonData["success"]){
          if(jsonData["version"] > currentVersion){
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            try{
              DateTime datetime_now = DateTime.now();

              var remember = await prefs.getBool('remember');
              var str_remember_date = await prefs.getString('remember_date');

              DateTime remember_date = DateTime.parse(str_remember_date!);
              if(remember != null && remember_date != null){
                if(remember){
                  if(datetime_now.isAfter(remember_date)){
                    _showMyDialog();
                  }
                }
              }else{
                _showMyDialog();
              }
            }catch(e){
              print(e);
              _showMyDialog();
            }
          }
        }
        print("current --version ${jsonData}");
      } else {
        throw Exception('Failed to get current version');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  void rememberLater () async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    try{
      DateTime datetime_remember = DateTime.now().add(Duration(hours: 24)); // Remember After 24h
      String dateStr = datetime_remember.toString();
      await prefs.setBool('remember', true);
      await prefs.setString('remember_date', dateStr);
    }catch(e){
      print(e);
    }
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Notification de mise à jour'),
          content: const Text("Une version de l'application est disponible maintenant, obtenez-la maintenant"),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(context, 'Cancel');
                rememberLater();
              },
              child: const Text('Plus tard'),
            ),
            TextButton(
              onPressed: () async{
                Navigator.pop(context, 'OK');
                final Uri url = Uri.parse('market://details?id=ma.fithouse.fitapp');
                if (!await launchUrl(url)) {
                  throw Exception('Could not launch $url');
                }
              },
              child: const Text('Mise à jour'),
            ),
          ],
        );
      },
    );
  }

  @override
  void initState() {
    _controller = PersistentTabController();
    _loadNotificationData();
    checkUpdateVersion();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final clientapi = Get.put(ClientAPI());
    for (Client client1 in clientapi.clients) {
      print('loop for');
      print('client1.idClient: ${client1.idClient}');
      print('widget.client.idClient: ${widget.client.idClient}');
      if (client1.idClient == widget.client.idClient) {
        print(client1.image);
        print('enter');
        img = client1.image;
        nom = client1.nomClient;
      }
    }
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: Align(
              alignment: Alignment.centerRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    nom.toString(),
                    style: TextStyle(color: Colors.black),
                  ),
                  Padding(padding: EdgeInsets.only(left: 15)),
                  GestureDetector(
                    onTap: () =>
                    {
                      if(widget.client.mail != "guest@fithouse.com"){
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => HomePage(
                                client: widget.client,
                                currentItem: MenuItems.profil,
                              )),
                        )
                      }

                    },
                    child: CircleAvatar(
                      backgroundImage: img != ''
                          ? NetworkImage(
                              '${API.MEDIA_ENDPOINT}${img}',
                            )
                          : null,
                    ),
                  ),
                ],
              )),
          backgroundColor: Colors.white,
          leading: MenuWidget(),
        ),
        body: PersistentTabView(
          context,
          controller: _controller,
          navBarHeight: kSizeBottomNavigationBarHeight,
          screens: _buildScreens(),
          items: _navBarsItems(),
          confineInSafeArea: true,
          backgroundColor: kColorBNBBackground,
          handleAndroidBackButtonPress: true,
          resizeToAvoidBottomInset: true,
          stateManagement: true,
          hideNavigationBarWhenKeyboardShows: true,
          popAllScreensOnTapOfSelectedTab: false,
          popActionScreens: PopActionScreensType.all,
          itemAnimationProperties: const ItemAnimationProperties(
            duration: Duration(milliseconds: 200),
            curve: Curves.ease,
          ),
          screenTransitionAnimation: const ScreenTransitionAnimation(
            animateTabTransition: false,
            curve: Curves.ease,
            duration: Duration(milliseconds: 200),
          ),
          navBarStyle: NavBarStyle.style19,
          onItemSelected: (final index) {
            setState(() {
              _controller?.index = index; // THIS IS CRITICAL!! Don't miss it!
            });
          },
        ),
      ),
    );
  }

  List<Widget> _buildScreens() {
    return [
      HomePagess(pclient: widget.client),
      NotificationPage(
        nclient: widget.client,
        updateIndicator: updateNotificationIndicator,
      ),
      ReservationScreen(
        mclient: widget.client,
      ),
      PlanningPage(
        pclient: widget.client,
      ),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems() {
    return [
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarHome,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarHomeDeactive,
              ),
            ),
          ],
        ),
        title: ('Home'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: kSizeBottomNavigationBarIconHeight,
                  child: Image.asset(
                    kIconPathBottomNavigationBarAnimals,
                  ),
                ),
              ],
            ),
            if (showNotificationIndicator)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),
        inactiveIcon: Stack(
          children: [
            Column(
              children: [
                SizedBox(
                  height: kSizeBottomNavigationBarIconHeight,
                  child: Image.asset(
                    kIconPathBottomNavigationBarAnimalsDeactive,
                  ),
                ),
              ],
            ),
            if (showNotificationIndicator)
              Positioned(
                top: 0,
                right: 0,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
          ],
        ),

        // Other properties
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarPlants,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarPlantsDeactive,
              ),
            ),
          ],
        ),
        title: ('Plants'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
      PersistentBottomNavBarItem(
        icon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarProfile,
              ),
            ),
          ],
        ),
        inactiveIcon: Column(
          children: [
            SizedBox(
              height: kSizeBottomNavigationBarIconHeight,
              child: Image.asset(
                kIconPathBottomNavigationBarProfileDeactive,
              ),
            ),
          ],
        ),
        title: ('Profile'),
        activeColorPrimary: kColorBNBActiveTitleColor,
        inactiveColorPrimary: kColorBNBDeactiveTitleColor,
      ),
    ];
  }
}

import 'dart:async';

import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_ville.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:fithouse_mobile/core/providers/p_ville.dart';
import 'package:fithouse_mobile/views/auth_screen.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/menu_page.dart';
import 'package:fithouse_mobile/views/menu_wideget.dart';
import 'package:fithouse_mobile/views/v_editprofil.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../utilities/env.dart';

class ProfilPage extends StatefulWidget {
  final Client pclient;
  const ProfilPage({Key? key, required this.pclient}) : super(key: key);
  @override
  _ProfilPageState createState() => _ProfilPageState(paclient: pclient);
}

class _ProfilPageState extends State<ProfilPage> {
  final Client paclient;
  final villeController = Get.put(VilleController());
  final ClientAPI clientAPI = Get.put(ClientAPI());
  Timer? _timer;
  _ProfilPageState({Key? key, required this.paclient});
  @override
  void initState() {
    super.initState();
    clientAPI.fetchClient();
    _timer = Timer.periodic(Duration(seconds: 2), (timer) {
      clientAPI.fetchClient();
    });
    villeController.fetchVilles();
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: MenuWidget(),
        ),
        body: WillPopScope(
          onWillPop: () async {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => HomePage(
                  client: paclient,
                  currentItem: MenuItems.acceuil,
                ),
              ),
            );
            return true;
          },
          child: Obx(() {
            // String laville = '';
            for (Client client in clientAPI.clients) {
              if (paclient.idClient == client.idClient) {
                if (villeController.isLoading.value) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }

                getville() {
                  for (Ville ville in villeController.villes) {
                    if (ville.idVille == client.idVille) {
                      return ville.nomVille.toString();
                    }
                  }
                }

                return SingleChildScrollView(
                    child: Container(
                  padding: const EdgeInsets.all(50),
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          SizedBox(
                            width: 120,
                            height: 120,
                            child: ClipRRect(
                                borderRadius: BorderRadius.circular(50),
                                child: Image(
                                    image: NetworkImage(
                                        '${API.MEDIA_ENDPOINT}${client.image}'))),
                          ),
                          // Positioned(
                          //   bottom: 0,
                          //   right: 0,
                          //   child: Container(
                          //     width: 35,
                          //     height: 35,
                          //     decoration: BoxDecoration(
                          //       borderRadius: BorderRadius.circular(100),
                          //       color: Color.fromARGB(184, 228, 142, 21),
                          //     ),
                          //     child: const Icon(
                          //       LineAwesomeIcons.alternate_pencil,
                          //       color: Colors.black,
                          //       size: 20,
                          //     ),
                          //   ),
                          // )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(client.nomClient + ' ' + client.prenomClient,
                          style: TextStyle(fontWeight: FontWeight.bold)),
                      Text(client.mail),
                      const SizedBox(
                        height: 20,
                      ),
                      SizedBox(
                        width: 200,
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => UpdateProfileScreen(
                                        zaclient: paclient,
                                      )),
                            );
                          },
                          style: ElevatedButton.styleFrom(
                              backgroundColor:
                                  const Color.fromARGB(184, 228, 142, 21),
                              side: BorderSide.none,
                              shape: const StadiumBorder()),
                          child: Text(
                            'Editer mon profile',
                            style: TextStyle(color: Color(0xff000000)),
                          ),
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      const Divider(),
                      const SizedBox(
                        height: 10,
                      ),
                      ProfileMenuWidget(
                        title: client.adresse,
                        icon: LineAwesomeIcons.map_marker,
                      ),
                      ProfileMenuWidget(
                        title: client.tel,
                        icon: LineAwesomeIcons.phone,
                      ),
                      // const ProfileMenuWidget(
                      //   title: 'Z1524356',
                      //   icon: LineAwesomeIcons.address_card,
                      // ),

                      ProfileMenuWidget(
                        title: getville().toString(),
                        icon: LineAwesomeIcons.map_marked,
                      ),
                      ProfileMenuWidget(
                        title: DateFormat.yMMMd()
                            .format(client.dateNaissance ?? DateTime.now()),
                        icon: LineAwesomeIcons.calendar_1,
                      ),
                    ],
                  ),
                ));
              }
            }

            return Scaffold();
          }),
        ),
      );
}

class ProfileMenuWidget extends StatelessWidget {
  const ProfileMenuWidget({
    Key? key,
    required this.title,
    required this.icon,
  }) : super(key: key);
  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(100),
          color: Color(0xFF001BFF).withOpacity(0.1),
        ),
        child: Icon(
          icon,
          color: Color(0xFF001BFF),
        ),
      ),
      title: Text(
        title,
        style: Theme.of(context).textTheme.labelLarge,
      ),
    );
  }
}

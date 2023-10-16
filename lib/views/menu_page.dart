import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_items.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:fithouse_mobile/views/Datab.dart';
import 'package:fithouse_mobile/views/auth_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

import '../utilities/env.dart';

class MenuItems {
  static const acceuil = MenuItem('Acceuil', Icons.home);
  static const profil = MenuItem('Profil', Icons.face);
  static const settings = MenuItem('Paramètres', Icons.settings);
  static const apropos = MenuItem('À-propos', Icons.info_outline);
  static const contrats =
      MenuItem('Mes contrats', LineAwesomeIcons.file_contract);

  static var all = <MenuItem>[
    acceuil,
    profil,
    settings,
    apropos,
    contrats,
  ];
}

Future<void> deletit() async {
  await DatabaseHelper.deleteItems();
}

Future<void> delet() async {
  await DatabaseHelper.updateAllPasswords('');
}

class MenuPage extends StatefulWidget {
  final Client myClient;
  final MenuItem currentItem;
  final ValueChanged<MenuItem> onSelectedItem;

  const MenuPage({
    Key? key,
    required this.myClient,
    required this.currentItem,
    required this.onSelectedItem,
  }) : super(key: key);

  @override
  _MenuPageState createState() => _MenuPageState();
}

String img = '';
String pren = '';
String noom = '';

class _MenuPageState extends State<MenuPage> {
  final clientapi = Get.put(ClientAPI());
  @override
  void initState() {
    clientapi.fetchClient();
    super.initState();
  }

  // void getClientDetails() {
  //   final clientapi = Get.put(ClientAPI());
  //   for (Client client1 in clientapi.clients) {
  //     if (client1.idClient == widget.myClient.idClient) {
  //       setState(() {
  //         img = client1.image;
  //         pren = client1.prenomClient;
  //         noom = client1.nomClient;
  //       });
  //       break;
  //     }
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    setState(() {
      clientapi.fetchClient();
    });
    for (Client client1 in clientapi.clients) {
      print('loop for');
      print('client1.idClient: ${client1.idClient}');
      print('widget.client.idClient: ${widget.myClient.idClient}');
      if (client1.idClient == widget.myClient.idClient) {
        print(client1.image);
        print('enter');
        img = client1.image;
        noom = client1.nomClient;
        pren = client1.prenomClient;
        if(client1.mail == "guest@fithouse.com"){
          MenuItems.all = MenuItems.all.where((item) => item.title != "Paramètres").toList();
          MenuItems.all = MenuItems.all.where((item) => item.title != "Mes contrats").toList();
          MenuItems.all = MenuItems.all.where((item) => item.title != "Profil").toList();
        }
      }
    }
    return Theme(
      data: ThemeData.dark(),
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(padding: EdgeInsets.only(top: 50)),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: CircleAvatar(
                  radius: 50,
                  child: ClipOval(
                    child: SizedBox(
                      width: 100,
                      height: 100,
                      child: CircleAvatar(
                        backgroundImage: img != ''
                            ? NetworkImage(
                                '${API.MEDIA_ENDPOINT}${img}',
                              )
                            : null,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  '${noom.toString()} ${pren.toString()}',
                  style: TextStyle(color: Colors.black, fontSize: 20.0),
                ),
              ),
              Spacer(),
              ...MenuItems.all.map((item) => buildMenuItem(item)).toList(),
              Spacer(
                flex: 2,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 15),
                child: ElevatedButton(
                  style: ButtonStyle(
                    backgroundColor:
                        MaterialStateProperty.all<Color>(Colors.white),
                    side: MaterialStateProperty.all<BorderSide>(
                      BorderSide(
                        color: Colors.black,
                        width: 2.0,
                        style: BorderStyle.solid,
                      ),
                    ),
                  ),
                  onPressed: () {
                    delet();
                    /*Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(builder: (context) => AuthScreen()),
                            (Route<dynamic> route) => false
                    );*/
                    Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => AuthScreen()),

                    );
                  },
                  child: Text(
                    'Se deconnecter',
                    style: TextStyle(color: Colors.black),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget buildMenuItem(MenuItem item,
          {Color iconColor = Colors.black, Color textColor = Colors.black}) =>
      ListTileTheme(
        selectedColor: Colors.black,
        child: ListTile(
          selectedTileColor: Colors.black26,
          selected: widget.currentItem == item,
          minLeadingWidth: 20,
          leading: Icon(
            item.icon,
            color: iconColor,
          ),
          title: Text(
            item.title,
            style: TextStyle(color: textColor),
          ),
          onTap: () => widget.onSelectedItem(item),
        ),
      );
}

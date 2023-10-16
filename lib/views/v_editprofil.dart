import 'dart:async';
import 'dart:io';
import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_ville.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:fithouse_mobile/core/providers/p_ville.dart';
import 'package:fithouse_mobile/views/auth_screen.dart';
import 'package:fithouse_mobile/views/v_imagepick.dart';
import 'package:fithouse_mobile/views/v_profil.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../utilities/env.dart';
// import 'package:animated_custom_dropdown/custom_dropdown.dart';

class UpdateProfileScreen extends StatefulWidget {
  final Client zaclient;
  static GlobalKey<_UpdateProfileScreenState> updateProfileKey =
      GlobalKey<_UpdateProfileScreenState>();
  UpdateProfileScreen({Key? key, required this.zaclient}) : super(key: key);

  @override
  _UpdateProfileScreenState createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final VilleController villeController = Get.put(VilleController());
  final ClientAPI clientAPI = Get.put(ClientAPI());
  Timer? _timer;
  // TextEditingController cin = TextEditingController();
  // TextEditingController civilite = TextEditingController();
  // TextEditingController date = TextEditingController();
  @override
  void initState() {
    super.initState();
    clientAPI.fetchClient();
    setState(() {});
    // _timer = Timer.periodic(Duration(seconds: 10), (timer) {
    //   clientAPI.fetchClient();
    // });
  }

  @override
  void dispose() {
    // Cancel the timer when the widget is disposed
    _timer?.cancel();
    super.dispose();
  }

  void refresh() {
    clientAPI.fetchClient();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    String imgcl = '';
    String namecl = '';
    String prenomcl = '';
    String adressecl = '';
    String telcl = '';
    String mailcl = '';
    String villese = '';
    String dateins = '';
    // String prenomcl = '';
    // String prenomcl = '';
    // String prenomcl = '';
    // String prenomcl = '';
    for (Client client in clientAPI.clients) {
      if (widget.zaclient.idClient == client.idClient) {
        namecl = client.nomClient;
        prenomcl = client.prenomClient;
        imgcl = client.image;
        adressecl = client.adresse;
        telcl = client.tel;
        mailcl = client.mail;
        villese = client.idVille.toString();
        dateins = client.dateInscription.toString().substring(0, 10);
      }
    }
    TextEditingController name = TextEditingController(text: namecl);
    TextEditingController prenom = TextEditingController(text: prenomcl);
    // int ville = 0;
    TextEditingController address = TextEditingController(text: adressecl);
    // villeController.fetchVilles();
    final clientapi = Get.put(ClientAPI());
    Ville selectedVille = Ville(idVille: 0, nomVille: '');
    for (Ville ville in villeController.villes) {
      for (Client client1 in clientapi.clients) {
        if (client1.idClient == widget.zaclient.idClient) {
          if (client1.idVille == ville.idVille) {
            selectedVille = ville;
            break; // Exit the loop once the matching Ville is found
          }
        }
      }
    }
    TextEditingController email = TextEditingController(text: mailcl);
    // TextEditingController pass = TextEditingController();
    final villeControllered = TextEditingController();
    // TextEditingController pass2 = TextEditingController();

    TextEditingController tel = TextEditingController(text: telcl);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(184, 228, 142, 21),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(LineAwesomeIcons.angle_left),
        ),
        title: Text(
          "Editer mon profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
          child: Container(
        padding: EdgeInsets.all(50),
        child: Column(children: [
          Stack(
            children: [
              SizedBox(
                width: 120,
                height: 120,
                child: ClipRRect(
                    borderRadius: BorderRadius.circular(50),
                    child: Image(
                        image: NetworkImage('${API.MEDIA_ENDPOINT}${imgcl}'))),
              ),
              Positioned(
                bottom: 0,
                right: 0,
                child: GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            ImageUploaderScreen(imclient: widget.zaclient),
                      ),
                    ).then((_) {
                      // Appelé lorsque la page NextPage est poppée
                      UpdateProfileScreen.updateProfileKey.currentState
                          ?.refresh(); // Appel de la méthode de rafraîchissement
                    });
                  },
                  child: Container(
                    width: 35,
                    height: 35,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: Color.fromARGB(184, 228, 142, 21),
                    ),
                    child: const Icon(
                      LineAwesomeIcons.alternate_pencil,
                      color: Colors.black,
                      size: 20,
                    ),
                  ),
                ),
              )
            ],
          ),
          const SizedBox(height: 50),
          Form(
            child: Column(children: [
              // CustomDropdown.search(
              //   hintText: 'Select Ville',
              //   items: villeController.villes
              //       .map((Ville ville) => ville.nomVille)
              //       .toList(),
              //   controller: villeControllered,
              // ),
              TextFormField(
                controller: name,
                // initialValue: 'Mon nom',
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIconColor: Color(0xFF272727),
                    floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF272727))),
                    label: Text('Nom'),
                    prefixIcon: Icon(LineAwesomeIcons.user)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: prenom,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIconColor: Color(0xFF272727),
                    floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF272727))),
                    label: Text('Prenom'),
                    prefixIcon: Icon(LineAwesomeIcons.user)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: address,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIconColor: Color(0xFF272727),
                    floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF272727))),
                    label: Text('Adresse'),
                    prefixIcon: Icon(LineAwesomeIcons.map_marker)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: tel,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIconColor: Color(0xFF272727),
                    floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF272727))),
                    label: Text('Phone'),
                    prefixIcon: Icon(LineAwesomeIcons.phone)),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: email,
                decoration: const InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIconColor: Color(0xFF272727),
                    floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF272727))),
                    label: Text('Email'),
                    prefixIcon: Icon(LineAwesomeIcons.mail_bulk)),
              ),
              const SizedBox(height: 10),

              DropdownButtonFormField<Ville>(
                value: selectedVille,
                isExpanded: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    prefixIconColor: Color(0xFF272727),
                    floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                    focusedBorder: OutlineInputBorder(
                        borderSide:
                            BorderSide(width: 2, color: Color(0xFF272727))),
                    label: Text('Ville'),
                    prefixIcon: Icon(LineAwesomeIcons.location_arrow)),
                items: villeController.villes.map((Ville ville) {
                  return DropdownMenuItem<Ville>(
                    value: ville,
                    child: Text(ville.nomVille),
                  );
                }).toList(),
                onChanged: (Ville? newValue) {
                  if (newValue != null) {
                    selectedVille = newValue;
                    int? selectedIdVille = selectedVille.idVille;
                    String? selectedNomVille = selectedVille.nomVille;
                    print(
                        'Selected ville: $selectedNomVille (ID: $selectedIdVille)');
                  }
                },
              ),
              const SizedBox(height: 10),
              // TextFormField(
              //   controller: pass,
              //   decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       prefixIconColor: Color(0xFF272727),
              //       floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(width: 2, color: Color(0xFF272727))),
              //       label: Text('Mot de passe'),
              //       prefixIcon: Icon(LineAwesomeIcons.map_marker)),
              // ),
              // const SizedBox(height: 10),
              // TextFormField(
              //   decoration: const InputDecoration(
              //       border: OutlineInputBorder(),
              //       prefixIconColor: Color(0xFF272727),
              //       floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
              //       focusedBorder: OutlineInputBorder(
              //           borderSide:
              //               BorderSide(width: 2, color: Color(0xFF272727))),
              //       label: Text('Date de naissance'),
              //       prefixIcon: Icon(LineAwesomeIcons.calendar)),
              // ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    final clientapi = Get.put(ClientAPI());
                    await clientapi.fetchClient();
                    final RegExp emailRegex = RegExp(
                      r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$',
                    );
                    final RegExp telRegex = RegExp(
                      r'^0[0-9]{9}$',
                    );
                    for (Client client in clientapi.clients) {
                      if (client.idClient == widget.zaclient.idClient) {
                        if (!emailRegex.hasMatch(email.text)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                content: Text('Email incorrect'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else if (!telRegex.hasMatch(tel.text)) {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return CupertinoAlertDialog(
                                content: Text('tel incorrect'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        } else {
                          final updatedClient = Client(
                              idClient: client.idClient,
                              civilite: client.civilite,
                              nomClient: name.text.toString(),
                              prenomClient: prenom.text.toString(),
                              adresse: address.text.toString(),
                              tel: tel.text.toString(),
                              mail: email.text.toString(),
                              dateInscription: client.dateInscription,
                              dateNaissance: client.dateNaissance,
                              // password: pass.text.toString(),
                              cin: client.cin,
                              idVille: selectedVille.idVille,
                              image: client.image,
                              blackliste: client.blackliste,
                              statut: client.statut,
                              newsletter: client.newsletter);
                          print(updatedClient.toJson());
                          await ClientAPI.updateClient(updatedClient);
                          Navigator.of(context).pop();
                        }
                      }
                    }
                    // Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                      backgroundColor: const Color.fromARGB(184, 228, 142, 21),
                      side: BorderSide.none,
                      shape: const StadiumBorder()),
                  child: const Text(
                    'Valider',
                    style: TextStyle(color: Color(0xff000000)),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Row(
                children: [
                  Text.rich(TextSpan(
                      text: 'Membre depuis le ',
                      style: TextStyle(fontSize: 12),
                      children: [
                        TextSpan(
                            text: dateins,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 12))
                      ]))
                ],
              )
            ]),
          )
        ]),
      )),
    );
  }
}

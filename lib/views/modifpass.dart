import 'package:crypto/crypto.dart';
import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';

class ChangePasswordPage extends StatefulWidget {
  final Client chclient;
  const ChangePasswordPage({super.key, required this.chclient});

  @override
  State<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends State<ChangePasswordPage> {
  bool obscurePassword = true;
  bool obscurePassword2 = true;
  bool obscurePassword3 = true;
  TextEditingController currentPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confPasswordController = TextEditingController();
  bool showError = false;
  String errorMessage = '';
  @override
  Widget build(BuildContext context) {
    // final FocusNode newPasswordFocusNode = FocusNode();

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: Text(
          'Changer le mot de passe',
          style: TextStyle(color: Colors.black),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            children: [
              // TextFormField(
              //   controller: currentPasswordController,
              //   obscureText: obscurePassword3,
              //   decoration: InputDecoration(
              //     border: OutlineInputBorder(),
              //     prefixIconColor: Color(0xFF272727),
              //     floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
              //     focusedBorder: OutlineInputBorder(
              //         borderSide:
              //             BorderSide(width: 2, color: Color(0xFF272727))),
              //     label: Text('Ancien mot de passe'),
              //     prefixIcon: Icon(LineAwesomeIcons.user),
              //     suffixIcon: IconButton(
              //       onPressed: () {
              //         // Toggle password visibility
              //         setState(() {
              //           obscurePassword3 = !obscurePassword3;
              //         });
              //       },
              //       icon: obscurePassword3 == true
              //           ? Icon(Icons.visibility)
              //           : Icon(Icons.visibility_off),
              //     ),
              //   ),
              // ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: newPasswordController,
                // focusNode: newPasswordFocusNode,
                obscureText: obscurePassword2,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIconColor: Color(0xFF272727),
                  floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFF272727))),
                  label: Text('Nouveau mot de passe'),
                  prefixIcon: Icon(LineAwesomeIcons.user),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Toggle password visibility
                      setState(() {
                        obscurePassword2 = !obscurePassword2;
                      });
                    },
                    icon: obscurePassword2 == true
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              TextFormField(
                controller: confPasswordController,
                // initialValue: 'Mon nom',
                obscureText: obscurePassword,
                decoration: InputDecoration(
                  border: OutlineInputBorder(),
                  prefixIconColor: Color(0xFF272727),
                  floatingLabelStyle: TextStyle(color: Color(0xFF272727)),
                  focusedBorder: OutlineInputBorder(
                      borderSide:
                          BorderSide(width: 2, color: Color(0xFF272727))),
                  label: Text('Confirmer votre mot de passe'),
                  prefixIcon: Icon(LineAwesomeIcons.user),
                  suffixIcon: IconButton(
                    onPressed: () {
                      // Toggle password visibility
                      setState(() {
                        obscurePassword = !obscurePassword;
                      });
                    },
                    icon: obscurePassword == true
                        ? Icon(Icons.visibility)
                        : Icon(Icons.visibility_off),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Align(
                alignment: Alignment.center,
                child: TextButton(
                  onPressed: () {
                    final currentPassword = currentPasswordController.text;
                    final hashedCurrentPassword =
                        sha1.convert(utf8.encode(currentPassword)).toString();

                    final ClientAPI clientAPI = Get.put(ClientAPI());
                    clientAPI.fetchClient();
                    for (Client client in clientAPI.clients) {
                      print(client.password);
                      if (widget.chclient.idClient == client.idClient) {
                        print(client.password);
                        // if (client.password != hashedCurrentPassword) {
                        //   setState(() {
                        //     // print(
                        //     //     hashedCurrentPassword + ' ' + client.password);
                        //     showError = true;
                        //     errorMessage = 'Votre mot de passe est incorrect.';
                        //   });
                        //   return;
                        // } else
                        if (newPasswordController.text == '') {
                          setState(() {
                            showError = true;
                            errorMessage = 'remplit les champs';
                          });
                          return;
                        } else if (newPasswordController.text !=
                            confPasswordController.text) {
                          setState(() {
                            showError = true;
                            errorMessage =
                                'Les mots de passe ne correspondent pas.';
                          });
                          return;
                        } else {
                          setState(() {
                            showError = false;
                            errorMessage = '';
                          });
                          Client clientToUpdate = Client(
                              // Set the properties of the client to update
                              idClient: client.idClient,
                              civilite: client.civilite,
                              nomClient: client.nomClient,
                              prenomClient: client.prenomClient,
                              adresse: client.adresse,
                              dateInscription: client.dateInscription,
                              dateNaissance: client.dateNaissance,
                              tel: client.tel,
                              mail: client.mail,
                              password: newPasswordController.text.toString(),
                              idVille: client.idVille,
                              cin: client.cin,
                              image: client.image,
                              statut: client.statut,
                              blackliste: client.blackliste,
                              newsletter: client.newsletter);
                          ClientAPI.updateClient(clientToUpdate);
                          // setState(() {
                          //   showError = true;
                          //   errorMessage =
                          //       'Votre mot de passe est changé avec succée.';
                          // });
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                content: Text(
                                    'Le mot de passe a été modifié avec succès.'),
                                actions: [
                                  TextButton(
                                    child: Text('OK'),
                                    onPressed: () {
                                      Navigator.of(context)
                                          .pop(); // Ferme le AlertDialog
                                      Navigator.of(context).pop();
                                    },
                                  ),
                                ],
                              );
                            },
                          );
                        }
                      }
                    }
                  },
                  child: Text(
                    'Confirmer',
                    style: TextStyle(color: Colors.black, fontSize: 25),
                  ),
                ),
              ),
              if (showError)
                Text(
                  errorMessage,
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

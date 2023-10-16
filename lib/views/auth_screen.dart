import 'dart:math';
import 'package:animated_custom_dropdown/custom_dropdown.dart';
import 'package:fithouse_mobile/core/providers/p_client.dart';
import 'package:fithouse_mobile/views/Datab.dart';
import 'package:fithouse_mobile/views/v_apropos.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dropdown_search/dropdown_search.dart';
import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:fithouse_mobile/core/models/m_ville.dart';
import 'package:fithouse_mobile/core/providers/auth_provider.dart';
import 'package:fithouse_mobile/core/providers/p_ville.dart';
import 'package:fithouse_mobile/utilities/socal_buttons.dart';
import 'package:fithouse_mobile/views/homepage.dart';
import 'package:fithouse_mobile/views/v_acceuilp.dart';
import 'package:flutter_dialogs/flutter_dialogs.dart';
import 'package:intl/intl.dart';

import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
// import 'dart:io';
import '../utilities/constant.dart';
import 'package:line_awesome_flutter/line_awesome_flutter.dart';
import 'package:flutter_svg/flutter_svg.dart';
// import 'dart:convert';

import 'menu_page.dart';

final _emailController = TextEditingController();

// GlobalKey<FormState> _formKey = GlobalKey<FormState>();
// GlobalKey<FormState> _formKey2 = GlobalKey<FormState>();

final _passwordController = TextEditingController();
TextEditingController name = TextEditingController();
TextEditingController prenom = TextEditingController();
TextEditingController ville = TextEditingController();
TextEditingController email = TextEditingController();
TextEditingController pass = TextEditingController();
TextEditingController pass2 = TextEditingController();
TextEditingController address = TextEditingController();
TextEditingController tel = TextEditingController();
TextEditingController cin = TextEditingController();
// TextEditingController civilite = TextEditingController();
TextEditingController date = TextEditingController();
Ville? selectedVille;
int currentStep = 0;
final villeControllered = TextEditingController();
String selectedCivility = 'Monsieur';

bool _isLoading = false;
void _submit(BuildContext context) async {
  try {
    final data = await ClientService.login(
        _emailController.text, _passwordController.text, context);
    Client client = data["client"];
    client.token = data["token"];
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => HomePage(
                client: client,
                currentItem: MenuItems.acceuil,
              )),
      (Route<dynamic> route) => false,
    );
    // Navigator.push(
    //   context,
    //   MaterialPageRoute(
    //       builder: (context) => HomePage(
    //             client: client,
    //             currentItem: MenuItems.acceuil,
    //           )),
    // );
    // Navigate to the next screen after successful login
  } catch (e) {
    print('Failed to log in: $e');

    // Show an error message to the user
  }
}

List<String>? ites = ['Villes'];
final VilleController villeController = Get.put(VilleController());
List<Step> getSteps() => [
      Step(
          isActive: currentStep >= 0,
          title: Text(""),
          content: Column(
            children: [
              DropdownButtonFormField<String>(
                decoration: InputDecoration(
                  labelText: "Civilité",
                  prefixIcon: Icon(Icons.person),
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
                value: selectedCivility,
                items: [
                  DropdownMenuItem<String>(
                    value: "Monsieur",
                    child: Text("Monsieur"),
                  ),
                  DropdownMenuItem<String>(
                    value: "Madame",
                    child: Text("Madame"),
                  ),
                  DropdownMenuItem<String>(
                    value: "Mademoiselle",
                    child: Text("Mademoiselle"),
                  ),
                ],
                onChanged: (value) {
                  selectedCivility = value!;
                },
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: name,
                decoration: InputDecoration(
                  labelText: "Nom",
                  prefixIcon: Icon(Icons.person),
                  // fillColor: Color.fromARGB(184, 228, 142, 21),
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: prenom,
                decoration: const InputDecoration(
                  labelText: "Prenom",
                  prefixIcon: Icon(Icons.person),
                  fillColor: Color.fromARGB(184, 228, 142, 21),
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: tel,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: InputDecoration(
                    fillColor: Color.fromARGB(184, 228, 142, 21),
                    labelStyle: TextStyle(fontSize: 22),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(15.0)),
                    ),
                    label: Text('Tel'),
                    prefixIcon: Icon(LineAwesomeIcons.phone)),
              ),
            ],
          )),
      Step(
          isActive: currentStep >= 1,
          title: Text(""),
          content: Column(
            children: [
              DropdownSearch<Ville>(
                showSearchBox: true,
                mode: Mode.DIALOG,

                selectedItem: selectedVille,
                // selectedItem: selectedVille,
                dropdownSearchDecoration: InputDecoration(
                  fillColor: Color.fromARGB(184, 228, 142, 21),
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                  labelText: 'Ville',
                  prefixIcon: Icon(LineAwesomeIcons.map_marked),
                ),
                items: villeController.villes,
                itemAsString: (Ville? ville) => ville!.nomVille,
                onChanged: (Ville? newValue) {
                  if (newValue != null) {
                    selectedVille = newValue;
                    int selectedIdVille = selectedVille!.idVille;
                    String selectedNomVille = selectedVille!.nomVille;
                    print(
                        'Selected ville: $selectedNomVille (ID: $selectedIdVille)');
                  }
                },
              ),
              // CustomDropdown.search(
              //   hintText: 'Select Ville',
              //   items: villeController.villes.isNotEmpty
              //       ? villeController.villes
              //           .map((Ville ville) => ville.nomVille)
              //           .toList()
              //       : ites,
              //   controller: villeControllered,
              // ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: email,
                keyboardType: TextInputType.emailAddress,
                decoration: InputDecoration(
                  labelText: "Email",
                  prefixIcon: Icon(Icons.email),
                  fillColor: Color.fromARGB(184, 228, 142, 21),
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: pass,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe",
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Color.fromARGB(184, 228, 142, 21),
                  labelStyle: TextStyle(
                    fontSize: 22,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
              SizedBox(
                height: 15,
              ),
              TextFormField(
                controller: pass2,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Mot de passe de confirmation",
                  prefixIcon: Icon(Icons.lock),
                  fillColor: Color.fromARGB(184, 228, 142, 21),
                  labelStyle: TextStyle(fontSize: 22),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(15.0)),
                  ),
                ),
              ),
            ],
          )),
      Step(
          isActive: currentStep >= 2,
          title: Text(""),
          content: Container(
              child:
                  Text('Si tu es sur de tes données click sur enregistrer'))),
    ];

///Sign Up formulaire
// class SignUpForm extends StatelessWidget {
//   SignUpForm({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     final VilleController villeController = Get.put(VilleController());
//     var confirmpass;
//     return
//         // resizeToAvoidBottomInset: true,
//         Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width * 0.13),
//       child: Form(
//         // key: _formKey2,
//         child: Theme(
//           data: ThemeData(
//             // canvasColor: Colors.orange[100],
//             colorScheme: Theme.of(context).colorScheme.copyWith(
//                   primary: Color.fromARGB(184, 228, 142, 21),
//                 ),
//           ),
//           // child: Padding(
//           //   padding: const EdgeInsets.only(top: 150.0),
//           // child: Stepper(
//           //   type: StepperType.horizontal,
//           //   steps: getSteps(),
//           //   currentStep: currentStep,
//           //   onStepContinue: () {
//           //     setState() => currentStep += 1;
//           //   },
//           //   onStepCancel: () {
//           //     setState() => currentStep -= 1;
//           //   },
//           // ),

//           child: Column(
//             children: [
//               Spacer(),

//               SizedBox(
//                 height: 80,
//               ),
//               DropdownButtonFormField<String>(
//                 decoration: InputDecoration(
//                   labelText: "Civilité",
//                   prefixIcon: Icon(Icons.person),
//                   labelStyle: TextStyle(fontSize: 22),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                   ),
//                 ),
//                 value: selectedCivility,
//                 items: [
//                   DropdownMenuItem<String>(
//                     value: "Monsieur",
//                     child: Text("Monsieur"),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: "Madame",
//                     child: Text("Madame"),
//                   ),
//                   DropdownMenuItem<String>(
//                     value: "Mademoiselle",
//                     child: Text("Mademoiselle"),
//                   ),
//                 ],
//                 onChanged: (value) {
//                   selectedCivility = value!;
//                 },
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextFormField(
//                 controller: name,
//                 decoration: InputDecoration(
//                   labelText: "Nom",
//                   prefixIcon: Icon(Icons.person),
//                   // fillColor: Color.fromARGB(184, 228, 142, 21),
//                   labelStyle: TextStyle(fontSize: 22),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextFormField(
//                 controller: prenom,
//                 decoration: const InputDecoration(
//                   labelText: "Prenom",
//                   prefixIcon: Icon(Icons.person),
//                   fillColor: Color.fromARGB(184, 228, 142, 21),
//                   labelStyle: TextStyle(fontSize: 22),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextFormField(
//                 controller: tel,
//                 keyboardType: TextInputType.number,
//                 maxLength: 10,
//                 decoration: InputDecoration(
//                     fillColor: Color.fromARGB(184, 228, 142, 21),
//                     labelStyle: TextStyle(fontSize: 22),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     label: Text('Tel'),
//                     prefixIcon: Icon(LineAwesomeIcons.phone)),
//               ),
//               // SizedBox(
//               //   height: 15,
//               // ),
//               DropdownButtonFormField<Ville>(
//                 value: selectedVille,
//                 isExpanded: true,
//                 decoration: InputDecoration(
//                     fillColor: Color.fromARGB(184, 228, 142, 21),
//                     labelStyle: TextStyle(fontSize: 22),
//                     border: OutlineInputBorder(
//                       borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                     ),
//                     label: Text('Ville'),
//                     prefixIcon: Icon(LineAwesomeIcons.location_arrow)),
//                 items: villeController.villes.map((Ville ville) {
//                   return DropdownMenuItem<Ville>(
//                     value: ville,
//                     child: Text(ville.nomVille),
//                   );
//                 }).toList(),
//                 onChanged: (Ville? newValue) {
//                   if (newValue != null) {
//                     selectedVille = newValue;
//                     int selectedIdVille = selectedVille!.idVille;
//                     String selectedNomVille = selectedVille!.nomVille;
//                     print(
//                         'Selected ville: $selectedNomVille (ID: $selectedIdVille)');
//                   }
//                 },
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextFormField(
//                 controller: email,
//                 keyboardType: TextInputType.emailAddress,
//                 decoration: InputDecoration(
//                   labelText: "Email",
//                   prefixIcon: Icon(Icons.email),
//                   fillColor: Color.fromARGB(184, 228, 142, 21),
//                   labelStyle: TextStyle(fontSize: 22),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextFormField(
//                 controller: pass,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: "Mot de passe",
//                   prefixIcon: Icon(Icons.lock),
//                   fillColor: Color.fromARGB(184, 228, 142, 21),
//                   labelStyle: TextStyle(
//                     fontSize: 22,
//                   ),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 15,
//               ),
//               TextFormField(
//                 controller: pass2,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                   labelText: "Password",
//                   prefixIcon: Icon(Icons.lock),
//                   fillColor: Color.fromARGB(184, 228, 142, 21),
//                   labelStyle: TextStyle(fontSize: 22),
//                   border: OutlineInputBorder(
//                     borderRadius: BorderRadius.all(Radius.circular(15.0)),
//                   ),
//                 ),
//               ),
//               Spacer(flex: 2)
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
class SignUpForm extends StatefulWidget {
  SignUpForm({Key? key}) : super(key: key);

  @override
  _SignUpFormState createState() => _SignUpFormState();
}

void showConfirmationDialog(BuildContext context) async {
  final confirmed = await showPlatformDialog<bool>(
    context: context,
    builder: (_) => BasicDialogAlert(
      title: Text("Confirmation"),
      content: Text("Are you sure you want to proceed?"),
      actions: <Widget>[
        BasicDialogAction(
          title: Text("Cancel"),
          onPressed: () {
            Navigator.of(context).pop(false);
          },
        ),
        BasicDialogAction(
          title: Text("Confirm"),
          onPressed: () {
            Navigator.of(context).pop(true);
            signup(context);
          },
        ),
      ],
    ),
  );

  if (confirmed == true) {
    // Proceed with action
  }
}

showAlertDialog(BuildContext context, String msg) {
  Widget cancelButton = TextButton(
    child: Text("OK"),
    onPressed: () {
      Navigator.pop(context);
    },
  );
  // set up the AlertDialog
  AlertDialog alert = AlertDialog(
    title: Text("Creation de compte"),
    content: Text(msg),
    actions: [
      cancelButton,
    ],
  );
  // show the dialog
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return alert;
    },
  );
}

void signup(BuildContext context) async {
  var client = <String, dynamic>{
    "nom_client": name.text,
    "prenom_client": prenom.text,
    //"adresse": address.text,
    "tel": tel.text,
    "mail": email.text,
    "civilite": selectedCivility,
    "ville": selectedVille?.idVille,
    // "civilite": _selectCivilite.getSelected()?.getValue(),
    "password": pass.text,
    "cin": 'public',
    "date_inscription": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    "date_naissance": DateFormat("yyyy-MM-dd").format(DateTime.now()),
    "newsletter": false
  };

  print(client);

  final response = await http.post(
    Uri.parse('${HOST}' + "/api/signup"),
    headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8',
    },
    body: jsonEncode(client),
  );
  print(response.body);
  if (response.statusCode == 200) {
    final body = json.decode(response.body);
    final status = body["status"];
    if (status == true) {
      Navigator.pop(context);
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => AuthScreen()));
    } else {
      showAlertDialog(context, body["msg"]);
    }
  } else {
    showAlertDialog(context, "Erreur ajout client");
    //throw Exception('Failed to load data');
  }
}

class _SignUpFormState extends State<SignUpForm> {
  // final VilleController villeController = Get.put(VilleController());
  var confirmpass;
  // String? selectedCivility;
  // TextEditingController name = TextEditingController();
  // TextEditingController prenom = TextEditingController();
  // TextEditingController tel = TextEditingController();
  // Ville? selectedVille;
  // TextEditingController email = TextEditingController();
  // TextEditingController pass = TextEditingController();
  // TextEditingController pass2 = TextEditingController();
  // void dispose() {
  //   // N'oubliez pas de libérer les ressources des contrôleurs de champ de texte
  //   name.dispose();
  //   prenom.dispose();
  //   tel.dispose();
  //   email.dispose();
  //   pass.dispose();
  //   pass2.dispose();
  //   super.dispose();
  // }
  bool isValidPhoneNumber(String phoneNumber) {
    // Expression régulière pour valider le format du numéro de téléphone
    final phoneRegex = RegExp(r'^0[0-9]{9}$');
    return phoneRegex.hasMatch(phoneNumber);
  }

  bool validateFields() {
    if (selectedCivility == null) {
      showAlertDialog(context, "Veuillez sélectionner une civilité.");
      return false;
    }

    if (name.text.isEmpty) {
      showAlertDialog(context, "Veuillez entrer votre nom.");
      return false;
    }

    if (prenom.text.isEmpty) {
      showAlertDialog(context, "Veuillez entrer votre prénom.");
      return false;
    }

    if (tel.text.isEmpty) {
      showAlertDialog(context, "Veuillez entrer votre numéro de téléphone.");
      return false;
    }
    if (!isValidPhoneNumber(tel.text)) {
      showAlertDialog(context,
          "Veuillez entrer un numéro de téléphone valide (10 chiffres).");
      return false;
    }
    // Ajoutez des validations supplémentaires pour d'autres champs si nécessaire

    return true;
  }

  bool isValidEmail(String email) {
    // Expression régulière pour valider le format de l'email
    final emailRegex = RegExp(
        r'^[\w-]+(\.[\w-]+)*@[a-zA-Z0-9-]+(\.[a-zA-Z0-9-]+)*(\.[a-zA-Z]{2,})$');
    return emailRegex.hasMatch(email);
  }

  bool validateFieldsStep2() {
    if (selectedVille == null) {
      showAlertDialog(context, "Veuillez sélectionner une ville.");
      return false;
    }

    if (email.text.isEmpty) {
      showAlertDialog(context, "Veuillez entrer votre email.");
      return false;
    }
    if (!isValidEmail(email.text)) {
      showAlertDialog(context, "Veuillez entrer un email valide.");
      return false;
    }
    if (pass.text.isEmpty) {
      showAlertDialog(context, "Veuillez entrer votre mot de passe.");
      return false;
    }

    if (pass2.text.isEmpty) {
      showAlertDialog(
          context, "Veuillez entrer votre mot de passe de confirmation.");
      return false;
    }
    if (pass.text != pass2.text) {
      showAlertDialog(context, "Les mots de passe ne sont pas identiques.");
      return false;
    }
    // Ajoutez des validations supplémentaires pour d'autres champs si nécessaire

    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width * 0.10),
        child: Form(
          child: Theme(
              data: ThemeData(
                colorScheme: Theme.of(context).colorScheme.copyWith(
                      primary: Color.fromARGB(184, 228, 142, 21),
                    ),
              ),
              child: Scaffold(
                body: Padding(
                  padding: const EdgeInsets.only(top: 0.0),
                  child: Stepper(
                    type: StepperType.horizontal,
                    steps: getSteps(),
                    currentStep: currentStep,
                    onStepContinue: () {
                      if (currentStep == 0) {
                        if (validateFields()) {
                          if (mounted) {
                            setState(() {
                              currentStep++;
                            });
                          }
                        }
                      } else if (currentStep == 1) {
                        if (validateFieldsStep2()) {
                          if (mounted) {
                            setState(() {
                              currentStep++;
                            });
                          }
                        }
                      }
                    },
                    onStepCancel: () {
                      if (currentStep > 0) {
                        if (mounted) {
                          setState(() {
                            currentStep--;
                          });
                        }
                      }
                    },
                    controlsBuilder:
                        (BuildContext context, ControlsDetails controls) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Row(
                          children: <Widget>[
                            currentStep != 2
                                ? ElevatedButton(
                                    onPressed: controls.onStepContinue,
                                    child: const Text('Continue'),
                                  )
                                : ElevatedButton(
                                    onPressed: () {
                                      // await ClientAPI.checkIfEmailExists(
                                      //     context, email.text, tel.text);
                                      if (currentStep != 2) {
                                        showAlertDialog(
                                            context, "finir les etapes");
                                      } else if (pass.text == pass2.text) {
                                        showConfirmationDialog(context);
                                      } else {
                                        showAlertDialog(context,
                                            "mot de pass de confrmation n'est pas correct");
                                      }
                                    },
                                    child: const Text('Confirmer'),
                                  ),
                            if (currentStep != 0)
                              TextButton(
                                onPressed: controls.onStepCancel,
                                child: const Text(
                                  'Retour',
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                          ],
                        ),
                      );
                    },
                  ),
                ),
              )),
        ));
  }
}

///Login page formulaire
// class LoginForm extends StatelessWidget {
//   LoginForm({
//     Key? key,
//   }) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Padding(
//       padding: EdgeInsets.symmetric(
//           horizontal: MediaQuery.of(context).size.width * 0.13),
//       child: Form(
//         // key: _formKey,

//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Spacer(),
//             TextFormField(
//               controller: _emailController,
//               decoration: InputDecoration(
//                   prefixIcon: Icon(Icons.email),
//                   labelText: "Email",
//                   labelStyle: TextStyle(fontSize: 22)),
//               validator: (value) {
//                 if (value!.isEmpty) {
//                   return 'Please enter your email';
//                 }
//                 if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
//                     .hasMatch(value)) {
//                   return 'Please enter a valid email';
//                 }
//                 return null;
//               },
//             ),
//             Padding(
//               padding: const EdgeInsets.symmetric(vertical: defpaultPadding),
//               child: TextFormField(
//                 controller: _passwordController,
//                 obscureText: true,
//                 decoration: InputDecoration(
//                     prefixIcon: Icon(Icons.lock),
//                     labelText: "Password",
//                     labelStyle: TextStyle(fontSize: 22)),
//                 validator: (value) {
//                   if (value!.isEmpty) {
//                     return "* Required";
//                   } else if (value.length < 6) {
//                     return "Password should be atleast 6 characters";
//                   } else if (value.length > 15) {
//                     return "Password should not be greater than 15 characters";
//                   } else
//                     return null;
//                 },
//               ),
//             ),
//             Padding(
//               padding: const EdgeInsets.only(top: 100.0),
//               child: TextButton(
//                 onPressed: () {},
//                 child: Text(
//                   "Mot de passe oublier",
//                   style: TextStyle(color: Colors.white, fontSize: 18),
//                 ),
//               ),
//             ),
//             // TextButton(
//             //   onPressed: () {
//             //     Navigator.push(
//             //       context,
//             //       MaterialPageRoute(builder: (context) => PublicPage()),
//             //     );
//             //   },
//             //   child: Text(
//             //     "Public",
//             //     style: TextStyle(color: Colors.white, fontSize: 18),
//             //   ),
//             // ),
//             Spacer(flex: 2),
//           ],
//         ),
//       ),
//     );
//   }
// }
class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  _LoginFormState createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  List<Map<String, dynamic>> myData = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    if (mounted) {
      setState(() {
        myData = data;
        _isLoading = false;
        print(myData);
      });
    }
  }

  Future<void> emmm() async {
    _emailController.text = await DatabaseHelper.getFirstTitle() ?? '';
    _refreshData();
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _refreshData();
    emmm();
  }

  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width * 0.13),
      child: Form(
        // key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Spacer(),
            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                  prefixIcon: Icon(Icons.email),
                  labelText: "Email",
                  labelStyle: TextStyle(fontSize: 22)),
              validator: (value) {
                if (value!.isEmpty) {
                  return 'Please enter your email';
                }
                if (!RegExp(r"^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$")
                    .hasMatch(value)) {
                  return 'Please enter a valid email';
                }
                return null;
              },
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: defpaultPadding),
              child: TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: InputDecoration(
                    prefixIcon: Icon(Icons.lock),
                    labelText: "Password",
                    labelStyle: TextStyle(fontSize: 22)),
                validator: (value) {
                  if (value!.isEmpty) {
                    return "* Required";
                  } else if (value.length < 6) {
                    return "Password should be at least 6 characters";
                  } else if (value.length > 15) {
                    return "Password should not be greater than 15 characters";
                  } else
                    return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 100.0),
              child: TextButton(
                onPressed: () {},
                child: Text(
                  "Mot de passe oublier",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ),
            ),
            Spacer(flex: 2),
          ],
        ),
      ),
    );
  }
}

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  List<Ville> villes = [];
  List<Client> data = [];
  bool _isSowSignUp = false;
  late AnimationController _animationController;
  late Animation<double> _animationTextRotate;
  void getVilles() async {
    final response = await http
        .get(Uri.parse('${HOST}' + '/api/villes/'));
    if (response.statusCode == 200) {
      final body = json.decode(response.body);
      final List result = body["data"];
      print("--result--");
      print(result.length);
      if (mounted) {
        setState(() {
          villes = result.map<Ville>((e) => Ville.fromJson(e)).toList();
        });
      }
      print("--data--");
      print(data.length);
      // initSelectVilles();
    } else {
      throw Exception('Failed to load villes');
    }
  }

  void setUpAnimation() {
    _animationController =
        AnimationController(vsync: this, duration: defaultDuration);
    _animationTextRotate =
        Tween<double>(begin: 0, end: 90).animate(_animationController);
  }

  void updateView() {
    if (mounted) {
      setState(() {
        _isSowSignUp = !_isSowSignUp;
      });
    }

    _isSowSignUp
        ? _animationController.forward()
        : _animationController.reverse();
  }

  double getUpdatedPlace() {
    final _size = MediaQuery.of(context).size;

    if (currentStep != 1) {
      return _size.height * 0.1 - 80;
    } else {
      return _size.height * 0.1 - 50;
    }
  }

  void updatePlace() {
    if (mounted) {
      setState(() {
        currentStep;
      });
    }
  }

  List<Map<String, dynamic>> myData = [];

  bool _isLoading = true;
  // This function is used to fetch all data from the database
  void _refreshData() async {
    final data = await DatabaseHelper.getItems();
    if (mounted) {
      setState(() {
        myData = data;
        _isLoading = false;
        print(myData);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    // _formKey = new GlobalKey<FormState>();
    // _formKey2 = new GlobalKey<FormState>();
    setUpAnimation();
    getVilles();
    // _emailController;
    // _passwordController;
    // _animationController;
    _refreshData();

    if (myData.isNotEmpty) {
      final TextEditingController _emailController =
          TextEditingController(text: myData[0]['title']);
    }
  }

  @override
  void dispose() {
    // _emailController.dispose();
    // _passwordController.dispose();
    _animationController.dispose();
    super.dispose();
  }

  Future<void> addItem(int id, String mail, String mdp, String token, String civilite) async {
    await DatabaseHelper.createItem(id, mail, mdp, token, civilite);
    _refreshData();
  }

  // Future<void> emmm() async {
  //   _emailController.text = await DatabaseHelper.getFirstTitle() ?? '';
  //   _refreshData();
  // }

  Future<void> deletit() async {
    await DatabaseHelper.deleteItems();
    _refreshData();
  }
  // Future<void> getclt() async {
  // await DatabaseHelper.getItems();
  // _refreshData();
  // }
  // void deleteItems() async {
  //   await DatabaseHelper.deleteItems();
  //   ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
  //       content: Text('Successfully deleted!'), backgroundColor: Colors.green));
  //   _refreshData();
  // }

  @override
  Widget build(BuildContext context) =>

      // Future<void> getclt(int id) async {
      //   await SQLHelper.getClient(id);
      //   _refreshJournals();
      //   print("Number of items ${_journals.length}");
      // }
      // if (myData.length != 0) {
      //   print(myData[0]['title']);
      //   final _emailController = TextEditingController(text: myData[0]['title']);
      // }

      OrientationBuilder(
        builder: (context, orientation) {
          SystemChrome.setPreferredOrientations([
            DeviceOrientation.portraitUp,
            DeviceOrientation.portraitDown,
          ]);
          if (myData.isNotEmpty) {
            final TextEditingController _emailController =
                TextEditingController(text: myData[0]['title']);
          }
          final _size = MediaQuery.of(context).size;
          final ClientAPI clientapi = Get.put(ClientAPI());
          final isPortrait = orientation == Orientation.portrait;
          return WillPopScope(
            onWillPop: () async {
              // Fermer l'application
              SystemNavigator.pop();
              return false;
            },
            child: Scaffold(
                resizeToAvoidBottomInset: false,
                body: AnimatedBuilder(
                    animation: _animationController,
                    builder: (context, _) {
                      return Stack(
                        children: [
                          //Login
                          AnimatedPositioned(
                            duration: defaultDuration,
                            width: isPortrait
                                ? _size.width * 0.88
                                : _size.width * 0.82,
                            height: _size.height,
                            left: _isSowSignUp ? -_size.width * 0.76 : 0,
                            child: Container(
                              color: Color.fromARGB(184, 228, 142, 21),
                              child: LoginForm(),
                            ),
                          ),
                          //Sign Up
                          AnimatedPositioned(
                              duration: defaultDuration,
                              height: _size.height * 0.97,
                              width: _size.width * 0.88,
                              left: _isSowSignUp
                                  ? _size.width * 0.12
                                  : _size.width * 0.88,
                              child: Padding(
                                padding: isPortrait
                                    ? const EdgeInsets.only(top: 180.0)
                                    : const EdgeInsets.only(top: 0.0),
                                child: Container(
                                  width: 20,
                                  color: Colors.white,
                                  child: SignUpForm(),
                                ),
                              )),
                          //Logo
                          isPortrait
                              ? AnimatedPositioned(
                                  duration: defaultDuration,
                                  top: _size.height * 0.1 - 40,
                                  left: 0,
                                  right: _isSowSignUp
                                      ? -_size.width * 0.06
                                      : _size.width * 0.06,
                                  child: CircleAvatar(
                                    radius: 25,
                                    backgroundColor: _isSowSignUp
                                        ? Color.fromARGB(184, 228, 142, 21)
                                        : Colors.white,
                                    child: AnimatedSwitcher(
                                      duration: defaultDuration,
                                      child: SvgPicture.asset(
                                        "assets/cover.svg",
                                        // color: login_bg,
                                      ),
                                    ),
                                  ),
                                )
                              : Container(
                                  width: 0,
                                  height: 0,
                                ),
                          isPortrait
                              ? AnimatedPositioned(
                                  duration: defaultDuration,
                                  width: _size.width,
                                  bottom: _size.height * 0.1,
                                  right: _isSowSignUp
                                      ? -_size.width * 5
                                      : _size.width * 0.06,
                                  child: SocalButtns(),
                                )
                              : Container(),
                          //Login Animation Text
                          Form(
                            child: AnimatedPositioned(
                                duration: defaultDuration,
                                bottom: _isSowSignUp
                                    ? _size.height / 2 - 80
                                    : isPortrait
                                        ? _size.height * 0.47
                                        : _size.height * 0.25,
                                left:
                                    _isSowSignUp ? 0 : _size.width * 0.44 - 80,
                                child: AnimatedDefaultTextStyle(
                                  duration: defaultDuration,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      fontSize: _isSowSignUp ? 22 : 23,
                                      fontWeight: FontWeight.bold,
                                      color: _isSowSignUp
                                          ? Colors.white
                                          : Colors.white70),
                                  child: Transform.rotate(
                                    angle:
                                        -_animationTextRotate.value * pi / 180,
                                    alignment: Alignment.topLeft,
                                    child: Column(
                                      children: [
                                        InkWell(
                                          onTap: _isSowSignUp
                                              ? updateView
                                              : () {
                                                  // if (_formKey.currentState!.validate()) {
                                                  void testCredentials(
                                                      BuildContext
                                                          context) async {
                                                    // Obtain the values of the username and password from your text fields

                                                    try {
                                                      // Call the login method from the ClientService class
                                                      final data =
                                                          await ClientService.login(
                                                              _emailController
                                                                  .text,
                                                              _passwordController
                                                                  .text,
                                                              context);

                                                      // If login is successful, iterate over the list of clients

                                                      // Check if the entered username and password match any client's credentials
                                                      deletit();
                                                      Client client = data["client"];
                                                      client.token = data["token"];
                                                      addItem(
                                                          client.idClient,
                                                          _emailController.text,
                                                          _passwordController.text,
                                                          data["token"],
                                                        client.civilite
                                                      );// Print the password
                                                    } catch (e) {
                                                      // Handle any exceptions or display error messages
                                                      print('Error: $e');
                                                    }
                                                  }

                                                  // for (Client client
                                                  //     in clientapi.clients) {
                                                  //   print(client.password);
                                                  //   if (_emailController.text ==
                                                  //           client.mail &&
                                                  //       sha1.convert(utf8.encode(
                                                  //               _passwordController
                                                  //                   .text)) ==
                                                  //           client.password) {
                                                  //
                                                  //   }
                                                  // }
                                                  testCredentials(context);

                                                  print(
                                                      myData[0]['description']);
                                                  _submit(context);
                                                  // }
                                                },
                                          child: Container(
                                            padding: const EdgeInsets.symmetric(
                                                vertical:
                                                    defpaultPadding * 0.75),
                                            width: 160,
                                            child: Text(
                                              "Connexion",
                                            ),
                                          ),
                                        ),
                                        !_isSowSignUp
                                            ? TextButton(
                                                onPressed: () async{
                                                  void testCredentials(
                                                      BuildContext
                                                      context) async {
                                                    // Obtain the values of the username and password from your text fields

                                                    try {
                                                      // Call the login method from the ClientService class
                                                      final data =
                                                      await ClientService.login(
                                                          "guest@fithouse.com",
                                                          "12345678",
                                                          context);

                                                      // If login is successful, iterate over the list of clients

                                                      // Check if the entered username and password match any client's credentials
                                                      deletit();
                                                      Client client = data["client"];
                                                      client.token = data["token"];
                                                      addItem(
                                                          client.idClient,
                                                          _emailController.text,
                                                          _passwordController.text,
                                                          data["token"],
                                                        client.civilite
                                                      );// Print the password
                                                    } catch (e) {
                                                      // Handle any exceptions or display error messages
                                                      print('Error: $e');
                                                    }
                                                  }
                                                  // for (Client client
                                                  //     in clientapi.clients) {
                                                  //   print(client.password);
                                                  //   if (_emailController.text ==
                                                  //           client.mail &&
                                                  //       sha1.convert(utf8.encode(
                                                  //               _passwordController
                                                  //                   .text)) ==
                                                  //           client.password) {
                                                  //
                                                  //   }
                                                  // }
                                                  testCredentials(context);

                                                  print(
                                                      myData[0]['description']);
                                                  try {
                                                    final data = await ClientService.login(
                                                        "guest@fithouse.com",
                                                        "12345678", context);
                                                    Client client = data["client"];
                                                    client.token = data["token"];
                                                    Navigator.pushAndRemoveUntil(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) => HomePage(
                                                            client: client,
                                                            currentItem: MenuItems.acceuil,
                                                          )),
                                                          (Route<dynamic> route) => false,
                                                    );

                                                    // Navigate to the next screen after successful login
                                                  } catch (e) {
                                                    print('Failed to log in: $e');

                                                    // Show an error message to the user
                                                  }
                                                },
                                                child: Text(
                                                  "Public",
                                                  style: TextStyle(
                                                      color: Colors.white70,
                                                      fontSize: 23,
                                                      fontWeight:
                                                          FontWeight.bold),
                                                ),
                                              )
                                            : SizedBox(),
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                          // top: !_isSowSignUp
                          //                           ? _size.height / 2 + 70
                          //                           : currentStep < 1
                          //                               ? _size.height / 2 + 150
                          //                               : _size.height / 2 + 400,
                          //Register Animation Text
                          AnimatedPositioned(
                              duration: defaultDuration,
                              bottom: !_isSowSignUp
                                  ? _size.height / 2 - 130
                                  : _size.height * 50,
                              right: _isSowSignUp ? _size.width * 0.35 - 80 : 0,
                              child: AnimatedDefaultTextStyle(
                                duration: defaultDuration,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontSize: !_isSowSignUp ? 22 : 23,
                                    fontWeight: FontWeight.bold,
                                    color: !_isSowSignUp
                                        ? Colors.white
                                        : Colors.white70),
                                child: Transform.rotate(
                                  angle: (90 - _animationTextRotate.value) *
                                      pi /
                                      180,
                                  alignment: Alignment.topRight,
                                  child: InkWell(
                                    onTap: _isSowSignUp
                                        ? () async {
                                            // if (await ClientAPI().checkIfEmailExists(
                                            //     context, email.text)) {
                                            //   // L'e-mail est déjà enregistré, afficher un message d'erreur
                                            //   showDialog(
                                            //     context: context,
                                            //     builder: (context) => AlertDialog(
                                            //       title: Text('Erreur'),
                                            //       content: Text(
                                            //           'Cet e-mail est déjà enregistré.'),
                                            //       actions: [
                                            //         TextButton(
                                            //           onPressed: () =>
                                            //               Navigator.pop(context),
                                            //           child: Text('OK'),
                                            //         ),
                                            //       ],
                                            //     ),
                                            //   );
                                            // } else {
                                            // L'e-mail n'est pas enregistré, continuer avec l'inscription
                                            // ...
                                          }
                                        // }
                                        : updateView,
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          vertical: defpaultPadding * 0.75),
                                      width: 220,
                                      child: Text(
                                        "S'enregistrer",
                                        style: TextStyle(color: Colors.black),
                                      ),
                                    ),
                                  ),
                                ),
                              )),
                        ],
                      );
                    })),
          );
        },
      );
}

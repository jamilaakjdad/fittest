import 'dart:convert';

import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:intl/intl.dart';
import 'package:get/get.dart';

import '../../utilities/constant.dart';
import '../../views/Datab.dart';

class ClientAPI extends GetxController {
  static const String apiUrl =
      '${HOST}/api/clients/';
  var isLoading = false.obs;
  var clients = <Client>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchClient();

  }

  Future<void> fetchClient() async {
    try {
      final data = await DatabaseHelper.getItems();
      isLoading.value = true;
      final response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${data[0]["token"]}",
        }
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final clientsList = <Client>[];
        for (var data in jsonData['data']) {
          clientsList.add(Client.fromJson(data));
        }
        clients.value = clientsList;
      } else {
        throw Exception('Failed to load client');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  static Future<void> updateClientPassword(
      String currentPassword, String newPassword) async {
    try {
      final data = await DatabaseHelper.getItems();
      // Effectuer une requête pour récupérer les détails du client actuel
      final response = await http.get(Uri.parse(apiUrl), headers: {
      "Content-Type": "application/json",
      "Authorization": "Bearer ${data[0]["token"]}",
      });
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final clientsList = <Client>[];
        for (var data in jsonData['data']) {
          clientsList.add(Client.fromJson(data));
        }

        // Vérifier si le mot de passe actuel correspond à celui du client
        Client client = clientsList.firstWhere(
          (client) => client.password == currentPassword,
        );

        if (client != null) {
          // Mettre à jour le mot de passe du client avec le nouveau mot de passe
          client.password = newPassword;
          await updateClient(client);
          // Afficher un message de succès ou effectuer d'autres actions nécessaires
          print('Mot de passe mis à jour avec succès');
        } else {
          // Afficher un message d'erreur indiquant que le mot de passe actuel est incorrect
          print('Mot de passe actuel incorrect');
        }
      } else {
        throw Exception('Failed to load clients');
      }
    } catch (e) {
      print(e.toString());
    }
  }

  static Future<Client> updateClient(Client client) async {
    final DateFormat formatter = DateFormat('yyyy-MM-dd');
    final String formattedDateNaissance =
        formatter.format(client.dateNaissance ?? DateTime.now());
    final String formattedDateop =
        formatter.format(client.dateInscription ?? DateTime.now());
    final data = await DatabaseHelper.getItems();
    final response = await http.put(
        Uri.parse('$apiUrl${client.idClient}'),
        headers: {'Content-Type': 'application/json', "Authorization": "Bearer ${data[0]["token"]}",},
        body: json.encode(client.toJson()
          ..['date_naissance'] = formattedDateNaissance
          ..['date_inscription'] = formattedDateop
          ..['password'] = client.password));
    print(response.body);
    if (response.statusCode == 200) {
      return Client.fromJson(json.decode(response.body));
    } else {
      throw Exception('Failed to update client data');
    }
  }

  static Future<void> checkIfEmailExists(
      BuildContext context, String email, String telph) async {
    final data = await DatabaseHelper.getItems();
    final response = await http.get(Uri.parse(apiUrl),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer ${data[0]["token"]}",
        });

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      final clientsList = <Client>[];
      for (var data in jsonData['data']) {
        clientsList.add(Client.fromJson(data));
      }
      // Vérifier si l'e-mail existe dans la liste des clients
      bool emailExists = clientsList.any((client) => client.mail == email);
      bool telExists = clientsList.any((client) => client.tel == telph);
      if (emailExists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('Email déjà enregistré'),
              content: Text('L\' email $email existe déjà.'),
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
        return;
      } else if (telExists) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              title: Text('numero déjà enregistré'),
              content: Text('numero $telph existe déjà.'),
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
        return;
      }
    } else {
      throw Exception('Failed to load clients');
    }
  }
}

Future<List<dynamic>> fetchClients() async {
  final data = await DatabaseHelper.getItems();
  final response = await http
      .get(Uri.parse('${HOST}/api/clients/'),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer ${data[0]["token"]}",
      });
  if (response.statusCode == 200) {
    final decodedJson = json.decode(response.body);
    return decodedJson['data'];
  } else {
    throw Exception('Failed to load clients');
  }
}

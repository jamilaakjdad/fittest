import 'dart:convert';
// import 'dart:js';
import 'package:fithouse_mobile/core/models/m_client.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';

import '../../utilities/constant.dart';

class ClientService {
  static const String _baseUrl = '${HOST}/api';

  static Future<Map<String, dynamic>> login(
      String email, String password, BuildContext context) async {
    final response = await http.post(
      Uri.parse('$_baseUrl/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: jsonEncode(<String, String>{
        'username': email,
        'password': password,
      }),
    );
    print(response.body);
    if (response.statusCode == 200) {
      final jsonResponse = jsonDecode(response.body);
      if (jsonResponse['success'] == false) {
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return CupertinoAlertDialog(
              // title: Text("Error"),
              content: jsonResponse['msg'] == "user not found"
                  ? Text(
                      'Utilisateur introuvable',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold),
                    )
                  : Text('Mot de passe incorrect',
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.bold)),
              actions: [
                CupertinoDialogAction(
                  child: Text("OK"),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                ),
              ],
            );
          },
        );
        throw Exception(jsonResponse['msg']);
      }
      return {"token": jsonResponse["token"],"client": Client.fromJson(jsonResponse['data'][0])};
    } else {
      throw Exception('Failed to log in.');
    }
  }
}

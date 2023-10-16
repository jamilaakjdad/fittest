import 'dart:convert';

import 'package:fithouse_mobile/core/models/m_reservation.dart';
import 'package:http/http.dart' as http;
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../utilities/env.dart';
import '../../views/Datab.dart';

class ReservationController extends GetxController {
  static const String apiUrl = API.RESERVATIONS_ENDPOINT;

  var isLoading = false.obs;
  var reservations = <Reservation>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchReservation();
  }

  Future<void> fetchReservation() async {
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
        final reservationsList = <Reservation>[];
        for (var data in jsonData['data']) {
          reservationsList.add(Reservation.fromJson(data));
        }
        reservations.value = reservationsList;
      } else {
        throw Exception('Failed to load reservation');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<Map> addReservation(Reservation reservation) async {
    try {
      isLoading.value = true;
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final DateFormat formatter2 = DateFormat('yyyy-MM-dd HH:mm:ss');
      final DateFormat formatter3 = DateFormat('HH:mm:ss');
      final String formattedDateNaissance =
          formatter.format(reservation.datePresence ?? DateTime.now());
      final String formattedDateop =
          formatter2.format(reservation.dateOperation ?? DateTime.now());
      final String formattedDatedb =
          formatter3.format(reservation.dateOperation ?? DateTime.now());
      final data = await DatabaseHelper.getItems();
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          "Authorization": "Bearer ${data[0]["token"]}",
        },
        body: jsonEncode(reservation.toJson()
          ..['date_presence'] = formattedDateNaissance
          ..['date_operation'] = formattedDateop
          ..['heur_debut'] = formattedDatedb
          ..['heure_fin'] = formattedDatedb),
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        print(jsonData);
        if (jsonData['status'] == false) {
          // Show the error message in an AlertDialog
          /*ScaffoldMessenger.of(Get.context!).showSnackBar(
            SnackBar(
              content: Text(jsonData['msg']),
            ),
          );*/
          print(jsonData['msg']);
          isLoading.value = false;
          return {
            "is_booking": false,
            "msg": jsonData['msg']
          };
        } else {
          reservations.add(Reservation.fromJson(jsonData['data']));
          isLoading.value = true;
          return {
            "is_booking": true,
            "msg": jsonData['msg']
          };
        }
      } else {
        //throw Exception('Failed to add reservation');
        return {
          "is_booking": false,
          "msg": 'Failed to add reservation'
        };
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
    return {
      "is_booking": false,
      "msg": 'Failed to add reservation 2'
    };
  }
}

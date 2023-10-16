import 'dart:convert';

// import 'package:fithouse_admin_app/utils/env.dart';
import 'package:fithouse_mobile/core/models/m_seance.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:intl/intl.dart';
import '../../utilities/env.dart';
import '../../views/Datab.dart';

class SeanceController extends GetxController {
  static const String apiUrl = API.SEANCES_ENDPOINT;

  var isLoading = false.obs;
  var seances = <Seance>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchSeances();
  }

  Future<void> fetchSeances() async {
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
        print(jsonData);
        final seancesList = <Seance>[];
        for (var data in jsonData['data']) {
          seancesList.add(Seance.fromJson(data));
        }
        print("NB SEANCES : ${seancesList.length}");
        seances.value = seancesList;
      } else {
        throw Exception('Failed to load seance');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

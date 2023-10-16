import 'dart:convert';

import 'package:fithouse_mobile/core/models/m_cours.dart';

// import 'package:fithouse_admin_app/utils/env.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:fithouse_mobile/utilities/env.dart';

import '../../views/Datab.dart';

class CourController extends GetxController {
  static const String apiUrl = API.COURS_ENDPOINT;

  var isLoading = false.obs;
  var cours = <Cour>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCours();
  }

  Future<void> fetchCours() async {
    try {
      isLoading.value = true;
      final data = await DatabaseHelper.getItems();
      final response = await http.get(Uri.parse(apiUrl),
          headers: {
            "Content-Type": "application/json",
            "Authorization": "Bearer ${data[0]["token"]}",
          }
      );
      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final coursList = <Cour>[];
        for (var data in jsonData['data']) {
          coursList.add(Cour.fromJson(data));
        }

        cours.value = coursList;
      } else {
        print('response.statusCode: ${response.statusCode}');
        print('response ${response}');
        throw Exception('Failed to load cours');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

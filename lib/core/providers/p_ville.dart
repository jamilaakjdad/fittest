import 'dart:convert';

import 'package:fithouse_mobile/core/models/m_ville.dart';

// import 'package:fithouse_admin_app/utils/env.dart';
import 'package:http/http.dart' as http;
import '../../utilities/env.dart';
import 'package:get/get.dart';

import '../../views/Datab.dart';

class VilleController extends GetxController {
  static const String apiUrl = API.VILLES_ENDPOINT;

  var isLoading = false.obs;
  var villes = <Ville>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchVilles();
  }

  Future<void> fetchVilles() async {
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
        final villesList = <Ville>[];
        for (var data in jsonData['data']) {
          villesList.add(Ville.fromJson(data));
        }

        villes.value = villesList;
      } else {
        print('response.statusCode: ${response.statusCode}');
        print('response ${response}');
        throw Exception('Failed to load villes');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

import 'dart:convert';
import '../../utilities/env.dart';
import 'package:fithouse_mobile/core/models/m_etablissement.dart';
// import 'package:fithouse_admin_app/utils/env.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';

import '../../views/Datab.dart';

class EtablissementController extends GetxController {
  static const String apiUrl = API.ETABLISSEMENTS_ENDPOINT;

  var isLoading = false.obs;
  var etablissements = <Etablissement>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchEtablissements();
  }

  Future<void> fetchEtablissements() async {
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
        final etablissementsList = <Etablissement>[];
        for (var data in jsonData['data']) {
          etablissementsList.add(Etablissement.fromJson(data));
        }
        etablissements.value = etablissementsList;
      } else {
        throw Exception('Failed to load etablissements');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

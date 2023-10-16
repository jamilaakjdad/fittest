import 'dart:convert';

import 'package:fithouse_mobile/core/models/m_coach.dart';

// import 'package:fithouse_admin_app/utils/env.dart';
import 'package:http/http.dart' as http;

import 'package:get/get.dart';
import 'package:fithouse_mobile/utilities/env.dart';

import '../../views/Datab.dart';

class CoachController extends GetxController {
  static const String apiUrl = API.COACH_ENDPOINT;

  var isLoading = false.obs;
  var coachs = <Coach>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchCoachs();
  }

  Future<void> fetchCoachs() async {
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
        final coachsList = <Coach>[];
        for (var data in jsonData['data']) {
          coachsList.add(Coach.fromJson(data));
        }

        coachs.value = coachsList;
      } else {
        print('response.statusCode: ${response.statusCode}');
        print('response ${response}');
        throw Exception('Failed to load coachs');
      }
    } catch (e) {
      print(e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}

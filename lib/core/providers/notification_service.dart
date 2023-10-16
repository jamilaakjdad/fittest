import 'package:http/http.dart' as http;
import 'package:fithouse_mobile/core/models/m_client.dart';
import '../../utilities/env.dart';
// json
import 'dart:convert';

import '../../views/Datab.dart';

class NotificationService {
  static Future<bool> hasUnreadNotifications(Client client) async {
    final data = await DatabaseHelper.getItems();
    final response =
        await http.get(Uri.parse(API.NOTIFICATIONS_VALID_ENDPOINT),
            headers: {
          'Content-Type':
          'application/json; charset=UTF-8', // Specify the content type and encoding
          "Authorization": "Bearer ${data[0]["token"]}"
        });
    if (response.statusCode == 200) {
      final body = response.body;
      final notifications = json.decode(body);
      final unreadNotifications = notifications.where((notif) =>
          notif['client_id'] == client.idClient && notif['is_read'] == false);
      return unreadNotifications.isNotEmpty;
    } else {
      throw Exception('Failed to load valid notifications');
    }
  }

  // has unpopped notifications
  static Future<bool> hasUnpoppedNotifications(Client client) async {
    final data = await DatabaseHelper.getItems();
    final response =
        await http.get(Uri.parse(API.NOTIFICATIONS_VALID_ENDPOINT),
            headers: {
              'Content-Type':
              'application/json; charset=UTF-8', // Specify the content type and encoding
              "Authorization": "Bearer ${data[0]["token"]}"
            });
    if (response.statusCode == 200) {
      final body = response.body;
      final notifications = json.decode(body);
      final unpoppedNotifications = notifications.where((notif) =>
          notif['client_id'] == client.idClient && notif['is_popped'] == false);
      return unpoppedNotifications.isNotEmpty;
    } else {
      throw Exception('Failed to load unpopped notifications');
    }
  }
}

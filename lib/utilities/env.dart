import 'constant.dart';


class API {
  static const String BASE_URL = '$HOST/api/';
  static const String CATEGORIES_ENDPOINT = BASE_URL + 'category/';
  static const String ETABLISSEMENTS_ENDPOINT = BASE_URL + 'etablissements/';
  static const String CLIENTS_ENDPOINT = BASE_URL + 'clients/';
  static const String COACH_ENDPOINT = BASE_URL + 'coach/';
  static const String SALLE_ENDPOINT = BASE_URL + 'salle/';
  static const String LOGIN_ENDPOINT = BASE_URL + 'login';
  static const String VILLES_ENDPOINT = BASE_URL + 'villes/';
  static const String COURS_ENDPOINT = BASE_URL + 'cours/';
  static const String RESERVATIONS_ENDPOINT = BASE_URL + 'reservation/';
  static const String SEANCES_ENDPOINT = BASE_URL + 'seance/';
  // notifications
  static const String NOTIFICATIONS_ENDPOINT = BASE_URL + 'notifications/';
  static const String NOTIFICATIONS_VALID_ENDPOINT =
      BASE_URL + 'validation/notification/';
  static const String NOTIFICATIONS_ENDPOINTlast_id =
      BASE_URL + 'notification/last/';
  static const String SEND_NOTIFICATION_ENDPOINT =
      BASE_URL + 'send/notification/';
  static const String VALID_NOTIFICATIONS_ENDPOINT =
      BASE_URL + 'valid-notifications/';
  static const String MARK_NOTIFICATION_ENDPOINT =
      BASE_URL + 'mark/notification/';
  static const String MARK_NOTIFICATION_POPPED_ENDPOINT =
      BASE_URL + 'mark/notification/popped/';
  // media
  static const String MEDIA_ENDPOINT = '$HOST/media/';
}

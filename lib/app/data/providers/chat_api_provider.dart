import '../../core/api/api_client.dart';
import '../../core/constants/api_constants.dart';

class ChatApiProvider {
  ChatApiProvider(this._apiClient);

  final ApiClient _apiClient;

  Future<dynamic> sendMessage({
    required String sessionId,
    required String message,
    required double userLatitude,
    required double userLongitude,
    int? kosId,
  }) {
    return _apiClient.post(
      ApiConstants.chat,
      data: buildChatPayload(
        sessionId: sessionId,
        message: message,
        userLatitude: userLatitude,
        userLongitude: userLongitude,
        kosId: kosId,
      ),
    );
  }

  static Map<String, dynamic> buildChatPayload({
    required String sessionId,
    required String message,
    required double userLatitude,
    required double userLongitude,
    int? kosId,
  }) {
    final payload = <String, dynamic>{
      'session_id': sessionId,
      'message': message.trim(),
      'user_lat': userLatitude,
      'user_lon': userLongitude,
    };

    if (kosId != null && kosId > 0) {
      payload['kos_id'] = kosId;
    }

    return payload;
  }
}

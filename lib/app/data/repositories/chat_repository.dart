import '../../core/api/api_client.dart';
import '../models/chat_response_model.dart';
import '../providers/chat_api_provider.dart';

class ChatRepository {
  ChatRepository(this._provider);

  final ChatApiProvider _provider;

  Future<ChatResponseModel> sendMessage({
    required String sessionId,
    required String message,
    required double userLatitude,
    required double userLongitude,
    int? kosId,
  }) async {
    final response = await _provider.sendMessage(
      sessionId: sessionId,
      message: message,
      userLatitude: userLatitude,
      userLongitude: userLongitude,
      kosId: kosId,
    );
    if (response is! Map) {
      throw const ApiException('Format respons chat tidak valid.');
    }
    return ChatResponseModel.fromJson(Map<String, dynamic>.from(response));
  }
}

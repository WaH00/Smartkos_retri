import 'package:flutter_test/flutter_test.dart';
import 'package:smartkos_mobile/app/data/providers/chat_api_provider.dart';

void main() {
  test('builds and trims the exact chat backend payload', () {
    final payload = ChatApiProvider.buildChatPayload(
      sessionId: 'detail-kos-1-test',
      message: '  Apakah ada WiFi?  ',
      userLatitude: -6.1862,
      userLongitude: 106.8348,
    );

    expect(payload, {
      'session_id': 'detail-kos-1-test',
      'message': 'Apakah ada WiFi?',
      'user_lat': -6.1862,
      'user_lon': 106.8348,
    });
  });
}

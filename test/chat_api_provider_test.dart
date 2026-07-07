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

  test('includes a positive kos ID with the exact backend key', () {
    final payload = ChatApiProvider.buildChatPayload(
      sessionId: 'detail-kos-123-test',
      message: '  Apakah kos ini memiliki WiFi?  ',
      userLatitude: -6.1862,
      userLongitude: 106.8348,
      kosId: 123,
    );

    expect(payload, {
      'session_id': 'detail-kos-123-test',
      'message': 'Apakah kos ini memiliki WiFi?',
      'user_lat': -6.1862,
      'user_lon': 106.8348,
      'kos_id': 123,
    });
  });

  test('omits kos_id when kos ID is not provided', () {
    final payload = ChatApiProvider.buildChatPayload(
      sessionId: 'general-test',
      message: 'Cari kos murah',
      userLatitude: -6.1862,
      userLongitude: 106.8348,
    );

    expect(payload.containsKey('kos_id'), isFalse);
  });

  test('omits kos_id when kos ID is zero', () {
    final payload = ChatApiProvider.buildChatPayload(
      sessionId: 'general-test',
      message: 'Cari kos murah',
      userLatitude: -6.1862,
      userLongitude: 106.8348,
      kosId: 0,
    );

    expect(payload.containsKey('kos_id'), isFalse);
  });

  test('omits kos_id when kos ID is negative', () {
    final payload = ChatApiProvider.buildChatPayload(
      sessionId: 'general-test',
      message: 'Cari kos murah',
      userLatitude: -6.1862,
      userLongitude: 106.8348,
      kosId: -1,
    );

    expect(payload.containsKey('kos_id'), isFalse);
  });
}

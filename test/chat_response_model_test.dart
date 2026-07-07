import 'package:flutter_test/flutter_test.dart';
import 'package:smartkos_mobile/app/data/models/chat_response_model.dart';

void main() {
  test('maps the chat response contract', () {
    final response = ChatResponseModel.fromJson({
      'reply': 'Ada WiFi.',
      'is_kos_related': true,
      'suggested_action': 'SHOW_SEARCH_RESULTS',
    });

    expect(response.reply, 'Ada WiFi.');
    expect(response.isKosRelated, isTrue);
    expect(response.suggestedAction, 'SHOW_SEARCH_RESULTS');
  });

  test('uses safe defaults for missing and unknown fields', () {
    final response = ChatResponseModel.fromJson({
      'reply': null,
      'suggested_action': 'UNKNOWN',
    });

    expect(response.reply, isNotEmpty);
    expect(response.isKosRelated, isTrue);
    expect(response.suggestedAction, 'NONE');
  });
}

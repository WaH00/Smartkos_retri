import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:smartkos_mobile/app/data/models/chat_message_model.dart';
import 'package:smartkos_mobile/app/modules/detail_kos/widgets/chat_message_bubble.dart';

void main() {
  Widget buildBubble(ChatMessageModel message) {
    return MaterialApp(
      home: Scaffold(
        body: ChatMessageBubble(
          message: message,
          onRetry: () {},
          onReturnToSearch: () {},
        ),
      ),
    );
  }

  testWidgets('renders AI Markdown with selectable MarkdownBody', (
    tester,
  ) async {
    await tester.pumpWidget(
      buildBubble(
        ChatMessageModel(
          text: '### Fasilitas\n\n* Memiliki **WiFi**',
          isUser: false,
          timestamp: DateTime(2026),
        ),
      ),
    );

    final markdown = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdown.selectable, isTrue);
    expect(tester.takeException(), isNull);
  });

  testWidgets('keeps user messages as plain Text', (tester) async {
    await tester.pumpWidget(
      buildBubble(
        ChatMessageModel(
          text: '# Bukan heading *biasa*',
          isUser: true,
          timestamp: DateTime(2026),
        ),
      ),
    );

    expect(find.byKey(const ValueKey('user-message-text')), findsOneWidget);
    expect(find.byType(MarkdownBody), findsNothing);
    expect(find.text('# Bukan heading *biasa*'), findsOneWidget);
  });

  testWidgets('renders plain and empty AI responses safely', (tester) async {
    await tester.pumpWidget(
      buildBubble(
        ChatMessageModel(
          text: 'Respons plain text.',
          isUser: false,
          timestamp: DateTime(2026),
        ),
      ),
    );
    expect(find.byType(MarkdownBody), findsOneWidget);
    expect(tester.takeException(), isNull);

    await tester.pumpWidget(
      buildBubble(
        ChatMessageModel(text: '   ', isUser: false, timestamp: DateTime(2026)),
      ),
    );
    final markdown = tester.widget<MarkdownBody>(find.byType(MarkdownBody));
    expect(markdown.data, 'Maaf, respons Makelar AI kosong.');
    expect(tester.takeException(), isNull);
  });
}

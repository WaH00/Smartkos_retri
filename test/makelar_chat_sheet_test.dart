import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:smartkos_mobile/app/core/api/api_client.dart';
import 'package:smartkos_mobile/app/data/providers/chat_api_provider.dart';
import 'package:smartkos_mobile/app/data/providers/search_api_provider.dart';
import 'package:smartkos_mobile/app/data/repositories/chat_repository.dart';
import 'package:smartkos_mobile/app/data/repositories/search_repository.dart';
import 'package:smartkos_mobile/app/modules/detail_kos/controllers/detail_kos_controller.dart';
import 'package:smartkos_mobile/app/modules/detail_kos/widgets/makelar_chat_sheet.dart';

void main() {
  setUp(() {
    Get.testMode = true;
    final apiClient = ApiClient();
    Get.put(
      DetailKosController(
        SearchRepository(SearchApiProvider(apiClient)),
        ChatRepository(ChatApiProvider(apiClient)),
      ),
    );
  });

  tearDown(Get.reset);

  testWidgets('keeps the chat input directly above the mobile keyboard', (
    tester,
  ) async {
    tester.view.devicePixelRatio = 1;
    tester.view.physicalSize = const Size(400, 800);
    tester.view.viewInsets = const FakeViewPadding(bottom: 300);
    addTearDown(tester.view.resetDevicePixelRatio);
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetViewInsets);

    await tester.pumpWidget(
      const GetMaterialApp(home: Scaffold(body: SizedBox.expand())),
    );
    Get.bottomSheet<void>(
      const MakelarChatSheet(),
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
    );
    await tester.pumpAndSettle();

    final surfaceBottom = tester
        .getBottomLeft(find.byKey(const ValueKey('chat-sheet-surface')))
        .dy;
    final inputBottom = tester
        .getBottomLeft(find.byKey(const ValueKey('chat-input-bar')))
        .dy;

    expect(surfaceBottom, 500);
    expect(inputBottom, surfaceBottom);
    expect(tester.takeException(), isNull);
  });
}

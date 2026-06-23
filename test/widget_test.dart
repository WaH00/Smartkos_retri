// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:smartkos_mobile/main.dart';

void main() {
  testWidgets('SmartKos opens location picker from home map', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const SmartKosApp());
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('KosFind'), findsOneWidget);
    expect(find.text('Explore'), findsOneWidget);

    await tester.tap(find.text('Perbesar Peta'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 350));

    expect(find.text('Pilih Lokasi Kos'), findsOneWidget);
  });

  testWidgets('SmartKos renders saved panel', (WidgetTester tester) async {
    await tester.pumpWidget(const SmartKosApp());
    await tester.pump(const Duration(milliseconds: 500));

    await tester.tap(find.text('Saved'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(find.text('Kos Tersimpan'), findsOneWidget);
    expect(find.text('Clear All'), findsOneWidget);
    expect(find.textContaining('properties saved'), findsOneWidget);
  });
}

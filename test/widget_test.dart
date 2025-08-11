import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:streethousemobile/main.dart';

void main() {
  testWidgets('App builds and shows LoginPage', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const StreetHouseApp());

    // Verify that the login screen appears (adjust the text according to your LoginPage).
    expect(find.byType(MaterialApp), findsOneWidget);
    expect(find.byType(StreetHouseApp), findsOneWidget);
    // Exemplo: Se seu LoginPage tem o texto "E-mail:", pode testar isso:
    expect(find.text('E-mail:'), findsOneWidget);
  });
}
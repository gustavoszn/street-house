import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:streethouse_flutter/main.dart'; // Corrija para o seu package name!

void main() {
  testWidgets('App builds and shows LoginPage', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());

    // Verifica se o MaterialApp está presente
    expect(find.byType(MaterialApp), findsOneWidget);

    // Verifica se os campos de login aparecem (ajuste o texto conforme seu login_page.dart!)
    expect(find.text('E-mail'), findsOneWidget);
    expect(find.text('Senha'), findsOneWidget);
  });
}
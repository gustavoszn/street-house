import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:street_house/main.dart';

void main() {
  testWidgets('shows discovery experience', (tester) async {
    await tester.pumpWidget(const StreetHouseApp());
    expect(find.text('DESCUBRA A CENA'), findsOneWidget);
    expect(find.text('Em destaque'), findsOneWidget);
    expect(find.text('Festival de Rua'), findsWidgets);
  });

  testWidgets('navigates to agenda on compact layout', (tester) async {
    tester.view.physicalSize = const Size(390, 844);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(const StreetHouseApp());
    await tester.tap(find.text('Agenda').last);
    await tester.pumpAndSettle();
    expect(find.text('Sua agenda'), findsOneWidget);
  });
}

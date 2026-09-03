import 'package:flutter_test/flutter_test.dart';
import 'package:street_house/main.dart';

void main() {
  testWidgets('shows branded splash and onboarding', (tester) async {
    await tester.pumpWidget(const StreetHouseApp());
    expect(find.text('STREET HOUSE'), findsOneWidget);
    await tester.pump(const Duration(milliseconds: 1500));
    expect(find.text('Descubra artistas'), findsOneWidget);
    expect(find.text('Pular'), findsOneWidget);
  });

  testWidgets('opens validated login after skipping onboarding', (tester) async {
    await tester.pumpWidget(const StreetHouseApp());
    await tester.pump(const Duration(milliseconds: 1500));
    await tester.tap(find.text('Pular'));
    await tester.pumpAndSettle();
    expect(find.text('Bem-vindo de volta'), findsOneWidget);
    expect(find.text('Entrar na demonstração'), findsOneWidget);
  });
}

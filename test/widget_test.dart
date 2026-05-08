import 'package:flutter_test/flutter_test.dart';

import 'package:trinity_gym/main.dart';

void main() {
  testWidgets('Trinity Gym renders catalog and plan tabs', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const TrinityGymApp());

    expect(find.text('Trinity Gym'), findsOneWidget);
    expect(find.text('Catálogo'), findsOneWidget);
    expect(find.textContaining('ejercicios disponibles'), findsOneWidget);

    await tester.tap(find.text('Plan'));
    await tester.pump();

    expect(find.textContaining('Plan 3 días'), findsOneWidget);
  });
}

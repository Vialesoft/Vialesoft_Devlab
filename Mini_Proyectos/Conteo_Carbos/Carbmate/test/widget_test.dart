import 'package:carbmate/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navega desde el inicio a crear alimento', (tester) async {
    await tester.pumpWidget(const CarbmateApp());

    expect(find.text('App Conteo Carbos'), findsOneWidget);
    await tester.tap(find.byTooltip('Crear alimento'));
    await tester.pumpAndSettle();

    expect(find.text('Crear alimento'), findsOneWidget);
  });
}

import 'package:carbmate/app/app.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('muestra el nombre de la aplicación', (tester) async {
    await tester.pumpWidget(const CarbmateApp());

    expect(find.text('App Conteo Carbos'), findsOneWidget);
  });
}

import 'package:carbmate/app/app.dart';
import 'package:carbmate/features/foods/create_food_screen.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('navega desde el inicio a crear alimento', (tester) async {
    final repository = _FakeFoodRepository();
    await tester.pumpWidget(CarbmateApp(repository: repository));
    await tester.pumpAndSettle();

    expect(find.text('Catálogo de alimentos'), findsOneWidget);
    await tester.tap(find.byTooltip('Crear alimento'));
    await tester.pumpAndSettle();

    expect(find.text('Crear alimento'), findsOneWidget);
  });

  testWidgets('valida y guarda CHO por 100 g y medidas adicionales', (
    tester,
  ) async {
    final repository = _FakeFoodRepository();
    await tester.pumpWidget(
      MaterialApp(home: CreateFoodScreen(repository: repository)),
    );
    await tester.pumpAndSettle();

    expect(
      find.text('No hay tags asociados. Podés continuar sin ellos.'),
      findsOneWidget,
    );
    expect(
      find.text('No hay medidas asociadas. Podés continuar sin ellas.'),
      findsOneWidget,
    );
    await tester.scrollUntilVisible(
      find.text('Guardar'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();
    await tester.drag(find.byType(ListView), const Offset(0, 600));
    await tester.pumpAndSettle();

    expect(find.text('El nombre es obligatorio.'), findsOneWidget);
    expect(repository.savedFood, isNull);

    await tester.enterText(find.byKey(const Key('food-name')), 'Pan casero');
    await tester.tap(find.byKey(const Key('food-tags-picker')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pan').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('carbohydrates-per-100g')),
      '45,5',
    );
    await tester.tap(find.text('Agregar otra medida'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('additional-measure-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Taza').last);
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const ValueKey('product-grams-0')),
      '120',
    );
    await tester.enterText(
      find.byKey(const ValueKey('additional-carbohydrates-0')),
      '54',
    );
    await tester.scrollUntilVisible(
      find.text('Guardar'),
      300,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(find.text('El nombre es obligatorio.'), findsNothing);
    expect(repository.savedFood?.name, 'Pan casero');
    expect(repository.savedFood?.tagIds, [1]);
    expect(
      repository.savedFood?.measures
          .map(
            (measure) =>
                '${measure.measureId}:${measure.productGrams}:${measure.carbohydrateGrams}',
          )
          .toList(),
      ['7:100.0:45.5', '5:120.0:54.0'],
    );
  });
}

class _FakeFoodRepository implements FoodRepository {
  NewFood? savedFood;

  @override
  Future<List<FoodListItem>> loadFoods() async => const [
    FoodListItem(id: 1, name: 'Pan lactal', brandName: 'Lays', tags: ['Pan']),
  ];

  @override
  Future<FoodFormOptions> loadFormOptions() async {
    return const FoodFormOptions(
      brands: [CatalogOption(id: 1, name: 'Lays')],
      tags: [CatalogOption(id: 1, name: 'Pan')],
      measures: [
        CatalogOption(id: 4, name: 'Unidad'),
        CatalogOption(id: 5, name: 'Taza'),
        CatalogOption(id: 7, name: '100 g'),
      ],
    );
  }

  @override
  Future<FoodDetails?> loadFood(int id) async => null;

  @override
  Future<void> createFood(NewFood food) async {
    savedFood = food;
  }

  @override
  Future<void> updateFood(int id, NewFood food) async {
    savedFood = food;
  }

  @override
  Future<void> deleteFood(int id) async {}
}

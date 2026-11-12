import 'package:carbmate/app/app.dart';
import 'package:carbmate/features/calculator/calculator_screen.dart';
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
    expect(find.text('Carbohidratos por 100 g'), findsOneWidget);
    expect(
      find.text('No hay medidas asociadas. Podés continuar sin ellas.'),
      findsNothing,
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
    await tester.scrollUntilVisible(
      find.text('Agregar otra medida'),
      300,
      scrollable: find.byType(Scrollable).first,
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

  testWidgets('recalcula CHO cada 100 g al guardar una preparación', (
    tester,
  ) async {
    final repository = _FakeFoodRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: CreateFoodScreen(
          repository: repository,
          initialFood: const NewFood(
            name: '',
            tagIds: [],
            isPreparation: true,
            isWeightEstimated: true,
            measures: [
              FoodMeasureDraft(
                measureId: 4,
                productGrams: 1000,
                carbohydrateGrams: 200,
              ),
              FoodMeasureDraft(
                measureId: 7,
                productGrams: 100,
                carbohydrateGrams: 20,
              ),
            ],
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('food-name')), 'Pan de banana');
    await tester.enterText(
      find.byKey(const Key('preparation-final-weight')),
      '2500',
    );
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.byKey(const Key('carbohydrates-per-100g')),
      250,
      scrollable: find.byType(Scrollable).first,
    );
    expect(
      tester
          .widget<TextFormField>(
            find.byKey(const Key('carbohydrates-per-100g')),
          )
          .controller
          ?.text,
      '8',
    );
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(repository.savedFood?.isPreparation, isTrue);
    expect(repository.savedFood?.isWeightEstimated, isFalse);
    expect(repository.savedFood?.name, startsWith('Pan de banana ('));
    final savedMeasures = repository.savedFood!.measures;
    final unit = savedMeasures.firstWhere((measure) => measure.measureId == 4);
    final hundredGrams = savedMeasures.firstWhere(
      (measure) => measure.measureId == 7,
    );
    expect(unit.productGrams, 2500);
    expect(unit.carbohydrateGrams, 200);
    expect(hundredGrams.carbohydrateGrams, 8);
  });

  testWidgets('guarda como preparación desde la calculadora', (tester) async {
    final repository = _FakeFoodRepository();
    await tester.pumpWidget(
      MaterialApp(
        home: CalculatorScreen(
          repository: repository,
          session: CalculatorSession(),
        ),
      ),
    );
    await tester.pumpAndSettle();
    await tester.enterText(
      find.byKey(const Key('calculator-food-search')),
      'Pan',
    );
    await tester.pumpAndSettle();
    await tester.tap(find.text('Pan lactal').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('OK'));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const Key('save-as-preparation')));
    await tester.pumpAndSettle();

    await tester.enterText(find.byKey(const Key('food-name')), 'Pan casero');
    await tester.tap(find.text('Guardar'));
    await tester.pumpAndSettle();

    expect(repository.savedFood?.name, startsWith('Pan casero ('));
    expect(repository.savedFood?.isPreparation, isTrue);
    expect(repository.savedFood?.measures, hasLength(2));
  });

  testWidgets('filtra la lista de alimentos por preparaciones', (tester) async {
    final repository = _FakeFoodRepository()
      ..foods = const [
        FoodListItem(id: 1, name: 'Leche', brandName: null, tags: []),
        FoodListItem(
          id: 2,
          name: 'Pan de banana (11/11/26)',
          brandName: null,
          tags: [],
          isPreparation: true,
        ),
      ];
    await tester.pumpWidget(CarbmateApp(repository: repository));
    await tester.pumpAndSettle();

    await tester.tap(find.byKey(const Key('food-list-filter')));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Preparaciones'));
    await tester.pumpAndSettle();

    expect(find.text('Leche'), findsNothing);
    expect(find.text('Pan de banana (11/11/26)'), findsOneWidget);
  });
}

class _FakeFoodRepository implements FoodRepository {
  NewFood? savedFood;
  List<FoodListItem> foods = const [
    FoodListItem(id: 1, name: 'Pan lactal', brandName: 'Lays', tags: ['Pan']),
  ];

  @override
  Future<List<MaintenanceCatalogEntry>> loadCatalogEntries(
    CatalogKind kind,
  ) async => const [];

  @override
  Future<void> saveCatalogEntry({
    required CatalogKind kind,
    int? id,
    required String name,
    String? note,
  }) async {}

  @override
  Future<void> deleteCatalogEntry(CatalogKind kind, int id) async {}

  @override
  Future<List<FoodListItem>> loadFoods() async => foods;

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
  Future<FoodDetails?> loadFood(int id) async => FoodDetails(
    id: id,
    food: NewFood(
      name: 'Pan lactal',
      tagIds: const [1],
      measures: const [
        FoodMeasureDraft(
          measureId: 7,
          productGrams: 100,
          carbohydrateGrams: 10,
        ),
      ],
    ),
  );

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

  @override
  Future<void> saveRecipe({
    required String name,
    required List<RecipeIngredientDraft> ingredients,
    String? instructions,
    String? note,
    double? cookedWeightGrams,
  }) async {}

  @override
  Future<List<RecipeListItem>> loadRecipes() async => const [];

  @override
  Future<RecipeDetails?> loadRecipe(int id) async => null;

  @override
  Future<void> updateRecipe({
    required int id,
    required String name,
    required List<RecipeIngredientDraft> ingredients,
    String? instructions,
    String? note,
    double? cookedWeightGrams,
  }) async {}

  @override
  Future<void> setRecipeFavorite(int id, bool isFavorite) async {}

  @override
  Future<List<InsulinPen>> loadInsulinPens() async => const [];

  @override
  Future<int> addInsulinPen(InsulinPenType type, DateTime openedOn) async => 1;

  @override
  Future<void> deleteInsulinPen(int id) async {}
}

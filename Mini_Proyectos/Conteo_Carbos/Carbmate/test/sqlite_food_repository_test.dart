import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sqlite_async/sqlite_async.dart';

import 'package:carbmate/features/foods/data/sqlite_food_repository.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  test(
    'carga catálogos y guarda un alimento con varias equivalencias',
    () async {
      final directory = await Directory.systemTemp.createTemp('carbmate-test-');
      final database = SqliteDatabase(
        path: '${directory.path}${Platform.pathSeparator}test.sqlite',
      );

      try {
        await database.initialize();
        await database.withAllConnections((writer, readers) async {
          await _enableForeignKeys(writer);
          for (final reader in readers) {
            await _enableForeignKeys(reader);
          }
        });

        final migrations = SqliteMigrations()
          ..add(
            SqliteMigration(1, (transaction) async {
              final schema = await rootBundle.loadString(
                'assets/database/migrations/initial_db.sql',
              );
              final initialData = await rootBundle.loadString(
                'assets/database/migrations/datos_iniciales.sql',
              );
              await transaction.executeMultiple(schema);
              await transaction.executeMultiple(initialData);
            }),
          )
          ..add(
            SqliteMigration(2, (transaction) async {
              final migration = await rootBundle.loadString(
                'assets/database/migrations/add_measure_eliminable.sql',
              );
              await transaction.executeMultiple(migration);
            }),
          )
          ..add(
            SqliteMigration(3, (transaction) async {
              final migration = await rootBundle.loadString(
                'assets/database/migrations/add_notes_to_brands_and_tags.sql',
              );
              await transaction.executeMultiple(migration);
            }),
          )
          ..add(
            SqliteMigration(4, (transaction) async {
              final migration = await rootBundle.loadString(
                'assets/database/migrations/add_food_favorites_and_notes.sql',
              );
              await transaction.executeMultiple(migration);
            }),
          )
          ..add(
            SqliteMigration(5, (transaction) async {
              final migration = await rootBundle.loadString(
                'assets/database/migrations/add_preparation_food_type.sql',
              );
              await transaction.executeMultiple(migration);
            }),
          )
          ..add(
            SqliteMigration(6, (transaction) async {
              final migration = await rootBundle.loadString(
                'assets/database/migrations/add_recipes.sql',
              );
              await transaction.executeMultiple(migration);
            }),
          )
          ..add(
            SqliteMigration(7, (transaction) async {
              final migration = await rootBundle.loadString(
                'assets/database/migrations/add_recipe_ingredient_notes.sql',
              );
              await transaction.executeMultiple(migration);
            }),
          )
          ..add(
            SqliteMigration(8, (transaction) async {
              final migration = await rootBundle.loadString(
                'assets/database/migrations/add_recipe_favorites_and_cooked_weight.sql',
              );
              await transaction.executeMultiple(migration);
            }),
          );
        await migrations.migrate(database);

        final repository = SqliteFoodRepository(database);
        final options = await repository.loadFormOptions();
        final hundredGrams = options.measures.firstWhere(
          (option) => option.name == '100 g',
        );
        final cup = options.measures.firstWhere(
          (option) => option.name == 'Taza',
        );
        final preparedTag = options.tags.firstWhere(
          (option) => option.name == 'Preparado',
        );
        var measureEntries = await repository.loadCatalogEntries(
          CatalogKind.measures,
        );
        expect(
          measureEntries
              .firstWhere((entry) => entry.id == hundredGrams.id)
              .deletable,
          isFalse,
        );
        expect(
          measureEntries.firstWhere((entry) => entry.id == cup.id).deletable,
          isTrue,
        );

        await repository.createFood(
          NewFood(
            name: 'Pan de prueba',
            brandId: null,
            tagIds: [preparedTag.id],
            measures: [
              FoodMeasureDraft(
                measureId: hundredGrams.id,
                productGrams: 100,
                carbohydrateGrams: 45.5,
              ),
              FoodMeasureDraft(
                measureId: cup.id,
                productGrams: 120,
                carbohydrateGrams: 54,
              ),
            ],
            isPreparation: true,
            isWeightEstimated: true,
          ),
        );

        final food = await database.get(
          'SELECT id FROM PRODUCTO WHERE nombre = ?',
          ['Pan de prueba'],
        );
        final foodId = food['id'] as int;
        final measures = await database.getAll(
          'SELECT id_med, grs_prod, grs_cho, confianza '
          'FROM PRODUCTO_MEDIDA WHERE id_prod = ? ORDER BY id_med',
          [foodId],
        );
        final tags = await database.getAll(
          'SELECT id_tag FROM PRODUCTO_TAG WHERE id_prod = ?',
          [foodId],
        );

        expect(measures, hasLength(2));
        expect(measures[0]['grs_cho'], 54.0);
        expect(measures[0]['confianza'], isNull);
        expect(measures[1]['grs_cho'], 45.5);
        expect(measures[1]['confianza'], isNull);
        final loadedFood = await repository.loadFood(foodId);
        expect(loadedFood?.food.isPreparation, isTrue);
        expect(loadedFood?.food.isWeightEstimated, isTrue);
        final listItem = (await repository.loadFoods()).singleWhere(
          (item) => item.id == foodId,
        );
        expect(listItem.isPreparation, isTrue);
        expect(listItem.isWeightEstimated, isTrue);
        expect(tags, hasLength(1));
        expect(await database.getAll('PRAGMA foreign_key_check'), isEmpty);

        await repository.deleteCatalogEntry(CatalogKind.measures, cup.id);
        measureEntries = await repository.loadCatalogEntries(
          CatalogKind.measures,
        );
        final cupEntry = measureEntries.firstWhere(
          (entry) => entry.id == cup.id,
        );
        expect(cupEntry.deletable, isFalse);
      } finally {
        await database.close();
        await directory.delete(recursive: true);
      }
    },
  );
}

Future<void> _enableForeignKeys(SqliteReadContext connection) async {
  await connection.computeWithDatabase((database) async {
    database.execute('PRAGMA foreign_keys = ON');
  });
}

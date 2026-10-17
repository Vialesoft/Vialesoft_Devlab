import 'package:sqlite_async/sqlite_async.dart';

import 'package:carbmate/features/foods/domain/food_repository.dart';

class SqliteFoodRepository implements FoodRepository {
  const SqliteFoodRepository(this._database);

  final SqliteDatabase _database;

  @override
  Future<List<FoodListItem>> loadFoods() async {
    final rows = await _database.getAll(
      'SELECT p.id, p.nombre, m.nombre AS marca, '
      "COALESCE((SELECT group_concat(t.nombre, '|') "
      'FROM PRODUCTO_TAG pt JOIN TAG t ON t.id = pt.id_tag '
      'WHERE pt.id_prod = p.id AND t.eliminado_en IS NULL), \'\') AS tags '
      'FROM PRODUCTO p LEFT JOIN MARCA m '
      'ON m.id = p.id_marca AND m.eliminado_en IS NULL '
      'WHERE p.eliminado_en IS NULL '
      'ORDER BY p.nombre COLLATE NOCASE',
    );

    return [
      for (final row in rows)
        FoodListItem(
          id: row['id'] as int,
          name: row['nombre'] as String,
          brandName: row['marca'] as String?,
          tags: (row['tags'] as String)
              .split('|')
              .where((tag) => tag.isNotEmpty)
              .toList(),
        ),
    ];
  }

  @override
  Future<FoodFormOptions> loadFormOptions() async {
    return FoodFormOptions(
      brands: await _loadOptions('MARCA'),
      tags: await _loadOptions('TAG'),
      measures: await _loadOptions('MEDIDA'),
    );
  }

  Future<List<CatalogOption>> _loadOptions(String tableName) async {
    final rows = await _database.getAll(
      'SELECT id, nombre FROM $tableName '
      'WHERE eliminado_en IS NULL ORDER BY nombre COLLATE NOCASE',
    );

    return [
      for (final row in rows)
        CatalogOption(id: row['id'] as int, name: row['nombre'] as String),
    ];
  }

  @override
  Future<void> createFood(NewFood food) {
    return _database.writeTransaction((transaction) async {
      await transaction.execute(
        'INSERT INTO PRODUCTO (nombre, id_marca, creado_en) VALUES (?, ?, ?)',
        [food.name.trim(), food.brandId, DateTime.now().toIso8601String()],
      );
      final row = await transaction.get('SELECT last_insert_rowid() AS id');
      final foodId = row['id'] as int;
      for (final tagId in food.tagIds) {
        await transaction.execute(
          'INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES (?, ?)',
          [foodId, tagId],
        );
      }

      for (final measure in food.measures) {
        await transaction.execute(
          'INSERT INTO PRODUCTO_MEDIDA '
          '(id_prod, id_med, grs_prod, grs_cho, confianza) '
          'VALUES (?, ?, ?, ?, ?)',
          [
            foodId,
            measure.measureId,
            measure.productGrams,
            measure.carbohydrateGrams,
            measure.confidence,
          ],
        );
      }
    });
  }
}

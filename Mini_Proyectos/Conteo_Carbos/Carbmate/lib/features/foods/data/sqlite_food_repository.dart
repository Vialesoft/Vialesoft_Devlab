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
    final measureRows = await _database.getAll(
      'SELECT pm.id_prod, pm.grs_cho, m.nombre AS medida '
      'FROM PRODUCTO_MEDIDA pm '
      'JOIN MEDIDA m ON m.id = pm.id_med '
      "WHERE pm.grs_cho IS NOT NULL AND m.eliminado_en IS NULL "
      "AND m.nombre IN ('Unidad', '100 g') "
      "ORDER BY pm.id_prod, CASE m.nombre WHEN 'Unidad' THEN 0 ELSE 1 END",
    );
    final summariesByFood = <int, List<FoodCarbohydrateSummary>>{};
    for (final measureRow in measureRows) {
      summariesByFood
          .putIfAbsent(measureRow['id_prod'] as int, () => [])
          .add(
            FoodCarbohydrateSummary(
              carbohydrateGrams: (measureRow['grs_cho'] as num).toDouble(),
              measureName: measureRow['medida'] as String,
            ),
          );
    }

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
          carbohydrateSummaries: summariesByFood[row['id'] as int] ?? const [],
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

  @override
  Future<FoodDetails?> loadFood(int id) async {
    final rows = await _database.getAll(
      'SELECT id, nombre, id_marca FROM PRODUCTO '
      'WHERE id = ? AND eliminado_en IS NULL',
      [id],
    );
    if (rows.isEmpty) return null;

    final tagRows = await _database.getAll(
      'SELECT id_tag FROM PRODUCTO_TAG WHERE id_prod = ?',
      [id],
    );
    final measureRows = await _database.getAll(
      'SELECT id_med, grs_prod, grs_cho, confianza '
      'FROM PRODUCTO_MEDIDA WHERE id_prod = ? ORDER BY id_med',
      [id],
    );
    final row = rows.single;

    return FoodDetails(
      id: id,
      food: NewFood(
        name: row['nombre'] as String,
        brandId: row['id_marca'] as int?,
        tagIds: [for (final tag in tagRows) tag['id_tag'] as int],
        measures: [
          for (final measure in measureRows)
            FoodMeasureDraft(
              measureId: measure['id_med'] as int,
              productGrams: (measure['grs_prod'] as num?)?.toDouble(),
              carbohydrateGrams: (measure['grs_cho'] as num?)?.toDouble(),
              confidence: measure['confianza'] as String?,
            ),
        ],
      ),
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

  @override
  Future<void> updateFood(int id, NewFood food) {
    return _database.writeTransaction((transaction) async {
      final existingFood = await transaction.getAll(
        'SELECT id FROM PRODUCTO WHERE id = ? AND eliminado_en IS NULL',
        [id],
      );
      if (existingFood.isEmpty) {
        throw StateError('No existe el alimento que se quiere editar.');
      }

      await transaction.execute(
        'UPDATE PRODUCTO SET nombre = ?, id_marca = ? WHERE id = ?',
        [food.name.trim(), food.brandId, id],
      );

      await transaction.execute('DELETE FROM PRODUCTO_TAG WHERE id_prod = ?', [
        id,
      ]);
      for (final tagId in food.tagIds) {
        await transaction.execute(
          'INSERT INTO PRODUCTO_TAG (id_prod, id_tag) VALUES (?, ?)',
          [id, tagId],
        );
      }

      final existingMeasures = await transaction.getAll(
        'SELECT id_med FROM PRODUCTO_MEDIDA WHERE id_prod = ?',
        [id],
      );
      final existingMeasureIds = {
        for (final row in existingMeasures) row['id_med'] as int,
      };
      final updatedMeasureIds = food.measures
          .map((measure) => measure.measureId)
          .toSet();

      for (final measureId in existingMeasureIds.difference(
        updatedMeasureIds,
      )) {
        await transaction.execute(
          'DELETE FROM PRODUCTO_MEDIDA WHERE id_prod = ? AND id_med = ?',
          [id, measureId],
        );
      }

      for (final measure in food.measures) {
        final values = [
          measure.productGrams,
          measure.carbohydrateGrams,
          measure.confidence,
        ];
        if (existingMeasureIds.contains(measure.measureId)) {
          await transaction.execute(
            'UPDATE PRODUCTO_MEDIDA '
            'SET grs_prod = ?, grs_cho = ?, confianza = ? '
            'WHERE id_prod = ? AND id_med = ?',
            [...values, id, measure.measureId],
          );
        } else {
          await transaction.execute(
            'INSERT INTO PRODUCTO_MEDIDA '
            '(id_prod, id_med, grs_prod, grs_cho, confianza) '
            'VALUES (?, ?, ?, ?, ?)',
            [id, measure.measureId, ...values],
          );
        }
      }
    });
  }

  @override
  Future<void> deleteFood(int id) {
    return _database.writeTransaction((transaction) async {
      await transaction.execute('DELETE FROM PRODUCTO_TAG WHERE id_prod = ?', [
        id,
      ]);
      await transaction.execute(
        'DELETE FROM PRODUCTO_MEDIDA WHERE id_prod = ?',
        [id],
      );
      await transaction.execute('DELETE FROM PRODUCTO WHERE id = ?', [id]);
    });
  }
}

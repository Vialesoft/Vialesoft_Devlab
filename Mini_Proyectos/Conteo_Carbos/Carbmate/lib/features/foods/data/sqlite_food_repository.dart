import 'package:sqlite_async/sqlite_async.dart';

import 'package:carbmate/features/foods/domain/food_repository.dart';

class SqliteFoodRepository implements FoodRepository {
  const SqliteFoodRepository(this._database);

  final SqliteDatabase _database;

  @override
  Future<List<MaintenanceCatalogEntry>> loadCatalogEntries(
    CatalogKind kind,
  ) async {
    final table = _catalogTable(kind);
    final select = switch (kind) {
      CatalogKind.tags =>
        'SELECT c.id, c.nombre, c.nota, '
            'CASE WHEN EXISTS (SELECT 1 FROM PRODUCTO_TAG x '
            'JOIN PRODUCTO p ON p.id = x.id_prod '
            'WHERE x.id_tag = c.id AND p.eliminado_en IS NULL) '
            'THEN 0 ELSE 1 END AS eliminable '
            'FROM $table c WHERE c.eliminado_en IS NULL '
            'ORDER BY c.nombre COLLATE NOCASE',
      CatalogKind.brands =>
        'SELECT c.id, c.nombre, c.nota, '
            'CASE WHEN EXISTS (SELECT 1 FROM PRODUCTO x '
            'WHERE x.id_marca = c.id AND x.eliminado_en IS NULL) '
            'THEN 0 ELSE 1 END AS eliminable FROM $table c '
            'WHERE c.eliminado_en IS NULL ORDER BY c.nombre COLLATE NOCASE',
      CatalogKind.measures =>
        'SELECT c.id, c.nombre, c.nota, '
            'CASE WHEN c.eliminable = 1 AND NOT EXISTS '
            '(SELECT 1 FROM PRODUCTO_MEDIDA x JOIN PRODUCTO p '
            'ON p.id = x.id_prod WHERE x.id_med = c.id '
            'AND p.eliminado_en IS NULL) '
            'THEN 1 ELSE 0 END AS eliminable FROM $table c '
            'WHERE c.eliminado_en IS NULL ORDER BY c.nombre COLLATE NOCASE',
    };
    final rows = await _database.getAll(select);
    return [
      for (final row in rows)
        MaintenanceCatalogEntry(
          id: row['id'] as int,
          name: row['nombre'] as String,
          note: row['nota'] as String?,
          deletable: row['eliminable'] == 1,
        ),
    ];
  }

  @override
  Future<void> saveCatalogEntry({
    required CatalogKind kind,
    int? id,
    required String name,
    String? note,
  }) {
    final table = _catalogTable(kind);
    final cleanName = name.trim();
    final cleanNote = note?.trim();
    return _database.writeTransaction((transaction) async {
      if (id == null) {
        await transaction.execute(
          'INSERT INTO $table (nombre, nota, creado_en) VALUES (?, ?, ?)',
          [
            cleanName,
            cleanNote == null || cleanNote.isEmpty ? null : cleanNote,
            DateTime.now().toIso8601String(),
          ],
        );
      } else {
        await transaction.execute(
          'UPDATE $table SET nombre = ?, nota = ? WHERE id = ? AND eliminado_en IS NULL',
          [
            cleanName,
            cleanNote == null || cleanNote.isEmpty ? null : cleanNote,
            id,
          ],
        );
      }
    });
  }

  @override
  Future<void> deleteCatalogEntry(CatalogKind kind, int id) {
    final table = _catalogTable(kind);
    final now = DateTime.now().toIso8601String();
    return _database.writeTransaction((transaction) async {
      final deletableCondition = kind == CatalogKind.measures
          ? 'AND eliminable = 1 AND NOT EXISTS '
                '(SELECT 1 FROM PRODUCTO_MEDIDA x JOIN PRODUCTO p '
                'ON p.id = x.id_prod WHERE x.id_med = $table.id '
                'AND p.eliminado_en IS NULL) '
          : kind == CatalogKind.tags
          ? 'AND NOT EXISTS '
                '(SELECT 1 FROM PRODUCTO_TAG x JOIN PRODUCTO p '
                'ON p.id = x.id_prod WHERE x.id_tag = $table.id '
                'AND p.eliminado_en IS NULL) '
          : 'AND NOT EXISTS '
                '(SELECT 1 FROM PRODUCTO x '
                'WHERE x.id_marca = $table.id AND x.eliminado_en IS NULL) ';
      await transaction.execute(
        'UPDATE $table SET eliminado_en = ? '
        'WHERE id = ? $deletableCondition AND eliminado_en IS NULL',
        [now, id],
      );
    });
  }

  String _catalogTable(CatalogKind kind) => switch (kind) {
    CatalogKind.tags => 'TAG',
    CatalogKind.brands => 'MARCA',
    CatalogKind.measures => 'MEDIDA',
  };

  @override
  Future<List<FoodListItem>> loadFoods() async {
    final rows = await _database.getAll(
      'SELECT p.id, p.nombre, p.es_favorito, p.es_preparacion, '
      'p.peso_estimado, m.nombre AS marca, '
      "COALESCE((SELECT group_concat(t.nombre, '|') "
      'FROM PRODUCTO_TAG pt JOIN TAG t ON t.id = pt.id_tag '
      'WHERE pt.id_prod = p.id AND t.eliminado_en IS NULL), \'\') AS tags '
      'FROM PRODUCTO p LEFT JOIN MARCA m '
      'ON m.id = p.id_marca AND m.eliminado_en IS NULL '
      'WHERE p.eliminado_en IS NULL '
      'ORDER BY p.es_favorito DESC, p.nombre COLLATE NOCASE',
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
          isFavorite: row['es_favorito'] == 1,
          isPreparation: row['es_preparacion'] == 1,
          isWeightEstimated: row['peso_estimado'] == 1,
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
      'SELECT id, nombre, id_marca, nota, es_favorito, es_preparacion, '
      'peso_estimado FROM PRODUCTO '
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
        note: row['nota'] as String?,
        isFavorite: row['es_favorito'] == 1,
        isPreparation: row['es_preparacion'] == 1,
        isWeightEstimated: row['peso_estimado'] == 1,
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
        'INSERT INTO PRODUCTO '
        '(nombre, id_marca, nota, es_favorito, es_preparacion, '
        'peso_estimado, creado_en) VALUES (?, ?, ?, ?, ?, ?, ?)',
        [
          food.name.trim(),
          food.brandId,
          _cleanNote(food.note),
          food.isFavorite ? 1 : 0,
          food.isPreparation ? 1 : 0,
          food.isWeightEstimated ? 1 : 0,
          DateTime.now().toIso8601String(),
        ],
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
        'UPDATE PRODUCTO SET nombre = ?, id_marca = ?, nota = ?, '
        'es_favorito = ?, es_preparacion = ?, peso_estimado = ? WHERE id = ?',
        [
          food.name.trim(),
          food.brandId,
          _cleanNote(food.note),
          food.isFavorite ? 1 : 0,
          food.isPreparation ? 1 : 0,
          food.isWeightEstimated ? 1 : 0,
          id,
        ],
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

  @override
  Future<void> saveRecipe({
    required String name,
    required List<RecipeIngredientDraft> ingredients,
    String? instructions,
    String? note,
    double? cookedWeightGrams,
  }) {
    if (ingredients.isEmpty) {
      throw ArgumentError('La receta debe tener al menos un ingrediente.');
    }
    return _database.writeTransaction((transaction) async {
      await transaction.execute(
        'INSERT INTO RECETA '
        '(nombre, instrucciones, nota, creado_en, peso_cocido) '
        'VALUES (?, ?, ?, ?, ?)',
        [
          name.trim(),
          _cleanNote(instructions),
          _cleanNote(note),
          DateTime.now().toIso8601String(),
          cookedWeightGrams,
        ],
      );
      final row = await transaction.get('SELECT last_insert_rowid() AS id');
      final recipeId = row['id'] as int;
      for (var index = 0; index < ingredients.length; index++) {
        final ingredient = ingredients[index];
        await transaction.execute(
          'INSERT INTO RECETA_INGREDIENTE '
          '(id_receta, id_prod, id_med, cantidad, es_gramos, orden, nota) '
          'VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            recipeId,
            ingredient.foodId,
            ingredient.measureId,
            ingredient.quantity,
            ingredient.isGrams ? 1 : 0,
            index,
            _cleanNote(ingredient.note),
          ],
        );
      }
    });
  }

  @override
  Future<List<RecipeListItem>> loadRecipes() async {
    final recipes = await _database.getAll(
      'SELECT id, nombre, creado_en, es_favorita, peso_cocido FROM RECETA '
      'ORDER BY es_favorita DESC, nombre COLLATE NOCASE',
    );
    final ingredients = await _database.getAll(
      'SELECT ri.id_receta, ri.cantidad, ri.es_gramos, '
      'pm.grs_prod AS medida_gramos, pm.grs_cho AS medida_cho, '
      '(SELECT ref.grs_prod FROM PRODUCTO_MEDIDA ref '
      'JOIN MEDIDA rm ON rm.id = ref.id_med '
      'WHERE ref.id_prod = ri.id_prod AND ref.grs_prod > 0 '
      'AND ref.grs_cho IS NOT NULL AND rm.eliminado_en IS NULL '
      "ORDER BY CASE WHEN rm.nombre = '100 g' THEN 0 ELSE 1 END, ref.id_med "
      'LIMIT 1) AS referencia_gramos, '
      '(SELECT ref.grs_cho FROM PRODUCTO_MEDIDA ref '
      'JOIN MEDIDA rm ON rm.id = ref.id_med '
      'WHERE ref.id_prod = ri.id_prod AND ref.grs_prod > 0 '
      'AND ref.grs_cho IS NOT NULL AND rm.eliminado_en IS NULL '
      "ORDER BY CASE WHEN rm.nombre = '100 g' THEN 0 ELSE 1 END, ref.id_med "
      'LIMIT 1) AS referencia_cho '
      'FROM RECETA_INGREDIENTE ri '
      'JOIN PRODUCTO_MEDIDA pm '
      'ON pm.id_prod = ri.id_prod AND pm.id_med = ri.id_med '
      'JOIN MEDIDA m ON m.id = ri.id_med AND m.eliminado_en IS NULL '
      'ORDER BY ri.id_receta, ri.orden',
    );

    final ingredientsByRecipe = <int, List<Map<String, Object?>>>{};
    for (final ingredient in ingredients) {
      ingredientsByRecipe
          .putIfAbsent(ingredient['id_receta'] as int, () => [])
          .add(ingredient);
    }

    return [
      for (final recipe in recipes)
        _buildRecipeListItem(
          recipe,
          ingredientsByRecipe[recipe['id'] as int] ?? const [],
        ),
    ];
  }

  @override
  Future<RecipeDetails?> loadRecipe(int id) async {
    final recipes = await _database.getAll(
      'SELECT id, nombre, instrucciones, nota, peso_cocido, es_favorita '
      'FROM RECETA WHERE id = ?',
      [id],
    );
    if (recipes.isEmpty) return null;
    final ingredients = await _database.getAll(
      'SELECT ri.id_prod, p.nombre AS alimento, ri.id_med, m.nombre AS medida, '
      'ri.cantidad, ri.es_gramos, ri.nota, '
      'pm.grs_prod AS medida_gramos, pm.grs_cho AS medida_cho, '
      '(SELECT ref.grs_prod FROM PRODUCTO_MEDIDA ref '
      'JOIN MEDIDA rm ON rm.id = ref.id_med '
      'WHERE ref.id_prod = ri.id_prod AND ref.grs_prod > 0 '
      'AND ref.grs_cho IS NOT NULL AND rm.eliminado_en IS NULL '
      "ORDER BY CASE WHEN rm.nombre = '100 g' THEN 0 ELSE 1 END, ref.id_med "
      'LIMIT 1) AS referencia_gramos, '
      '(SELECT ref.grs_cho FROM PRODUCTO_MEDIDA ref '
      'JOIN MEDIDA rm ON rm.id = ref.id_med '
      'WHERE ref.id_prod = ri.id_prod AND ref.grs_prod > 0 '
      'AND ref.grs_cho IS NOT NULL AND rm.eliminado_en IS NULL '
      "ORDER BY CASE WHEN rm.nombre = '100 g' THEN 0 ELSE 1 END, ref.id_med "
      'LIMIT 1) AS referencia_cho '
      'FROM RECETA_INGREDIENTE ri '
      'JOIN PRODUCTO p ON p.id = ri.id_prod '
      'JOIN MEDIDA m ON m.id = ri.id_med '
      'JOIN PRODUCTO_MEDIDA pm '
      'ON pm.id_prod = ri.id_prod AND pm.id_med = ri.id_med '
      'WHERE ri.id_receta = ? ORDER BY ri.orden',
      [id],
    );
    final recipe = recipes.single;
    return RecipeDetails(
      id: recipe['id'] as int,
      name: recipe['nombre'] as String,
      instructions: recipe['instrucciones'] as String?,
      note: recipe['nota'] as String?,
      cookedWeightGrams: (recipe['peso_cocido'] as num?)?.toDouble(),
      isFavorite: recipe['es_favorita'] == 1,
      ingredients: [
        for (final row in ingredients) _buildRecipeIngredientDetails(row),
      ],
    );
  }

  RecipeIngredientDetails _buildRecipeIngredientDetails(
    Map<String, Object?> row,
  ) {
    final isGrams = row['es_gramos'] == 1;
    final measureGrams = (row['medida_gramos'] as num?)?.toDouble();
    final measureCarbohydrates = (row['medida_cho'] as num?)?.toDouble();
    final referenceGrams = (row['referencia_gramos'] as num?)?.toDouble();
    final referenceCarbohydrates = (row['referencia_cho'] as num?)?.toDouble();

    double? carbohydratesPerUse;
    double? gramsPerUse;
    if (isGrams) {
      final hasMeasureRatio =
          measureGrams != null &&
          measureGrams > 0 &&
          measureCarbohydrates != null;
      final grams = hasMeasureRatio ? measureGrams : referenceGrams;
      final carbohydrates = hasMeasureRatio
          ? measureCarbohydrates
          : referenceCarbohydrates;
      if (grams != null && grams > 0 && carbohydrates != null) {
        carbohydratesPerUse = carbohydrates / grams;
      }
      gramsPerUse = 1;
    } else {
      carbohydratesPerUse = measureCarbohydrates;
      if (carbohydratesPerUse == null &&
          measureGrams != null &&
          measureGrams > 0 &&
          referenceGrams != null &&
          referenceGrams > 0 &&
          referenceCarbohydrates != null) {
        carbohydratesPerUse =
            measureGrams * referenceCarbohydrates / referenceGrams;
      }
      gramsPerUse = measureGrams;
    }

    return RecipeIngredientDetails(
      foodId: row['id_prod'] as int,
      foodName: row['alimento'] as String,
      measureId: row['id_med'] as int,
      measureName: isGrams ? 'Gramos' : row['medida'] as String,
      quantity: (row['cantidad'] as num).toDouble(),
      isGrams: isGrams,
      carbohydratesPerUse: carbohydratesPerUse,
      gramsPerUse: gramsPerUse,
      note: row['nota'] as String?,
    );
  }

  @override
  Future<void> updateRecipe({
    required int id,
    required String name,
    required List<RecipeIngredientDraft> ingredients,
    String? instructions,
    String? note,
    double? cookedWeightGrams,
  }) {
    if (ingredients.isEmpty) {
      throw ArgumentError('La receta debe tener al menos un ingrediente.');
    }
    return _database.writeTransaction((transaction) async {
      await transaction.execute(
        'UPDATE RECETA SET nombre = ?, instrucciones = ?, nota = ?, '
        'peso_cocido = ? WHERE id = ?',
        [
          name.trim(),
          _cleanNote(instructions),
          _cleanNote(note),
          cookedWeightGrams,
          id,
        ],
      );
      await transaction.execute(
        'DELETE FROM RECETA_INGREDIENTE WHERE id_receta = ?',
        [id],
      );
      for (var index = 0; index < ingredients.length; index++) {
        final ingredient = ingredients[index];
        await transaction.execute(
          'INSERT INTO RECETA_INGREDIENTE '
          '(id_receta, id_prod, id_med, cantidad, es_gramos, orden, nota) '
          'VALUES (?, ?, ?, ?, ?, ?, ?)',
          [
            id,
            ingredient.foodId,
            ingredient.measureId,
            ingredient.quantity,
            ingredient.isGrams ? 1 : 0,
            index,
            _cleanNote(ingredient.note),
          ],
        );
      }
    });
  }

  @override
  Future<void> setRecipeFavorite(int id, bool isFavorite) {
    return _database.writeTransaction((transaction) async {
      await transaction.execute(
        'UPDATE RECETA SET es_favorita = ? WHERE id = ?',
        [isFavorite ? 1 : 0, id],
      );
    });
  }

  @override
  Future<List<InsulinPen>> loadInsulinPens() async {
    final rows = await _database.getAll(
      'SELECT id, tipo, dias_vida_util, abierta_el '
      'FROM LAPICERA_INSULINA ORDER BY abierta_el, id',
    );
    return [
      for (final row in rows)
        InsulinPen(
          id: row['id'] as int,
          type: InsulinPenType.fromDatabaseValue(row['tipo'] as String),
          shelfLifeDays: row['dias_vida_util'] as int,
          openedOn: DateTime.parse(row['abierta_el'] as String),
        ),
    ];
  }

  @override
  Future<int> addInsulinPen(InsulinPenType type, DateTime openedOn) {
    return _database.writeTransaction((transaction) async {
      await transaction.execute(
        'INSERT INTO LAPICERA_INSULINA '
        '(tipo, dias_vida_util, abierta_el, creada_en) VALUES (?, ?, ?, ?)',
        [
          type.databaseValue,
          type.shelfLifeDays,
          _formatDateOnly(openedOn),
          DateTime.now().toIso8601String(),
        ],
      );
      final row = await transaction.get('SELECT last_insert_rowid() AS id');
      return row['id'] as int;
    });
  }

  @override
  Future<void> deleteInsulinPen(int id) {
    return _database.writeTransaction((transaction) async {
      await transaction.execute('DELETE FROM LAPICERA_INSULINA WHERE id = ?', [
        id,
      ]);
    });
  }

  RecipeListItem _buildRecipeListItem(
    Map<String, Object?> recipe,
    List<Map<String, Object?>> ingredients,
  ) {
    var totalCarbohydrates = 0.0;
    var totalWeight = 0.0;
    var hasUnknownCarbohydrates = false;
    var hasUnknownWeight = false;

    for (final ingredient in ingredients) {
      final quantity = (ingredient['cantidad'] as num).toDouble();
      final isGrams = ingredient['es_gramos'] == 1;
      final measureGrams = (ingredient['medida_gramos'] as num?)?.toDouble();
      final measureCarbohydrates = (ingredient['medida_cho'] as num?)
          ?.toDouble();
      final referenceGrams = (ingredient['referencia_gramos'] as num?)
          ?.toDouble();
      final referenceCarbohydrates = (ingredient['referencia_cho'] as num?)
          ?.toDouble();

      double? carbohydrates;
      if (isGrams) {
        final hasMeasureRatio =
            measureGrams != null &&
            measureGrams > 0 &&
            measureCarbohydrates != null;
        final grams = hasMeasureRatio ? measureGrams : referenceGrams;
        final cho = hasMeasureRatio
            ? measureCarbohydrates
            : referenceCarbohydrates;
        if (grams != null && grams > 0 && cho != null) {
          carbohydrates = quantity * cho / grams;
        }
        totalWeight += quantity;
      } else {
        if (measureCarbohydrates != null) {
          carbohydrates = quantity * measureCarbohydrates;
        } else if (measureGrams != null &&
            measureGrams > 0 &&
            referenceGrams != null &&
            referenceGrams > 0 &&
            referenceCarbohydrates != null) {
          carbohydrates =
              quantity * measureGrams * referenceCarbohydrates / referenceGrams;
        }
        if (measureGrams == null) {
          hasUnknownWeight = true;
        } else {
          totalWeight += quantity * measureGrams;
        }
      }

      if (carbohydrates == null) {
        hasUnknownCarbohydrates = true;
      } else {
        totalCarbohydrates += carbohydrates;
      }
    }

    return RecipeListItem(
      id: recipe['id'] as int,
      name: recipe['nombre'] as String,
      createdAt: DateTime.parse(recipe['creado_en'] as String),
      totalCarbohydrates: hasUnknownCarbohydrates ? null : totalCarbohydrates,
      estimatedWeightGrams: ingredients.isEmpty ? null : totalWeight,
      cookedWeightGrams: (recipe['peso_cocido'] as num?)?.toDouble(),
      hasUnknownWeight: hasUnknownWeight,
      hasUnknownCarbohydrates: hasUnknownCarbohydrates,
      isFavorite: recipe['es_favorita'] == 1,
    );
  }
}

String? _cleanNote(String? note) {
  final cleanNote = note?.trim();
  return cleanNote == null || cleanNote.isEmpty ? null : cleanNote;
}

String _formatDateOnly(DateTime date) {
  final day = date.day.toString().padLeft(2, '0');
  final month = date.month.toString().padLeft(2, '0');
  return '${date.year}-$month-$day';
}

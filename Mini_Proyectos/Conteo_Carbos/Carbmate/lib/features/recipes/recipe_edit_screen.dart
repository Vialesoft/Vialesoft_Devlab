import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:carbmate/core/text/search_text.dart';
import 'package:carbmate/features/foods/create_food_screen.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';

class RecipeEditScreen extends StatefulWidget {
  const RecipeEditScreen({super.key, required this.repository, this.recipeId});

  final FoodRepository repository;
  final int? recipeId;

  @override
  State<RecipeEditScreen> createState() => _RecipeEditScreenState();
}

class _RecipeEditScreenState extends State<RecipeEditScreen> {
  final _formKey = GlobalKey<FormState>();
  late final Future<_RecipeEditorData> _dataFuture = _loadData();
  late TextEditingController _nameController;
  late TextEditingController _instructionsController;
  late TextEditingController _noteController;
  late TextEditingController _cookedWeightController;
  List<RecipeIngredientDetails> _ingredients = [];
  bool _initialized = false;
  bool _isSaving = false;

  String get _screenTitle =>
      widget.recipeId == null ? 'Nueva receta' : 'Editar receta';

  Future<_RecipeEditorData> _loadData() async {
    final values = await Future.wait([
      if (widget.recipeId != null)
        widget.repository.loadRecipe(widget.recipeId!),
      widget.repository.loadFoods(),
      widget.repository.loadFormOptions(),
    ]);
    final hasExistingRecipe = widget.recipeId != null;
    final recipe = hasExistingRecipe
        ? values[0] as RecipeDetails?
        : const RecipeDetails(id: 0, name: '', ingredients: []);
    if (recipe == null) throw StateError('No se encontro la receta.');
    final offset = hasExistingRecipe ? 1 : 0;
    return _RecipeEditorData(
      recipe: recipe,
      foods: values[offset] as List<FoodListItem>,
      options: values[offset + 1] as FoodFormOptions,
    );
  }

  void _initialize(_RecipeEditorData data) {
    if (_initialized) return;
    _nameController = TextEditingController(text: data.recipe.name);
    _instructionsController = TextEditingController(
      text: data.recipe.instructions ?? '',
    );
    _noteController = TextEditingController(text: data.recipe.note ?? '');
    _cookedWeightController = TextEditingController(
      text: data.recipe.cookedWeightGrams == null
          ? ''
          : _formatNumber(data.recipe.cookedWeightGrams!),
    );
    _ingredients = List.of(data.recipe.ingredients);
    _initialized = true;
  }

  @override
  void dispose() {
    if (_initialized) {
      _nameController.dispose();
      _instructionsController.dispose();
      _noteController.dispose();
      _cookedWeightController.dispose();
    }
    super.dispose();
  }

  Future<void> _editIngredient(_RecipeEditorData data, {int? index}) async {
    final initial = index == null ? null : _ingredients[index];
    final result = await showDialog<_IngredientEditResult>(
      context: context,
      builder: (_) => _RecipeIngredientDialog(
        repository: widget.repository,
        foods: data.foods,
        options: data.options,
        initialIngredient: initial,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (result.deleted && index != null) {
        _ingredients.removeAt(index);
      } else if (result.ingredient != null) {
        if (index == null) {
          _ingredients.add(result.ingredient!);
        } else {
          _ingredients[index] = result.ingredient!;
        }
      }
    });
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ingrediente.')),
      );
      return;
    }

    setState(() => _isSaving = true);
    try {
      final ingredients = [
        for (final ingredient in _ingredients)
          RecipeIngredientDraft(
            foodId: ingredient.foodId,
            measureId: ingredient.measureId,
            quantity: ingredient.quantity,
            isGrams: ingredient.isGrams,
            note: ingredient.note,
          ),
      ];
      if (widget.recipeId == null) {
        await widget.repository.saveRecipe(
          name: _nameController.text.trim(),
          instructions: _instructionsController.text,
          note: _noteController.text,
          cookedWeightGrams: _parseOptionalWeight(_cookedWeightController.text),
          ingredients: ingredients,
        );
      } else {
        await widget.repository.updateRecipe(
          id: widget.recipeId!,
          name: _nameController.text.trim(),
          instructions: _instructionsController.text,
          note: _noteController.text,
          cookedWeightGrams: _parseOptionalWeight(_cookedWeightController.text),
          ingredients: ingredients,
        );
      }
      if (mounted) Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar la receta.')),
      );
    }
  }

  double? get _totalCarbohydrates {
    if (_ingredients.any(
      (ingredient) => ingredient.carbohydratesPerUse == null,
    )) {
      return null;
    }
    return _ingredients.fold<double>(
      0.0,
      (total, ingredient) =>
          total + ingredient.quantity * ingredient.carbohydratesPerUse!,
    );
  }

  double? get _estimatedWeight {
    if (_ingredients.any((ingredient) => ingredient.gramsPerUse == null)) {
      return null;
    }
    return _ingredients.fold<double>(
      0.0,
      (total, ingredient) =>
          total + ingredient.quantity * ingredient.gramsPerUse!,
    );
  }

  double? get _carbohydratesPer100g {
    final cookedWeight = _parseOptionalWeight(_cookedWeightController.text);
    final weight = cookedWeight ?? _estimatedWeight;
    final carbohydrates = _totalCarbohydrates;
    if (weight == null || weight <= 0 || carbohydrates == null) return null;
    return carbohydrates * 100 / weight;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_RecipeEditorData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: Text(_screenTitle)),
            body: const Center(child: Text('No se pudo cargar la receta.')),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return Scaffold(
            appBar: AppBar(title: Text(_screenTitle)),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        _initialize(data);
        return Scaffold(
          appBar: AppBar(title: Text(_screenTitle)),
          body: Form(
            key: _formKey,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
              children: [
                TextFormField(
                  key: const Key('recipe-edit-name'),
                  controller: _nameController,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Nombre *',
                    border: OutlineInputBorder(),
                  ),
                  validator: (value) => value == null || value.trim().isEmpty
                      ? 'El nombre es obligatorio.'
                      : null,
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Ingredientes',
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                    TextButton.icon(
                      key: const Key('add-recipe-ingredient'),
                      onPressed: _isSaving ? null : () => _editIngredient(data),
                      icon: const Icon(Icons.add),
                      label: const Text('Agregar'),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                if (_ingredients.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 12),
                    child: Text('Agrega los ingredientes de la receta.'),
                  ),
                for (var index = 0; index < _ingredients.length; index++)
                  _buildIngredientTile(data, index),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('recipe-instructions'),
                  controller: _instructionsController,
                  minLines: 3,
                  maxLines: 7,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Instrucciones',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                TextFormField(
                  key: const Key('recipe-note'),
                  controller: _noteController,
                  minLines: 2,
                  maxLines: 5,
                  textCapitalization: TextCapitalization.sentences,
                  decoration: const InputDecoration(
                    labelText: 'Notas',
                    alignLabelWithHint: true,
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 24),
                TextFormField(
                  key: const Key('recipe-cooked-weight'),
                  controller: _cookedWeightController,
                  decoration: const InputDecoration(
                    labelText: 'Peso cocido (opcional)',
                    helperText: 'Al completarlo, CHO/100 g usa este peso.',
                    suffixText: 'g',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  validator: (value) {
                    if (value == null || value.trim().isEmpty) return null;
                    final weight = _parseOptionalWeight(value);
                    if (weight == null || weight <= 0) {
                      return 'Ingresa un peso mayor que cero.';
                    }
                    return null;
                  },
                  onChanged: (_) => setState(() {}),
                ),
                const SizedBox(height: 16),
                _buildNutritionSummary(context),
              ],
            ),
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
              child: FilledButton.icon(
                key: const Key('save-recipe-edits'),
                onPressed: _isSaving ? null : _save,
                icon: const Icon(Icons.save_outlined),
                label: const Text('Guardar'),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildIngredientTile(_RecipeEditorData data, int index) {
    final ingredient = _ingredients[index];
    final quantityLabel = ingredient.isGrams
        ? '${_formatNumber(ingredient.quantity)} g'
        : '${_formatNumber(ingredient.quantity)} x ${ingredient.measureName}';
    final grams = ingredient.gramsPerUse == null
        ? null
        : ingredient.quantity * ingredient.gramsPerUse!;
    final carbohydrates = ingredient.carbohydratesPerUse == null
        ? null
        : ingredient.quantity * ingredient.carbohydratesPerUse!;
    final details = [
      if (grams != null && !ingredient.isGrams)
        '$quantityLabel - ${_formatNumber(grams)} g'
      else
        quantityLabel,
      if (carbohydrates != null) 'CHO: ${_formatNumber(carbohydrates)} g',
    ].join(' · ');
    final note = ingredient.note?.trim();

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        key: ValueKey('recipe-ingredient-$index'),
        title: Text(ingredient.foodName),
        subtitle: Text.rich(
          TextSpan(
            children: [
              TextSpan(text: details),
              if (note != null && note.isNotEmpty)
                TextSpan(
                  text: '\n$note',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
            ],
          ),
        ),
        trailing: const Icon(Icons.chevron_right),
        onTap: _isSaving ? null : () => _editIngredient(data, index: index),
      ),
    );
  }

  Widget _buildNutritionSummary(BuildContext context) {
    final carbohydrates = _totalCarbohydrates;
    final weight = _estimatedWeight;
    final per100g = _carbohydratesPer100g;
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _SummaryLine(
              label: 'Carbohidratos totales',
              value: carbohydrates == null
                  ? '—'
                  : '${_formatNumber(carbohydrates)} g',
              emphasized: true,
            ),
            const SizedBox(height: 8),
            _SummaryLine(
              label: 'Peso estimado (suma de ingredientes)',
              value: weight == null ? '—' : '${_formatNumber(weight)} g',
            ),
            const Divider(height: 20),
            _SummaryLine(
              label: _parseOptionalWeight(_cookedWeightController.text) == null
                  ? 'CHO/100 g estimado'
                  : 'CHO/100 g',
              value: per100g == null ? '—' : '${_formatNumber(per100g)} g',
              emphasized: true,
            ),
          ],
        ),
      ),
    );
  }
}

class RecipeCookScreen extends StatefulWidget {
  const RecipeCookScreen({
    super.key,
    required this.repository,
    required this.recipeId,
  });

  final FoodRepository repository;
  final int recipeId;

  @override
  State<RecipeCookScreen> createState() => _RecipeCookScreenState();
}

class _RecipeCookScreenState extends State<RecipeCookScreen> {
  late final Future<_RecipeEditorData> _dataFuture = _loadData();
  late List<RecipeIngredientDetails> _ingredients;
  late List<RecipeIngredientDetails> _originalIngredients;
  final Set<int> _checkedIndices = {};
  bool _initialized = false;
  bool _isSaving = false;

  Future<_RecipeEditorData> _loadData() async {
    final values = await Future.wait([
      widget.repository.loadRecipe(widget.recipeId),
      widget.repository.loadFoods(),
      widget.repository.loadFormOptions(),
    ]);
    final recipe = values[0] as RecipeDetails?;
    if (recipe == null) throw StateError('No se encontró la receta.');
    return _RecipeEditorData(
      recipe: recipe,
      foods: values[1] as List<FoodListItem>,
      options: values[2] as FoodFormOptions,
    );
  }

  void _initialize(_RecipeEditorData data) {
    if (_initialized) return;
    _ingredients = List.of(data.recipe.ingredients);
    _originalIngredients = List.of(data.recipe.ingredients);
    _initialized = true;
  }

  bool get _hasChanges {
    if (_ingredients.length != _originalIngredients.length) return true;
    for (var index = 0; index < _ingredients.length; index++) {
      final current = _ingredients[index];
      final original = _originalIngredients[index];
      if (current.foodId != original.foodId ||
          current.measureId != original.measureId ||
          current.quantity != original.quantity ||
          current.isGrams != original.isGrams ||
          current.note != original.note) {
        return true;
      }
    }
    return false;
  }

  double? get _totalCarbohydrates {
    var total = 0.0;
    for (final index in _checkedIndices) {
      final ingredient = _ingredients[index];
      final carbohydrates = ingredient.carbohydratesPerUse;
      if (carbohydrates == null) return null;
      total += ingredient.quantity * carbohydrates;
    }
    return total;
  }

  double get _totalWeight {
    var total = 0.0;
    for (final index in _checkedIndices) {
      final ingredient = _ingredients[index];
      final grams = ingredient.gramsPerUse;
      if (grams != null) total += ingredient.quantity * grams;
    }
    return total;
  }

  bool get _hasUnknownCheckedWeight =>
      _checkedIndices.any((index) => _ingredients[index].gramsPerUse == null);

  Future<void> _editIngredient(_RecipeEditorData data, {int? index}) async {
    final result = await showDialog<_IngredientEditResult>(
      context: context,
      builder: (_) => _RecipeIngredientDialog(
        repository: widget.repository,
        foods: data.foods,
        options: data.options,
        initialIngredient: index == null ? null : _ingredients[index],
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (index != null && result.deleted) {
        _ingredients.removeAt(index);
        _checkedIndices.remove(index);
        final shifted = _checkedIndices
            .where((checkedIndex) => checkedIndex > index)
            .toList();
        for (final checkedIndex in shifted) {
          _checkedIndices
            ..remove(checkedIndex)
            ..add(checkedIndex - 1);
        }
      } else if (result.ingredient != null) {
        if (index == null) {
          _ingredients.add(result.ingredient!);
        } else {
          _ingredients[index] = result.ingredient!;
        }
      }
    });
  }

  List<RecipeIngredientDraft> _ingredientDrafts() => [
    for (final ingredient in _ingredients)
      RecipeIngredientDraft(
        foodId: ingredient.foodId,
        measureId: ingredient.measureId,
        quantity: ingredient.quantity,
        isGrams: ingredient.isGrams,
        note: ingredient.note,
      ),
  ];

  Future<void> _updateRecipe(_RecipeEditorData data) async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ingrediente.')),
      );
      return;
    }
    setState(() => _isSaving = true);
    try {
      await widget.repository.updateRecipe(
        id: widget.recipeId,
        name: data.recipe.name,
        instructions: data.recipe.instructions,
        note: data.recipe.note,
        cookedWeightGrams: data.recipe.cookedWeightGrams,
        ingredients: _ingredientDrafts(),
      );
      if (!mounted) return;
      _originalIngredients = List.of(_ingredients);
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Receta actualizada.')));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar la receta.')),
      );
    }
  }

  Future<void> _saveAsNewRecipe(_RecipeEditorData data) async {
    if (_ingredients.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Agrega al menos un ingrediente.')),
      );
      return;
    }
    final name = await showDialog<String>(
      context: context,
      builder: (_) => _CopyRecipeNameDialog(initialName: data.recipe.name),
    );
    if (name == null || !mounted) return;
    setState(() => _isSaving = true);
    try {
      await widget.repository.saveRecipe(
        name: name,
        instructions: data.recipe.instructions,
        note: data.recipe.note,
        ingredients: _ingredientDrafts(),
      );
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Receta "$name" guardada.')));
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar la receta nueva.')),
      );
    }
  }

  Future<void> _savePreparation(_RecipeEditorData data) async {
    if (_checkedIndices.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Marca al menos un ingrediente usado.')),
      );
      return;
    }
    final carbohydrates = _totalCarbohydrates;
    if (carbohydrates == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Faltan datos de CHO en un ingrediente marcado.'),
        ),
      );
      return;
    }
    if (_checkedIndices.length < _ingredients.length) {
      final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Preparación incompleta'),
          content: const Text(
            'Hay ingredientes sin marcar. ¿Querés guardar la preparación incompleta?',
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false),
              child: const Text('Cancelar'),
            ),
            FilledButton(
              onPressed: () => Navigator.of(context).pop(true),
              child: const Text('Guardar'),
            ),
          ],
        ),
      );
      if (confirmed != true || !mounted) return;
    }

    final unitMeasureId = data.options.measures
        .where((measure) => measure.name == 'Unidad')
        .map((measure) => measure.id)
        .firstOrNull;
    final hundredGramMeasureId = data.options.measures
        .where((measure) => measure.name == '100 g')
        .map((measure) => measure.id)
        .firstOrNull;
    if (unitMeasureId == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No existe la medida Unidad.')),
      );
      return;
    }

    final weight = _totalWeight;
    final initialFood = NewFood(
      name: '',
      tagIds: const [],
      isPreparation: true,
      isWeightEstimated: _hasUnknownCheckedWeight,
      measures: [
        FoodMeasureDraft(
          measureId: unitMeasureId,
          productGrams: weight > 0 ? weight : null,
          carbohydrateGrams: carbohydrates,
        ),
        if (weight > 0 && hundredGramMeasureId != null)
          FoodMeasureDraft(
            measureId: hundredGramMeasureId,
            productGrams: 100,
            carbohydrateGrams: carbohydrates * 100 / weight,
          ),
      ],
    );
    final saved = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CreateFoodScreen(
          repository: widget.repository,
          initialFood: initialFood,
        ),
      ),
    );
    if (saved == true && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Preparación guardada como alimento.')),
      );
    }
  }

  String _quantityLabel(RecipeIngredientDetails ingredient) {
    if (ingredient.isGrams) return '${_formatNumber(ingredient.quantity)} g';
    final quantity =
        '${_formatNumber(ingredient.quantity)} x ${ingredient.measureName}';
    final grams = ingredient.gramsPerUse == null
        ? null
        : ingredient.quantity * ingredient.gramsPerUse!;
    return grams == null ? quantity : '$quantity - ${_formatNumber(grams)} g';
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<_RecipeEditorData>(
      future: _dataFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cocinar')),
            body: const Center(child: Text('No se pudo cargar la receta.')),
          );
        }
        final data = snapshot.data;
        if (data == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Cocinar')),
            body: const Center(child: CircularProgressIndicator()),
          );
        }
        _initialize(data);
        return Scaffold(
          appBar: AppBar(title: Text('Cocinar: ${data.recipe.name}')),
          body: ListView.separated(
            padding: const EdgeInsets.fromLTRB(12, 12, 12, 20),
            itemCount: _ingredients.isEmpty ? 2 : _ingredients.length + 1,
            separatorBuilder: (_, _) => const Divider(height: 1),
            itemBuilder: (context, index) {
              if (_ingredients.isEmpty && index == 0) {
                return const Padding(
                  padding: EdgeInsets.symmetric(vertical: 20),
                  child: Text('La receta no tiene ingredientes.'),
                );
              }
              if (index == _ingredients.length ||
                  (_ingredients.isEmpty && index == 1)) {
                return Padding(
                  padding: const EdgeInsets.only(top: 12),
                  child: OutlinedButton.icon(
                    key: const Key('cook-add-ingredient'),
                    onPressed: _isSaving ? null : () => _editIngredient(data),
                    icon: const Icon(Icons.add),
                    label: const Text('Agregar alimento'),
                  ),
                );
              }
              final ingredient = _ingredients[index];
              final carbohydrates = ingredient.carbohydratesPerUse == null
                  ? null
                  : ingredient.quantity * ingredient.carbohydratesPerUse!;
              final note = ingredient.note?.trim();
              return ListTile(
                key: ValueKey('cook-ingredient-$index'),
                leading: Checkbox(
                  value: _checkedIndices.contains(index),
                  onChanged: _isSaving
                      ? null
                      : (checked) => setState(() {
                          if (checked == true) {
                            _checkedIndices.add(index);
                          } else {
                            _checkedIndices.remove(index);
                          }
                        }),
                ),
                title: Text(ingredient.foodName),
                subtitle: Text(
                  '${_quantityLabel(ingredient)}${carbohydrates == null ? '' : ' · CHO: ${_formatNumber(carbohydrates)} g'}${note == null || note.isEmpty ? '' : '\n$note'}',
                  style: note == null || note.isEmpty
                      ? null
                      : const TextStyle(fontWeight: FontWeight.w600),
                ),
                trailing: IconButton(
                  tooltip: 'Editar ingrediente',
                  onPressed: _isSaving
                      ? null
                      : () => _editIngredient(data, index: index),
                  icon: const Icon(Icons.edit_outlined),
                ),
                onTap: _isSaving
                    ? null
                    : () => _editIngredient(data, index: index),
              );
            },
          ),
          bottomNavigationBar: SafeArea(
            top: false,
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 12),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surface,
                border: Border(
                  top: BorderSide(
                    color: Theme.of(context).colorScheme.primary
                        .withValues(alpha: 0.35),
                  ),
                ),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SummaryLine(
                    label: 'Peso marcado',
                    value: _hasUnknownCheckedWeight
                        ? '—'
                        : '${_formatNumber(_totalWeight)} g',
                  ),
                  const SizedBox(height: 6),
                  _SummaryLine(
                    label: 'CHO marcados',
                    value: _totalCarbohydrates == null
                        ? '—'
                        : '${_formatNumber(_totalCarbohydrates!)} g',
                    emphasized: true,
                  ),
                  if (_hasChanges) ...[
                    const SizedBox(height: 10),
                    OutlinedButton.icon(
                      key: const Key('cook-update-recipe'),
                      onPressed: _isSaving ? null : () => _updateRecipe(data),
                      icon: const Icon(Icons.save_outlined),
                      label: const Text('Actualizar receta'),
                    ),
                    OutlinedButton.icon(
                      key: const Key('cook-save-new-recipe'),
                      onPressed: _isSaving
                          ? null
                          : () => _saveAsNewRecipe(data),
                      icon: const Icon(Icons.copy_outlined),
                      label: const Text('Guardar como receta nueva'),
                    ),
                  ],
                  const SizedBox(height: 8),
                  FilledButton.icon(
                    key: const Key('cook-save-preparation'),
                    onPressed: _isSaving ? null : () => _savePreparation(data),
                    icon: const Icon(Icons.save_alt),
                    label: const Text('Guardar preparación'),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

class _CopyRecipeNameDialog extends StatefulWidget {
  const _CopyRecipeNameDialog({required this.initialName});

  final String initialName;

  @override
  State<_CopyRecipeNameDialog> createState() => _CopyRecipeNameDialogState();
}

class _CopyRecipeNameDialogState extends State<_CopyRecipeNameDialog> {
  late final _controller = TextEditingController(
    text: '${widget.initialName} (copia)',
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _submit() {
    final name = _controller.text.trim();
    if (name.isNotEmpty) Navigator.of(context).pop(name);
  }

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Guardar como receta nueva'),
    content: TextField(
      autofocus: true,
      controller: _controller,
      textCapitalization: TextCapitalization.sentences,
      decoration: const InputDecoration(
        labelText: 'Nombre',
        border: OutlineInputBorder(),
      ),
      onSubmitted: (_) => _submit(),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancelar'),
      ),
      FilledButton(onPressed: _submit, child: const Text('Guardar')),
    ],
  );
}

class _RecipeEditorData {
  const _RecipeEditorData({
    required this.recipe,
    required this.foods,
    required this.options,
  });

  final RecipeDetails recipe;
  final List<FoodListItem> foods;
  final FoodFormOptions options;
}

class _IngredientEditResult {
  const _IngredientEditResult(this.ingredient) : deleted = false;
  const _IngredientEditResult.deleted() : ingredient = null, deleted = true;

  final RecipeIngredientDetails? ingredient;
  final bool deleted;
}

class _RecipeIngredientDialog extends StatefulWidget {
  const _RecipeIngredientDialog({
    required this.repository,
    required this.foods,
    required this.options,
    this.initialIngredient,
  });

  final FoodRepository repository;
  final List<FoodListItem> foods;
  final FoodFormOptions options;
  final RecipeIngredientDetails? initialIngredient;

  @override
  State<_RecipeIngredientDialog> createState() =>
      _RecipeIngredientDialogState();
}

class _RecipeIngredientDialogState extends State<_RecipeIngredientDialog> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _noteController = TextEditingController();
  FoodListItem? _food;
  List<_MeasureChoice> _choices = const [];
  _MeasureChoice? _selectedChoice;
  bool _isLoadingFood = false;

  @override
  void initState() {
    super.initState();
    final initial = widget.initialIngredient;
    if (initial == null) {
      _quantityController.text = '1';
    } else {
      _food = widget.foods.firstWhere((food) => food.id == initial.foodId);
      _quantityController.text = _formatNumber(initial.quantity);
      _noteController.text = initial.note ?? '';
      _loadFood(_food!, initial: initial);
    }
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _noteController.dispose();
    super.dispose();
  }

  Future<void> _loadFood(
    FoodListItem food, {
    RecipeIngredientDetails? initial,
  }) async {
    setState(() {
      _food = food;
      _isLoadingFood = true;
      _choices = const [];
      _selectedChoice = null;
    });
    try {
      final details = await widget.repository.loadFood(food.id);
      if (!mounted || details == null) return;
      final measureNames = {
        for (final measure in widget.options.measures) measure.id: measure.name,
      };
      final referenceMeasures = details.food.measures.where(
        (measure) =>
            measure.productGrams != null &&
            measure.productGrams! > 0 &&
            measure.carbohydrateGrams != null,
      );
      FoodMeasureDraft? reference;
      for (final measure in referenceMeasures) {
        if (measureNames[measure.measureId] == '100 g') {
          reference = measure;
          break;
        }
      }
      reference ??= referenceMeasures.firstOrNull;

      final choices = <_MeasureChoice>[];
      if (reference != null) {
        choices.add(
          _MeasureChoice(
            measureId: reference.measureId,
            name: 'Gramos',
            carbohydratesPerUse:
                reference.carbohydrateGrams! / reference.productGrams!,
            gramsPerUse: 1,
            isGrams: true,
          ),
        );
      }
      for (final measure in details.food.measures) {
        final name = measureNames[measure.measureId] ?? 'Medida';
        if (_isWeightMeasure(name)) continue;
        var carbohydratesPerUse = measure.carbohydrateGrams;
        if (carbohydratesPerUse == null &&
            measure.productGrams != null &&
            reference != null) {
          carbohydratesPerUse =
              measure.productGrams! *
              reference.carbohydrateGrams! /
              reference.productGrams!;
        }
        if (carbohydratesPerUse == null) continue;
        choices.add(
          _MeasureChoice(
            measureId: measure.measureId,
            name: name,
            carbohydratesPerUse: carbohydratesPerUse,
            gramsPerUse: measure.productGrams,
          ),
        );
      }
      final initialGramMeasure = initial?.isGrams == true ? initial : null;
      if (initialGramMeasure != null &&
          !choices.any(
            (choice) =>
                choice.isGrams &&
                choice.measureId == initialGramMeasure.measureId,
          )) {
        final carbohydratesPerGram =
            initialGramMeasure.carbohydratesPerUse ??
            (reference == null
                ? null
                : reference.carbohydrateGrams! / reference.productGrams!);
        if (carbohydratesPerGram != null) {
          choices.add(
            _MeasureChoice(
              measureId: initialGramMeasure.measureId,
              name: 'Gramos',
              carbohydratesPerUse: carbohydratesPerGram,
              gramsPerUse: 1,
              isGrams: true,
            ),
          );
        }
      }
      if (!mounted) return;
      setState(() {
        _choices = choices;
        _isLoadingFood = false;
        if (initial != null) {
          _selectedChoice = choices.firstWhere(
            (choice) =>
                choice.measureId == initial.measureId &&
                choice.isGrams == initial.isGrams,
            orElse: () => _defaultChoice(choices),
          );
        } else if (choices.isNotEmpty) {
          _selectedChoice = _defaultChoice(choices);
        }
      });
    } catch (_) {
      if (!mounted) return;
      setState(() => _isLoadingFood = false);
    }
  }

  _MeasureChoice _defaultChoice(List<_MeasureChoice> choices) =>
      choices.firstWhere(
        (choice) => choice.name == 'Unidad',
        orElse: () => choices.first,
      );

  bool _isWeightMeasure(String name) => RegExp(
    r'^\s*\d+(?:[,.]\d+)?\s*g\s*$',
    caseSensitive: false,
  ).hasMatch(name);

  double? _parseQuantity(String text) =>
      double.tryParse(text.trim().replaceAll(',', '.'));

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    final food = _food;
    final choice = _selectedChoice;
    if (food == null || choice == null) return;
    Navigator.of(context).pop(
      _IngredientEditResult(
        RecipeIngredientDetails(
          foodId: food.id,
          foodName: food.name,
          measureId: choice.measureId,
          measureName: choice.name,
          quantity: _parseQuantity(_quantityController.text)!,
          isGrams: choice.isGrams,
          carbohydratesPerUse: choice.carbohydratesPerUse,
          gramsPerUse: choice.gramsPerUse,
          note: _noteController.text.trim().isEmpty
              ? null
              : _noteController.text.trim(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final editing = widget.initialIngredient != null;
    return AlertDialog(
      title: Text(editing ? 'Editar ingrediente' : 'Agregar ingrediente'),
      content: SizedBox(
        width: 420,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                if (editing)
                  InputDecorator(
                    decoration: const InputDecoration(
                      labelText: 'Alimento',
                      border: OutlineInputBorder(),
                    ),
                    child: Text(_food?.name ?? ''),
                  )
                else
                  Autocomplete<FoodListItem>(
                    displayStringForOption: (food) => food.name,
                    optionsBuilder: (value) {
                      final query = normalizeSearchText(value.text.trim());
                      if (query.length < 2) return const [];
                      return widget.foods.where((food) {
                        final searchable = [
                          food.name,
                          food.brandName ?? '',
                          ...food.tags,
                        ].map(normalizeSearchText).join(' ');
                        return searchable.contains(query);
                      });
                    },
                    onSelected: (food) => _loadFood(food),
                    fieldViewBuilder:
                        (context, controller, focusNode, onSubmitted) =>
                            TextField(
                              key: const Key('recipe-ingredient-search'),
                              controller: controller,
                              focusNode: focusNode,
                              decoration: const InputDecoration(
                                labelText: 'Buscar alimento',
                                border: OutlineInputBorder(),
                                prefixIcon: Icon(Icons.search),
                              ),
                            ),
                  ),
                if (_food != null) ...[
                  const SizedBox(height: 12),
                  if (_isLoadingFood)
                    const LinearProgressIndicator()
                  else if (_choices.isEmpty)
                    const Text('Este alimento no tiene medidas calculables.')
                  else ...[
                    DropdownButtonFormField<_MeasureChoice>(
                      key: const Key('recipe-ingredient-measure'),
                      initialValue: _selectedChoice,
                      decoration: const InputDecoration(
                        labelText: 'Medida',
                        border: OutlineInputBorder(),
                      ),
                      items: [
                        for (final choice in _choices)
                          DropdownMenuItem(
                            value: choice,
                            child: Text(choice.name),
                          ),
                      ],
                      onChanged: (value) =>
                          setState(() => _selectedChoice = value),
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('recipe-ingredient-quantity'),
                      controller: _quantityController,
                      autofocus: editing,
                      decoration: InputDecoration(
                        labelText: _selectedChoice?.isGrams == true
                            ? 'Cantidad en gramos'
                            : 'Cantidad',
                        suffixText: _selectedChoice?.isGrams == true
                            ? 'g'
                            : null,
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                      ],
                      validator: (value) {
                        final quantity = _parseQuantity(value ?? '');
                        if (quantity == null || quantity <= 0) {
                          return 'Ingresa una cantidad mayor que cero.';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 12),
                    TextFormField(
                      key: const Key('recipe-ingredient-note'),
                      controller: _noteController,
                      maxLines: 2,
                      textCapitalization: TextCapitalization.sentences,
                      decoration: const InputDecoration(
                        labelText: 'Nota (opcional)',
                        hintText: 'Ej.: pomada, picada fina',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ],
                ],
              ],
            ),
          ),
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        if (editing)
          IconButton(
            tooltip: 'Quitar ingrediente',
            onPressed: () =>
                Navigator.of(context)
                    .pop(const _IngredientEditResult.deleted()),
            color: Theme.of(context).colorScheme.error.withValues(alpha: 0.75),
            icon: const Icon(Icons.delete_outline),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _isLoadingFood || _choices.isEmpty ? null : _submit,
          child: Text(editing ? 'Guardar' : 'Agregar'),
        ),
      ],
    );
  }
}

class _MeasureChoice {
  const _MeasureChoice({
    required this.measureId,
    required this.name,
    required this.carbohydratesPerUse,
    required this.gramsPerUse,
    this.isGrams = false,
  });

  final int measureId;
  final String name;
  final double carbohydratesPerUse;
  final double? gramsPerUse;
  final bool isGrams;
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.emphasized = false,
  });

  final String label;
  final String value;
  final bool emphasized;

  @override
  Widget build(BuildContext context) {
    final style = emphasized
        ? Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.bold)
        : Theme.of(context).textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: style),
        Text(value, style: style),
      ],
    );
  }
}

String _formatNumber(double value) {
  if (value == value.truncateToDouble()) return value.toStringAsFixed(0);
  return value
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '')
      .replaceAll('.', ',');
}

double? _parseOptionalWeight(String value) =>
    double.tryParse(value.trim().replaceAll(',', '.'));

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:carbmate/core/text/search_text.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';

class CreateFoodScreen extends StatefulWidget {
  const CreateFoodScreen({super.key, required this.repository, this.foodId});

  final FoodRepository repository;
  final int? foodId;

  @override
  State<CreateFoodScreen> createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _carbohydratesPer100gFieldKey = GlobalKey();
  final _carbohydratesPer100gFocusNode = FocusNode();
  final _nameController = TextEditingController();
  final _carbohydratesPer100gController = TextEditingController();
  final _additionalMeasures = <_AdditionalMeasureInput>[];
  final _selectedTagIds = <int>{};
  final _existingMeasureIds = <int>{};

  late final Future<FoodFormOptions> _optionsFuture;
  int? _brandId;
  int? _measure100gId;
  String? _confidence100g;
  bool _show100gMeasure = true;
  bool _carbohydratesPer100gWasCalculated = false;
  bool _isSaving = false;
  bool _isDeleting = false;

  bool get _isEditing => widget.foodId != null;

  @override
  void initState() {
    super.initState();
    _optionsFuture = _loadOptions();
  }

  Future<FoodFormOptions> _loadOptions() async {
    final options = await widget.repository.loadFormOptions();
    final defaultMeasure = options.measures.firstWhere(
      (measure) => measure.name == '100 g',
      orElse: () => throw StateError('No existe la medida 100 g.'),
    );
    _measure100gId = defaultMeasure.id;

    final foodId = widget.foodId;
    if (foodId != null) {
      final details = await widget.repository.loadFood(foodId);
      if (details == null) {
        throw StateError('No se encontró el alimento.');
      }
      _loadFoodIntoForm(details.food);
    }

    return options;
  }

  void _loadFoodIntoForm(NewFood food) {
    _nameController.text = food.name;
    _brandId = food.brandId;
    _selectedTagIds.addAll(food.tagIds);
    _show100gMeasure = false;

    for (final measure in food.measures) {
      _existingMeasureIds.add(measure.measureId);
      if (measure.measureId == _measure100gId) {
        _show100gMeasure = true;
        _carbohydratesPer100gController.text =
            measure.carbohydrateGrams?.toString() ?? '';
        _confidence100g = measure.confidence;
      } else {
        _additionalMeasures.add(
          _AdditionalMeasureInput(
            measureId: measure.measureId,
            confidence: measure.confidence,
            productGrams: measure.productGrams?.toString(),
            carbohydrates: measure.carbohydrateGrams?.toString(),
            isExisting: true,
          ),
        );
      }
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _carbohydratesPer100gController.dispose();
    _carbohydratesPer100gFocusNode.dispose();
    for (final measure in _additionalMeasures) {
      measure.dispose();
    }
    super.dispose();
  }

  double? _parseNumber(String value) {
    final normalized = value.trim().replaceAll(',', '.');
    if (normalized.isEmpty) return null;
    return double.tryParse(normalized);
  }

  String? _validateOptionalNumber(String? value) {
    if (value == null || value.trim().isEmpty) return null;
    final number = _parseNumber(value);
    if (number == null) return 'Ingresá un número válido.';
    if (number < 0) return 'El valor no puede ser negativo.';
    return null;
  }

  String? _validateProductGrams(String? value) {
    final error = _validateOptionalNumber(value);
    if (error != null) return error;
    if (value != null && value.trim().isNotEmpty && _parseNumber(value) == 0) {
      return 'El peso debe ser mayor a 0.';
    }
    return null;
  }

  double? _calculateCarbohydratesPer100g(_AdditionalMeasureInput measure) {
    final productGrams = _parseNumber(measure.productGrams.text);
    final carbohydrateGrams = _parseNumber(measure.carbohydrates.text);
    if (productGrams == null || productGrams <= 0 || carbohydrateGrams == null) {
      return null;
    }
    return carbohydrateGrams * 100 / productGrams;
  }

  void _onAdditionalMeasureChanged(_AdditionalMeasureInput measure) {
    final calculated = _calculateCarbohydratesPer100g(measure);
    if (calculated != null &&
        (_carbohydratesPer100gController.text.trim().isEmpty ||
            _carbohydratesPer100gWasCalculated)) {
      setState(() {
        _show100gMeasure = true;
        _carbohydratesPer100gController.text = _formatNumber(calculated);
        _carbohydratesPer100gWasCalculated = true;
      });
    } else {
      setState(() {});
    }
  }

  InputDecoration _measureInputDecoration({
    required String labelText,
    required bool incomplete,
    String? suffixText,
  }) {
    final colorScheme = Theme.of(context).colorScheme;
    final borderColor = incomplete
        ? colorScheme.error
        : colorScheme.outline;
    return InputDecoration(
      labelText: labelText,
      suffixText: suffixText,
      border: const OutlineInputBorder(),
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: borderColor,
          width: incomplete ? 1.5 : 1,
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: incomplete ? colorScheme.error : colorScheme.primary,
          width: 2,
        ),
      ),
    );
  }

  String _formatNumber(double value) {
    if (value == value.truncateToDouble()) return value.toStringAsFixed(0);
    return value
        .toStringAsFixed(2)
        .replaceFirst(RegExp(r'0+$'), '')
        .replaceFirst(RegExp(r'\.$'), '');
  }

  Future<List<_CarbohydrateMismatch>> _findCarbohydrateMismatches() async {
    const toleranceGramsPer100g = 1.0;
    final current = _parseNumber(_carbohydratesPer100gController.text);
    if (current == null) return [];

    final options = await _optionsFuture;
    final mismatches = <_CarbohydrateMismatch>[];
    for (final measure in _additionalMeasures) {
      final calculated = _calculateCarbohydratesPer100g(measure);
      if (calculated == null || (calculated - current).abs() <= toleranceGramsPer100g) {
        continue;
      }
      var measureName = 'Medida';
      for (final option in options.measures) {
        if (option.id == measure.measureId) {
          measureName = option.name;
          break;
        }
      }
      mismatches.add(
        _CarbohydrateMismatch(measureName: measureName, calculated: calculated),
      );
    }
    return mismatches;
  }

  Future<bool> _confirmSavingWithMismatches(
    List<_CarbohydrateMismatch> mismatches,
  ) async {
    final mismatchDetails = mismatches
        .map(
          (mismatch) =>
              '• ${mismatch.measureName}: ${_formatNumber(mismatch.calculated)} g CHO/100 g',
        )
        .join('\n');
    final choice = await showDialog<_MismatchSaveChoice>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Revisar CHO/100 g'),
        content: Text(
          'Ingresaste ${_formatNumber(_parseNumber(_carbohydratesPer100gController.text)!)} g CHO/100 g, '
          'pero al calcular desde estas medidas se obtienen:\n\n'
          '$mismatchDetails\n\n'
          'La diferencia supera 1 g CHO/100 g. Podés revisar el valor o guardarlo igualmente.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(dialogContext).pop(
              _MismatchSaveChoice.edit,
            ),
            child: const Text('Revisar valor'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(
              _MismatchSaveChoice.saveAsIs,
            ),
            child: const Text('Guardar igualmente'),
          ),
        ],
      ),
    );

    if (choice == _MismatchSaveChoice.edit && mounted) {
      final fieldContext = _carbohydratesPer100gFieldKey.currentContext;
      if (fieldContext != null && fieldContext.mounted) {
        await Scrollable.ensureVisible(
          fieldContext,
          duration: const Duration(milliseconds: 250),
          alignment: 0.35,
        );
        if (mounted) {
          FocusScope.of(context).requestFocus(_carbohydratesPer100gFocusNode);
        }
      }
    }
    return choice == _MismatchSaveChoice.saveAsIs;
  }

  Future<List<_MeasureMissingWeight>> _findMeasuresMissingWeight() async {
    final options = await _optionsFuture;
    final missing = <_MeasureMissingWeight>[];
    for (final measure in _additionalMeasures) {
      final carbohydrates = _parseNumber(measure.carbohydrates.text);
      if (measure.measureId == null ||
          carbohydrates == null ||
          _parseNumber(measure.productGrams.text) != null) {
        continue;
      }
      var measureName = 'Medida';
      for (final option in options.measures) {
        if (option.id == measure.measureId) {
          measureName = option.name;
          break;
        }
      }
      missing.add(
        _MeasureMissingWeight(
          measure: measure,
          name: measureName,
          carbohydrates: carbohydrates,
        ),
      );
    }
    return missing;
  }

  Future<bool> _confirmSavingWithoutWeights(
    List<_MeasureMissingWeight> missing,
  ) async {
    final details = missing
        .map(
          (item) =>
              '• ${item.name}: ${_formatNumber(item.carbohydrates)} g CHO',
        )
        .join('\n');
    final choice = await showDialog<_MissingWeightSaveChoice>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Falta el peso de algunas medidas'),
        content: SingleChildScrollView(
          child: Text(
            'Cargaste los carbohidratos, pero no el peso de estas medidas:\n\n'
            '$details\n\n'
            'Podrás usarlas por medida, pero no convertirlas a gramos ni '
            'incluirlas en el peso total. ¿Querés guardarlas así?',
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _focusProductGrams(missing.first.measure),
            child: const Text('Completar peso'),
          ),
          FilledButton(
            onPressed: () => Navigator.of(dialogContext).pop(
              _MissingWeightSaveChoice.saveWithoutWeight,
            ),
            child: const Text('Guardar sin peso'),
          ),
        ],
      ),
    );
    return choice == _MissingWeightSaveChoice.saveWithoutWeight;
  }

  Future<void> _focusProductGrams(_AdditionalMeasureInput measure) async {
    if (!context.mounted) return;
    Navigator.of(context).pop(_MissingWeightSaveChoice.completeWeight);
    await WidgetsBinding.instance.endOfFrame;
    final fieldContext = measure.fieldKey.currentContext;
    if (fieldContext == null || !fieldContext.mounted || !mounted) return;
    await Scrollable.ensureVisible(
      fieldContext,
      duration: const Duration(milliseconds: 250),
      alignment: 0.35,
    );
    if (mounted) {
      FocusScope.of(context).requestFocus(measure.productGramsFocusNode);
    }
  }

  List<FoodMeasureDraft> _collectMeasures() {
    final measures = <FoodMeasureDraft>[];
    final carbohydratesPer100g = _parseNumber(
      _carbohydratesPer100gController.text,
    );

    if (_show100gMeasure &&
        (carbohydratesPer100g != null ||
            (_measure100gId != null &&
                _existingMeasureIds.contains(_measure100gId))) &&
        _measure100gId != null) {
      measures.add(
        FoodMeasureDraft(
          measureId: _measure100gId!,
          productGrams: 100,
          carbohydrateGrams: carbohydratesPer100g,
          confidence: _confidence100g,
        ),
      );
    }

    for (final measure in _additionalMeasures) {
      final productGrams = _parseNumber(measure.productGrams.text);
      final carbohydrateGrams = _parseNumber(measure.carbohydrates.text);
      if (measure.measureId == null ||
          (productGrams == null &&
              carbohydrateGrams == null &&
              !measure.isExisting)) {
        continue;
      }

      measures.add(
        FoodMeasureDraft(
          measureId: measure.measureId!,
          productGrams: productGrams,
          carbohydrateGrams: carbohydrateGrams,
          confidence: measure.confidence,
        ),
      );
    }

    return measures;
  }

  Future<void> _saveFood() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final mismatches = await _findCarbohydrateMismatches();
    if (!mounted) return;
    if (mismatches.isNotEmpty &&
        !await _confirmSavingWithMismatches(mismatches)) {
      return;
    }
    final missingWeights = await _findMeasuresMissingWeight();
    if (!mounted) return;
    if (missingWeights.isNotEmpty &&
        !await _confirmSavingWithoutWeights(missingWeights)) {
      return;
    }

    setState(() => _isSaving = true);
    try {
      final food = NewFood(
        name: _nameController.text.trim(),
        brandId: _brandId,
        tagIds: _selectedTagIds.toList(),
        measures: _collectMeasures(),
      );
      if (_isEditing) {
        await widget.repository.updateFood(widget.foodId!, food);
      } else {
        await widget.repository.createFood(food);
      }

      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            _isEditing ? 'Cambios guardados.' : 'Alimento guardado.',
          ),
        ),
      );
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el alimento.')),
      );
    }
  }

  Future<void> _deleteFood() async {
    final shouldDelete = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Eliminar alimento'),
        content: const Text(
          'Se eliminarán el alimento, sus tags asociados y sus medidas. '
          'Esta acción no se puede deshacer.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Cancelar'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );
    if (shouldDelete != true || !mounted) return;

    setState(() => _isDeleting = true);
    try {
      await widget.repository.deleteFood(widget.foodId!);
      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Alimento eliminado.')));
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isDeleting = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo eliminar el alimento.')),
      );
    }
  }

  Future<void> _chooseCatalogOption({
    required String title,
    required List<CatalogOption> options,
    required ValueChanged<int> onSelected,
    bool allowNone = false,
    VoidCallback? onNoneSelected,
  }) async {
    final result = await showModalBottomSheet<int>(
      context: context,
      isScrollControlled: true,
      builder: (_) => _CatalogPickerSheet(
        title: title,
        options: options,
        allowNone: allowNone,
      ),
    );
    if (!mounted || result == null) return;
    if (result == -1) {
      onNoneSelected?.call();
    } else {
      onSelected(result);
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<FoodFormOptions>(
      future: _optionsFuture,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_isEditing ? 'Editar alimento' : 'Crear alimento'),
            ),
            body: const Center(
              child: Text('No se pudieron cargar los catálogos.'),
            ),
          );
        }

        final options = snapshot.data;
        if (options == null) {
          return Scaffold(
            appBar: AppBar(
              title: Text(_isEditing ? 'Editar alimento' : 'Crear alimento'),
            ),
            body: const Center(child: CircularProgressIndicator()),
          );
        }

        return _buildLoadedForm(options);
      },
    );
  }

  Widget _buildLoadedForm(FoodFormOptions options) {
    final measure100g = options.measures.firstWhere(
      (measure) => measure.id == _measure100gId,
    );
    final hasCarbohydratesPer100g =
        _parseNumber(_carbohydratesPer100gController.text) != null;
    final hasMeasures = _collectMeasures().isNotEmpty;

    return Scaffold(
      appBar: AppBar(
        title: Text(_isEditing ? 'Editar alimento' : 'Crear alimento'),
        actions: [
          if (_isEditing)
            IconButton(
              key: const Key('delete-food'),
              tooltip: 'Eliminar alimento',
              onPressed: _isSaving || _isDeleting ? null : _deleteFood,
              icon: _isDeleting
                  ? const SizedBox.square(
                      dimension: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : Icon(
                      Icons.delete_outline,
                      color: Theme.of(context).colorScheme.error,
                    ),
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 8, 24, 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              FilledButton.icon(
                onPressed: _isSaving || _isDeleting ? null : _saveFood,
                icon: _isSaving
                    ? const SizedBox.square(
                        dimension: 18,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Icon(Icons.save),
                label: const Text('Guardar'),
              ),
            ],
          ),
        ),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            TextFormField(
              key: const Key('food-name'),
              controller: _nameController,
              decoration: const InputDecoration(
                labelText: 'Nombre *',
                border: OutlineInputBorder(),
              ),
              textCapitalization: TextCapitalization.sentences,
              textInputAction: TextInputAction.next,
              validator: (value) {
                if (value == null || value.trim().isEmpty) {
                  return 'El nombre es obligatorio.';
                }
                return null;
              },
            ),
            const SizedBox(height: 16),
            InkWell(
              key: const Key('food-brand'),
              onTap: () => _chooseCatalogOption(
                title: 'Elegir marca',
                options: options.brands,
                allowNone: true,
                onSelected: (value) => setState(() => _brandId = value),
                onNoneSelected: () => setState(() => _brandId = null),
              ),
              child: InputDecorator(
                decoration: const InputDecoration(
                  labelText: 'Marca (opcional)',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.arrow_drop_down),
                ),
                child: Text(
                  _brandId == null
                      ? 'Sin marca'
                      : options.brands
                            .firstWhere((brand) => brand.id == _brandId)
                            .name,
                ),
              ),
            ),
            const SizedBox(height: 24),
            Text('Tags', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            InkWell(
              key: const Key('food-tags-picker'),
              onTap: options.tags.length == _selectedTagIds.length
                  ? null
                  : () => _chooseCatalogOption(
                      title: 'Agregar tag',
                      options: options.tags
                          .where((tag) => !_selectedTagIds.contains(tag.id))
                          .toList(),
                      onSelected: (value) =>
                          setState(() => _selectedTagIds.add(value)),
                    ),
              child: const InputDecorator(
                decoration: InputDecoration(
                  labelText: 'Buscar y agregar tags',
                  border: OutlineInputBorder(),
                  suffixIcon: Icon(Icons.search),
                ),
                child: Text('Seleccionar tag'),
              ),
            ),
            if (_selectedTagIds.isNotEmpty) ...[
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  for (final tag in options.tags.where(
                    (tag) => _selectedTagIds.contains(tag.id),
                  ))
                    InputChip(
                      label: Text(tag.name),
                      onDeleted: () =>
                          setState(() => _selectedTagIds.remove(tag.id)),
                    ),
                ],
              ),
            ],
            if (_selectedTagIds.isEmpty) ...[
              const SizedBox(height: 8),
              const _RelationshipWarning(
                message: 'No hay tags asociados. Podés continuar sin ellos.',
              ),
            ],
            const SizedBox(height: 24),
            Text('Medidas', style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 12),
            if (_show100gMeasure) ...[
              Container(
                margin: const EdgeInsets.only(bottom: 12),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  border: Border.all(
                    color: (hasCarbohydratesPer100g
                            ? Theme.of(context).colorScheme.primary
                            : Theme.of(context).colorScheme.error)
                        .withValues(alpha: 0.55),
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Column(
                  children: [
                    Row(
                      key: _carbohydratesPer100gFieldKey,
                      children: [
                        Expanded(
                          child: TextFormField(
                            key: const Key('carbohydrates-per-100g'),
                            focusNode: _carbohydratesPer100gFocusNode,
                            controller: _carbohydratesPer100gController,
                            decoration: _measureInputDecoration(
                              labelText:
                                  'Carbohidratos por ${measure100g.name}',
                              suffixText: 'g CHO',
                              incomplete: !hasCarbohydratesPer100g,
                            ),
                            keyboardType: const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            inputFormatters: [
                              FilteringTextInputFormatter.allow(
                                RegExp(r'[0-9,.]'),
                              ),
                            ],
                            validator: _validateOptionalNumber,
                            onChanged: (_) => setState(
                              () => _carbohydratesPer100gWasCalculated = false,
                            ),
                          ),
                        ),
                        IconButton(
                          key: const Key('remove-100g-measure'),
                          tooltip: 'Quitar medida de 100 g',
                          onPressed: () {
                            setState(() {
                              _show100gMeasure = false;
                              _carbohydratesPer100gController.clear();
                              _carbohydratesPer100gWasCalculated = false;
                              _confidence100g = null;
                            });
                          },
                          icon: const Icon(Icons.delete_outline),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    _buildConfidenceDropdown(
                      key: const Key('confidence-100g'),
                      value: _confidence100g,
                      onChanged: (value) =>
                          setState(() => _confidence100g = value),
                    ),
                  ],
                ),
              ),
            ] else
              Align(
                alignment: Alignment.centerLeft,
                child: TextButton.icon(
                  key: const Key('restore-100g-measure'),
                  onPressed: () => setState(() => _show100gMeasure = true),
                  icon: const Icon(Icons.add),
                  label: Text('Agregar medida ${measure100g.name}'),
                ),
              ),
            for (var index = 0; index < _additionalMeasures.length; index++)
              _buildAdditionalMeasureRow(options, index),
            Align(
              alignment: Alignment.centerLeft,
              child: TextButton.icon(
                onPressed: () {
                  setState(
                    () => _additionalMeasures.add(_AdditionalMeasureInput()),
                  );
                },
                icon: const Icon(Icons.add),
                label: const Text('Agregar otra medida'),
              ),
            ),
            if (!hasMeasures) ...[
              const SizedBox(height: 8),
              const _RelationshipWarning(
                message: 'No hay medidas asociadas. Podés continuar sin ellas.',
              ),
            ],
            const SizedBox(height: 28),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalMeasureRow(FoodFormOptions options, int index) {
    final row = _additionalMeasures[index];
    final isMissingProductGrams =
        _parseNumber(row.productGrams.text) == null;
    final isMissingCarbohydrates =
        _parseNumber(row.carbohydrates.text) == null;
    final isIncomplete =
        isMissingProductGrams || isMissingCarbohydrates;
    final usedByOtherRows = _additionalMeasures
        .where((measure) => !identical(measure, row))
        .map((measure) => measure.measureId)
        .toSet();
    final availableMeasures = options.measures
        .where(
          (measure) =>
              measure.id != _measure100gId &&
              !usedByOtherRows.contains(measure.id),
        )
        .toList();

    return Padding(
      key: row.fieldKey,
      padding: const EdgeInsets.only(top: 12),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(
            color: (isIncomplete
                    ? Theme.of(context).colorScheme.error
                    : Theme.of(context).colorScheme.primary)
                .withValues(alpha: 0.55),
          ),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: DropdownButtonFormField<int>(
                    key: ValueKey('additional-measure-$index'),
                    initialValue: row.measureId,
                    decoration: const InputDecoration(
                      labelText: 'Medida',
                      border: OutlineInputBorder(),
                    ),
                    items: [
                      for (final measure in availableMeasures)
                        DropdownMenuItem<int>(
                          value: measure.id,
                          child: Text(measure.name),
                        ),
                    ],
                    validator: (value) {
                      final hasValues =
                          row.productGrams.text.trim().isNotEmpty ||
                          row.carbohydrates.text.trim().isNotEmpty;
                      if (hasValues && value == null) return 'Elegí una medida.';
                      return null;
                    },
                    onChanged: (value) => setState(() => row.measureId = value),
                  ),
                ),
                IconButton(
                  tooltip: 'Quitar medida',
                  onPressed: () {
                    setState(() => _additionalMeasures.removeAt(index));
                    row.dispose();
                  },
                  icon: const Icon(Icons.delete_outline),
                ),
              ],
            ),
            const SizedBox(height: 12),
            _buildConfidenceDropdown(
              key: ValueKey('confidence-$index'),
              value: row.confidence,
              onChanged: (value) => setState(() => row.confidence = value),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: TextFormField(
                    key: ValueKey('product-grams-$index'),
                    controller: row.productGrams,
                    focusNode: row.productGramsFocusNode,
                    decoration: _measureInputDecoration(
                      labelText: 'Gramos de producto',
                      incomplete: isMissingProductGrams,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    validator: _validateProductGrams,
                    onChanged: (_) => _onAdditionalMeasureChanged(row),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextFormField(
                    key: ValueKey('additional-carbohydrates-$index'),
                    controller: row.carbohydrates,
                    decoration: _measureInputDecoration(
                      labelText: 'Carbohidratos (g)',
                      incomplete: isMissingCarbohydrates,
                    ),
                    keyboardType: const TextInputType.numberWithOptions(
                      decimal: true,
                    ),
                    inputFormatters: [
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                    ],
                    validator: _validateOptionalNumber,
                    onChanged: (_) => _onAdditionalMeasureChanged(row),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _AdditionalMeasureInput {
  _AdditionalMeasureInput({
    this.measureId,
    this.confidence,
    this.isExisting = false,
    String? productGrams,
    String? carbohydrates,
  }) : productGrams = TextEditingController(text: productGrams),
       carbohydrates = TextEditingController(text: carbohydrates);

  final fieldKey = GlobalKey();
  final productGramsFocusNode = FocusNode();
  int? measureId;
  String? confidence;
  final bool isExisting;
  final TextEditingController productGrams;
  final TextEditingController carbohydrates;

  void dispose() {
    productGrams.dispose();
    carbohydrates.dispose();
    productGramsFocusNode.dispose();
  }
}

enum _MissingWeightSaveChoice { completeWeight, saveWithoutWeight }

class _MeasureMissingWeight {
  const _MeasureMissingWeight({
    required this.measure,
    required this.name,
    required this.carbohydrates,
  });

  final _AdditionalMeasureInput measure;
  final String name;
  final double carbohydrates;
}

enum _MismatchSaveChoice { edit, saveAsIs }

class _CarbohydrateMismatch {
  const _CarbohydrateMismatch({
    required this.measureName,
    required this.calculated,
  });

  final String measureName;
  final double calculated;
}

const _confidenceLevels = ['1 - Bajo', '2 - Medio', '3 - Alto'];
const _noConfidence = '__sin_confianza__';

Widget _buildConfidenceDropdown({
  required Key key,
  required String? value,
  required ValueChanged<String?> onChanged,
}) {
  return DropdownButtonFormField<String>(
    key: key,
    initialValue: value ?? _noConfidence,
    decoration: const InputDecoration(
      labelText: 'Confianza',
      border: OutlineInputBorder(),
    ),
    items: [
      const DropdownMenuItem<String>(
        value: _noConfidence,
        child: Text('Sin especificar'),
      ),
      for (final option in _confidenceLevels)
        DropdownMenuItem<String>(value: option, child: Text(option)),
    ],
    onChanged: (selected) =>
        onChanged(selected == _noConfidence ? null : selected),
  );
}

class _CatalogPickerSheet extends StatefulWidget {
  const _CatalogPickerSheet({
    required this.title,
    required this.options,
    this.allowNone = false,
  });

  final String title;
  final List<CatalogOption> options;
  final bool allowNone;

  @override
  State<_CatalogPickerSheet> createState() => _CatalogPickerSheetState();
}

class _CatalogPickerSheetState extends State<_CatalogPickerSheet> {
  final _searchController = TextEditingController();
  String _query = '';

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final query = normalizeSearchText(_query.trim());
    final filtered = widget.options
        .where((option) => normalizeSearchText(option.name).contains(query))
        .toList();
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 16,
          right: 16,
          top: 16,
          bottom: MediaQuery.viewInsetsOf(context).bottom + 16,
        ),
        child: SizedBox(
          height: MediaQuery.sizeOf(context).height * 0.7,
          child: Column(
            children: [
              Text(widget.title, style: Theme.of(context).textTheme.titleLarge),
              const SizedBox(height: 12),
              TextField(
                controller: _searchController,
                autofocus: true,
                decoration: const InputDecoration(
                  hintText: 'Escribir para filtrar',
                  prefixIcon: Icon(Icons.search),
                  border: OutlineInputBorder(),
                ),
                onChanged: (value) => setState(() => _query = value),
              ),
              const SizedBox(height: 8),
              Expanded(
                child: ListView(
                  children: [
                    if (widget.allowNone)
                      ListTile(
                        title: const Text('Sin marca'),
                        onTap: () => Navigator.pop(context, -1),
                      ),
                    for (final option in filtered)
                      ListTile(
                        title: Text(option.name),
                        onTap: () => Navigator.pop(context, option.id),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _RelationshipWarning extends StatelessWidget {
  const _RelationshipWarning({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colorScheme.tertiaryContainer,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Icon(Icons.info_outline, color: colorScheme.onTertiaryContainer),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: colorScheme.onTertiaryContainer),
            ),
          ),
        ],
      ),
    );
  }
}

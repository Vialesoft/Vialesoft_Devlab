import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:carbmate/features/foods/domain/food_repository.dart';

class CreateFoodScreen extends StatefulWidget {
  const CreateFoodScreen({super.key, required this.repository});

  final FoodRepository repository;

  @override
  State<CreateFoodScreen> createState() => _CreateFoodScreenState();
}

class _CreateFoodScreenState extends State<CreateFoodScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _carbohydratesPer100gController = TextEditingController();
  final _additionalMeasures = <_AdditionalMeasureInput>[];
  final _selectedTagIds = <int>{};

  late final Future<FoodFormOptions> _optionsFuture;
  int? _brandId;
  int? _measure100gId;
  String? _confidence100g;
  bool _show100gMeasure = true;
  bool _isSaving = false;

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
    return options;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _carbohydratesPer100gController.dispose();
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

  List<FoodMeasureDraft> _collectMeasures() {
    final measures = <FoodMeasureDraft>[];
    final carbohydratesPer100g = _parseNumber(
      _carbohydratesPer100gController.text,
    );

    if (_show100gMeasure &&
        carbohydratesPer100g != null &&
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
          (productGrams == null && carbohydrateGrams == null)) {
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

    setState(() => _isSaving = true);
    try {
      await widget.repository.createFood(
        NewFood(
          name: _nameController.text.trim(),
          brandId: _brandId,
          tagIds: _selectedTagIds.toList(),
          measures: _collectMeasures(),
        ),
      );

      if (!mounted) return;
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Alimento guardado.')));
      Navigator.of(context).pop(true);
    } catch (_) {
      if (!mounted) return;
      setState(() => _isSaving = false);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo guardar el alimento.')),
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
            appBar: AppBar(title: const Text('Crear alimento')),
            body: const Center(
              child: Text('No se pudieron cargar los catálogos.'),
            ),
          );
        }

        final options = snapshot.data;
        if (options == null) {
          return Scaffold(
            appBar: AppBar(title: const Text('Crear alimento')),
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
    final hasMeasures = _collectMeasures().isNotEmpty;

    return Scaffold(
      appBar: AppBar(title: const Text('Crear alimento')),
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
                child: Text(_brandId == null
                    ? 'Sin marca'
                    : options.brands
                        .firstWhere((brand) => brand.id == _brandId)
                        .name),
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
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      key: const Key('carbohydrates-per-100g'),
                      controller: _carbohydratesPer100gController,
                      decoration: InputDecoration(
                        labelText: 'Carbohidratos por ${measure100g.name}',
                        suffixText: 'g CHO',
                        border: const OutlineInputBorder(),
                      ),
                      keyboardType: const TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      inputFormatters: [
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                      ],
                      validator: _validateOptionalNumber,
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  IconButton(
                    key: const Key('remove-100g-measure'),
                    tooltip: 'Quitar medida de 100 g',
                    onPressed: () {
                      setState(() {
                        _show100gMeasure = false;
                        _carbohydratesPer100gController.clear();
                        _confidence100g = null;
                      });
                    },
                    icon: const Icon(Icons.close),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              _buildConfidenceDropdown(
                key: const Key('confidence-100g'),
                value: _confidence100g,
                onChanged: (value) => setState(() => _confidence100g = value),
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
            FilledButton.icon(
              onPressed: _isSaving ? null : _saveFood,
              icon: _isSaving
                  ? const SizedBox.square(
                      dimension: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save),
              label: Text(_isSaving ? 'Guardando...' : 'Guardar alimento'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAdditionalMeasureRow(FoodFormOptions options, int index) {
    final row = _additionalMeasures[index];
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
      padding: const EdgeInsets.only(top: 16),
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
                  decoration: const InputDecoration(
                    labelText: 'Gramos de producto',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  validator: _validateOptionalNumber,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextFormField(
                  key: ValueKey('additional-carbohydrates-$index'),
                  controller: row.carbohydrates,
                  decoration: const InputDecoration(
                    labelText: 'Carbohidratos (g)',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: const TextInputType.numberWithOptions(
                    decimal: true,
                  ),
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
                  ],
                  validator: _validateOptionalNumber,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _AdditionalMeasureInput {
  int? measureId;
  String? confidence;
  final productGrams = TextEditingController();
  final carbohydrates = TextEditingController();

  void dispose() {
    productGrams.dispose();
    carbohydrates.dispose();
  }
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
    final query = _query.trim().toLowerCase();
    final filtered = widget.options
        .where((option) => option.name.toLowerCase().contains(query))
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

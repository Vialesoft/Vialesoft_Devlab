import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:carbmate/core/text/search_text.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';

class CalculatorScreen extends StatefulWidget {
  const CalculatorScreen({
    super.key,
    required this.repository,
    required this.session,
  });

  final FoodRepository repository;
  final CalculatorSession session;

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  late final Future<_CalculatorData> _dataFuture = _loadData();
  TextEditingController? _searchController;

  List<_CalculatorEntry> get _entries => widget.session._entries;

  Future<_CalculatorData> _loadData() async {
    final foodsFuture = widget.repository.loadFoods();
    final optionsFuture = widget.repository.loadFormOptions();
    final foods = await foodsFuture;
    final options = await optionsFuture;
    return _CalculatorData(
      foods: foods,
      measureNames: {
        for (final measure in options.measures) measure.id: measure.name,
      },
    );
  }

  Future<void> _selectFood(FoodListItem food, _CalculatorData data) async {
    final details = await widget.repository.loadFood(food.id);
    if (!mounted || details == null) return;

    final measureOptions = _buildMeasureOptions(
      details.food,
      data.measureNames,
    );
    if (measureOptions.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Este alimento no tiene medidas con CHO calculable.'),
        ),
      );
      return;
    }

    final result = await showDialog<_IngredientDialogResult>(
      context: context,
      builder: (_) => _AddIngredientDialog(
        food: food,
        measureOptions: measureOptions,
      ),
    );
    final entry = result?.entry;
    if (entry != null && mounted) {
      setState(() => _addOrMergeEntry(entry));
      _searchController?.clear();
    }
  }

  Future<void> _editEntry(int index) async {
    final current = _entries[index];
    final details = await widget.repository.loadFood(current.food.id);
    if (!mounted || details == null) return;
    final data = await _dataFuture;
    final measureOptions = _buildMeasureOptions(
      details.food,
      data.measureNames,
    );
    if (!mounted || measureOptions.isEmpty) return;

    final result = await showDialog<_IngredientDialogResult>(
      context: context,
      builder: (_) => _AddIngredientDialog(
        food: current.food,
        measureOptions: measureOptions,
        initialEntry: current,
      ),
    );
    if (result == null || !mounted) return;
    setState(() {
      if (result.deleted) {
        _entries.removeAt(index);
      } else if (result.entry != null) {
        final updatedEntry = result.entry!;
        _entries.removeAt(index);
        _addOrMergeEntry(updatedEntry);
      }
    });
  }

  void _addOrMergeEntry(_CalculatorEntry incoming) {
    final matchingIndex = _entries.indexWhere(
      (existing) =>
          existing.food.id == incoming.food.id &&
          existing.measure.isGrams == incoming.measure.isGrams &&
          existing.measure.measureId == incoming.measure.measureId,
    );
    if (matchingIndex >= 0) {
      final existing = _entries[matchingIndex];
      _entries[matchingIndex] = existing.copyWith(
        quantity: existing.quantity + incoming.quantity,
      );
      return;
    }

    final convertibleIndex = _entries.indexWhere(
      (existing) =>
          existing.food.id == incoming.food.id &&
          existing.measure.gramsPerUse != null &&
          incoming.measure.gramsPerUse != null,
    );
    if (convertibleIndex < 0) {
      _entries.add(incoming);
      return;
    }

    final existing = _entries[convertibleIndex];
    final totalGrams =
        existing.quantity * existing.measure.gramsPerUse! +
        incoming.quantity * incoming.measure.gramsPerUse!;
    final totalCarbohydrates =
        existing.totalCarbohydrates + incoming.totalCarbohydrates;
    _entries[convertibleIndex] = _CalculatorEntry(
      food: incoming.food,
      measure: _CalculatorMeasureOption(
        name: 'Gramos',
        carbohydratesPerUse: totalCarbohydrates / totalGrams,
        gramsPerUse: 1,
        isGrams: true,
      ),
      quantity: totalGrams,
    );
  }

  List<_CalculatorMeasureOption> _buildMeasureOptions(
    NewFood food,
    Map<int, String> measureNames,
  ) {
    final referenceMeasures = food.measures.where((measure) {
      final grams = measure.productGrams;
      return grams != null &&
          grams > 0 &&
          measure.carbohydrateGrams != null;
    }).toList();
    FoodMeasureDraft? reference;
    for (final measure in referenceMeasures) {
      if (measureNames[measure.measureId] == '100 g') {
        reference = measure;
        break;
      }
    }
    reference ??= referenceMeasures.isEmpty ? null : referenceMeasures.first;

    final options = <_CalculatorMeasureOption>[];
    if (reference != null) {
      options.add(
        _CalculatorMeasureOption(
          name: 'Gramos',
          carbohydratesPerUse:
              reference.carbohydrateGrams! / reference.productGrams!,
          gramsPerUse: 1,
          isGrams: true,
        ),
      );
    }

    for (final measure in food.measures) {
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

      options.add(
        _CalculatorMeasureOption(
          name: name,
          measureId: measure.measureId,
          carbohydratesPerUse: carbohydratesPerUse,
          gramsPerUse: measure.productGrams,
        ),
      );
    }
    return options;
  }

  bool _isWeightMeasure(String name) =>
      RegExp(r'^\s*\d+(?:[,.]\d+)?\s*g\s*$', caseSensitive: false)
          .hasMatch(name);

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Calculadora'),
        actions: [
          if (_entries.length >= 2)
            TextButton.icon(
              key: const Key('clear-calculator'),
              onPressed: _clearEntries,
              icon: const Icon(Icons.cleaning_services_outlined),
              label: const Text('Limpiar'),
            ),
        ],
      ),
      body: FutureBuilder<_CalculatorData>(
        future: _dataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('No se pudieron cargar los alimentos.'),
            );
          }
          final data = snapshot.data;
          if (data == null) {
            return const Center(child: CircularProgressIndicator());
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Autocomplete<FoodListItem>(
                  displayStringForOption: (food) => food.name,
                  optionsBuilder: (value) {
                    final query = normalizeSearchText(value.text.trim());
                    if (query.length < 2) return const [];
                    return data.foods.where((food) {
                      final searchableText = [
                        food.name,
                        food.brandName ?? '',
                        ...food.tags,
                      ].map(normalizeSearchText).join(' ');
                      return searchableText.contains(query);
                    });
                  },
                  onSelected: (food) => _selectFood(food, data),
                  fieldViewBuilder:
                      (context, controller, focusNode, onFieldSubmitted) {
                        _searchController = controller;
                        return TextField(
                          key: const Key('calculator-food-search'),
                          controller: controller,
                          focusNode: focusNode,
                          decoration: const InputDecoration(
                            hintText: 'Buscar alimentos',
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(),
                          ),
                          textInputAction: TextInputAction.search,
                          onSubmitted: (_) => onFieldSubmitted(),
                        );
                      },
                  optionsViewBuilder: (context, onSelected, options) {
                    final results = options.toList();
                    return Align(
                      alignment: Alignment.topLeft,
                      child: Material(
                        elevation: 8,
                        color: colorScheme.surface,
                        borderRadius: BorderRadius.circular(12),
                        clipBehavior: Clip.antiAlias,
                        child: ConstrainedBox(
                          constraints: const BoxConstraints(maxHeight: 320),
                          child: ListView.separated(
                            padding: EdgeInsets.zero,
                            shrinkWrap: true,
                            itemCount: results.length,
                            separatorBuilder: (_, _) =>
                                const Divider(height: 1),
                            itemBuilder: (context, index) {
                              final food = results[index];
                              return _FoodSearchResult(
                                food: food,
                                onTap: () => onSelected(food),
                              );
                            },
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                child: _entries.isEmpty
                    ? const Center(
                        child: Text('Buscá y agregá alimentos para empezar.'),
                      )
                    : ListView.builder(
                        padding: const EdgeInsets.fromLTRB(12, 4, 12, 12),
                        itemCount: _entries.length,
                        itemBuilder: (context, index) {
                          final entry = _entries[index];
                          final missingWeight =
                              entry.measure.gramsPerUse == null;
                          return Card(
                            margin: const EdgeInsets.symmetric(vertical: 5),
                            color: missingWeight
                                ? colorScheme.tertiaryContainer.withValues(
                                    alpha: 0.35,
                                  )
                                : colorScheme.surface,
                            elevation: missingWeight ? 0 : 1,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(
                                color: colorScheme.primary.withValues(
                                  alpha: 0.25,
                                ),
                              ),
                            ),
                            child: InkWell(
                              onTap: () => _editEntry(index),
                              borderRadius: BorderRadius.circular(12),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 10,
                                  horizontal: 4,
                                ),
                                child: Row(
                                  children: [
                                    IconButton(
                                      tooltip: 'Quitar alimento',
                                      onPressed: () => setState(
                                        () => _entries.removeAt(index),
                                      ),
                                      padding: EdgeInsets.zero,
                                      constraints:
                                          const BoxConstraints.tightFor(
                                            width: 36,
                                            height: 40,
                                          ),
                                      visualDensity: VisualDensity.compact,
                                      color: colorScheme.error.withValues(
                                        alpha: 0.72,
                                      ),
                                      icon: const Icon(Icons.delete_outline),
                                    ),
                                    const SizedBox(width: 4),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            entry.food.name,
                                            style: Theme.of(context)
                                                .textTheme
                                                .titleLarge
                                                ?.copyWith(fontSize: 20),
                                          ),
                                          if (entry.food.brandName
                                                  ?.trim()
                                                  .isNotEmpty ??
                                              false)
                                            Text(
                                              entry.food.brandName!.trim(),
                                              style: Theme.of(context)
                                                  .textTheme
                                                  .bodySmall
                                                  ?.copyWith(
                                                    fontWeight: FontWeight.w600,
                                                    color: colorScheme.primary,
                                                  ),
                                            ),
                                          Text(entry.quantityLabel),
                                        ],
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.end,
                                      children: [
                                        if (missingWeight)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                              bottom: 2,
                                            ),
                                            child: Tooltip(
                                              message:
                                                  'Falta cargar el peso de esta medida.',
                                              child: Icon(
                                                Icons.info_outline,
                                                size: 16,
                                                color:
                                                    Colors.orange.shade700,
                                              ),
                                            ),
                                          ),
                                        Text(
                                          'CHO:',
                                          style: Theme.of(
                                            context,
                                          ).textTheme.bodySmall,
                                        ),
                                        Text(
                                          '${_formatNumber(entry.totalCarbohydrates)}g',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium
                                              ?.copyWith(
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(width: 8),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      bottomNavigationBar: SafeArea(
        top: false,
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 14, 20, 16),
          decoration: BoxDecoration(
            color: colorScheme.surface,
            border: Border(
              top: BorderSide(
                color: colorScheme.primary.withValues(alpha: 0.4),
              ),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _TotalRow(
                label: 'Peso total',
                value: _totalWeightLabel,
              ),
              const SizedBox(height: 8),
              _TotalRow(
                label: 'Carbohidratos totales',
                value: '${_formatNumber(_totalCarbohydrates)} g',
                emphasize: true,
              ),
            ],
          ),
        ),
      ),
    );
  }

  double get _totalCarbohydrates => _entries.fold(
    0,
    (total, entry) =>
        total + entry.quantity * entry.measure.carbohydratesPerUse,
  );

  bool get _hasUnknownWeight =>
      _entries.any((entry) => entry.measure.gramsPerUse == null);

  double get _totalWeight => _entries.fold(
    0,
    (total, entry) => total + entry.quantity * (entry.measure.gramsPerUse ?? 0),
  );

  String get _totalWeightLabel => _hasUnknownWeight
      ? '—'
      : '${_formatNumber(_totalWeight)} g';

  void _clearEntries() {
    setState(_entries.clear);
    _searchController?.clear();
  }
}

class CalculatorSession {
  final List<_CalculatorEntry> _entries = [];
}

class _FoodSearchResult extends StatelessWidget {
  const _FoodSearchResult({required this.food, required this.onTap});

  final FoodListItem food;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final brand = food.brandName?.trim();
    final unitSummaries = food.carbohydrateSummaries
        .where((summary) => summary.measureName == 'Unidad')
        .toList();
    final summaries = unitSummaries.isNotEmpty
        ? unitSummaries
        : food.carbohydrateSummaries
              .where((summary) => summary.measureName == '100 g')
              .toList();
    final details = [
      if (food.tags.isNotEmpty) food.tags.join(', '),
      for (final summary in summaries) _formatSummary(summary),
    ].join(' · ');
    final hasBrand = brand != null && brand.isNotEmpty;

    return ListTile(
      onTap: onTap,
      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 4),
      title: Text(food.name, style: Theme.of(context).textTheme.titleLarge),
      trailing: const Icon(Icons.chevron_right),
      subtitle: !hasBrand && details.isEmpty
          ? null
          : Text.rich(
              TextSpan(
                children: [
                  if (hasBrand)
                    TextSpan(
                      text: brand,
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                    ),
                  if (hasBrand && details.isNotEmpty)
                    const TextSpan(text: ' · '),
                  if (details.isNotEmpty) TextSpan(text: details),
                ],
              ),
              style: Theme.of(context).textTheme.bodySmall,
            ),
    );
  }
}

class _AddIngredientDialog extends StatefulWidget {
  const _AddIngredientDialog({
    required this.food,
    required this.measureOptions,
    this.initialEntry,
  });

  final FoodListItem food;
  final List<_CalculatorMeasureOption> measureOptions;
  final _CalculatorEntry? initialEntry;

  @override
  State<_AddIngredientDialog> createState() => _AddIngredientDialogState();
}

class _AddIngredientDialogState extends State<_AddIngredientDialog> {
  final _formKey = GlobalKey<FormState>();
  late final _quantityController = TextEditingController(
    text: _formatNumber(widget.initialEntry?.quantity ?? 1),
  );
  late _CalculatorMeasureOption _selectedMeasure = _initialMeasure;

  _CalculatorMeasureOption get _initialMeasure {
    final initialMeasure = widget.initialEntry?.measure;
    if (initialMeasure != null) {
      for (final option in widget.measureOptions) {
        if (option.isGrams == initialMeasure.isGrams &&
            option.measureId == initialMeasure.measureId) {
          return option;
        }
      }
    }
    return widget.measureOptions.firstWhere(
      (measure) => measure.name == 'Unidad',
      orElse: () => widget.measureOptions.first,
    );
  }

  @override
  void dispose() {
    _quantityController.dispose();
    super.dispose();
  }

  double? _parseQuantity(String value) =>
      double.tryParse(value.trim().replaceAll(',', '.'));

  void _submit() {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    Navigator.of(context).pop(
      _IngredientDialogResult(
        entry: _CalculatorEntry(
          food: widget.food,
          measure: _selectedMeasure,
          quantity: _parseQuantity(_quantityController.text)!,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.initialEntry == null
            ? widget.food.name
            : 'Editar ${widget.food.name}',
      ),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            DropdownButtonFormField<_CalculatorMeasureOption>(
              initialValue: _selectedMeasure,
              decoration: const InputDecoration(
                labelText: 'Medida',
                border: OutlineInputBorder(),
              ),
              items: [
                for (final option in widget.measureOptions)
                  DropdownMenuItem(
                    value: option,
                    child: Text(option.name),
                  ),
              ],
              onChanged: (value) {
                if (value != null) setState(() => _selectedMeasure = value);
              },
            ),
            const SizedBox(height: 12),
            TextFormField(
              controller: _quantityController,
              autofocus: true,
              decoration: InputDecoration(
                labelText: _selectedMeasure.isGrams
                    ? 'Cantidad en gramos'
                    : 'Cantidad',
                suffixText: _selectedMeasure.isGrams ? 'g' : null,
                border: const OutlineInputBorder(),
              ),
              keyboardType: TextInputType.numberWithOptions(
                decimal: !_selectedMeasure.isGrams,
              ),
              inputFormatters: [
                _selectedMeasure.isGrams
                    ? FilteringTextInputFormatter.digitsOnly
                    : FilteringTextInputFormatter.allow(RegExp(r'[0-9,.]')),
              ],
              textInputAction: TextInputAction.done,
              onFieldSubmitted: (_) => _submit(),
              validator: (value) {
                final quantity = _parseQuantity(value ?? '');
                if (quantity == null || quantity <= 0) {
                  return 'Ingresá una cantidad mayor que cero.';
                }
                return null;
              },
            ),
          ],
        ),
      ),
      actionsAlignment: MainAxisAlignment.spaceBetween,
      actions: [
        if (widget.initialEntry != null)
          IconButton(
            tooltip: 'Eliminar ingrediente',
            onPressed: () => Navigator.of(context).pop(
              const _IngredientDialogResult.deleted(),
            ),
            color: Theme.of(context)
                .colorScheme
                .error
                .withValues(alpha: 0.72),
            icon: const Icon(Icons.delete_outline),
          ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancelar'),
        ),
        FilledButton(
          onPressed: _submit,
          child: Text(widget.initialEntry == null ? 'OK' : 'Guardar'),
        ),
      ],
    );
  }
}

class _CalculatorData {
  const _CalculatorData({required this.foods, required this.measureNames});

  final List<FoodListItem> foods;
  final Map<int, String> measureNames;
}

class _CalculatorMeasureOption {
  const _CalculatorMeasureOption({
    required this.name,
    required this.carbohydratesPerUse,
    required this.gramsPerUse,
    this.measureId,
    this.isGrams = false,
  });

  final String name;
  final double carbohydratesPerUse;
  final double? gramsPerUse;
  final int? measureId;
  final bool isGrams;
}

class _CalculatorEntry {
  const _CalculatorEntry({
    required this.food,
    required this.measure,
    required this.quantity,
  });

  final FoodListItem food;
  final _CalculatorMeasureOption measure;
  final double quantity;

  String get quantityLabel {
    final quantityText = measure.isGrams
        ? '${_formatNumber(quantity)} g'
        : '${_formatNumber(quantity)} × ${measure.name}';
    final gramsPerUse = measure.gramsPerUse;
    if (measure.isGrams || gramsPerUse == null) return quantityText;
    final totalGrams = quantity * gramsPerUse;
    return '$quantityText - ${_formatNumber(totalGrams)} g';
  }

  double get totalCarbohydrates =>
      quantity * measure.carbohydratesPerUse;

  _CalculatorEntry copyWith({double? quantity}) => _CalculatorEntry(
    food: food,
    measure: measure,
    quantity: quantity ?? this.quantity,
  );
}

class _IngredientDialogResult {
  const _IngredientDialogResult({this.entry}) : deleted = false;

  const _IngredientDialogResult.deleted() : entry = null, deleted = true;

  final _CalculatorEntry? entry;
  final bool deleted;
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.emphasize = false,
  });

  final String label;
  final String value;
  final bool emphasize;

  @override
  Widget build(BuildContext context) {
    final style = emphasize
        ? Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          )
        : Theme.of(context).textTheme.bodyLarge;

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [Text(label, style: style), Text(value, style: style)],
    );
  }
}

String _formatNumber(double value) {
  if (value == value.truncateToDouble()) return value.toStringAsFixed(0);
  return value
      .toStringAsFixed(2)
      .replaceFirst(RegExp(r'0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

String _formatSummary(FoodCarbohydrateSummary summary) {
  final amount = _formatNumber(summary.carbohydrateGrams);
  final measure = summary.measureName == '100 g' ? '100g' : summary.measureName;
  return '$amount g CHO / $measure';
}

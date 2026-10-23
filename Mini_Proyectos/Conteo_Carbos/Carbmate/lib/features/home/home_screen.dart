import 'package:flutter/material.dart';

import 'package:carbmate/core/text/search_text.dart';
import 'package:carbmate/features/calculator/calculator_screen.dart';
import 'package:carbmate/features/catalog/catalog_maintenance_screen.dart';
import 'package:carbmate/features/foods/create_food_screen.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key, required this.repository});

  final FoodRepository repository;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _searchController = TextEditingController();
  final _calculatorSession = CalculatorSession();
  List<FoodListItem> _foods = const [];
  String _query = '';
  Object? _loadError;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadFoods();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _loadFoods() async {
    setState(() {
      _isLoading = true;
      _loadError = null;
    });
    try {
      final foods = await widget.repository.loadFoods();
      if (!mounted) return;
      setState(() {
        _foods = foods;
        _isLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _loadError = error;
        _isLoading = false;
      });
    }
  }

  Future<void> _openCreateFood() async {
    await _openFoodEditor();
  }

  Future<void> _openFoodEditor({int? foodId}) async {
    final changed = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) =>
            CreateFoodScreen(repository: widget.repository, foodId: foodId),
      ),
    );
    if (changed == true && mounted) await _loadFoods();
  }

  void _openCalculator() {
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => CalculatorScreen(
          repository: widget.repository,
          session: _calculatorSession,
        ),
      ),
    );
  }

  void _openAbout() {
    Navigator.of(context).pop();
    Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => const _AboutScreen(),
      ),
    );
  }

  Future<void> _openCatalogMaintenance(
    CatalogKind kind,
    String title,
    IconData icon,
  ) async {
    Navigator.of(context).pop();
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => CatalogMaintenanceScreen(
          repository: widget.repository,
          kind: kind,
          title: title,
          icon: icon,
        ),
      ),
    );
    if (mounted) await _loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    final query = normalizeSearchText(_query.trim());
    final visibleFoods = _foods.where((food) {
      if (query.isEmpty) return true;
      final searchableText = [
        food.name,
        food.brandName ?? '',
        ...food.tags,
      ].map(normalizeSearchText).join(' ');
      return searchableText.contains(query);
    }).toList();

    return Scaffold(
      drawer: Drawer(
        child: SafeArea(
          child: ListView(
            padding: EdgeInsets.zero,
            children: [
              ListTile(
                leading: const Icon(Icons.sell_outlined),
                title: const Text('Tags'),
                onTap: () => _openCatalogMaintenance(
                  CatalogKind.tags,
                  'Tags',
                  Icons.sell_outlined,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.storefront_outlined),
                title: const Text('Marcas'),
                onTap: () => _openCatalogMaintenance(
                  CatalogKind.brands,
                  'Marcas',
                  Icons.storefront_outlined,
                ),
              ),
              ListTile(
                leading: const Icon(Icons.scale_outlined),
                title: const Text('Medidas'),
                onTap: () => _openCatalogMaintenance(
                  CatalogKind.measures,
                  'Medidas',
                  Icons.scale_outlined,
                ),
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.info_outline),
                title: const Text('Acerca de'),
                onTap: _openAbout,
              ),
            ],
          ),
        ),
      ),
      appBar: AppBar(
        title: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.restaurant_menu),
            const SizedBox(width: 8),
            const Flexible(child: Text('Catálogo de alimentos')),
          ],
        ),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TextField(
              key: const Key('food-search'),
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Buscar alimentos',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _query.isEmpty
                    ? null
                    : IconButton(
                        tooltip: 'Limpiar búsqueda',
                        onPressed: () {
                          _searchController.clear();
                          setState(() => _query = '');
                        },
                        icon: const Icon(Icons.close),
                      ),
                border: const OutlineInputBorder(),
              ),
              onChanged: (value) => setState(() => _query = value),
            ),
          ),
          Expanded(child: _buildFoodList(visibleFoods)),
        ],
      ),
      floatingActionButton: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          FloatingActionButton(
            heroTag: 'open-calculator',
            tooltip: 'Calculadora',
            onPressed: _openCalculator,
            child: const Icon(Icons.calculate_outlined),
          ),
          const SizedBox(height: 12),
          FloatingActionButton(
            heroTag: 'create-food',
            tooltip: 'Crear alimento',
            onPressed: _openCreateFood,
            child: const Icon(Icons.add),
          ),
        ],
      ),
    );
  }

  Widget _buildFoodList(List<FoodListItem> foods) {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (_loadError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('No se pudieron cargar los alimentos.'),
              const SizedBox(height: 8),
              TextButton(
                onPressed: _loadFoods,
                child: const Text('Reintentar'),
              ),
            ],
          ),
        ),
      );
    }
    if (foods.isEmpty) {
      return Center(
        child: Text(
          _query.trim().isEmpty
              ? 'Todavía no hay alimentos.'
              : 'No se encontraron alimentos.',
        ),
      );
    }

    return ListView.separated(
      key: const Key('food-list'),
      itemCount: foods.length,
      separatorBuilder: (_, _) => const Divider(height: 1),
      itemBuilder: (context, index) {
        final food = foods[index];
        final brand = food.brandName?.trim();
        final unitSummaries = food.carbohydrateSummaries
            .where((summary) => summary.measureName == 'Unidad')
            .toList();
        final carbohydrateSummaries = unitSummaries.isNotEmpty
            ? unitSummaries
            : food.carbohydrateSummaries
                  .where((summary) => summary.measureName == '100 g')
                  .toList();
        final additionalDetails = [
          if (food.tags.isNotEmpty) food.tags.join(', '),
          for (final summary in carbohydrateSummaries)
            _formatCarbohydrateSummary(summary),
        ].join(' · ');
        final hasBrand = brand != null && brand.isNotEmpty;

        return ListTile(
          onTap: () => _openFoodEditor(foodId: food.id),
          trailing: const Icon(Icons.chevron_right),
          title: Text(food.name, style: Theme.of(context).textTheme.titleLarge),
          subtitle: !hasBrand && additionalDetails.isEmpty
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
                      if (hasBrand && additionalDetails.isNotEmpty)
                        const TextSpan(text: ' · '),
                      if (additionalDetails.isNotEmpty)
                        TextSpan(text: additionalDetails),
                    ],
                  ),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 4,
          ),
        );
      },
    );
  }
}

class _AboutScreen extends StatelessWidget {
  const _AboutScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Acerca de')),
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 440),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  Icons.restaurant_menu,
                  size: 56,
                  color: theme.colorScheme.primary,
                ),
                const SizedBox(height: 12),
                Text('Carbmate', style: theme.textTheme.headlineMedium),
                const SizedBox(height: 4),
                Text(
                  'Vialesoft',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: theme.colorScheme.primary,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'Carbmate ayuda a organizar alimentos y consultar su contenido '
                  'de carbohidratos de forma práctica. El catálogo reúne marcas, '
                  'tags y medidas para tener la información a mano.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 12),
                Text(
                  'Su calculadora permite combinar ingredientes y obtener el '
                  'peso y los carbohidratos totales de una preparación.',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.bodyLarge,
                ),
                const SizedBox(height: 32),
                Text(
                  '© ${DateTime.now().year} Vialesoft',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

String _formatCarbohydrateSummary(FoodCarbohydrateSummary summary) {
  final amount =
      summary.carbohydrateGrams == summary.carbohydrateGrams.truncateToDouble()
      ? summary.carbohydrateGrams.toStringAsFixed(0)
      : summary.carbohydrateGrams.toString();
  final measure = summary.measureName == '100 g' ? '100g' : summary.measureName;
  return '${amount}g CHO / $measure';
}

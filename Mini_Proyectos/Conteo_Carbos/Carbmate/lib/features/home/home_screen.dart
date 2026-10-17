import 'package:flutter/material.dart';

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
    final created = await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) => CreateFoodScreen(repository: widget.repository),
      ),
    );
    if (created == true && mounted) await _loadFoods();
  }

  @override
  Widget build(BuildContext context) {
    final query = _query.trim().toLowerCase();
    final visibleFoods = _foods.where((food) {
      if (query.isEmpty) return true;
      final searchableText = [
        food.name,
        food.brandName ?? '',
        ...food.tags,
      ].join(' ').toLowerCase();
      return searchableText.contains(query);
    }).toList();

    return Scaffold(
      appBar: AppBar(title: const Text('Alimentos')),
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
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear alimento',
        onPressed: _openCreateFood,
        child: const Icon(Icons.add),
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
              TextButton(onPressed: _loadFoods, child: const Text('Reintentar')),
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
        final details = [
          food.brandName ?? 'Sin marca',
          food.tags.isEmpty ? 'Sin tags' : food.tags.join(', '),
        ].join(' · ');

        return ListTile(
          title: Text(
            food.name,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(
            details,
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

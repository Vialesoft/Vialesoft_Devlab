import 'package:flutter/material.dart';

import 'package:carbmate/core/text/search_text.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';
import 'package:carbmate/features/recipes/recipe_edit_screen.dart';

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key, required this.repository});

  final FoodRepository repository;

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  final _searchController = TextEditingController();
  late Future<List<RecipeListItem>> _recipesFuture;
  String _query = '';

  @override
  void initState() {
    super.initState();
    _recipesFuture = widget.repository.loadRecipes();
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _openRecipe({int? id}) async {
    await Navigator.of(context).push<bool>(
      MaterialPageRoute<bool>(
        builder: (_) =>
            RecipeEditScreen(repository: widget.repository, recipeId: id),
      ),
    );
    if (!mounted) return;
    final updatedRecipes = widget.repository.loadRecipes();
    setState(() {
      _recipesFuture = updatedRecipes;
    });
    await updatedRecipes;
  }

  Future<void> _cookRecipe(int id) async {
    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (_) => RecipeCookScreen(
          repository: widget.repository,
          recipeId: id,
        ),
      ),
    );
    if (!mounted) return;
    final updatedRecipes = widget.repository.loadRecipes();
    setState(() {
      _recipesFuture = updatedRecipes;
    });
    await updatedRecipes;
  }

  Future<void> _toggleFavorite(RecipeListItem recipe) async {
    try {
      await widget.repository.setRecipeFavorite(recipe.id, !recipe.isFavorite);
      if (!mounted) return;
      setState(() {
        _recipesFuture = widget.repository.loadRecipes();
      });
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No se pudo actualizar el favorito.')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Recetas')),
      body: FutureBuilder<List<RecipeListItem>>(
        future: _recipesFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('No se pudieron cargar las recetas.'),
            );
          }
          final recipes = snapshot.data;
          if (recipes == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final normalizedQuery = normalizeSearchText(_query.trim());
          final visibleRecipes = recipes
              .where(
                (recipe) =>
                    normalizeSearchText(recipe.name).contains(normalizedQuery),
              )
              .toList();

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: TextField(
                  key: const Key('recipe-search'),
                  controller: _searchController,
                  decoration: InputDecoration(
                    labelText: 'Buscar recetas',
                    prefixIcon: const Icon(Icons.search),
                    suffixIcon: _query.isEmpty
                        ? null
                        : IconButton(
                            tooltip: 'Limpiar busqueda',
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
              Expanded(
                child: recipes.isEmpty
                    ? const Center(
                        child: Text('Todavia no hay recetas guardadas.'),
                      )
                    : visibleRecipes.isEmpty
                    ? const Center(child: Text('No se encontraron recetas.'))
                    : ListView.separated(
                        itemCount: visibleRecipes.length,
                        separatorBuilder: (_, _) => const Divider(height: 1),
                        itemBuilder: (context, index) {
                          final recipe = visibleRecipes[index];
                          final carbohydratesPer100g =
                              recipe.carbohydratesPer100g;
                          return ListTile(
                            leading: IconButton(
                              tooltip: recipe.isFavorite
                                  ? 'Quitar de favoritos'
                                  : 'Marcar como favorita',
                              onPressed: () => _toggleFavorite(recipe),
                              icon: Icon(
                                recipe.isFavorite
                                    ? Icons.star
                                    : Icons.star_outline,
                                color: recipe.isFavorite
                                    ? Colors.amber.shade800
                                    : null,
                              ),
                            ),
                            onTap: () => _openRecipe(id: recipe.id),
                            title: Text(recipe.name),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Creada el ${_formatDate(recipe.createdAt)}',
                                ),
                                Text(
                                  carbohydratesPer100g == null
                                      ? recipe.carbohydratesPer100gIsEstimated
                                            ? '— CHO/100 g (est.)'
                                            : '— CHO/100 g'
                                      : '${_formatNumber(carbohydratesPer100g)} g CHO/100 g${recipe.carbohydratesPer100gIsEstimated ? ' (est.)' : ''}',
                                  style: Theme.of(context).textTheme.bodySmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.w600,
                                        color: carbohydratesPer100g == null
                                            ? Theme.of(context)
                                                  .colorScheme
                                                  .onSurfaceVariant
                                            : Theme.of(context)
                                                  .colorScheme
                                                  .primary,
                                      ),
                                ),
                              ],
                            ),
                            trailing: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                IconButton(
                                  tooltip: 'Cocinar receta',
                                  onPressed: () => _cookRecipe(recipe.id),
                                  icon: const Icon(Icons.soup_kitchen_outlined),
                                ),
                                const Icon(Icons.chevron_right),
                              ],
                            ),
                          );
                        },
                      ),
              ),
            ],
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        key: const Key('create-recipe'),
        heroTag: 'create-recipe',
        tooltip: 'Crear receta',
        onPressed: () => _openRecipe(),
        child: const Icon(Icons.add),
      ),
    );
  }
}

String _formatDate(DateTime date) {
  final local = date.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  return '$day/$month/${local.year}';
}

String _formatNumber(double value) {
  final rounded = value.roundToDouble();
  final text = (value - rounded).abs() < 0.000001
      ? rounded.toStringAsFixed(0)
      : value.toStringAsFixed(1);
  return text.replaceAll('.', ',');
}

class CatalogOption {
  const CatalogOption({required this.id, required this.name});

  final int id;
  final String name;
}

enum CatalogKind { tags, brands, measures }

class MaintenanceCatalogEntry {
  const MaintenanceCatalogEntry({
    required this.id,
    required this.name,
    required this.deletable,
    this.note,
  });

  final int id;
  final String name;
  final String? note;
  final bool deletable;
}

class FoodFormOptions {
  const FoodFormOptions({
    required this.brands,
    required this.tags,
    required this.measures,
  });

  final List<CatalogOption> brands;
  final List<CatalogOption> tags;
  final List<CatalogOption> measures;
}

class FoodListItem {
  const FoodListItem({
    required this.id,
    required this.name,
    required this.brandName,
    required this.tags,
    this.carbohydrateSummaries = const [],
    this.isFavorite = false,
    this.isPreparation = false,
    this.isWeightEstimated = false,
  });

  final int id;
  final String name;
  final String? brandName;
  final List<String> tags;
  final List<FoodCarbohydrateSummary> carbohydrateSummaries;
  final bool isFavorite;
  final bool isPreparation;
  final bool isWeightEstimated;
}

class FoodCarbohydrateSummary {
  const FoodCarbohydrateSummary({
    required this.carbohydrateGrams,
    required this.measureName,
  });

  final double carbohydrateGrams;
  final String measureName;
}

class FoodMeasureDraft {
  const FoodMeasureDraft({
    required this.measureId,
    this.productGrams,
    this.carbohydrateGrams,
    this.confidence,
  });

  final int measureId;
  final double? productGrams;
  final double? carbohydrateGrams;
  final String? confidence;
}

class NewFood {
  const NewFood({
    required this.name,
    required this.tagIds,
    required this.measures,
    this.brandId,
    this.note,
    this.isFavorite = false,
    this.isPreparation = false,
    this.isWeightEstimated = false,
  });

  final String name;
  final int? brandId;
  final List<int> tagIds;
  final List<FoodMeasureDraft> measures;
  final String? note;
  final bool isFavorite;
  final bool isPreparation;
  final bool isWeightEstimated;
}

class FoodDetails {
  const FoodDetails({required this.id, required this.food});

  final int id;
  final NewFood food;
}

class RecipeIngredientDraft {
  const RecipeIngredientDraft({
    required this.foodId,
    required this.measureId,
    required this.quantity,
    this.isGrams = false,
    this.note,
  });

  final int foodId;
  final int measureId;
  final double quantity;
  final bool isGrams;
  final String? note;
}

class RecipeIngredientDetails {
  const RecipeIngredientDetails({
    required this.foodId,
    required this.foodName,
    required this.measureId,
    required this.measureName,
    required this.quantity,
    required this.isGrams,
    required this.carbohydratesPerUse,
    required this.gramsPerUse,
    this.note,
  });

  final int foodId;
  final String foodName;
  final int measureId;
  final String measureName;
  final double quantity;
  final bool isGrams;
  final double? carbohydratesPerUse;
  final double? gramsPerUse;
  final String? note;
}

class RecipeDetails {
  const RecipeDetails({
    required this.id,
    required this.name,
    required this.ingredients,
    this.instructions,
    this.note,
    this.cookedWeightGrams,
    this.isFavorite = false,
  });

  final int id;
  final String name;
  final String? instructions;
  final String? note;
  final List<RecipeIngredientDetails> ingredients;
  final double? cookedWeightGrams;
  final bool isFavorite;
}

class RecipeListItem {
  const RecipeListItem({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.totalCarbohydrates,
    required this.estimatedWeightGrams,
    required this.cookedWeightGrams,
    required this.hasUnknownWeight,
    required this.hasUnknownCarbohydrates,
    required this.isFavorite,
  });

  final int id;
  final String name;
  final DateTime createdAt;
  final double? totalCarbohydrates;
  final double? estimatedWeightGrams;
  final double? cookedWeightGrams;
  final bool hasUnknownWeight;
  final bool hasUnknownCarbohydrates;
  final bool isFavorite;

  double? get carbohydratesPer100g {
    final cookedWeight = cookedWeightGrams;
    final weight = cookedWeight ?? estimatedWeightGrams;
    final carbohydrates = totalCarbohydrates;
    if ((cookedWeight == null && hasUnknownWeight) ||
        hasUnknownCarbohydrates ||
        carbohydrates == null ||
        weight == null ||
        weight <= 0) {
      return null;
    }
    return carbohydrates * 100 / weight;
  }

  bool get carbohydratesPer100gIsEstimated => cookedWeightGrams == null;
}

abstract interface class FoodRepository {
  Future<List<MaintenanceCatalogEntry>> loadCatalogEntries(CatalogKind kind);

  Future<void> saveCatalogEntry({
    required CatalogKind kind,
    int? id,
    required String name,
    String? note,
  });

  Future<void> deleteCatalogEntry(CatalogKind kind, int id);

  Future<List<FoodListItem>> loadFoods();

  Future<FoodFormOptions> loadFormOptions();

  Future<FoodDetails?> loadFood(int id);

  Future<void> createFood(NewFood food);

  Future<void> updateFood(int id, NewFood food);

  Future<void> deleteFood(int id);

  Future<void> saveRecipe({
    required String name,
    required List<RecipeIngredientDraft> ingredients,
    String? instructions,
    String? note,
    double? cookedWeightGrams,
  });

  Future<List<RecipeListItem>> loadRecipes();

  Future<RecipeDetails?> loadRecipe(int id);

  Future<void> updateRecipe({
    required int id,
    required String name,
    required List<RecipeIngredientDraft> ingredients,
    String? instructions,
    String? note,
    double? cookedWeightGrams,
  });

  Future<void> setRecipeFavorite(int id, bool isFavorite);
}

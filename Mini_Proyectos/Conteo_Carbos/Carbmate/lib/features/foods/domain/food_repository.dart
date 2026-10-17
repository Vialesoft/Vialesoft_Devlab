class CatalogOption {
  const CatalogOption({required this.id, required this.name});

  final int id;
  final String name;
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
  });

  final int id;
  final String name;
  final String? brandName;
  final List<String> tags;
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
  });

  final String name;
  final int? brandId;
  final List<int> tagIds;
  final List<FoodMeasureDraft> measures;
}

abstract interface class FoodRepository {
  Future<List<FoodListItem>> loadFoods();

  Future<FoodFormOptions> loadFormOptions();

  Future<void> createFood(NewFood food);
}

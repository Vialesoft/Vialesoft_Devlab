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
  });

  final int id;
  final String name;
  final String? brandName;
  final List<String> tags;
  final List<FoodCarbohydrateSummary> carbohydrateSummaries;
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
  });

  final String name;
  final int? brandId;
  final List<int> tagIds;
  final List<FoodMeasureDraft> measures;
}

class FoodDetails {
  const FoodDetails({required this.id, required this.food});

  final int id;
  final NewFood food;
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
}

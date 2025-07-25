// food_product.dart

class FoodProduct {
  final String name;
  final double calories;
  final double protein;
  final double fat;
  final double carbs;

  FoodProduct({
    required this.name,
    required this.calories,
    required this.protein,
    required this.fat,
    required this.carbs,
  });

  factory FoodProduct.fromFDCJson(Map<String, dynamic> json) {
    final String name = json['description'] ?? 'Unknown';

    double calories = 0.0;
    double protein = 0.0;
    double fat = 0.0;
    double carbs = 0.0;

    if (json['foodNutrients'] != null) {
      for (final nutrient in json['foodNutrients']) {
        final String nutrientName = nutrient['nutrientName'] ?? '';
        final unit = nutrient['unitName'] ?? '';

        final value = nutrient['value'];
        double parsedValue = (value is num) ? value.toDouble() : 0.0;

        if (nutrientName.toLowerCase() == 'energy' && unit == 'KCAL') {
          calories = parsedValue;
        } else if (nutrientName.toLowerCase() == 'protein') {
          protein = parsedValue;
        } else if (nutrientName.toLowerCase() == 'total lipid (fat)') {
          fat = parsedValue;
        } else if (nutrientName.toLowerCase() == 'carbohydrate, by difference') {
          carbs = parsedValue;
        }
      }
    }

    if (calories <= 0) {
      throw FormatException("Invalid or missing calories for $name");
    }

    return FoodProduct(
      name: name,
      calories: calories,
      protein: protein,
      fat: fat,
      carbs: carbs,
    );
  }

  FoodProduct copyWith({
    double? calories,
    double? protein,
    double? fat,
    double? carbs,
  }) {
    return FoodProduct(
      name: name,
      calories: calories ?? this.calories,
      protein: protein ?? this.protein,
      fat: fat ?? this.fat,
      carbs: carbs ?? this.carbs,
    );
  }


  Map<String, dynamic> toJson() => {
    'name': name,
    'calories': calories,
    'protein': protein,
    'fat': fat,
    'carbs': carbs,
  };
}
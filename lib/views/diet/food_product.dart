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

  factory FoodProduct.fromJson(Map<String, dynamic> json) {
    final nutriments = json['nutriments'] ?? {};

    double parseToDouble(dynamic value) {
      if (value is double) return value;
      if (value is int) return value.toDouble();
      if (value is String) return double.tryParse(value) ?? 0.0;
      return 0.0;
    }

    final name = json['product_name'] ?? '';

    final lowerName = name.toLowerCase();

    if (name.isEmpty ||
        lowerName.contains("wicked") ||
        lowerName.contains("soygurt") ||
        lowerName.contains("ready meal") ||
        lowerName.contains("steak") ||
        name.contains(',') ||
        name.contains(';') ||
        name.length > 40) {
      throw FormatException("Unwanted product: $name");
    }

    final calories = parseToDouble(nutriments['energy-kcal']);
    if (calories <= 0) {
      throw FormatException("Invalid calorie value for product: $name");
    }

    return FoodProduct(
      name: name,
      calories: calories,
      protein: parseToDouble(nutriments['proteins']),
      fat: parseToDouble(nutriments['fat']),
      carbs: parseToDouble(nutriments['carbohydrates']),
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
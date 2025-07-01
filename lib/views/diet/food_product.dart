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

    return FoodProduct(
      name: json['product_name'] ?? 'Unnamed',
      calories: parseToDouble(nutriments['energy-kcal']),
      protein: parseToDouble(nutriments['proteins']),
      fat: parseToDouble(nutriments['fat']),
      carbs: parseToDouble(nutriments['carbohydrates']),
    );
  }
}

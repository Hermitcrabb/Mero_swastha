import 'meal_item.dart';
class MealCategory {
  final List<MealItem> breakfast;
  final List<MealItem> lunch;
  final List<MealItem> dinner;
  final List<MealItem> snacks;

  MealCategory({
    required this.breakfast,
    required this.lunch,
    required this.dinner,
    required this.snacks,
  });

  factory MealCategory.fromJson(Map<String, dynamic> json) {
    List<MealItem> parseMealList(List<dynamic> items) {
      return items.map((item) {
        try {
          return MealItem.fromJson(item);
        } catch (e) {
          print("Error parsing item: $item — $e");
          return MealItem(
            name: "Invalid",
            calories: 0,
            protein: 0,
            fat: 0,
            carbs: 0,
          );
        }
      }).toList();
    }

    return MealCategory(
      breakfast: parseMealList(json['breakfast'] ?? []),
      lunch: parseMealList(json['lunch'] ?? []),
      dinner: parseMealList(json['dinner'] ?? []),
      snacks: parseMealList(json['snacks'] ?? []),
    );
  }

}

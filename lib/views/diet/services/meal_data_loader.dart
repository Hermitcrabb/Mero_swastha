import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../products/meal_catagory.dart';

class MealDataLoader {
  static MealCategory? _cachedLocalMealData;

  static Future<MealCategory> loadLocalMealData() async {
    if (_cachedLocalMealData != null) {
      return _cachedLocalMealData!;
    }

    final String jsonString = await rootBundle.loadString('assets/Nepali_foods.json');
    final Map<String, dynamic> jsonMap = json.decode(jsonString);
    _cachedLocalMealData = MealCategory.fromJson(jsonMap);
    return _cachedLocalMealData!;
  }
}

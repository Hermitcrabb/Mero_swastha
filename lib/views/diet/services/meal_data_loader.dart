import 'dart:convert';
import 'package:flutter/services.dart' show rootBundle;
import '../products/meal_catagory.dart';

Future<MealCategory> loadLocalMealData() async {
  final String jsonString = await rootBundle.loadString('assets/Nepali_foods.json');
  final Map<String, dynamic> jsonMap = json.decode(jsonString);
  return MealCategory.fromJson(jsonMap);
}

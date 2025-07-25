// food_product_service.dart

import 'dart:convert';
import 'package:http/http.dart' as http;
import '../products/food_product.dart';
import 'meal_data_loader.dart';
import 'package:string_similarity/string_similarity.dart';
import '../products/meal_item.dart';

class FoodProductService {
  static const String _fdcApiKey = '314HCg7nkuOaz7Z16EeWB46AgMliP4LLBArWBagT';

  static Future<Map<String, List<FoodProduct>>> searchFoodByName(String query) async {
    List<FoodProduct> localResults = [];
    List<FoodProduct> apiResults = [];

    // --- Local Search ---
    try {
      final localMeals = await MealDataLoader.loadLocalMealData();
      final allMeals = [
        ...localMeals.breakfast,
        ...localMeals.lunch,
        ...localMeals.dinner,
        ...localMeals.snacks,
      ];

      final localScored = allMeals.map((meal) {
        final score = StringSimilarity.compareTwoStrings(
          query.toLowerCase(),
          meal.name.toLowerCase(),
        );
        return {'meal': meal, 'score': score};
      }).toList();

      var filteredLocal = localScored
          .where((entry) => (entry['score'] as double) > 0.3)
          .toList();
      filteredLocal.sort((a, b) =>
          (b['score'] as double).compareTo(a['score'] as double));

      localResults = filteredLocal.map((entry) {
        final meal = entry['meal'] as MealItem;
        return FoodProduct(
          name: meal.name,
          calories: meal.calories,
          protein: meal.protein,
          fat: meal.fat,
          carbs: meal.carbs,
        );
      }).toList();
    } catch (e) {
      print("Local search error: $e");
    }

    // --- USDA API Search ---
    try {
      final response = await http.get(Uri.parse(
          'https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&pageSize=10&api_key=$_fdcApiKey'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foods = data['foods'] as List<dynamic>;

        final products = foods.map((json) {
          try {
            return FoodProduct.fromFDCJson(json);
          } catch (_) {
            return null;
          }
        }).whereType<FoodProduct>().toList();

        final scoredResults = products.map((food) {
          final similarity = StringSimilarity.compareTwoStrings(
            query.toLowerCase(),
            food.name.toLowerCase(),
          );
          return {'food': food, 'score': similarity};
        }).toList();

        final filteredApi = scoredResults
            .where((entry) => ((entry['score'] as num?) ?? 0) > 0.3)
            .toList();
        filteredApi.sort((a, b) =>
            ((b['score'] as num?) ?? 0).compareTo((a['score'] as num?) ?? 0));

        apiResults = filteredApi.map((e) => e['food'] as FoodProduct).toList();
      } else {
        print('USDA API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('USDA API fetch error: $e');
    }

    return {
      'local': localResults,
      'api': apiResults,
    };
  }

  static Future<List<FoodProduct>> fetchProductsFromUSDA(List<String> staples, String dietType) async {
    List<FoodProduct> allProducts = [];

    for (String staple in staples) {
      try {
        final response = await http.get(Uri.parse(
            'https://api.nal.usda.gov/fdc/v1/foods/search?query=$staple&pageSize=10&api_key=$_fdcApiKey'));

        if (response.statusCode == 200) {
          final data = jsonDecode(response.body);
          final foods = data['foods'] as List<dynamic>;

          final products = foods.map((json) {
            try {
              return FoodProduct.fromFDCJson(json);
            } catch (_) {
              return null;
            }
          }).whereType<FoodProduct>().toList();

          allProducts.addAll(products);
        } else {
          print('USDA API Error for $staple: ${response.statusCode}');
        }
      } catch (e) {
        print('Error fetching $staple from USDA: $e');
      }
    }

    return allProducts;
  }

  static List<FoodProduct> selectProductsForMeal(List<FoodProduct> products, double targetCalories) {
    List<FoodProduct> meal = [];
    double currentCalories = 0;

    for (var product in products) {
      if (currentCalories + product.calories <= targetCalories) {
        meal.add(product);
        currentCalories += product.calories;
      }
      if (currentCalories >= targetCalories) break;
    }

    return meal;
  }
  static Future<List<FoodProduct>> searchLocalFoods(String query) async {
    final localMeals = await MealDataLoader.loadLocalMealData();

    final allMeals = [
      ...localMeals.breakfast,
      ...localMeals.lunch,
      ...localMeals.dinner,
      ...localMeals.snacks,
    ];

    final scored = allMeals.map((meal) {
      final score = StringSimilarity.compareTwoStrings(
        query.toLowerCase(),
        meal.name.toLowerCase(),
      );
      return {'meal': meal, 'score': score};
    }).toList();

    final filtered = scored.where((entry) => (entry['score'] as double) > 0.3).toList();

    filtered.sort((a, b) => (b['score'] as double).compareTo(a['score'] as double));

    return filtered.map((entry) {
      final meal = entry['meal'] as MealItem;
      return FoodProduct(
        name: meal.name,
        calories: meal.calories.toDouble(),
        protein: meal.protein.toDouble(),
        fat: meal.fat.toDouble(),
        carbs: meal.carbs.toDouble(),
      );
    }).toList();
  }
  static Future<List<FoodProduct>> searchAPIFoods(String query) async {
    List<FoodProduct> apiResults = [];

    try {
      final response = await http.get(Uri.parse(
          'https://api.nal.usda.gov/fdc/v1/foods/search?query=$query&pageSize=10&api_key=$_fdcApiKey'
      ));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foods = data['foods'] as List<dynamic>;

        final products = foods.map((json) {
          try {
            return FoodProduct.fromFDCJson(json);
          } catch (_) {
            return null;
          }
        }).whereType<FoodProduct>().toList();

        final scoredResults = products.map((food) {
          final similarity = StringSimilarity.compareTwoStrings(
            query.toLowerCase(),
            food.name.toLowerCase(),
          );
          return {'food': food, 'score': similarity};
        }).toList();

        final filteredApi = scoredResults
            .where((entry) => ((entry['score'] as num?) ?? 0) > 0.3)
            .toList();

        filteredApi.sort((a, b) =>
            ((b['score'] as num?) ?? 0).compareTo((a['score'] as num?) ?? 0));

        apiResults = filteredApi.map((e) => e['food'] as FoodProduct).toList();
      } else {
        print('USDA API Error: ${response.statusCode}');
      }
    } catch (e) {
      print('USDA API fetch error: $e');
    }

    return apiResults;
  }
}

// Add this to food_product.dart
extension FoodProductFDCParser on FoodProduct {
  static FoodProduct fromFDCJson(Map<String, dynamic> json) {
    final nutrients = json['foodNutrients'] as List<dynamic>;

    double getNutrientValue(String name) {
      try {
        final nutrient = nutrients.firstWhere(
              (n) => (n['nutrientName'] as String).toLowerCase() == name.toLowerCase(),
          orElse: () => null,
        );
        return (nutrient != null) ? (nutrient['value'] as num).toDouble() : 0.0;
      } catch (_) {
        return 0.0;
      }
    }

    return FoodProduct(
      name: json['description'] ?? '',
      calories: getNutrientValue('Energy'),
      protein: getNutrientValue('Protein'),
      fat: getNutrientValue('Total lipid (fat)'),
      carbs: getNutrientValue('Carbohydrate, by difference'),
    );
  }
}

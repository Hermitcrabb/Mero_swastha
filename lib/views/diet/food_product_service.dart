import 'dart:convert';
import 'package:http/http.dart' as http;
import 'food_product.dart';

class FoodProductService {
  static Future<List<FoodProduct>> fetchProductsByStapleAndDiet(
      List<String> stapleFoods,
      String dietType,
      ) async {
    List<FoodProduct> allProducts = [];

    for (String food in stapleFoods) {
      try {
        String labelFilter = '';
        if (dietType.toLowerCase() == 'vegetarian') {
          labelFilter = '&labels_tags=vegetarian';
        } else if (dietType.toLowerCase() == 'vegan') {
          labelFilter = '&labels_tags=vegan';
        }

        String query = 'search_terms=$food$labelFilter&json=true&page_size=10';
        final url = Uri.parse('https://world.openfoodfacts.org/cgi/search.pl?$query&lc=en');

        print("Fetching: $url"); // ✅ Add logging

        final response = await http.get(url);
        if (response.statusCode == 200) {
          final jsonData = jsonDecode(response.body);
          final productsJson = jsonData['products'] as List<dynamic>;

          final products = productsJson.map((p) {
            try {
              return FoodProduct.fromJson(p);
            } catch (_) {
              return null; // skip invalid/unwanted products gracefully
            }
          }).whereType<FoodProduct>().toList();

          allProducts.addAll(products);

        } else {
          print("API Error for $food: ${response.statusCode}");
        }
      } catch (e) {
        print("Error fetching $food: $e");
      }
    }

    return allProducts;
  }


  static List<FoodProduct> selectProductsForMeal(
      List<FoodProduct> products,
      double targetCalories,
      ) {
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
  static Future<List<FoodProduct>> searchFoodByName(String query) async {
    final response = await http.get(Uri.parse(
        'https://world.openfoodfacts.org/cgi/search.pl?search_terms=$query&search_simple=1&action=process&json=true&page_size=10'));

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final products = (data['products'] as List)
          .map((json) {
        try {
          return FoodProduct.fromJson(json);
        } catch (_) {
          return null;
        }
      })
          .whereType<FoodProduct>()
          .toList();
      return products;
    } else {
      throw Exception('Failed to search for food');
    }
  }
}

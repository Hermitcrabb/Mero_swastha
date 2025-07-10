import 'package:flutter/material.dart';
import 'products/food_product.dart';
import 'services/food_product_service.dart';
class EditMealDialog extends StatefulWidget {
  final String mealName;
  final List<FoodProduct> currentFoods;

  const EditMealDialog({required this.mealName, required this.currentFoods});

  @override
  State<EditMealDialog> createState() => _EditMealDialogState();
}

class _EditMealDialogState extends State<EditMealDialog> {
  String searchQuery = '';
  List<FoodProduct> searchResults = [];

  void _searchFood() async {
    final results = await FoodProductService.searchFoodByName(searchQuery);
    setState(() {
      searchResults = results;
    });
  }

  @override
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery
              .of(context)
              .viewInsets
              .bottom + 20,
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "Edit ${widget.mealName}",
                style: const TextStyle(
                    fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              const Text("Current Foods:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...widget.currentFoods.map((food) =>
                  ListTile(title: Text(food.name))),
              const Divider(),
              TextField(
                decoration: const InputDecoration(
                    labelText: "Search food to replace"),
                onChanged: (val) => searchQuery = val,
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                  onPressed: _searchFood, child: const Text("Search")),
              const SizedBox(height: 10),
              const Text("Search Results:",
                  style: TextStyle(fontWeight: FontWeight.bold)),
              ...searchResults.map((food) =>
                  ListTile(
                    title: Text(food.name),
                    subtitle: Text("${food.calories} kcal"),
                    onTap: () => Navigator.pop(context, food),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
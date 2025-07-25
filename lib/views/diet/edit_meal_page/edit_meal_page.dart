import 'package:flutter/material.dart';
import '../products/food_product.dart';
import '../services/food_product_service.dart';

class EditMealPage extends StatefulWidget {
  final String mealName;
  final List<FoodProduct> currentFoods;

  const EditMealPage({required this.mealName, required this.currentFoods});

  @override
  State<EditMealPage> createState() => _EditMealPageState();
}

class _EditMealPageState extends State<EditMealPage> {
  List<FoodProduct> editedFoods = [];
  FoodProduct? selectedFoodToReplace;
  bool isAddingNewFood = false;

  String searchQuery = '';
  bool isSearching = false;

  Map<String, List<FoodProduct>> searchResults = {'local': [], 'api': []};

  @override
  void initState() {
    super.initState();
    editedFoods = List.from(widget.currentFoods);
  }

  void _searchFood() async {
    if (searchQuery
        .trim()
        .isEmpty) return;

    final localResults = await FoodProductService.searchLocalFoods(searchQuery);
    List<FoodProduct> apiResults = [];

    if (localResults.isEmpty) {
      apiResults = await FoodProductService.searchAPIFoods(searchQuery);
    }

    setState(() {
      searchResults = {
        'local': localResults,
        'api': apiResults,
      };
    });
  }


  void _replaceFood(FoodProduct newFood) {
    final index = editedFoods.indexOf(selectedFoodToReplace!);
    if (index != -1) {
      setState(() {
        editedFoods[index] = newFood;
        selectedFoodToReplace = null;
        isAddingNewFood = false;
        searchResults = {'local': [], 'api': []};
        searchQuery = '';
      });
    }
  }

  void _addFood(FoodProduct newFood) {
    setState(() {
      editedFoods.add(newFood);
      isAddingNewFood = false;
      searchResults = {'local': [], 'api': []};
      searchQuery = '';
    });
  }

  void _deleteFood(FoodProduct food) {
    setState(() {
      editedFoods.remove(food);
    });
  }

  void _showQuantityDialog(FoodProduct food) {
    final TextEditingController quantityController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) =>
          AlertDialog(
            title: Text('Adjust Quantity for ${food.name}'),
            content: TextField(
              controller: quantityController,
              keyboardType: TextInputType.number,
              decoration: const InputDecoration(
                labelText: 'Enter weight in grams',
                hintText: 'e.g., 150',
              ),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Cancel'),
              ),
              ElevatedButton(
                onPressed: () {
                  final grams = double.tryParse(quantityController.text);
                  if (grams != null && grams > 0) {
                    _updateFoodQuantity(food, grams);
                    Navigator.pop(context);
                  }
                },
                child: const Text('Update'),
              ),
            ],
          ),
    );
  }

  void _updateFoodQuantity(FoodProduct food, double grams) {
    final factor = grams / 100.0;

    final updatedFood = food.copyWith(
      calories: food.calories * factor,
      protein: food.protein * factor,
      fat: food.fat * factor,
      carbs: food.carbs * factor,
    );

    setState(() {
      final index = editedFoods.indexOf(food);
      if (index != -1) {
        editedFoods[index] = updatedFood;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit ${widget.mealName}'),
        actions: [
          IconButton(
            icon: const Icon(Icons.check),
            onPressed: () {
              Navigator.pop(context, editedFoods);
            },
          ),
        ],
      ),
      floatingActionButton: isAddingNewFood || selectedFoodToReplace != null
          ? null
          : FloatingActionButton(
        onPressed: () {
          setState(() {
            isAddingNewFood = true;
          });
        },
        child: const Icon(Icons.add),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: (selectedFoodToReplace != null || isAddingNewFood)
            ? _buildFoodSearch()
            : _buildCurrentFoods(),
      ),
    );
  }

  Widget _buildCurrentFoods() {
    return ListView(
      children: [
        const Text('Current Foods:',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        if (editedFoods.isEmpty)
          const Text('No foods in this meal. Add new foods using ➕ button.'),
        ...editedFoods.map((food) =>
            ListTile(
              title: Text(food.name),
              subtitle: Text(
                  '${food.calories.toStringAsFixed(0)} kcal | ${food.protein
                      .toStringAsFixed(1)}g protein | ${food.fat
                      .toStringAsFixed(1)}g fat | ${food.carbs.toStringAsFixed(
                      1)}g carbs'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.scale),
                    onPressed: () {
                      _showQuantityDialog(food);
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.swap_horiz),
                    onPressed: () {
                      setState(() {
                        selectedFoodToReplace = food;
                      });
                    },
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => _deleteFood(food),
                  ),
                ],
              ),
            )),
      ],
    );
  }

  Widget _buildFoodSearch() {
    final contextTitle = selectedFoodToReplace != null
        ? 'Replace "${selectedFoodToReplace!.name}"'
        : 'Add New Food';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(contextTitle,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
        const SizedBox(height: 10),
        TextField(
          decoration: const InputDecoration(
              labelText: 'Search food', border: OutlineInputBorder()),
          onChanged: (val) => searchQuery = val,
        ),
        const SizedBox(height: 10),
        ElevatedButton(onPressed: _searchFood, child: const Text('Search')),
        const SizedBox(height: 20),

        // Wrap this entire results section in Expanded with ListView
        Expanded(
          child: ListView(
            children: [
              if (searchResults['local']!.isNotEmpty) ...[
                const Text('🔍 Local Foods:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...searchResults['local']!.map((food) => _buildFoodResultTile(food)),
                const Divider(),
              ],
              if (searchResults['api']!.isNotEmpty) ...[
                const Text('🌐 API Results:',
                    style: TextStyle(fontWeight: FontWeight.bold)),
                ...searchResults['api']!.map((food) => _buildFoodResultTile(food)),
              ],
              if (searchResults['local']!.isEmpty && searchResults['api']!.isEmpty)
                const Text('No results found.'),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildFoodResultTile(FoodProduct food) {
    return ListTile(
      title: Text(food.name),
      subtitle: Text('${food.calories.toStringAsFixed(0)} kcal'),
      onTap: () {
        if (selectedFoodToReplace != null) {
          _replaceFood(food);
        } else if (isAddingNewFood) {
          _addFood(food);
        }
      },
    );
  }
}

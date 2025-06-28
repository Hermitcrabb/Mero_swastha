import 'package:flutter/material.dart';

// MODEL CLASSES
class DietItem {
  final String name;
  final double price;
  final double calories;
  final double protein;

  DietItem(this.name, this.price, this.calories, this.protein);
}

class DietPlan {
  final String title;
  final String costRange;
  final List<DietItem> items;

  DietPlan(this.title, this.costRange, this.items);
}

// MAIN UI
class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    // All Diet Plans
    final List<DietPlan> plans = [
      DietPlan("Low Cost Plan", "₹500 - ₹800/day", [
        DietItem("Dal Bhat", 450, 450, 12),
        DietItem("Aloo Tama", 300, 300, 10),
        DietItem("Momo", 250, 250, 8),
        DietItem("Chutney", 50, 50, 2),
      ]),
      DietPlan("Medium Cost Plan", "₹800 - ₹1500/day", [
        DietItem("Sel Roti", 350, 350, 7),
        DietItem("Chicken Curry", 550, 550, 30),
        DietItem("Chana Masala", 200, 200, 12),
        DietItem("Aloo Gobi", 150, 150, 5),
      ]),
      DietPlan("High Cost Plan", "₹1500 - ₹2500/day", [
        DietItem("Thakali Set", 1200, 1200, 40),
        DietItem("Mutton Curry", 700, 700, 40),
        DietItem("Dal Bhat with Ghee", 500, 500, 15),
        DietItem("Chicken Tikka", 500, 500, 35),
      ]),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nepali Diet Plan'),
        backgroundColor: Colors.deepPurple,
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05, vertical: 16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Personalized Nepali Diet Plans',
              style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
            const SizedBox(height: 20),
            ...plans.map((plan) => _buildDietSection(context, plan, screenWidth)).toList(),
          ],
        ),
      ),
    );
  }

  Widget _buildDietSection(BuildContext context, DietPlan plan, double screenWidth) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(plan.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.deepPurple)),
        Text('Estimated Cost: ${plan.costRange}', style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey)),
        const SizedBox(height: 10),
        Wrap(
          spacing: 10.0,
          runSpacing: 10.0,
          children: plan.items.map((item) => SizedBox(
            width: screenWidth > 600 ? screenWidth * 0.45 : double.infinity,
            child: _buildDietItem(item),
          )).toList(),
        ),
        const SizedBox(height: 10),
        Center(
          child: ElevatedButton(
            onPressed: () => _showDietPlanDialog(context, plan),
            child: const Text('View Full Diet Plan'),
          ),
        ),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildDietItem(DietItem item) {
    return Card(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      shadowColor: Colors.deepPurple.shade100,
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Icon(Icons.fastfood, color: Colors.deepPurple),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.name, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                  Text('Calories: ${item.calories} kcal', style: const TextStyle(color: Colors.grey)),
                  Text('Protein: ${item.protein}g', style: const TextStyle(color: Colors.grey)),
                ],
              ),
            ),
            Text('₹${item.price}', style: const TextStyle(fontWeight: FontWeight.bold, color: Colors.deepPurple)),
          ],
        ),
      ),
    );
  }

  void _showDietPlanDialog(BuildContext context, DietPlan plan) {
    showDialog(
      context: context,
      builder: (_) => AlertDialog(
        title: Text("Full ${plan.title}"),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: plan.items.map((e) => Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Text('${e.name} - ${e.calories} kcal'),
          )).toList(),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text("Close"),
          )
        ],
      ),
    );
  }
}

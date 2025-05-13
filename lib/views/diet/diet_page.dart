import 'package:flutter/material.dart';

class DietPage extends StatelessWidget {
  const DietPage({super.key});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

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
              'Nepali Diet Plan Based on Your Budget',
              style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Colors.deepPurple),
            ),
            const SizedBox(height: 20),
            // Low Cost Section
            _buildDietSection(
              context,
              'Low Cost Plan',
              '₹500 - ₹800/day',
              [
                _buildDietItem('Dal Bhat (Lentil Soup with Rice)', 450, 12, 2.5),
                _buildDietItem('Aloo Tama (Potato and Bamboo Shoot Curry)', 300, 10, 3),
                _buildDietItem('Momo (Vegetarian Dumplings)', 250, 8, 5),
                _buildDietItem('Chutney (Tamarind and Spice)', 50, 2, 0),
              ],
            ),
            const SizedBox(height: 20),
            // Medium Cost Section
            _buildDietSection(
              context,
              'Medium Cost Plan',
              '₹800 - ₹1500/day',
              [
                _buildDietItem('Sel Roti (Nepali Rice Doughnut)', 350, 7, 10),
                _buildDietItem('Chicken Curry', 550, 30, 15),
                _buildDietItem('Chana Masala (Chickpea Curry)', 200, 12, 8),
                _buildDietItem('Aloo Gobi (Potato and Cauliflower Curry)', 150, 5, 7),
              ],
            ),
            const SizedBox(height: 20),
            // High Cost Section
            _buildDietSection(
              context,
              'High Cost Plan',
              '₹1500 - ₹2500/day',
              [
                _buildDietItem('Thakali Set', 1200, 40, 20),
                _buildDietItem('Mutton Curry', 700, 40, 25),
                _buildDietItem('Dal Bhat with Ghee and Pickles', 500, 15, 10),
                _buildDietItem('Chicken Tikka', 500, 35, 22),
              ],
            ),
          ],
        ),
      ),
    );
  }

  // ✅ Updated section layout using Wrap instead of GridView
  Widget _buildDietSection(BuildContext context, String title, String cost, List<Widget> meals) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: Colors.deepPurple),
          ),
          const SizedBox(height: 10),
          Text(
            'Estimated Cost: $cost',
            style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.grey),
          ),
          const SizedBox(height: 10),
          Wrap(
            spacing: 10.0,
            runSpacing: 10.0,
            children: meals.map((meal) => SizedBox(
              width: screenWidth > 600 ? (screenWidth * 0.45) : double.infinity,
              child: meal,
            )).toList(),
          ),
          const SizedBox(height: 10),
          Center(
            child: ElevatedButton(
              onPressed: () => _showDietPlanDialog(context, title),
              child: const Text('View Full Diet Plan'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.deepPurple,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                textStyle: const TextStyle(fontSize: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(30),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDietItem(String name, double price, double calories, double protein) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: Colors.white,
      shadowColor: Colors.deepPurple.shade200,
      child: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Row(
                children: [
                  Icon(
                    Icons.food_bank,
                    color: Colors.deepPurple.shade400,
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          name,
                          style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                              color: Colors.deepPurple),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                          softWrap: true,
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Calories: ${calories.toStringAsFixed(0)} kcal',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                        Text(
                          'Protein: ${protein.toStringAsFixed(1)}g',
                          style: const TextStyle(fontSize: 14, color: Colors.grey),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '₹${price.toStringAsFixed(0)}',
              style: const TextStyle(
                  fontSize: 16, fontWeight: FontWeight.bold, color: Colors.deepPurple),
            ),
          ],
        ),
      ),
    );
  }

  void _showDietPlanDialog(BuildContext context, String title) {
    final List<Map<String, dynamic>> mealList = [
      {'name': 'Dal Bhat', 'calories': 450},
      {'name': 'Aloo Tama', 'calories': 300},
      {'name': 'Momo', 'calories': 250},
      {'name': 'Chutney', 'calories': 50},
    ];

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Full $title'),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Here is a detailed meal plan for $title:'),
                const SizedBox(height: 10),
                ...mealList.map((meal) => Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4.0),
                  child: Text('${meal['name']} - ${meal['calories']} kcal'),
                )),
                const SizedBox(height: 10),
                const Text('More meal options based on the budget will be added soon!'),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('Close'),
            ),
          ],
        );
      },
    );
  }
}

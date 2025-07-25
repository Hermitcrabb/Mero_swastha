import 'package:flutter/material.dart';
import '../calorie_log_service.dart';
import '../../products/food_product.dart';

class MarkAsEatenButton extends StatefulWidget {
  final String mealName;
  final List<FoodProduct> foods;

  const MarkAsEatenButton({
    Key? key,
    required this.mealName,
    required this.foods,
  }) : super(key: key);

  @override
  _MarkAsEatenButtonState createState() => _MarkAsEatenButtonState();
}

class _MarkAsEatenButtonState extends State<MarkAsEatenButton> {
  bool _isLoading = false;

  Future<void> _markAsEaten() async {
    setState(() => _isLoading = true);
    try {
      await CalorieLogService.logMealForToday(widget.mealName, widget.foods);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('${widget.mealName} logged successfully!')),
      );
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to log meal: $e')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      icon: _isLoading
          ? SizedBox(
        width: 16,
        height: 16,
        child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
      )
          : Icon(Icons.check),
      label: Text(_isLoading ? 'Logging...' : 'Mark as Eaten'),
      onPressed: _isLoading ? null : _markAsEaten,
    );
  }
}

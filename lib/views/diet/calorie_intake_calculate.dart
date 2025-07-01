class CalorieIntakeCalculator {
  // Calculate calorie target based on TDEE and fitness goal
  static double calculateCalorieTarget(double tdee, String goal) {
    switch (goal.toLowerCase()) {
      case 'lose weight':
        return tdee - 500;
      case 'gain muscle':
        return tdee + 500;
      case 'maintain weight':
      default:
        return tdee;
    }
  }

  // Calculate macronutrients (protein, fat, carbs) in grams based on calorie target and goal
  static Map<String, double> calculateMacros(double calorieTarget, String goal) {
    double proteinPercent;
    double fatPercent;
    double carbsPercent;

    switch (goal.toLowerCase()) {
      case 'lose weight':
        proteinPercent = 0.40;
        fatPercent = 0.30;
        carbsPercent = 0.30;
        break;
      case 'gain muscle':
        proteinPercent = 0.30;
        fatPercent = 0.25;
        carbsPercent = 0.45;
        break;
      case 'maintain weight':
      default:
        proteinPercent = 0.30;
        fatPercent = 0.30;
        carbsPercent = 0.40;
        break;
    }

    double proteinCalories = calorieTarget * proteinPercent;
    double fatCalories = calorieTarget * fatPercent;
    double carbsCalories = calorieTarget * carbsPercent;

    return {
      'protein_g': proteinCalories / 4, // 4 kcal per gram protein
      'fat_g': fatCalories / 9,          // 9 kcal per gram fat
      'carbs_g': carbsCalories / 4,      // 4 kcal per gram carbs
    };
  }
}

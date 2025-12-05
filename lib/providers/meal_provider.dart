import 'package:flutter/material.dart';
import '../models/meal.dart';
import '../data/meal_repository.dart';

class MealProvider extends ChangeNotifier {
  List<Meal> meals = MealRepository.getAllMeals();

  void addMeal(Meal meal) {
    MealRepository.addMeal(meal);
    meals = MealRepository.getAllMeals();
    notifyListeners();
  }

  void clearMeals() {
    MealRepository.clearAll();
    meals = MealRepository.getAllMeals();
    notifyListeners();
  }
}

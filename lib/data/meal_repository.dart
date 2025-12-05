import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/meal.dart';

class MealRepository {
  static const String _storageKey = "meals_data";
  static List<Meal> _meals = [];

  /// 🔥 load saved meals when app starts
  static Future<void> loadMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_storageKey);

    if (stored != null) {
      final List decoded = jsonDecode(stored);
      _meals = decoded.map((e) => Meal.fromMap(e)).toList();
    }
  }

  /// 🔥 Save all meals → storage
  static Future<void> saveMeals() async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(_meals.map((m) => m.toMap()).toList());
    await prefs.setString(_storageKey, json);
  }

  /// 📌 return meals
  static List<Meal> getAll() => List.unmodifiable(_meals);

  /// ➕ add new meal
  static Future<void> add(Meal meal) async {
    _meals.add(meal);
    await saveMeals();
  }

  /// 🗑 delete all meals
  static Future<void> clear() async {
    _meals.clear();
    await saveMeals();
  }

  // أسماء بديلة لو الأكواد تستدعيهم
  static List<Meal> getAllMeals() => getAll();
  static Future<void> addMeal(Meal meal) async => add(meal);
  static Future<void> clearAll() async => clear();
}

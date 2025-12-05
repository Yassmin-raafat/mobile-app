enum MealType { nourishing, flexible }

class Meal {
  final String id;
  final String description;
  final DateTime date;
  final MealType type;
  final String? emotion;

  Meal({
    required this.id,
    required this.description,
    required this.date,
    required this.type,
    this.emotion,
  });

  // Convert Object → Map to save into SharedPreferences
  Map<String, dynamic> toMap() {
    return {
      "id": id,
      "description": description,
      "date": date.toIso8601String(),
      "type": type.index,
      "emotion": emotion,
    };
  }

  // Convert Saved Map → Meal Object
  factory Meal.fromMap(Map<String, dynamic> map) {
    return Meal(
      id: map["id"],
      description: map["description"],
      date: DateTime.parse(map["date"]),
      type: MealType.values[map["type"]],
      emotion: map["emotion"],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/meal.dart';
import '../providers/meal_provider.dart';
import '../services/notification_service.dart';

class TrackerScreen extends StatefulWidget {
  const TrackerScreen({super.key});

  @override
  State<TrackerScreen> createState() => _TrackerScreenState();
}

class _TrackerScreenState extends State<TrackerScreen> {
  final TextEditingController desc = TextEditingController();
  final TextEditingController emo = TextEditingController();

  MealType? type = MealType.nourishing; // Default type

  void save() {
    if (desc.text.isEmpty || type == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Please enter meal description & type"),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          backgroundColor: const Color(0xFFFF6B35),
        ),
      );
      return;
    }

    final meal = Meal(
      id: DateTime.now().toString(),
      description: desc.text,
      date: DateTime.now(),
      type: type!,
      emotion: emo.text.isEmpty ? null : emo.text,
    );

    Provider.of<MealProvider>(context, listen: false).addMeal(meal);

    /// 🔥 Notification pops up when user adds a meal
    NotificationService.show(
      title: "Meal Logged 🍽",
      body: "You added a ${type == MealType.nourishing ? "Healthy 🌿" : "Flexible 🎉"} meal!",
    );

    desc.clear();
    emo.clear();
    type = MealType.nourishing;
    setState(() {});

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Row(
          children: [
            Icon(Icons.check_circle_rounded, color: Colors.white),
            SizedBox(width: 8),
            Text("Meal added successfully ✔"),
          ],
        ),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: const Color(0xFF4ECDC4),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<MealProvider>(context).meals;

    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFFFFF8F5),
              Color(0xFFF8F9FA),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Modern App Bar
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFFF6B35),
                      Color(0xFFFF8C61),
                    ],
                  ),
                ),
                child: Row(
                  children: [
                    const Text(
                      "Log Meal",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(
                        Icons.restaurant_menu_rounded,
                        color: Colors.white,
                        size: 24,
                      ),
                    ),
                  ],
                ),
              ),

              // Form Section
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Meal Type Selection Cards
                      Text(
                        "Meal Type (80/20 Rule)",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: _buildMealTypeCard(
                              MealType.nourishing,
                              "Nourishing",
                              "80% Healthy",
                              const Color(0xFF4ECDC4),
                              Icons.eco_rounded,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildMealTypeCard(
                              MealType.flexible,
                              "Flexible",
                              "20% Enjoyment",
                              const Color(0xFFFF6B35),
                              Icons.cake_rounded,
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 24),

                      // Meal Description
                      Text(
                        "Meal Description",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: desc,
                          maxLines: 3,
                          decoration: InputDecoration(
                            hintText: "What did you eat?",
                            prefixIcon: const Icon(Icons.edit_rounded, color: Color(0xFFFF6B35)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 20),

                      // Emotion Field
                      Text(
                        "How did you feel? (Optional)",
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 12),
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.05),
                              blurRadius: 10,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: emo,
                          decoration: InputDecoration(
                            hintText: "E.g., Energized, Satisfied, Happy...",
                            prefixIcon: const Icon(Icons.sentiment_satisfied_rounded, color: Color(0xFFFF6B35)),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.all(20),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Save Button
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: save,
                          style: ElevatedButton.styleFrom(
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            elevation: 0,
                          ),
                          child: const Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(Icons.add_circle_rounded, size: 24),
                              SizedBox(width: 8),
                              Text(
                                "Add Meal",
                                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      // Meals List Header
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(8),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFFF6B35), Color(0xFFFF8C61)],
                              ),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.history_rounded,
                              color: Colors.white,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text(
                            "Your Meals",
                            style: Theme.of(context).textTheme.titleLarge,
                          ),
                          const Spacer(),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFF6B35).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Text(
                              "${meals.length}",
                              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                color: const Color(0xFFFF6B35),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 16),

                      // Meals List
                      if (meals.isEmpty)
                        Container(
                          padding: const EdgeInsets.all(40),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withOpacity(0.05),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Column(
                            children: [
                              Icon(
                                Icons.restaurant_menu_rounded,
                                size: 64,
                                color: Colors.grey.shade300,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                "No meals added yet",
                                style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        ...meals.map((m) => _buildMealCard(m)).toList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMealTypeCard(
    MealType mealType,
    String title,
    String subtitle,
    Color color,
    IconData icon,
  ) {
    final isSelected = type == mealType;
    return GestureDetector(
      onTap: () => setState(() => type = mealType),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected ? color : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : Colors.grey.shade300,
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: color.withOpacity(0.3),
                    blurRadius: 15,
                    offset: const Offset(0, 5),
                  ),
                ]
              : [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                    offset: const Offset(0, 2),
                  ),
                ],
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Colors.white : color,
              size: 32,
            ),
            const SizedBox(height: 8),
            Text(
              title,
              style: TextStyle(
                color: isSelected ? Colors.white : const Color(0xFF1A1A1A),
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              subtitle,
              style: TextStyle(
                color: isSelected ? Colors.white.withOpacity(0.9) : Colors.grey.shade600,
                fontSize: 12,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMealCard(Meal meal) {
    final isNourishing = meal.type == MealType.nourishing;
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: isNourishing
                  ? [const Color(0xFF4ECDC4), const Color(0xFF6EDDD6)]
                  : [const Color(0xFFFF6B35), const Color(0xFFFF8C61)],
            ),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            isNourishing ? Icons.eco_rounded : Icons.cake_rounded,
            color: Colors.white,
            size: 24,
          ),
        ),
        title: Text(
          meal.description,
          style: Theme.of(context).textTheme.bodyLarge?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              "${meal.date.toLocal().toString().substring(0, 16)}",
              style: Theme.of(context).textTheme.bodySmall,
            ),
            if (meal.emotion != null) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFE66D).withOpacity(0.2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.sentiment_satisfied_rounded, size: 14, color: Color(0xFFFF6B35)),
                    const SizedBox(width: 4),
                    Text(
                      meal.emotion!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: const Color(0xFFFF6B35),
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
            color: (isNourishing ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B35))
                .withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(
            isNourishing ? "80%" : "20%",
            style: TextStyle(
              color: isNourishing ? const Color(0xFF4ECDC4) : const Color(0xFFFF6B35),
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ),
    );
  }
}

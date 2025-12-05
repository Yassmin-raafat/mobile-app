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
        const SnackBar(content: Text("Please enter meal description & type")),
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
      const SnackBar(content: Text("Meal added successfully ✔")),
    );
  }

  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<MealProvider>(context).meals;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Log Meal"),
        backgroundColor: Colors.orangeAccent,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            TextField(
              controller: desc,
              decoration: InputDecoration(
                labelText: "Meal Description",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 12),

            DropdownButtonFormField<MealType>(
              value: type,
              decoration: InputDecoration(
                labelText: "Meal Type (80/20 Rule)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              items: const [
                DropdownMenuItem(
                  value: MealType.nourishing,
                  child: Text("Nourishing (80% Healthy)"),
                ),
                DropdownMenuItem(
                  value: MealType.flexible,
                  child: Text("Flexible (20% Enjoyment)"),
                ),
              ],
              onChanged: (v) => setState(() => type = v),
            ),

            const SizedBox(height: 12),

            TextField(
              controller: emo,
              decoration: InputDecoration(
                labelText: "How did you feel after eating? (Optional)",
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
            ),

            const SizedBox(height: 15),

            Center(
              child: ElevatedButton(
                onPressed: save,
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orangeAccent,
                  padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text("Add Meal", style: TextStyle(fontSize: 16)),
              ),
            ),

            const SizedBox(height: 18),
            const Text("Your Meals", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),

            const SizedBox(height: 8),

            Expanded(
              child: meals.isEmpty
                  ? const Center(child: Text("No meals added yet ❗"))
                  : ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (context, i) {
                        final m = meals[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Icon(
                              m.type == MealType.nourishing ? Icons.eco : Icons.cake,
                              color: m.type == MealType.nourishing ? Colors.green : Colors.pinkAccent,
                              size: 28,
                            ),
                            title: Text(m.description),
                            subtitle: Text(
                              "${m.date.toLocal().toString().substring(0,16)}"
                              "${m.emotion != null ? "\nFeeling: ${m.emotion}" : ""}",
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}

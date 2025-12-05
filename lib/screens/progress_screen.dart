import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../models/meal.dart';

class ProgressScreen extends StatelessWidget {
  const ProgressScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<MealProvider>(context).meals;

    int total = meals.length;
    int healthy = meals.where((m) => m.type == MealType.nourishing).length;
    int flexible = meals.where((m) => m.type == MealType.flexible).length;

    double percentage = total == 0 ? 0 : (healthy / total) * 100;

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        title: const Text("Progress Summary"),
        backgroundColor: Colors.orangeAccent,
      ),

      body: total == 0
          ? const Center(
              child: Text(
                "No recorded meals yet!\nStart logging to see progress 📈",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 18),
              ))
          : Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [
                  
                  // 🔥 Circle Progress
                  SizedBox(
                    width: 200,
                    height: 200,
                    child: Stack(
                      alignment: Alignment.center,
                      children: [
                        CircularProgressIndicator(
                          value: healthy / total,
                          color: Colors.green,
                          backgroundColor: Colors.redAccent.withOpacity(.4),
                          strokeWidth: 12,
                        ),
                        Text(
                          "${percentage.toStringAsFixed(1)}%",
                          style: const TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 25),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      statBox("Healthy", healthy, Colors.green),
                      statBox("Flexible", flexible, Colors.pinkAccent),
                      statBox("Total", total, Colors.blueAccent),
                    ],
                  ),

                  const SizedBox(height: 25),

                  const Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Meal History",
                      style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Expanded(
                    child: ListView.builder(
                      itemCount: meals.length,
                      itemBuilder: (ctx, i) {
                        final m = meals[i];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          child: ListTile(
                            leading: Icon(
                              m.type == MealType.nourishing ? Icons.eco : Icons.cake_rounded,
                              color: m.type == MealType.nourishing ? Colors.green : Colors.pinkAccent,
                            ),
                            title: Text(m.description),
                            subtitle: Text(
                              "${m.date.toLocal().toString().substring(0,16)}"
                            ),
                          ),
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
    );
  }

  Widget statBox(String label, int value, Color color) {
    return Container(
      padding: const EdgeInsets.all(12),
      width: 100,
      decoration: BoxDecoration(
        color: color.withOpacity(.15),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color,width: 2),
      ),
      child: Column(
        children: [
          Text("$value",
              style: TextStyle(fontSize: 22,fontWeight: FontWeight.bold,color: color)),
          Text(label,style: const TextStyle(fontSize: 13)),
        ],
      ),
    );
  }
}

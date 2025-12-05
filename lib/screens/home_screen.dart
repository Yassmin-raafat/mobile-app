import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

import '../data/meal_repository.dart';
import '../models/meal.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  // 🔥 API text
  String advice = "Loading daily wellness tip...";

  @override
  void initState() {
    super.initState();
    fetchAdvice(); // get API data when screen opens
  }

  // ---------------- API FUNCTION ----------------
  Future<void> fetchAdvice() async {
    try {
      final url = Uri.parse("https://api.adviceslip.com/advice");
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        setState(() => advice = data["slip"]["advice"]);
      } else {
        setState(() => advice = "Could not load advice.");
      }
    } catch(e){
      setState(() => advice = "Network Error — Try again");
    }
  }
  // ----------------------------------------------------

  bool _isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  @override
  Widget build(BuildContext context) {
    final meals = MealRepository.getAll();

    final now = DateTime.now();
    final todayMeals = meals.where((m) => _isSameDay(m.date, now)).toList();

    final weekAgo = now.subtract(const Duration(days: 7));
    final weekMeals = meals.where((m) => m.date.isAfter(weekAgo)).toList();

    final totalWeek = weekMeals.length;
    final nourishingWeek = weekMeals.where((m) => m.type == MealType.nourishing).length;
    final flexibleWeek = weekMeals.where((m) => m.type == MealType.flexible).length;

    final nourishingPercent = totalWeek == 0 ? 0 : (nourishingWeek / totalWeek * 100).round();
    final flexiblePercent = totalWeek == 0 ? 0 : (flexibleWeek / totalWeek * 100).round();

    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(
        backgroundColor: Colors.orangeAccent,
        title: const Text('Bite Bright'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchAdvice,
          ),
        ],
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            // 🔥 API MOTIVATION CARD
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              child: Padding(
                padding: const EdgeInsets.all(18),
                child: Column(
                  children: [
                    const Icon(Icons.lightbulb, color: Colors.orangeAccent, size: 45),
                    const SizedBox(height: 10),
                    Text(
                      advice,
                      textAlign: TextAlign.center,
                      style: const TextStyle(fontSize: 17, fontStyle: FontStyle.italic),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: fetchAdvice,
                      child: const Text("Get Another Tip 🔄"),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text('Welcome back 👋', style: Theme.of(context).textTheme.titleLarge),
            Text('Let’s keep your 80/20 balance on track today.', style: Theme.of(context).textTheme.bodyLarge),

            const SizedBox(height: 20),

            // TODAY CARD
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: ListTile(
                leading: const Icon(Icons.today, size: 45, color: Colors.orange),
                title: Text('Today’s Meals'),
                subtitle: Text('${todayMeals.length} meal(s) logged today'),
              ),
            ),

            const SizedBox(height: 18),

            // WEEKLY CARD + 80/20
            Card(
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 3,
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text("This Week's Balance", style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold)),
                    const SizedBox(height: 8),
                    Text(
                      totalWeek == 0
                          ? "No meals this week yet."
                          : "Nourishing $nourishingPercent%  |  Flexible $flexiblePercent%",
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                    const SizedBox(height: 14),
                    if(totalWeek > 0)
                      Row(
                        children: [
                          _bar(nourishingPercent, Colors.green, "Nourishing"),
                          const SizedBox(width: 15),
                          _bar(flexiblePercent, Colors.redAccent, "Flexible"),
                        ],
                      ),
                  ],
                ),
              ),
            ),

          ],
        ),
      ),
    );
  }


  Widget _bar(int percent, Color color, String label) {
    return Expanded(
      child: Column(
        children: [
          Text("$percent%", style: TextStyle(color: color,fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          Container(
            height: percent.toDouble() * 1.2,
            decoration: BoxDecoration(color: color,borderRadius: BorderRadius.circular(8)),
          ),
          const SizedBox(height: 5),
          Text(label),
        ],
      ),
    );
  }
}

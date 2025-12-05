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

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;

  //  API text
  String advice = "Loading daily wellness tip...";

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
    _animationController.forward();
    fetchAdvice(); // get API data when screen opens
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
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
    } catch (e) {
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
          child: FadeTransition(
            opacity: _fadeAnimation,
            child: CustomScrollView(
              slivers: [
                // Modern App Bar
                SliverAppBar(
                  expandedHeight: 120,
                  floating: false,
                  pinned: true,
                  elevation: 0,
                  backgroundColor: Colors.transparent,
                  flexibleSpace: FlexibleSpaceBar(
                    title: const Text(
                      'Bite Bright',
                      style: TextStyle(
                        color: Color(0xFF1A1A1A),
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    centerTitle: true,
                    background: Container(
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
                    ),
                  ),
                  actions: [
                    IconButton(
                      icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                      onPressed: fetchAdvice,
                    ),
                  ],
                ),

                // Content
                SliverPadding(
                  padding: const EdgeInsets.all(20),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      // Welcome Section
                      _buildWelcomeSection(context, todayMeals.length),
                      const SizedBox(height: 24),

                      //  API MOTIVATION CARD
                      _buildAdviceCard(context),
                      const SizedBox(height: 24),

                      // Today's Meals Card
                      _buildTodayCard(context, todayMeals.length),
                      const SizedBox(height: 24),

                      // Weekly Balance Card
                      _buildWeeklyBalanceCard(
                        context,
                        totalWeek,
                        nourishingPercent,
                        flexiblePercent,
                        nourishingWeek,
                        flexibleWeek,
                      ),
                    ]),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildWelcomeSection(BuildContext context, int todayCount) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Welcome back ',
          style: Theme.of(context).textTheme.displayMedium?.copyWith(
                color: const Color(0xFF1A1A1A),
              ),
        ),
        const SizedBox(height: 8),
        Text(
          "Let's keep your 80/20 balance on track today.", // fixed apostrophe
          style: Theme.of(context).textTheme.bodyLarge,
        ),
      ],
    );
  }

  Widget _buildAdviceCard(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFFFFE66D),
            Color(0xFFFFD93D),
          ],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFE66D).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white.withOpacity(0.3),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.lightbulb_rounded,
                color: Color(0xFF1A1A1A),
                size: 40,
              ),
            ),
            const SizedBox(height: 16),
            Text(
              advice,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0xFF1A1A1A),
                  ),
            ),
            const SizedBox(height: 16),
            TextButton.icon(
              onPressed: fetchAdvice,
              icon: const Icon(Icons.refresh_rounded, size: 18),
              label: const Text("Get Another Tip"),
              style: TextButton.styleFrom(
                foregroundColor: const Color(0xFF1A1A1A),
                backgroundColor: Colors.white.withOpacity(0.5),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTodayCard(BuildContext context, int count) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C61)],
                ),
                borderRadius: BorderRadius.circular(16),
              ),
              child: const Icon(
                Icons.today_rounded,
                color: Colors.white,
                size: 32,
              ),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Today's Meals", // fixed apostrophe
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '$count meal${count != 1 ? 's' : ''} logged today',
                    style: Theme.of(context).textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFFF6B35).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                '$count',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: const Color(0xFFFF6B35),
                      fontWeight: FontWeight.bold,
                    ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyBalanceCard(
    BuildContext context,
    int totalWeek,
    int nourishingPercent,
    int flexiblePercent,
    int nourishingWeek,
    int flexibleWeek,
  ) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 20,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF4ECDC4), Color(0xFF6EDDD6)],
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.insights_rounded,
                    color: Colors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  "This Week's Balance",
                  style: Theme.of(context).textTheme.titleLarge,
                ),
              ],
            ),
            const SizedBox(height: 24),
            if (totalWeek == 0)
              Center(
                child: Text(
                  "No meals this week yet.",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              )
            else ...[
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _buildBalanceItem(
                    context,
                    "Nourishing",
                    nourishingPercent,
                    nourishingWeek,
                    const Color(0xFF4ECDC4),
                    Icons.eco_rounded,
                  ),
                  _buildBalanceItem(
                    context,
                    "Flexible",
                    flexiblePercent,
                    flexibleWeek,
                    const Color(0xFFFF6B35),
                    Icons.cake_rounded,
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _buildProgressBar(
                      nourishingPercent / 100,
                      const Color(0xFF4ECDC4),
                      "Nourishing $nourishingPercent%",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _buildProgressBar(
                      flexiblePercent / 100,
                      const Color(0xFFFF6B35),
                      "Flexible $flexiblePercent%",
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildBalanceItem(
    BuildContext context,
    String label,
    int percent,
    int count,
    Color color,
    IconData icon,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.3)),
        ),
        child: Column(
          children: [
            Icon(icon, color: color, size: 32),
            const SizedBox(height: 8),
            Text(
              "$percent%",
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w500,
                  ),
            ),
            const SizedBox(height: 4),
            Text(
              "$count meals",
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar(double progress, Color color, String label) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: color,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: LinearProgressIndicator(
            value: progress,
            backgroundColor: color.withOpacity(0.2),
            valueColor: AlwaysStoppedAnimation<Color>(color),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

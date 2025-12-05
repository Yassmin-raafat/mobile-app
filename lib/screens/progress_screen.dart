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
          child: total == 0
              ? _buildEmptyState(context)
              : CustomScrollView(
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
                          'Progress Summary',
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
                    ),

                    // Content
                    SliverPadding(
                      padding: const EdgeInsets.all(20),
                      sliver: SliverList(
                        delegate: SliverChildListDelegate([
                          // Main Progress Circle
                          _buildProgressCircle(context, percentage, healthy, total),

                          const SizedBox(height: 32),

                          // Stats Cards
                          Row(
                            children: [
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  "Healthy",
                                  healthy,
                                  const Color(0xFF4ECDC4),
                                  Icons.eco_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  "Flexible",
                                  flexible,
                                  const Color(0xFFFF6B35),
                                  Icons.cake_rounded,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: _buildStatCard(
                                  context,
                                  "Total",
                                  total,
                                  const Color(0xFFFFE66D),
                                  Icons.restaurant_menu_rounded,
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 32),

                          // Progress Breakdown
                          _buildProgressBreakdown(context, healthy, flexible, total),

                          const SizedBox(height: 32),

                          // Meal History Header
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
                                "Meal History",
                                style: Theme.of(context).textTheme.titleLarge,
                              ),
                            ],
                          ),

                          const SizedBox(height: 16),

                          // Meal History List
                          ...meals.map((m) => _buildMealHistoryCard(context, m)).toList(),
                        ]),
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(32),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFFFF6B35), Color(0xFFFF8C61)],
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.insights_rounded,
                size: 64,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 32),
            Text(
              "No recorded meals yet!",
              style: Theme.of(context).textTheme.displaySmall,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              "Start logging your meals to see\nyour progress and insights 📈",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Colors.grey.shade600,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressCircle(BuildContext context, double percentage, int healthy, int total) {
    return Container(
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 30,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            width: 200,
            height: 200,
            child: CircularProgressIndicator(
              value: healthy / total,
              strokeWidth: 16,
              backgroundColor: const Color(0xFFFF6B35).withOpacity(0.2),
              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF4ECDC4)),
            ),
          ),
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                "${percentage.toStringAsFixed(1)}%",
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  color: const Color(0xFF4ECDC4),
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "Nourishing",
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
    BuildContext context,
    String label,
    int value,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            color,
            color.withOpacity(0.8),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.3),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: Colors.white, size: 28),
          const SizedBox(height: 12),
          Text(
            "$value",
            style: Theme.of(context).textTheme.displayMedium?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Colors.white.withOpacity(0.9),
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressBreakdown(
    BuildContext context,
    int healthy,
    int flexible,
    int total,
  ) {
    final healthyPercent = total == 0 ? 0.0 : (healthy / total);
    final flexiblePercent = total == 0 ? 0.0 : (flexible / total);

    return Container(
      padding: const EdgeInsets.all(24),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF4ECDC4), Color(0xFF6EDDD6)],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.pie_chart_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                "80/20 Balance",
                style: Theme.of(context).textTheme.titleLarge,
              ),
            ],
          ),
          const SizedBox(height: 24),
          _buildProgressRow(
            context,
            "Nourishing (80%)",
            healthyPercent,
            healthy,
            const Color(0xFF4ECDC4),
            Icons.eco_rounded,
          ),
          const SizedBox(height: 16),
          _buildProgressRow(
            context,
            "Flexible (20%)",
            flexiblePercent,
            flexible,
            const Color(0xFFFF6B35),
            Icons.cake_rounded,
          ),
        ],
      ),
    );
  }

  Widget _buildProgressRow(
    BuildContext context,
    String label,
    double progress,
    int count,
    Color color,
    IconData icon,
  ) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  Text(
                    "${(progress * 100).toStringAsFixed(1)}%",
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: color,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withOpacity(0.2),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 10,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                "$count meals",
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMealHistoryCard(BuildContext context, Meal meal) {
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
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: Text(
            "${meal.date.toLocal().toString().substring(0, 16)}",
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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

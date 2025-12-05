import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/meal_provider.dart';
import '../models/meal.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final meals = Provider.of<MealProvider>(context).meals;
    final totalMeals = meals.length;
    final healthyMeals = meals.where((m) => m.type == MealType.nourishing).length;
    final flexibleMeals = meals.where((m) => m.type == MealType.flexible).length;

    // Calculate streak: consecutive days with at least one meal
    final now = DateTime.now();
    int streak = 0;
    for (int i = 0;; i++) {
      final date = now.subtract(Duration(days: i));
      bool hasMeal = meals.any((m) =>
          m.date.year == date.year &&
          m.date.month == date.month &&
          m.date.day == date.day);
      if (hasMeal) {
        streak++;
      } else {
        break;
      }
    }

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
                    'Profile',
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
                    _buildProfileHeader(context),
                    const SizedBox(height: 24),
                    _buildStatsOverview(context, totalMeals, healthyMeals, flexibleMeals, streak),
                    const SizedBox(height: 24),
                    _buildAchievementsSection(context, totalMeals, streak),
                    const SizedBox(height: 24),
                    _buildSettingsSection(context),
                  ]),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileHeader(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFFFF6B35), Color(0xFFFF8C61)],
        ),
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFF6B35).withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(color: Colors.white, shape: BoxShape.circle),
            child: Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: const LinearGradient(colors: [Color(0xFFFFE66D), Color(0xFFFFD93D)]),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.person_rounded, size: 48, color: Colors.white),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            "Bite Bright User",
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 4),
          Text(
            "Tracking your 80/20 journey",
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withOpacity(0.9),
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsOverview(BuildContext context, int total, int healthy, int flexible, int streak) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4ECDC4), Color(0xFF6EDDD6)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.analytics_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text("Your Stats", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(child: _buildStatItem(context, "Total Meals", "$total", Icons.restaurant_menu_rounded, const Color(0xFFFF6B35))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatItem(context, "Healthy", "$healthy", Icons.eco_rounded, const Color(0xFF4ECDC4))),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Expanded(child: _buildStatItem(context, "Flexible", "$flexible", Icons.cake_rounded, const Color(0xFFFF6B35))),
              const SizedBox(width: 12),
              Expanded(child: _buildStatItem(context, "Day Streak", "$streak", Icons.local_fire_department_rounded, const Color(0xFFFFE66D))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatItem(BuildContext context, String label, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          const SizedBox(height: 8),
          Text(value, style: Theme.of(context).textTheme.titleLarge?.copyWith(color: color, fontWeight: FontWeight.bold)),
          const SizedBox(height: 4),
          Text(label, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600), textAlign: TextAlign.center),
        ],
      ),
    );
  }

  Widget _buildAchievementsSection(BuildContext context, int totalMeals, int streak) {
    final achievements = <Map<String, dynamic>>[];

    if (totalMeals >= 10) achievements.add({"title": "First 10 Meals", "icon": Icons.star_rounded, "color": const Color(0xFFFFE66D), "unlocked": true});
    if (totalMeals >= 50) achievements.add({"title": "50 Meals Logged", "icon": Icons.emoji_events_rounded, "color": const Color(0xFFFF6B35), "unlocked": true});
    if (streak >= 7) achievements.add({"title": "7 Day Streak", "icon": Icons.local_fire_department_rounded, "color": const Color(0xFFFF6B35), "unlocked": true});
    if (achievements.isEmpty) achievements.add({"title": "Keep logging meals!", "icon": Icons.lock_rounded, "color": Colors.grey, "unlocked": false});

    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFFFFE66D), Color(0xFFFFD93D)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.emoji_events_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text("Achievements", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 20),
          Wrap(
            spacing: 12,
            runSpacing: 12,
            children: achievements.map((achievement) {
              return Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: achievement["unlocked"] ? achievement["color"].withOpacity(0.1) : Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(color: achievement["unlocked"] ? achievement["color"].withOpacity(0.3) : Colors.grey.shade300),
                ),
                child: Column(
                  children: [
                    Icon(achievement["icon"], color: achievement["unlocked"] ? achievement["color"] : Colors.grey, size: 32),
                    const SizedBox(height: 8),
                    Text(achievement["title"], style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: achievement["unlocked"] ? const Color(0xFF1A1A1A) : Colors.grey,
                    ), textAlign: TextAlign.center),
                  ],
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingsSection(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 20, offset: const Offset(0, 5))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(colors: [Color(0xFF4ECDC4), Color(0xFF6EDDD6)]),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.settings_rounded, color: Colors.white, size: 20),
              ),
              const SizedBox(width: 12),
              Text("Settings", style: Theme.of(context).textTheme.titleLarge),
            ],
          ),
          const SizedBox(height: 20),
          _buildSettingItem(context, Icons.notifications_rounded, "Notifications", "Manage meal reminders", const Color(0xFFFF6B35), () {}),
          const SizedBox(height: 12),
          _buildSettingItem(context, Icons.palette_rounded, "Appearance", "Customize theme", const Color(0xFF4ECDC4), () {}),
          const SizedBox(height: 12),
          _buildSettingItem(context, Icons.info_rounded, "About", "App version and info", const Color(0xFFFFE66D), () {}),
        ],
      ),
    );
  }

  Widget _buildSettingItem(BuildContext context, IconData icon, String title, String subtitle, Color color, VoidCallback onTap) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withOpacity(0.2)),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(color: color.withOpacity(0.1), borderRadius: BorderRadius.circular(12)),
              child: Icon(icon, color: color, size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(title, style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w600)),
                  const SizedBox(height: 2),
                  Text(subtitle, style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey.shade600)),
                ],
              ),
            ),
            Icon(Icons.chevron_right_rounded, color: Colors.grey.shade400),
          ],
        ),
      ),
    );
  }
}

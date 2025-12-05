import 'package:flutter/material.dart';

// استيراد الصفحات
import 'screens/home_screen.dart';
import 'screens/tracker_screen.dart';
import 'screens/progress_screen.dart';
import 'screens/profile_screen.dart';

// Provider
import 'package:provider/provider.dart';
import 'providers/meal_provider.dart';

// Repository for loading saved meals
import 'data/meal_repository.dart';
import 'services/notification_service.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();       // مهم قبل أي async
  await MealRepository.loadMeals();  
   await NotificationService.init();                // تحميل البيانات من التخزين
  runApp(const BiteBrightApp());
}

class BiteBrightApp extends StatelessWidget {
  const BiteBrightApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => MealProvider(), // Phase 2 core logic
      child: MaterialApp(
        title: 'Bite Bright',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.orange),
          textTheme: const TextTheme(
            bodyLarge: TextStyle(fontSize: 16, color: Colors.black87),
            titleLarge: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          ),
        ),
        home: const MainNavigation(),
        debugShowCheckedModeBanner: false,
      ),
    );
  }
}

class MainNavigation extends StatefulWidget {
  const MainNavigation({super.key});

  @override
  State<MainNavigation> createState() => _MainNavigationState();
}

class _MainNavigationState extends State<MainNavigation> {
  int _index = 0;

  final List<Widget> pages = const [
    HomeScreen(),
    TrackerScreen(),
    ProgressScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[_index],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _index,
        onTap: (i) => setState(() => _index = i),
        selectedItemColor: Colors.orangeAccent,
        unselectedItemColor: Colors.grey,
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(icon: Icon(Icons.restaurant), label: "Log Meal"),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: "Progress"),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}

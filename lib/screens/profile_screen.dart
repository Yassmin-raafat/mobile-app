import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.orange[50],
      appBar: AppBar(title: const Text("Profile"), backgroundColor: Colors.orangeAccent),
      body: const Center(
        child: Text("Profile Page Coming Soon...", style: TextStyle(fontSize: 18)),
      ),
    );
  }
}

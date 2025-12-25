import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'auth/authenticate.dart';
import 'main.dart'; // Assuming MainNavigation is in main.dart

class Wrapper extends StatelessWidget {
  const Wrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User?>(context);

    // return either Home or Authenticate widget
    if (user == null) {
      return const Authenticate();
    } else {
      return const MainNavigation();
    }
  }
}


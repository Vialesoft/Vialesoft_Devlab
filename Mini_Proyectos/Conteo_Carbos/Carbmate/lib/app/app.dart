import 'package:flutter/material.dart';

import 'package:carbmate/features/home/home_screen.dart';

class CarbmateApp extends StatelessWidget {
  const CarbmateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'App Conteo Carbos',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: const HomeScreen(),
    );
  }
}

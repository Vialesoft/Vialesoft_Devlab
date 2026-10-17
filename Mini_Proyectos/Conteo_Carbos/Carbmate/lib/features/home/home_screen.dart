import 'package:flutter/material.dart';

import 'package:carbmate/features/foods/create_food_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: const Center(child: Text('App Conteo Carbos')),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Crear alimento',
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute<void>(
              builder: (_) => const CreateFoodScreen(),
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
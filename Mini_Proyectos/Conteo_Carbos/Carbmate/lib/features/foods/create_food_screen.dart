import 'package:flutter/material.dart';

class CreateFoodScreen extends StatelessWidget {
  const CreateFoodScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Crear alimento')),
      body: const SizedBox.expand(),
    );
  }
}
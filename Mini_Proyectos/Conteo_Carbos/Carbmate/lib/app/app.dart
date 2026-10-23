import 'package:flutter/material.dart';

import 'package:carbmate/core/persistence/app_database.dart';
import 'package:carbmate/features/foods/data/sqlite_food_repository.dart';
import 'package:carbmate/features/foods/domain/food_repository.dart';
import 'package:carbmate/features/home/home_screen.dart';

class CarbmateApp extends StatefulWidget {
  const CarbmateApp({super.key, this.repository});

  final FoodRepository? repository;

  @override
  State<CarbmateApp> createState() => _CarbmateAppState();
}

class _CarbmateAppState extends State<CarbmateApp> {
  late Future<FoodRepository> _repositoryFuture;

  @override
  void initState() {
    super.initState();
    _repositoryFuture = _loadRepository();
  }

  Future<FoodRepository> _loadRepository() async {
    final injectedRepository = widget.repository;
    if (injectedRepository != null) return injectedRepository;

    final database = await AppDatabase.open();
    return SqliteFoodRepository(database.connection);
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Carbmate',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),
      ),
      home: FutureBuilder<FoodRepository>(
        future: _repositoryFuture,
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const Text('No se pudo abrir la base de datos.'),
                      const SizedBox(height: 12),
                      TextButton(
                        onPressed: () {
                          setState(() => _repositoryFuture = _loadRepository());
                        },
                        child: const Text('Reintentar'),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }

          final repository = snapshot.data;
          if (repository == null) {
            return const _StartupScreen();
          }

          return HomeScreen(repository: repository);
        },
      ),
    );
  }
}

class _StartupScreen extends StatelessWidget {
  const _StartupScreen();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: const Color(0xFFE7F8F2),
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              'assets/images/carbmate_mascot.png',
              width: 220,
              height: 280,
              fit: BoxFit.contain,
            ),
            const SizedBox(height: 12),
            Text(
              'Carbmate',
              style: theme.textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 28),
            SizedBox(
              width: 24,
              height: 24,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: theme.colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

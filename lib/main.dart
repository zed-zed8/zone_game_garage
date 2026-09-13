import 'package:flutter/material.dart';
import 'package:zone_game_garage/repositories/games/blank_fill_repository.dart';
import 'package:zone_game_garage/screens/dashboard_screen.dart';
import 'package:zone_game_garage/services/databases/app_database.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await AppDatabase.instance.database;
  await BlankFillRepository.gameExistenceCheck();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ZoneGG',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blue,
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.blueAccent,
          brightness: Brightness.dark, // Crucial for dark mode configuration
        ),
      ),
      themeMode: ThemeMode.system,

      home: DashboardScreen(),
    );
  }
}

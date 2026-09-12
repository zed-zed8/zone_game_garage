import 'package:flutter/material.dart';
import 'package:zone_game_garage/screens/dashboard_screen.dart';
import 'package:zone_game_garage/screens/auth/login_screen.dart';

class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Home'),
          FilledButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) => DashboardScreen(screen: LoginScreen()),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: Text('Login'),
          ),
        ],
      ),
    );
  }
}

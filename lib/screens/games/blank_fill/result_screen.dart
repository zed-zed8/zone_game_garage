import 'package:flutter/material.dart';

import 'package:zone_game_garage/screens/dashboard_screen.dart';

class ResultScreen extends StatelessWidget {
  /// 'win' or 'lose'
  final String gameResult;

  ResultScreen({super.key, required this.gameResult});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: FilledButton(
        onPressed: () {
          // navigate to dashboard
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute<void>(builder: (context) => DashboardScreen()),
            (Route<dynamic> route) => false,
          );
        },
        child: Text('Go Home, You $gameResult'),
      ),
    );
  }
}

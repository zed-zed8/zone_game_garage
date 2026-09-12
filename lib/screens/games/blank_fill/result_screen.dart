import 'package:flutter/material.dart';

import 'package:zone_game_garage/screens/dashboard_screen.dart';

class ResultScreen extends StatelessWidget {
  /// 'win' or 'lose'
  final String gameResult;

  ResultScreen({super.key, required this.gameResult});
  bool get isWin => gameResult == 'win' ? true : false;

  TextStyle _textStyle(bool isWin) {
    if (isWin) {
      return TextStyle(color: Colors.greenAccent);
    }
    return TextStyle(color: Colors.redAccent);
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainer,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Center(
                child: Text(
                  isWin ? 'Congratulations You Win!' : 'You Lose',
                  style: _textStyle(isWin),
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: FilledButton(
                onPressed: () {
                  // navigate to dashboard
                  Navigator.pushAndRemoveUntil(
                    context,
                    MaterialPageRoute<void>(
                      builder: (context) => DashboardScreen(),
                    ),
                    (Route<dynamic> route) => false,
                  );
                },
                child: Text('Go Home'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

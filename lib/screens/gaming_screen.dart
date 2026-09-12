import 'package:flutter/material.dart';

class GamingScreen extends StatelessWidget {
  const GamingScreen({super.key, required this._gameScreen});

  /// game screen
  final Widget _gameScreen;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(
          child: Text(
            'Zone Game Garage',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: Theme.of(context).colorScheme.secondary,
            ),
          ),
        ),
        backgroundColor: Theme.of(context).colorScheme.primaryContainer,
      ),

      body: _gameScreen,
    );
  }
}

import 'package:flutter/material.dart';
import 'package:zone_game_garage/screens/games/blank_fill/blank_fill_screen.dart';
import 'package:zone_game_garage/screens/gaming_screen.dart';

class GameScreen extends StatelessWidget {
  GameScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('Game'),
          FilledButton(
            onPressed: () {
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(
                  builder: (context) =>
                      GamingScreen(gameScreen: BlankFillScreen()),
                ),
                (Route<dynamic> route) => false,
              );
            },
            child: Text('Play'),
          ),
        ],
      ),
    );
  }
}

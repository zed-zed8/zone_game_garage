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
          Text('BlankFill Game'),
          SizedBox(height: 10),
          Text('_ _ _ _ _'),
          SizedBox(height: 10),
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

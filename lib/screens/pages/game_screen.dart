import 'dart:math';

import 'package:flutter/material.dart';
import 'package:zone_game_garage/screens/games/blank_fill/blank_fill_screen.dart';
import 'package:zone_game_garage/screens/gaming_screen.dart';

class GameScreen extends StatefulWidget {
  GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Container(
        alignment: Alignment.topCenter,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [BlankFill()],
        ),
      ),
    );
  }
}

class BlankFill extends StatefulWidget {
  BlankFill({super.key});

  @override
  State<BlankFill> createState() => _BlankFillState();
}

class _BlankFillState extends State<BlankFill> {
  final _formGlobalKey = GlobalKey<FormState>();

  // BlankFill option // with default option
  int _timerSecond = 300;
  int _revealedLetterAmount = 0;
  int _length = 0; // can't be 1 or 2
  int _difficulty = 1;

  @override
  Widget build(BuildContext context) {
    bool isRevealedMoreThanLength =
        _revealedLetterAmount >= _length && _length != 0;

    return Container(
      width: 500,
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainer,
      ),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formGlobalKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                'BlankFill Game',
                style: Theme.of(context).textTheme.headlineSmall,
              ),
              SizedBox(height: 10),
              Text('_ _ _ _ _'),
              SizedBox(height: 10),

              // timerSecond
              Row(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: SizedBox(width: 100, child: Text('Timer'))),
                  Flexible(child: Text(' : ')),
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField(
                      initialValue: _timerSecond,
                      items: [
                        // value in second
                        DropdownMenuItem(value: 60, child: Text('1 minute')),
                        DropdownMenuItem(value: 180, child: Text('3 minute')),
                        DropdownMenuItem(value: 300, child: Text('5 minute')),
                        DropdownMenuItem(value: 600, child: Text('10 minute')),
                        DropdownMenuItem(value: 0, child: Text('♾️ infinite')),
                      ],
                      onChanged: (value) {
                        _timerSecond = value ?? 60;
                      },
                    ),
                  ),
                ],
              ),
              // revealed letter amount
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(width: 100, child: Text('Revealed Letter')),
                  ),
                  Flexible(child: Text(' : ')),
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField(
                      initialValue: _revealedLetterAmount,
                      items: [
                        DropdownMenuItem(value: 0, child: Text('Random')),
                        for (var i = 1; i <= 10; i++) ...{
                          DropdownMenuItem(value: i, child: Text('$i')),
                        },
                      ],
                      onChanged: (value) {
                        setState(() {
                          _revealedLetterAmount = value ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              // length
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(child: SizedBox(width: 100, child: Text('Length'))),
                  Flexible(child: Text(' : ')),
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField(
                      initialValue: _length,
                      items: [
                        DropdownMenuItem(value: 0, child: Text('Random')),
                        for (var i = 1; i <= 10; i++) ...{
                          if (i > 2)
                            DropdownMenuItem(value: i, child: Text('$i')),
                        },
                      ],
                      onChanged: (value) {
                        setState(() {
                          _length = value ?? 0;
                        });
                      },
                    ),
                  ),
                ],
              ),
              Text(
                '(Length cannot be 1 or 2)',
                style: Theme.of(context).textTheme.labelSmall,
              ),
              // difficulty
              Row(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Flexible(
                    child: SizedBox(width: 100, child: Text('Difficulty')),
                  ),
                  Flexible(child: Text(' : ')),
                  Flexible(
                    flex: 2,
                    child: DropdownButtonFormField(
                      initialValue: _difficulty,
                      items: [
                        DropdownMenuItem(value: 0, child: Text('Random')),
                        DropdownMenuItem(value: 1, child: Text('Normal')),
                        DropdownMenuItem(value: 2, child: Text('Hard')),
                        DropdownMenuItem(value: 3, child: Text('Difficult')),
                        DropdownMenuItem(value: 4, child: Text('Challenging')),
                        DropdownMenuItem(value: 5, child: Text('Rigorous')),
                      ],
                      onChanged: (value) {
                        _difficulty = value ?? 0;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 10),

              Text(
                '(Difficulty only works if length is less than 5)',
                style: Theme.of(context).textTheme.labelSmall,
              ),

              Container(
                decoration: isRevealedMoreThanLength
                    ? BoxDecoration(
                        color: Theme.of(context).colorScheme.errorContainer,
                      )
                    : null,
                child: Center(
                  child: Text(
                    '(Revealed Letter Amount can\'t be more than Length !!!)',
                    textAlign: TextAlign.center,
                    style: isRevealedMoreThanLength
                        ? TextStyle(
                            color: Theme.of(context)
                                .colorScheme
                                .onErrorContainer,
                          )
                        : Theme.of(context).textTheme.labelSmall,
                  ),
                ),
              ),

              SizedBox(height: 10),
              // button 'Play'
              FilledButton(
                onPressed: isRevealedMoreThanLength
                    ? null
                    : () {
                        if (_difficulty != 0 && _length == 0) {
                          _length = Random().nextInt(5) + 1;
                        }
                        Navigator.pushAndRemoveUntil(
                          context,
                          MaterialPageRoute(
                            builder: (context) => GamingScreen(
                              gameScreen: BlankFillScreen(
                                timerSecond: _timerSecond,
                                revealedLetterAmount: _revealedLetterAmount,
                                length: _length,
                                difficulty: _difficulty,
                              ),
                            ),
                          ),
                          (Route<dynamic> route) => false,
                        );
                      },
                child: Text('Play'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

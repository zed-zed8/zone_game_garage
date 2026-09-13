import 'dart:convert';

import 'package:zone_game_garage/models/game.dart';

class BlankFill extends Game {
  /// game specification
  static Game specification() {
    return Game(
      gameName: 'blank_fill',
      description: 'fill in the blank',
      version: '1.0',
    );
  }

  // option :
  int? timer;
  int? revealedLetterAmount;
  int? length;
  int? difficulty;

  // game result
  final String hiddenWord;
  final List<String> guesses;

  BlankFill({
    super.gameId, // Passed up to parent class
    super.gameResult,
    super.playedAt,
    this.timer,
    this.revealedLetterAmount,
    this.length,
    this.difficulty,
    required this.hiddenWord,
    required this.guesses,
  }) : super(
         gameName: BlankFill.specification().gameName,
         description: BlankFill.specification().description,
         version: BlankFill.specification().version,
       );

  /// game data @override game method
  @override
  Map<String, dynamic> get gameData {
    return {
      'timer': timer,
      'revealed_letter_amount': revealedLetterAmount,
      'length': length,
      'difficulty': difficulty,
      'hidden_word': hiddenWord,
      'guesses': guesses,
    };
  }

  /// factory constructor to get data from a map
  factory BlankFill.fromMap(Map<String, Object?> map) {
    final rawBlob = map['game_data'] as String;
    final Map<String, dynamic> blob = jsonDecode(rawBlob);

    return BlankFill(
      gameId: map['game_id'] as int?,
      gameResult: map['game_result'] as String,
      playedAt: DateTime.parse(map['played_at'] as String),
      // Extract specific options out of the blob map
      timer: blob['timer'] as int?,
      revealedLetterAmount: blob['revealed_letter_amount'] as int?,
      length: blob['length'] as int?,
      difficulty: blob['difficulty'] as int?,
      hiddenWord: blob['hidden_word'] as String,
      // Safely convert JSON list to List<String>
      guesses: List<String>.from(blob['guesses'] as List),
    );
  }
}

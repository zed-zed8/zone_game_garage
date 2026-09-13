import 'package:zone_game_garage/models/games/blank_fill.dart';

class Game {
  final int? gameId;
  final String? gameName;
  final String? description;
  final String? version;

  // game history
  final String? gameResult;
  final DateTime? playedAt;

  Game({
    this.gameId,
    required this.gameName,
    required this.description,
    this.version,
    //
    this.gameResult,
    this.playedAt,
  });

  /// values to be inserted to the db
  Map<String, dynamic> get values {
    return {
      'game_name': gameName,
      'description': description,
      'version': version,
    };
  }

  /// Factory constructor to handle conversion from a Map

  factory Game.fromMap(Map<String, Object?> map) {
    final name = map['game_name'] as String;

    switch (name) {
      case 'blank_fill':
        return BlankFill.fromMap(map);
      default:
        return Game(
          gameId: map['game_id'] as int?,
          gameName: name,
          description: map['description'] as String,
          version: map['version'] as String?,
        );
    }
  }

  /// method to handle conversion to a Map
  Map<String, Object?> map() {
    return {
      'game_id': gameId,
      'game_name': gameName,
      'description': description,
      'version': version,
    };
  }

  // Subclasses are forced to override this, or they will crash at runtime
  Map<String, dynamic> get gameData {
    throw UnimplementedError('gameData must be implemented by subclasses.');
  }
}

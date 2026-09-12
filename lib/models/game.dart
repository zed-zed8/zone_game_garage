class Game {
  int? gameId;
  String gameName;
  String description;
  String? version;

  Game({
    this.gameId,
    required this.gameName,
    required this.description,
    this.version,
  });

  /// values to be inserted to the db
  Map<String, dynamic> get values {
    return {
      'gameName': gameName,
      'description': description,
      'version': version,
    };
  }

  /// Factory constructor to handle conversion from a Map
  factory Game.fromMap(Map<String, Object?> map) {
    return Game(
      gameId: map['game_id'] as int,
      gameName: map['game_name'] as String,
      description: map['description'] as String,
      version: map['version'] as String?,
    );
  }
}

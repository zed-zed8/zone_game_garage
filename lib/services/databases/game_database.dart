import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:zone_game_garage/models/game.dart';

import 'package:zone_game_garage/services/databases/app_database.dart';

class GameDatabase {
  final AppDatabase _appDatabase;
  GameDatabase(this._appDatabase);

  /// insert game
  Future<void> insert(Game game) async {
    Database gameDB = await _appDatabase.database;
    gameDB.insert('games', game.values);
  }

  /// query games
  Future<Iterable<Game>> query({
    String? where,
    List<Object>? whereArgs,
    int? limit,
  }) async {
    Database gameDB = await _appDatabase.database;
    List<Map<String, Object?>> games = await gameDB.query(
      'games',
      where: where,
      whereArgs: whereArgs,
      limit: limit,
    );
    return games.map(Game.fromMap);
  }

  /// delete game
  Future<void> delete(Game game) async {
    Database userDB = await _appDatabase.database;
    await userDB.delete(
      'games',
      where: 'game_id = ?',
      whereArgs: [game.gameId],
    );
  }

  /// get game_name based on game_id
  Future<String> getGameName(int gameId) async {
    Database userDB = await _appDatabase.database;
    final List<Map<String, dynamic>> games = await userDB.query(
      'games', // Your table name
      columns: ['game_name'], // Only fetch the column you need
      where: 'game_id = ?', // Use '?' placeholder for safety
      whereArgs: [gameId], // Pass the ID to fill the placeholder
      limit: 1, // Optimize by stopping after 1 match
    );

    if (games.isNotEmpty) {
      return games.first['game_name'];
    }
    return 'game not found';
  }

  /// get game_id based on game_name
  Future<int> getGameId(String gameName) async {
    Database userDB = await _appDatabase.database;
    final List<Map<String, dynamic>> games = await userDB.query(
      'games', // Your table name
      columns: ['game_id'], // Only fetch the column you need
      where: 'game_name = ?', // Use '?' placeholder for safety
      whereArgs: [gameName], // Pass the ID to fill the placeholder
      limit: 1, // Optimize by stopping after 1 match
    );

    if (games.isNotEmpty) {
      return games.first['game_id'];
    }
    return 0;
  }
}

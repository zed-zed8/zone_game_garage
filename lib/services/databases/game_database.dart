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
}

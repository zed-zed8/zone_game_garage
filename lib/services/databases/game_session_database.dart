import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import 'package:zone_game_garage/models/game.dart';

import 'package:zone_game_garage/services/databases/app_database.dart';

class GameSessionDatabase {
  final AppDatabase _appDatabase;
  GameSessionDatabase(this._appDatabase);

  /// insert game
  ///
  /// #### 🔴 [gameChild] make sure [gameChild] is a child of Game class and not the Game class itself
  /// or else it'll throw error at runtime
  ///
  /// [gameDataJson] is a json string
  Future<void> insert(
    Game gameChild,
    int userId,
    int gameId,
    String gameDataJson,
  ) async {
    Database gameDB = await _appDatabase.database;

    Map<String, dynamic> values = {
      'user_id': userId,
      'game_id': gameId,
      'game_result': gameChild.gameResult,
      'played_at': gameChild.playedAt.toString(),
      'game_data': gameDataJson,
    };

    gameDB.insert('game_sessions', values);
  }

  /// query game sessions
  Future<Iterable<Game>> query({
    String? where,
    List<Object>? whereArgs,
    int? limit,
  }) async {
    Database gameDB = await _appDatabase.database;
    List<Map<String, dynamic>> gameSession = await gameDB.query(
      'game_sessions',
      where: where,
      whereArgs: whereArgs,
      limit: limit,
    );
    return gameSession.map(Game.fromMap);
  }

  /// delete game session
  ///
  /// #### 🔴 [gameChild] make sure [gameChild] is a child of Game class and not the Game class itself
  Future<void> delete(Game gameChild) async {
    Database userDB = await _appDatabase.database;
    await userDB.delete(
      'game_sessions',
      where: 'game_id = ?',
      whereArgs: [gameChild.gameId],
    );
  }
}

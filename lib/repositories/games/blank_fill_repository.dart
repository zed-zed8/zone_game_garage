import 'dart:convert';

import 'package:zone_game_garage/models/game.dart';
import 'package:zone_game_garage/models/games/blank_fill.dart';
import 'package:zone_game_garage/services/api/random_word_api.dart';
import 'package:zone_game_garage/services/databases/app_database.dart';
import 'package:zone_game_garage/services/databases/game_database.dart';
import 'package:zone_game_garage/services/databases/game_session_database.dart';
import 'package:zone_game_garage/services/databases/user_database.dart';
import 'package:zone_game_garage/services/shared_preferences/auth_storage.dart';

/// Repository is responsible for saving the data to the database
class BlankFillRepository {
  final GameSessionDatabase _gameSessionDatabase;
  final GameDatabase _gameDatabase;
  final UserDatabase _userDatabase;

  BlankFillRepository(AppDatabase appDatabase)
    : _gameSessionDatabase = GameSessionDatabase(appDatabase),
      _gameDatabase = GameDatabase(appDatabase),
      _userDatabase = UserDatabase(appDatabase);

  /// check if game exist and if it isn't create the game
  static Future<void> gameExistenceCheck() async {
    Game game = BlankFill.specification();
    Iterable<Game> gameExist = await GameDatabase(AppDatabase.instance)
        .query(where: 'game_name = ?', whereArgs: [game.gameName!]);
    if (gameExist.isEmpty) {
      await GameDatabase(AppDatabase.instance).insert(game);
    }
  }

  /// get a random word
  Future<String> randomWord({int? length, String? lang, int? diff}) async {
    String jsonString = await RandomWordApi.randomWord(
      number: 1,
      length: length,
      lang: lang,
      diff: diff,
    );

    final decoded = jsonDecode(jsonString);
    List<dynamic> list = List<String>.from(decoded);

    return list.first;
  }

  /// save the session
  Future<void> save({
    required BlankFill blankFill,
    String? gameName,
    int? gameId,
  }) async {
    assert(
      !(gameName == null && gameId == null),
      'gameId and game name not found on the save function in blank_fill_repository',
    );
    if (gameName == null && gameId == null) {
      print(
        'gameId and game name not found on the save function in blank_fill_repository',
      );
    }

    final int getGameId;
    if (gameId != null) {
      getGameId = gameId;
    } else {
      if (gameName != null) {
        getGameId = await _gameDatabase.getGameId(gameName);
      } else {
        getGameId = 1;
      }
    }

    String username = await AuthStorage.getUsername();
    int userId = await _userDatabase.getUserId(username);

    // create the game data json
    Map<String, dynamic> gameData = blankFill.gameData;
    String gameDataJson = jsonEncode(gameData);

    await _gameSessionDatabase.insert(
      blankFill,
      userId,
      getGameId,
      gameDataJson,
    );
  }
}

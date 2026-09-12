import 'package:zone_game_garage/models/game.dart';
import 'package:zone_game_garage/services/databases/app_database.dart';
import 'package:zone_game_garage/services/databases/game_database.dart';

/// Repository is responsible for saving the data to the database
class BlankFillRepository {
  final GameDatabase _gameDatabase;

  BlankFillRepository(this._gameDatabase);

  /// check if game exist and if it isn't create the game
  static Future<void> gameExistenceCheck() async {
    /// TODO Store game specification somewhere else, so that it can sync up with model
    Game game = Game(
      gameName: 'blank_fill',
      description: 'fill in the blank',
      version: '1.0',
    );
    Iterable<Game> gameExist = await GameDatabase(AppDatabase.instance)
        .query(where: 'game_name = ?', whereArgs: [game.gameName]);
    if (gameExist.isEmpty) {
      GameDatabase(AppDatabase.instance).insert(game);
    }
  }
}

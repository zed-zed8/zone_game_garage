import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Required for Windows

import 'package:zone_game_garage/models/user.dart';

import 'package:zone_game_garage/services/databases/app_database.dart';

class UserDatabase {
  final AppDatabase _appDatabase;
  UserDatabase(this._appDatabase);

  /// insert user
  Future<void> insert(User user) async {
    Database userDB = await _appDatabase.database;
    userDB.insert('users', user.values);
  }

  /// query user
  Future<Iterable<User>> query({
    String? where,
    List<Object>? whereArgs,
    int? limit,
  }) async {
    Database userDB = await _appDatabase.database;
    List<Map<String, Object?>> users = await userDB.query(
      'users',
      where: where,
      whereArgs: whereArgs,
      limit: limit,
    );
    return users.map(User.fromMap);
  }

  /// delete user
  Future<void> delete(User user) async {
    Database userDB = await _appDatabase.database;
    await userDB.delete(
      'users',
      where: 'user_id = ?',
      whereArgs: [user.userId],
    );
  }
}

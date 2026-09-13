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

  /// get username based on user_id
  Future<String> getUsername(int userId) async {
    Database userDB = await _appDatabase.database;
    final List<Map<String, dynamic>> users = await userDB.query(
      'users', // Your table name
      columns: ['username'], // Only fetch the column you need
      where: 'user_id = ?', // Use '?' placeholder for safety
      whereArgs: [userId], // Pass the ID to fill the placeholder
      limit: 1, // Optimize by stopping after 1 match
    );

    if (users.isNotEmpty) {
      return users.first['username'];
    }
    return 'user not found';
  }

  /// get user_id based on username
  Future<int> getUserId(String username) async {
    Database userDB = await _appDatabase.database;
    final List<Map<String, dynamic>> users = await userDB.query(
      'users', // Your table name
      columns: ['user_id'], // Only fetch the column you need
      where: 'username = ?', // Use '?' placeholder for safety
      whereArgs: [username], // Pass the ID to fill the placeholder
      limit: 1, // Optimize by stopping after 1 match
    );

    if (users.isNotEmpty) {
      return users.first['user_id'];
    }
    return 0;
  }
}

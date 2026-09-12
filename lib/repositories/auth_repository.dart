import 'dart:convert';

import 'package:zone_game_garage/models/user.dart';
import 'package:zone_game_garage/services/databases/user_database.dart';
import 'package:zone_game_garage/services/shared_preferences/auth_storage.dart';

class AuthRepository {
  final UserDatabase _userDatabase;

  AuthRepository(this._userDatabase);

  /// Register a new user
  ///
  /// returns a user on success
  Future<User> register(String username, String email, String password) async {
    // Encode password using dart:convert
    String encodedPassword = base64Encode(utf8.encode(password));
    // create date
    DateTime createAt = DateTime.now();

    User user = User(
      username: username,
      email: email,
      password: encodedPassword,
      createdAt: createAt,
    );

    await AuthStorage.setLoginStatus(true, username);
    await _userDatabase.insert(user);
    return user;
  }

  /// login user
  ///
  /// returns User
  Future<User?> login(String username, String password) async {
    // Encode password using dart:convert
    String encodedPassword = base64Encode(utf8.encode(password));

    final users = await _userDatabase.query(
      where: 'username = ? AND password = ?',
      whereArgs: [username, encodedPassword],
    );

    if (users.isEmpty) {
      return null;
    }

    await AuthStorage.setLoginStatus(true, username);
    return users.first;
  }

  /// login user
  ///
  /// returns User
  Future<void> logout() async {
    await AuthStorage.sessionLogout();
  }

  /// get current user
  Future<User?> getCurrentUser() async {
    if (await AuthStorage.isLoggedIn()) {
      final users = await _userDatabase.query(
        where: 'username = ?',
        whereArgs: [await AuthStorage.getUsername()],
        limit: 1,
      );

      return users.first;
    } else {
      return null;
    }
  }

  // get username
  Future<String> getUsername() async {
    return await AuthStorage.getUsername();
  }
}

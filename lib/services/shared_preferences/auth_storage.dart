import 'package:shared_preferences/shared_preferences.dart';

class AuthStorage {
  /// Save session flag, and username
  static Future<void> setLoginStatus(bool isLoggedIn, String username) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', isLoggedIn);
    await prefs.setString('username', username);
  }

  /// Check session flag
  static Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('is_logged_in') ?? false;
  }

  /// get username
  static Future<String> getUsername() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('username') ?? 'guest';
  }

  /// set session flag false, and remove the username
  static Future<void> sessionLogout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    await prefs.remove('username');
  }
}

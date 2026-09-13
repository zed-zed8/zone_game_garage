import 'dart:io';

import 'package:flutter/foundation.dart';

import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart'; // Required for Windows

class AppDatabase {
  static final AppDatabase instance = AppDatabase._init();
  static Database? _database;

  AppDatabase._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('zone_game_garage.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    // Initialize FFI if running on Windows or Linux
    if (!kIsWeb && (Platform.isWindows || Platform.isLinux)) {
      sqfliteFfiInit();
      databaseFactory = databaseFactoryFfi;
    }

    final dbPath = await getApplicationDocumentsDirectory();
    final path = join(dbPath.path, filePath);

    return await openDatabase(
      path,
      version: 1,
      onCreate: _createDB,
      onConfigure: _configureDB,
    );
  }

  Future<void> _configureDB(Database db) async {
    await db.execute('PRAGMA foreign_keys = ON');
  }

  Future _createDB(Database db, int version) async {
    // Users table
    await db.execute('''
      CREATE TABLE users(
        user_id INTEGER PRIMARY KEY, 
        username TEXT NOT NUll UNIQUE, 
        email TEXT NOT NUll UNIQUE,
        password TEXT NOT NUll,
        created_at TEXT NOT NUll
      );
      ''');

    // Game Sessions table
    await db.execute('''
      CREATE TABLE games(
        game_id INTEGER PRIMARY KEY, 
        game_name TEXT NOT NUll UNIQUE, 
        description TEXT, 
        version TEXT
      );
      ''');

    // Game Sessions table
    await db.execute('''
      CREATE TABLE game_sessions(
        game_session_id INTEGER PRIMARY KEY, 
        user_id INTEGER NOT NULL, 
        game_id INTEGER NOT NULL, 
        game_result TEXT NOT NUll, 
        played_at TEXT,
        game_data TEXT NOT NULL,

        FOREIGN KEY(user_id) REFERENCES users(user_id),
        FOREIGN KEY(game_id) REFERENCES games(game_id)
      );
      ''');

    _seedDB(db, version);
  }

  Future _seedDB(Database db, int version) async {
    db.insert('users', {
      'username': 'guest',
      'email': 'guest@gmail.com',
      'password': 'cGFzc3dvcmQ=',
      'created_at': '2009-10-08',
    });

    db.insert('games', {
      'game_name': 'spacewar',
      'description': 'placeholder game',
      'version': '0.0.0',
    });
  }
}

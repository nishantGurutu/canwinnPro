import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';

class DbHelper {
  static final DbHelper _instance = DbHelper._internal();
  factory DbHelper() => _instance;

  DbHelper._internal();

  Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDatabase();
    return _database!;
  }

  Future<Database> _initDatabase() async {
    WidgetsFlutterBinding
        .ensureInitialized(); // Ensure Flutter bindings are initialized
    String databasesPath =
        await getDatabasesPath(); // Ensure the path is retrieved correctly
    String path = join(databasesPath, 'task_database.db');

    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) {
        db.execute('''
          CREATE TABLE anniversaries (
            id INTEGER PRIMARY KEY,
            name TEXT,
            anniversary_date TEXT,
            dob TEXT,
            image TEXT,
            anniversary_type TEXT,
            chat_id INTEGER,
            msg TEXT
          )
        ''');
      },
    );
  }

  Future<int> insertAnniversary(Map<String, dynamic> anniversary) async {
    final db = await database;
    return await db.insert(
      'anniversaries',
      anniversary,
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<void> insertAnniversaries(List<Map<String, dynamic>> data) async {
    final db = await database;
    final batch = db.batch();
    for (var anniversary in data) {
      batch.insert('anniversaries', anniversary,
          conflictAlgorithm: ConflictAlgorithm.replace);
    }
    await batch.commit();
  }
}

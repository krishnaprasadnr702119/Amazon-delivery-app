// database_helper.dart

import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import 'package:task/models/user.dart';

class DatabaseHelper {
  static final DatabaseHelper _instance = DatabaseHelper._internal();

  factory DatabaseHelper() => _instance;

  DatabaseHelper._internal();

  Database? _database;

  Future<void> _initDatabase() async {
    final databasesPath = await getDatabasesPath();
    final path = join(databasesPath, 'amazontest.db');

    _database = await openDatabase(path, version: 1, onCreate: _createDb);
    print("Database initialized.");
  }

  Future<void> _createDb(Database db, int version) async {
    await db.execute('''
      CREATE TABLE users (
        id TEXT PRIMARY KEY, 
        username TEXT,
        email TEXT,
        password TEXT
      )
    ''');
  }

  Future<void> saveUser(User user, {bool resetPassword = false}) async {
    await _initDatabase();

    if (_database != null) {
      print("Saving user: ${user.toMap()}");

      if (resetPassword) {
        // If resetPassword is true, update the password for an existing user
        await _database!.update(
          'users',
          user.toMap(),
          where: 'email = ?',
          whereArgs: [user.email],
        );
      } else {
        // Use 'replace' to update an existing user with the same 'id'
        await _database!.insert(
          'users',
          user.toMap(),
          conflictAlgorithm: ConflictAlgorithm.replace,
        );
      }

      print("User saved.");
    }
  }

  Future<User?> getUser(String username, String password) async {
    await _initDatabase();
    if (_database != null) {
      final List<Map<String, dynamic>> result = await _database!.query(
        'users',
        where: 'username = ?',
        whereArgs: [username],
      );

      if (result.isNotEmpty) {
        final User user = User.fromMap(result.first);

        // Validate the password here
        if (user.password == password) {
          return user;
        }
      }
    }

    return null;
  }

  Future<User?> getUserByEmail(String email) async {
    await _initDatabase();

    if (_database != null) {
      final List<Map<String, dynamic>> result = await _database!.query(
        'users',
        where: 'email = ?',
        whereArgs: [email],
      );

      if (result.isNotEmpty) {
        return User.fromMap(result.first);
      }
    }

    return null;
  }
}

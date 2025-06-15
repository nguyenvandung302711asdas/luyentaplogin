import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DatabaseHelper {
  static final _dbName = 'uses.db';
  static final _dbVersion = 1;
  static final _tableName = 'users';

  static Database? _database;

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path = join(await getDatabasesPath(), _dbName);
    return await openDatabase(
      path,
      version: _dbVersion,
      onCreate: (db, version) async {
        await db.execute('''
          CREATE TABLE $_tableName (
            id INTEGER PRIMARY KEY AUTOINCREMENT,
            email TEXT NOT NULL,
            name TEXT NOT NULL,
            password TEXT NOT NULL
          )
        ''');
      },
    );
  }

  Future<int> insertUser(String email, String name, String password) async {
    final db = await database;
    return await db.insert(_tableName, {
      'email': email,
      'name': name,
      'password': password,
    });
  }

  Future<Map<String, dynamic>?> getUserByEmail(String email) async {
    final db = await database;
    List<Map<String, dynamic>> result =
    await db.query(_tableName, where: 'email = ?', whereArgs: [email]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<Map<String, dynamic>?> getUserByEmailAndPassword(String email, String password) async {
    final db = await database;
    List<Map<String, dynamic>> result = await db.query(_tableName,
        where: 'email = ? AND password = ?', whereArgs: [email, password]);
    return result.isNotEmpty ? result.first : null;
  }

  Future<int> updatePassword(String email, String newPassword) async {
    final db = await database;
    return await db.update(_tableName, {'password': newPassword},
        where: 'email = ?', whereArgs: [email]);
  }
}

// lib/helpers/db_helper.dart
import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class DBHelper {
  static final DBHelper _instance = DBHelper._internal();
  factory DBHelper() => _instance;
  static Database? _database;

  DBHelper._internal();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await initDB();
    return _database!;
  }

  // Initialize the SQLite database
  Future<Database> initDB() async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, 'quiz.db');
    // Open the database, creating it if it doesn't exist
    return await openDatabase(
      path,
      version: 1,
      onCreate: (db, version) async {
        // Create a table named 'score' with columns 'id' and 'score'
        await db.execute(
            'CREATE TABLE score(id INTEGER PRIMARY KEY, score INTEGER)'
        );
      },
    );
  }

  // Insert or update the score (we use id=0 for the single row)
  Future<void> insertScore(int score) async {
    final db = await database;
    await db.insert(
      'score',
      {'id': 0, 'score': score},
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Retrieve the saved score (returns null if not set)
  Future<int?> getScore() async {
    final db = await database;
    final List<Map<String, dynamic>> maps =
    await db.query('score', where: 'id = ?', whereArgs: [0]);
    if (maps.isNotEmpty) {
      return maps.first['score'] as int;
    }
    return null;
  }
}

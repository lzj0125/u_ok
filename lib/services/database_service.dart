import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';
import '../models/emotion_record.dart';
import '../models/detective_log.dart';

class DatabaseService {
  static final DatabaseService instance = DatabaseService._init();
  static Database? _database;

  DatabaseService._init();

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB('mood_tracker.db');
    return _database!;
  }

  Future<Database> _initDB(String filePath) async {
    final dbPath = await getDatabasesPath();
    final path = join(dbPath, filePath);

    return await openDatabase(
      path,
      version: 2,
      onCreate: _createDB,
      onUpgrade: _upgradeDB,
    );
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';

    await db.execute('''
      CREATE TABLE records (
        id $idType,
        emotion_type $intType NOT NULL,
        intensity $intType NOT NULL,
        scene $textType NOT NULL,
        custom_scene $textType,
        note $textType,
        created_at $textType NOT NULL,
        week_day $intType NOT NULL,
        time_period $intType NOT NULL
      )
    ''');

    await db.execute('''
      CREATE TABLE detective_logs (
        id $idType,
        record_id $intType NOT NULL,
        thought_before $textType,
        worst_case $textType,
        probability $intType,
        small_action $textType,
        FOREIGN KEY (record_id) REFERENCES records (id) ON DELETE CASCADE
      )
    ''');

    await db.execute('''
      CREATE TABLE achievements (
        id $textType PRIMARY KEY,
        title $textType NOT NULL,
        description $textType NOT NULL,
        icon $textType NOT NULL,
        is_unlocked $intType DEFAULT 0,
        unlocked_at $textType
      )
    ''');
  }

  Future _upgradeDB(Database db, int oldVersion, int newVersion) async {
    if (oldVersion < 2) {
      const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
      const textType = 'TEXT';
      const intType = 'INTEGER';

      await db.execute('''
        CREATE TABLE IF NOT EXISTS achievements (
          id $textType PRIMARY KEY,
          title $textType NOT NULL,
          description $textType NOT NULL,
          icon $textType NOT NULL,
          is_unlocked $intType DEFAULT 0,
          unlocked_at $textType
        )
      ''');
    }
  }

  Future<int> insertRecord(EmotionRecord record) async {
    final db = await instance.database;
    return await db.insert('records', record.toMap());
  }

  Future<int> insertDetectiveLog(DetectiveLog log) async {
    final db = await instance.database;
    return await db.insert('detective_logs', log.toMap());
  }

  Future<List<EmotionRecord>> getAllRecords() async {
    final db = await instance.database;
    final result = await db.query('records', orderBy: 'created_at DESC');
    return result.map((json) => EmotionRecord.fromMap(json)).toList();
  }
}

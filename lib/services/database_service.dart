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

    return await openDatabase(path, version: 1, onCreate: _createDB);
  }

  Future _createDB(Database db, int version) async {
    const idType = 'INTEGER PRIMARY KEY AUTOINCREMENT';
    const textType = 'TEXT';
    const intType = 'INTEGER';

    // 创建情绪记录表
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

    // 创建侦探追问表
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
  }

  // 插入情绪记录并返回ID
  Future<int> insertRecord(EmotionRecord record) async {
    final db = await instance.database;
    return await db.insert('records', record.toMap());
  }

  // 插入侦探日志
  Future<int> insertDetectiveLog(DetectiveLog log) async {
    final db = await instance.database;
    return await db.insert('detective_logs', log.toMap());
  }

  // 获取所有记录（简化版，实际需分页）
  Future<List<EmotionRecord>> getAllRecords() async {
    final db = await instance.database;
    final result = await db.query('records', orderBy: 'created_at DESC');
    return result.map((json) => EmotionRecord.fromMap(json)).toList();
  }
}

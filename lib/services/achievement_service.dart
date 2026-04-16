import '../models/achievement.dart';
import '../services/database_service.dart';

class AchievementService {
  static final AchievementService instance = AchievementService._init();

  AchievementService._init();

  static List<Achievement> allAchievements = [
    Achievement(
      id: 'first_record',
      title: '初次探索',
      description: '完成第一次情绪记录',
      icon: '🌟',
    ),
    Achievement(
      id: 'seven_days',
      title: '坚持一周',
      description: '连续记录7天',
      icon: '🔥',
    ),
    Achievement(
      id: 'thirty_days',
      title: '月度达人',
      description: '连续记录30天',
      icon: '💎',
    ),
    Achievement(
      id: 'detective_novice',
      title: '侦探新手',
      description: '完成第一次侦探追问',
      icon: '🕵️',
    ),
    Achievement(
      id: 'emotion_master',
      title: '情绪大师',
      description: '记录100次情绪',
      icon: '👑',
    ),
    Achievement(
      id: 'early_bird',
      title: '早起鸟儿',
      description: '在凌晨时段记录情绪',
      icon: '🌅',
    ),
    Achievement(
      id: 'night_owl',
      title: '夜猫子',
      description: '在晚上时段记录情绪',
      icon: '🌙',
    ),
    Achievement(
      id: 'honest_writer',
      title: '真诚书写',
      description: '单次备注超过200字',
      icon: '✍️',
    ),
  ];

  Future<List<Achievement>> getUserAchievements() async {
    final db = await DatabaseService.instance.database;
    final result = await db.query('achievements');

    if (result.isEmpty) {
      await _initializeAchievements();
      return allAchievements
          .map(
            (a) => Achievement(
              id: a.id,
              title: a.title,
              description: a.description,
              icon: a.icon,
              isUnlocked: false,
            ),
          )
          .toList();
    }

    return result.map((map) => Achievement.fromMap(map)).toList();
  }

  Future<void> _initializeAchievements() async {
    final db = await DatabaseService.instance.database;
    for (var achievement in allAchievements) {
      await db.insert('achievements', achievement.toMap());
    }
  }

  Future<void> checkAndUnlockAchievements() async {
    final db = await DatabaseService.instance.database;
    final records = await DatabaseService.instance.getAllRecords();

    if (records.isEmpty) return;

    final totalRecords = records.length;
    final consecutiveDays = _calculateConsecutiveDays(records);
    final lastRecord = records.first;

    await _unlockIfCondition('first_record', totalRecords >= 1);
    await _unlockIfCondition('seven_days', consecutiveDays >= 7);
    await _unlockIfCondition('thirty_days', consecutiveDays >= 30);
    await _unlockIfCondition('emotion_master', totalRecords >= 100);
    await _unlockIfCondition('early_bird', lastRecord.timePeriod == 0);
    await _unlockIfCondition('night_owl', lastRecord.timePeriod == 3);

    if (lastRecord.note != null && lastRecord.note!.length > 200) {
      await _unlockIfCondition('honest_writer', true);
    }

    final detectiveLogs = await db.query('detective_logs');
    await _unlockIfCondition('detective_novice', detectiveLogs.isNotEmpty);
  }

  int _calculateConsecutiveDays(List records) {
    if (records.isEmpty) return 0;

    int consecutiveDays = 1;
    DateTime currentDate = DateTime.now();

    for (int i = 0; i < records.length - 1; i++) {
      DateTime recordDate = records[i].createdAt;
      DateTime prevRecordDate = records[i + 1].createdAt;

      int difference = currentDate.difference(recordDate).inDays;
      int prevDifference = currentDate.difference(prevRecordDate).inDays;

      if (prevDifference - difference == 1) {
        consecutiveDays++;
      } else {
        break;
      }
    }

    return consecutiveDays;
  }

  Future<void> _unlockIfCondition(String achievementId, bool condition) async {
    if (!condition) return;

    final db = await DatabaseService.instance.database;
    final result = await db.query(
      'achievements',
      where: 'id = ?',
      whereArgs: [achievementId],
    );

    if (result.isNotEmpty && result.first['is_unlocked'] == 0) {
      await db.update(
        'achievements',
        {'is_unlocked': 1, 'unlocked_at': DateTime.now().toIso8601String()},
        where: 'id = ?',
        whereArgs: [achievementId],
      );
    }
  }

  Future<UserStats> getUserStats() async {
    final db = await DatabaseService.instance.database;
    final records = await DatabaseService.instance.getAllRecords();
    final achievements = await getUserAchievements();

    final consecutiveDays = _calculateConsecutiveDays(records);
    final unlockedAchievements = achievements.where((a) => a.isUnlocked).length;

    Map<String, int> emotionDistribution = {};
    for (var record in records) {
      String emotionName = _getEmotionName(record.emotionType);
      emotionDistribution[emotionName] =
          (emotionDistribution[emotionName] ?? 0) + 1;
    }

    return UserStats(
      totalRecords: records.length,
      consecutiveDays: consecutiveDays,
      totalAchievements: unlockedAchievements,
      lastRecordDate: records.isNotEmpty ? records.first.createdAt : null,
      emotionDistribution: emotionDistribution,
    );
  }

  String _getEmotionName(int type) {
    switch (type) {
      case 1:
        return '焦虑';
      case 2:
        return '身心劳累';
      case 3:
        return '抑郁';
      default:
        return '未知';
    }
  }
}

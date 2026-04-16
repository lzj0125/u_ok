import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DailyCheckIn {
  static const String _lastCheckInKey = 'last_check_in_date';
  static const String _checkInStreakKey = 'check_in_streak';

  static Future<bool> canCheckIn() async {
    final prefs = await SharedPreferences.getInstance();
    final lastCheckIn = prefs.getString(_lastCheckInKey);

    if (lastCheckIn == null) return true;

    final lastDate = DateTime.parse(lastCheckIn);
    final now = DateTime.now();

    return !isSameDay(lastDate, now);
  }

  static Future<Map<String, dynamic>> checkIn() async {
    final prefs = await SharedPreferences.getInstance();
    final now = DateTime.now();

    int streak = prefs.getInt(_checkInStreakKey) ?? 0;
    final lastCheckIn = prefs.getString(_lastCheckInKey);

    if (lastCheckIn != null) {
      final lastDate = DateTime.parse(lastCheckIn);
      final daysDiff = now.difference(lastDate).inDays;

      if (daysDiff == 1) {
        streak++;
      } else if (daysDiff > 1) {
        streak = 1;
      }
    } else {
      streak = 1;
    }

    await prefs.setString(_lastCheckInKey, now.toIso8601String());
    await prefs.setInt(_checkInStreakKey, streak);

    int reward = _calculateReward(streak);

    return {'success': true, 'streak': streak, 'reward': reward};
  }

  static Future<int> getCurrentStreak() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_checkInStreakKey) ?? 0;
  }

  static int _calculateReward(int streak) {
    if (streak >= 30) return 100;
    if (streak >= 14) return 50;
    if (streak >= 7) return 30;
    if (streak >= 3) return 15;
    return 10;
  }

  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }
}

class CheckInDialog extends StatefulWidget {
  @override
  _CheckInDialogState createState() => _CheckInDialogState();
}

class _CheckInDialogState extends State<CheckInDialog> {
  bool _isCheckingIn = false;
  Map<String, dynamic>? _result;

  Future<void> _performCheckIn() async {
    setState(() => _isCheckingIn = true);

    await Future.delayed(Duration(milliseconds: 800));

    final result = await DailyCheckIn.checkIn();

    setState(() {
      _isCheckingIn = false;
      _result = result;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_result != null) {
      return AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.celebration, size: 64, color: Color(0xFFFFD700)),
            SizedBox(height: 16),
            Text(
              '签到成功！',
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Color(0xFFFFF9E6),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  Text(
                    '连续签到 ${_result!['streak']} 天',
                    style: TextStyle(fontSize: 16, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '获得 ${_result!['reward']} 积分',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFF9F43),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: Text(
              '太棒了',
              style: TextStyle(
                color: Color(0xFF2DD4BF),
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    }

    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.calendar_today, size: 48, color: Color(0xFF2DD4BF)),
          SizedBox(height: 16),
          Text(
            '每日签到',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 8),
          Text(
            '连续签到获得更多奖励',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          ElevatedButton(
            onPressed: _isCheckingIn ? null : _performCheckIn,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 50),
              backgroundColor: Color(0xFF2DD4BF),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: _isCheckingIn
                ? SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation(Colors.white),
                    ),
                  )
                : Text(
                    '立即签到',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
          ),
        ],
      ),
    );
  }
}

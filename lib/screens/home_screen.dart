import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'record_screen.dart';
import 'insights_screen.dart';
import 'settings_screen.dart';
import 'quick_release_screen.dart';
import 'achievements_screen.dart';
import 'emotion_growth_tree.dart';
import '../providers/app_state_provider.dart';
import '../widgets/pro_lock_overlay.dart';
import '../utils/daily_checkin.dart';
import '../services/achievement_service.dart';
import '../models/achievement.dart';
import '../screens/dashboard_screen.dart';
import '../screens/insights_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  int _currentIndex = 0;
  int _checkInStreak = 0;
  UserStats? _userStats;
  late AnimationController _fadeController;
  late AnimationController _scaleController;

  @override
  void initState() {
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 800),
      vsync: this,
    );
    _scaleController = AnimationController(
      duration: Duration(milliseconds: 600),
      vsync: this,
    );
    _loadData();
    _fadeController.forward();
    _scaleController.forward();
  }

  Future<void> _loadData() async {
    final streak = await DailyCheckIn.getCurrentStreak();
    final stats = await AchievementService.instance.getUserStats();
    setState(() {
      _checkInStreak = streak;
      _userStats = stats;
    });
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _scaleController.dispose();
    super.dispose();
  }

  Future<void> _showCheckInDialog() async {
    final canCheckIn = await DailyCheckIn.canCheckIn();

    if (!canCheckIn) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(Icons.check_circle, color: Colors.white),
              SizedBox(width: 12),
              Text('今天已经签到过了，明天再来吧！'),
            ],
          ),
          backgroundColor: Color(0xFF2DD4BF),
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      );
      return;
    }

    final result = await showDialog(
      context: context,
      builder: (_) => CheckInDialog(),
    );

    if (result == true) {
      _loadData();
    }
  }

  void _navigateToRecord() {
    Navigator.push(context, MaterialPageRoute(builder: (_) => RecordScreen()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: [
          DashboardScreen(
            checkInStreak: _checkInStreak,
            userStats: _userStats,
            onCheckIn: _showCheckInDialog,
            fadeController: _fadeController,
            scaleController: _scaleController,
            onRefresh: _loadData,
          ),
          InsightsScreen(),
          SettingsScreen(),
        ],
      ),
      floatingActionButton: ScaleTransition(
        scale: Tween<double>(begin: 1.0, end: 1.1).animate(
          CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
        ),
        child: FloatingActionButton.extended(
          onPressed: _navigateToRecord,
          backgroundColor: Color(0xFF2DD4BF),
          foregroundColor: Colors.white,
          elevation: 8,
          icon: Icon(Icons.add_rounded, size: 28),
          label: Text(
            '记录情绪',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: Offset(0, -5),
            ),
          ],
        ),
        child: BottomNavigationBar(
          currentIndex: _currentIndex,
          onTap: (index) {
            setState(() {
              _currentIndex = index;
            });
          },
          type: BottomNavigationBarType.fixed,
          backgroundColor: Colors.transparent,
          elevation: 0,
          selectedItemColor: Color(0xFF2DD4BF),
          unselectedItemColor: Colors.grey[400],
          selectedFontSize: 12,
          unselectedFontSize: 11,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home_rounded),
              activeIcon: AnimatedContainer(
                duration: Duration(milliseconds: 300),
                child: Icon(Icons.home_rounded, size: 28),
              ),
              label: '首页',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.insights_rounded),
              activeIcon: Icon(Icons.insights_rounded, size: 28),
              label: '洞察',
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.settings_rounded),
              activeIcon: Icon(Icons.settings_rounded, size: 28),
              label: '设置',
            ),
          ],
        ),
      ),
    );
  }
}

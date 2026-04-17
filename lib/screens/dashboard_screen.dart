import 'package:flutter/material.dart';
import 'quick_release_screen.dart';
import 'achievements_screen.dart';
import 'emotion_growth_tree.dart';
import '../models/achievement.dart';

class DashboardScreen extends StatefulWidget {
  final int checkInStreak;
  final UserStats? userStats;
  final VoidCallback onCheckIn;
  final AnimationController fadeController;
  final AnimationController scaleController;
  final VoidCallback onRefresh;

  const DashboardScreen({
    Key? key,
    required this.checkInStreak,
    required this.userStats,
    required this.onCheckIn,
    required this.fadeController,
    required this.scaleController,
    required this.onRefresh,
  }) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: Duration(milliseconds: 2000),
      vsync: this,
    )..repeat(reverse: true);

    _pulseAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: RefreshIndicator(
        onRefresh: () async => widget.onRefresh(),
        color: Color(0xFF2DD4BF),
        child: SingleChildScrollView(
          physics: AlwaysScrollableScrollPhysics(),
          padding: EdgeInsets.all(20),
          child: FadeTransition(
            opacity: widget.fadeController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 12),
                _buildHeader(context),
                SizedBox(height: 24),
                _buildQuickStats(),
                SizedBox(height: 20),
                _buildAnimatedQuickReleaseCard(context),
                SizedBox(height: 16),
                _buildGrowthProgress(context),
                SizedBox(height: 16),
                _buildCheckInCard(),
                SizedBox(height: 16),
                _buildDailyTipCard(),
                SizedBox(height: 100),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _getGreeting(),
                style: TextStyle(
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1F2937),
                  height: 1.2,
                ),
              ),
              SizedBox(height: 6),
              Text(
                '每一次记录，都是成长的足迹',
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (_) => AchievementsScreen()),
            );
          },
          child: ScaleTransition(
            scale: Tween<double>(begin: 1.0, end: 1.1).animate(
              CurvedAnimation(
                parent: widget.scaleController,
                curve: Curves.easeInOut,
              ),
            ),
            child: Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.4),
                    blurRadius: 12,
                    offset: Offset(0, 4),
                  ),
                ],
              ),
              child: Icon(Icons.emoji_events, color: Colors.white, size: 26),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildQuickStats() {
    final totalRecords = widget.userStats?.totalRecords ?? 0;
    final consecutiveDays = widget.userStats?.consecutiveDays ?? 0;
    final achievements = widget.userStats?.totalAchievements ?? 0;

    return Container(
      padding: EdgeInsets.symmetric(horizontal: 4),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              icon: '📝',
              value: '$totalRecords',
              label: '总记录',
              color: Color(0xFF2DD4BF),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: '🔥',
              value: '$consecutiveDays',
              label: '连续天',
              color: Color(0xFFFF9F43),
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              icon: '🏆',
              value: '$achievements',
              label: '成就',
              color: Color(0xFF6C5CE7),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard({
    required String icon,
    required String value,
    required String label,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.symmetric(vertical: 16, horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Text(icon, style: TextStyle(fontSize: 28)),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 4),
          Text(label, style: TextStyle(fontSize: 11, color: Colors.grey[600])),
        ],
      ),
    );
  }

  Widget _buildAnimatedQuickReleaseCard(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseAnimation,
      builder: (context, child) {
        return Transform.scale(
          scale: _pulseAnimation.value,
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Color(
                    0xFFFF9F43,
                  ).withOpacity(0.4 + (_pulseAnimation.value - 1.0) * 2),
                  blurRadius: 16 + (_pulseAnimation.value - 1.0) * 20,
                  spreadRadius: (_pulseAnimation.value - 1.0) * 5,
                  offset: Offset(0, 8),
                ),
              ],
            ),
            child: child,
          ),
        );
      },
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => QuickReleaseScreen()),
          );
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xFFFF9F43), Color(0xFFFF6B6B)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.flash_on, color: Colors.white, size: 24),
                            SizedBox(width: 8),
                            Text(
                              '快速释放',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 8),
                        Text(
                          '呼吸 · 宣泄 · 白噪音 · 冥想',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.white.withOpacity(0.9),
                          ),
                        ),
                        SizedBox(height: 12),
                        Container(
                          padding: EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.25),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Text(
                                '立即开始',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14,
                                ),
                              ),
                              SizedBox(width: 4),
                              Icon(
                                Icons.arrow_forward,
                                color: Colors.white,
                                size: 18,
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 16),
                  Container(
                    width: 70,
                    height: 70,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.2),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.play_arrow_rounded,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGrowthProgress(BuildContext context) {
    final totalRecords = widget.userStats?.totalRecords ?? 0;
    final treeStage = _getTreeStage(totalRecords);
    final treeName = _getTreeName(totalRecords);
    final nextMilestone = _getNextMilestone(totalRecords);
    final progress = totalRecords / nextMilestone;

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => EmotionGrowthTree()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF2DD4BF).withOpacity(0.15),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          children: [
            Row(
              children: [
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        Color(0xFF2DD4BF).withOpacity(0.2),
                        Color(0xFF2DD4BF).withOpacity(0.1),
                      ],
                    ),
                    shape: BoxShape.circle,
                  ),
                  child: Center(
                    child: Text(treeStage, style: TextStyle(fontSize: 30)),
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            '情绪成长树',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Color(0xFF2DD4BF).withOpacity(0.1),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Text(
                              treeName,
                              style: TextStyle(
                                fontSize: 11,
                                color: Color(0xFF2DD4BF),
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 8),
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: LinearProgressIndicator(
                          value: progress > 1 ? 1 : progress,
                          minHeight: 8,
                          backgroundColor: Colors.grey[200],
                          valueColor: AlwaysStoppedAnimation(Color(0xFF2DD4BF)),
                        ),
                      ),
                      SizedBox(height: 6),
                      Text(
                        '$totalRecords / $nextMilestone 次记录升级',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: Colors.grey[400]),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCheckInCard() {
    final canCheckInToday = widget.checkInStreak >= 0;

    return GestureDetector(
      onTap: widget.onCheckIn,
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFD700).withOpacity(0.15),
              Color(0xFFFFD700).withOpacity(0.05),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: Color(0xFFFFD700).withOpacity(0.3),
            width: 2,
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xFFFFD700).withOpacity(0.4),
                    blurRadius: 8,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Icon(Icons.calendar_today, color: Colors.white, size: 24),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '每日签到',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4),
                  Row(
                    children: [
                      Icon(
                        Icons.local_fire_department,
                        size: 16,
                        color: Color(0xFFFF9F43),
                      ),
                      SizedBox(width: 4),
                      Text(
                        '已连续 ${widget.checkInStreak} 天',
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey[700],
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: Color(0xFFFFD700),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '签到',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDailyTipCard() {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Color(0xFF2DD4BF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              Icons.lightbulb_outline,
              color: Color(0xFF2DD4BF),
              size: 22,
            ),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Text(
              _getDailyTip(),
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey[700],
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _getGreeting() {
    final hour = DateTime.now().hour;
    if (hour < 6) return '夜深了 🌙';
    if (hour < 9) return '早上好 ☀️';
    if (hour < 12) return '上午好 🌤️';
    if (hour < 14) return '中午好 🌞';
    if (hour < 18) return '下午好 🌅';
    if (hour < 22) return '晚上好 🌆';
    return '晚安 🌙';
  }

  String _getDailyTip() {
    final tips = [
      '深呼吸是最简单的情绪调节方法，试试4-7-8呼吸法',
      '记录情绪能帮助你更好地认识自己，发现模式',
      '每天花5分钟冥想，长期坚持效果显著',
      '运动是缓解焦虑的最佳方式之一，哪怕只是散步',
      '和朋友聊天能减轻心理压力，不要独自承受',
      '写感恩日记能提升幸福感，记录3件小事就好',
      '保证充足睡眠对情绪很重要，今晚早点休息',
      '喝杯温水，给身体一个温柔的提醒',
      '听一首喜欢的歌，让音乐治愈心灵',
      '给自己一个拥抱，你值得被温柔对待',
    ];
    return tips[DateTime.now().day % tips.length];
  }

  String _getTreeStage(int records) {
    if (records >= 100) return '🌳';
    if (records >= 50) return '🌲';
    if (records >= 30) return '🌴';
    if (records >= 15) return '🌿';
    if (records >= 7) return '🌱';
    if (records >= 1) return '🌰';
    return '🟫';
  }

  String _getTreeName(int records) {
    if (records >= 100) return '参天大树';
    if (records >= 50) return '茂盛森林';
    if (records >= 30) return '热带棕榈';
    if (records >= 15) return '茁壮成长';
    if (records >= 7) return '嫩绿新芽';
    if (records >= 1) return '种子萌芽';
    return '等待播种';
  }

  int _getNextMilestone(int records) {
    if (records < 1) return 1;
    if (records < 7) return 7;
    if (records < 15) return 15;
    if (records < 30) return 30;
    if (records < 50) return 50;
    if (records < 100) return 100;
    return 200;
  }
}

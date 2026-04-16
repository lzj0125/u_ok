import 'package:flutter/material.dart';
import '../services/achievement_service.dart';
import '../models/achievement.dart';

class EmotionGrowthTree extends StatefulWidget {
  @override
  _EmotionGrowthTreeState createState() => _EmotionGrowthTreeState();
}

class _EmotionGrowthTreeState extends State<EmotionGrowthTree> {
  UserStats? _stats;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadStats();
  }

  Future<void> _loadStats() async {
    final stats = await AchievementService.instance.getUserStats();
    setState(() {
      _stats = stats;
      _isLoading = false;
    });
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('情绪成长树'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1F2937),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: EdgeInsets.all(24),
              child: Column(
                children: [
                  SizedBox(height: 20),
                  Text(
                    '每次记录都让你的心灵之树成长',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 32),
                  Container(
                    width: 200,
                    height: 200,
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Color(0xFF2DD4BF).withOpacity(0.2),
                          blurRadius: 20,
                          spreadRadius: 5,
                        ),
                      ],
                    ),
                    child: Center(
                      child: Text(
                        _getTreeStage(_stats?.totalRecords ?? 0),
                        style: TextStyle(fontSize: 100),
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  Text(
                    _getTreeName(_stats?.totalRecords ?? 0),
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF2DD4BF),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '已记录 ${_stats?.totalRecords ?? 0} 次情绪',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                  SizedBox(height: 32),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              '下一个目标',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.grey[600],
                              ),
                            ),
                            Text(
                              '${_stats?.totalRecords ?? 0} / ${_getNextMilestone(_stats?.totalRecords ?? 0)}',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: Color(0xFF2DD4BF),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(height: 12),
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value:
                                (_stats?.totalRecords ?? 0) /
                                        _getNextMilestone(
                                          _stats?.totalRecords ?? 0,
                                        ) >
                                    1
                                ? 1
                                : (_stats?.totalRecords ?? 0) /
                                      _getNextMilestone(
                                        _stats?.totalRecords ?? 0,
                                      ),
                            minHeight: 10,
                            backgroundColor: Colors.grey[200],
                            valueColor: AlwaysStoppedAnimation(
                              Color(0xFF2DD4BF),
                            ),
                          ),
                        ),
                        SizedBox(height: 8),
                        Text(
                          '再记录 ${_getNextMilestone(_stats?.totalRecords ?? 0) - (_stats?.totalRecords ?? 0)} 次即可升级',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    padding: EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [
                          Color(0xFF2DD4BF).withOpacity(0.1),
                          Color(0xFF2DD4BF).withOpacity(0.05),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Icon(Icons.info_outline, color: Color(0xFF2DD4BF)),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            '持续记录情绪，见证你的心灵成长之旅',
                            style: TextStyle(
                              fontSize: 13,
                              color: Colors.grey[700],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32),
                ],
              ),
            ),
    );
  }
}

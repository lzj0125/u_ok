import 'package:flutter/material.dart';
import 'dart:async';

class MeditationGuide extends StatefulWidget {
  @override
  _MeditationGuideState createState() => _MeditationGuideState();
}

class _MeditationGuideState extends State<MeditationGuide> {
  bool _isMeditating = false;
  int _remainingSeconds = 300; // 5分钟
  Timer? _timer;
  int _currentStep = 0;

  final List<Map<String, String>> _steps = [
    {'title': '准备阶段', 'instruction': '找个舒适的姿势坐下，闭上眼睛', 'duration': '30秒'},
    {'title': '深呼吸', 'instruction': '慢慢吸气4秒，屏息4秒，呼气6秒', 'duration': '2分钟'},
    {'title': '身体扫描', 'instruction': '从头顶到脚尖，感受每个部位', 'duration': '1.5分钟'},
    {'title': '正念觉察', 'instruction': '观察当下的想法，不做评判', 'duration': '1分钟'},
  ];

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startMeditation() {
    setState(() {
      _isMeditating = true;
      _remainingSeconds = 300;
      _currentStep = 0;
    });

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        if (_remainingSeconds > 0) {
          _remainingSeconds--;

          if (_remainingSeconds == 270) _currentStep = 1;
          if (_remainingSeconds == 150) _currentStep = 2;
          if (_remainingSeconds == 60) _currentStep = 3;
        } else {
          _timer?.cancel();
          _isMeditating = false;
          _showCompletionDialog();
        }
      });
    });
  }

  void _stopMeditation() {
    _timer?.cancel();
    setState(() {
      _isMeditating = false;
    });
  }

  void _showCompletionDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.self_improvement, size: 64, color: Color(0xFF2DD4BF)),
            SizedBox(height: 16),
            Text(
              '冥想完成！',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              '恭喜你完成了5分钟冥想练习',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text('好的', style: TextStyle(color: Color(0xFF2DD4BF))),
          ),
        ],
      ),
    );
  }

  String _formatTime(int seconds) {
    final minutes = seconds ~/ 60;
    final secs = seconds % 60;
    return '${minutes.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '快速冥想',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '5分钟，让心灵回归平静',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 32),
          Container(
            width: 200,
            height: 200,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: LinearGradient(
                colors: [
                  Color(0xFF2DD4BF).withOpacity(0.2),
                  Color(0xFF2DD4BF).withOpacity(0.4),
                ],
              ),
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF2DD4BF).withOpacity(0.3),
                  blurRadius: 30,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    _formatTime(_remainingSeconds),
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _isMeditating ? '冥想中...' : '准备开始',
                    style: TextStyle(fontSize: 14, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 32),
          if (!_isMeditating)
            ElevatedButton(
              onPressed: _startMeditation,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56),
                backgroundColor: Color(0xFF2DD4BF),
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                '开始冥想',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            )
          else
            ElevatedButton(
              onPressed: _stopMeditation,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 56),
                backgroundColor: Colors.red[400],
                foregroundColor: Colors.white,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
              ),
              child: Text(
                '结束冥想',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          SizedBox(height: 32),
          Expanded(
            child: ListView.builder(
              itemCount: _steps.length,
              itemBuilder: (context, index) {
                final step = _steps[index];
                final isActive = _isMeditating && _currentStep == index;
                final isCompleted = _isMeditating && _currentStep > index;

                return Container(
                  margin: EdgeInsets.only(bottom: 12),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isActive
                        ? Color(0xFF2DD4BF).withOpacity(0.1)
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: isActive ? Color(0xFF2DD4BF) : Colors.grey[300]!,
                      width: isActive ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          color: isCompleted
                              ? Color(0xFF2DD4BF)
                              : isActive
                              ? Color(0xFF2DD4BF).withOpacity(0.2)
                              : Colors.grey[200],
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: isCompleted
                              ? Icon(Icons.check, color: Colors.white, size: 20)
                              : Text(
                                  '${index + 1}',
                                  style: TextStyle(
                                    color: isActive
                                        ? Color(0xFF2DD4BF)
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                        ),
                      ),
                      SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              step['title']!,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF1F2937),
                              ),
                            ),
                            SizedBox(height: 4),
                            Text(
                              step['instruction']!,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey[600],
                              ),
                            ),
                          ],
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          step['duration']!,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

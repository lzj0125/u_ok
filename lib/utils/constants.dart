import 'package:flutter/material.dart';

class AppConstants {
  static const List<String> presetScenes = [
    '工作',
    '家庭',
    '事业',
    '健康',
    '社交',
    '经济',
    '其他',
  ];

  static const Map<int, String> emotionLabels = {1: '焦虑', 2: '身心劳累', 3: '抑郁'};

  static const Map<int, Color> emotionColors = {
    1: Color(0xFFFF9F43), // 焦虑 - 温暖橙色
    2: Color(0xFF5F9EA0), // 劳累 - 柔和蓝绿
    3: Color(0xFF6C5CE7), // 抑郁 - 优雅紫色
  };

  static const Map<int, String> timePeriods = {
    0: '凌晨',
    1: '上午',
    2: '下午',
    3: '晚上',
  };
}

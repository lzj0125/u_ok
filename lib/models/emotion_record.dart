class EmotionRecord {
  final int? id;
  final int emotionType; // 1=焦虑, 2=劳累, 3=抑郁
  final int intensity; // 1-10
  final String scene; // 预设场景
  final String? customScene; // 自定义场景
  final String? note; // 备注
  final DateTime createdAt;
  final int weekDay; // 1-7
  final int timePeriod; // 0=凌晨, 1=上午, 2=下午, 3=晚上

  EmotionRecord({
    this.id,
    required this.emotionType,
    required this.intensity,
    required this.scene,
    this.customScene,
    this.note,
    required this.createdAt,
    required this.weekDay,
    required this.timePeriod,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'emotion_type': emotionType,
      'intensity': intensity,
      'scene': scene,
      'custom_scene': customScene,
      'note': note,
      'created_at': createdAt.toIso8601String(),
      'week_day': weekDay,
      'time_period': timePeriod,
    };
  }

  factory EmotionRecord.fromMap(Map<String, dynamic> map) {
    return EmotionRecord(
      id: map['id'],
      emotionType: map['emotion_type'],
      intensity: map['intensity'],
      scene: map['scene'],
      customScene: map['custom_scene'],
      note: map['note'],
      createdAt: DateTime.parse(map['created_at']),
      weekDay: map['week_day'],
      timePeriod: map['time_period'],
    );
  }
}

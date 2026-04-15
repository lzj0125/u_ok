class DetectiveLog {
  final int? id;
  final int recordId; // 外键，关联 EmotionRecord
  final String? thoughtBefore;
  final String? worstCase;
  final int? probability; // 0-100
  final String? smallAction;

  DetectiveLog({
    this.id,
    required this.recordId,
    this.thoughtBefore,
    this.worstCase,
    this.probability,
    this.smallAction,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'record_id': recordId,
      'thought_before': thoughtBefore,
      'worst_case': worstCase,
      'probability': probability,
      'small_action': smallAction,
    };
  }

  factory DetectiveLog.fromMap(Map<String, dynamic> map) {
    return DetectiveLog(
      id: map['id'],
      recordId: map['record_id'],
      thoughtBefore: map['thought_before'],
      worstCase: map['worst_case'],
      probability: map['probability'],
      smallAction: map['small_action'],
    );
  }
}

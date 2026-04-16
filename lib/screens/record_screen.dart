import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/emotion_record.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import '../providers/app_state_provider.dart';
import 'detective_screen.dart';

class RecordScreen extends StatefulWidget {
  @override
  _RecordScreenState createState() => _RecordScreenState();
}

class _RecordScreenState extends State<RecordScreen> {
  int? _selectedEmotion;
  int _intensity = 5;
  String _selectedScene = AppConstants.presetScenes.first;
  String? _customScene;
  final TextEditingController _noteController = TextEditingController();

  late DateTime _now;
  late int _weekDay;
  late int _timePeriod;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _weekDay = _now.weekday;
    final hour = _now.hour;
    if (hour < 6)
      _timePeriod = 0;
    else if (hour < 12)
      _timePeriod = 1;
    else if (hour < 18)
      _timePeriod = 2;
    else
      _timePeriod = 3;
  }

  void _submitRecord() async {
    if (_selectedEmotion == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('请选择一种情绪')));
      return;
    }

    final record = EmotionRecord(
      emotionType: _selectedEmotion!,
      intensity: _intensity,
      scene: _selectedScene,
      customScene: _selectedScene == '其他' ? _customScene : null,
      note: _noteController.text.isEmpty ? null : _noteController.text,
      createdAt: _now,
      weekDay: _weekDay,
      timePeriod: _timePeriod,
    );

    final db = DatabaseService.instance;
    final recordId = await db.insertRecord(record);

    final isPro = Provider.of<AppStateProvider>(context, listen: false).isPro;

    if (isPro) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DetectiveScreen(recordId: recordId)),
      );
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('记录成功')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('记录此刻'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1F2937),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '选择情绪',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: AppConstants.emotionLabels.entries.map((entry) {
                final isSelected = _selectedEmotion == entry.key;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedEmotion = entry.key;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppConstants.emotionColors[entry.key]
                          : Colors.white,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? AppConstants.emotionColors[entry.key]!
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                      boxShadow: isSelected
                          ? [
                              BoxShadow(
                                color: AppConstants.emotionColors[entry.key]!
                                    .withOpacity(0.3),
                                blurRadius: 10,
                                offset: Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Text(
                      entry.value,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
            SizedBox(height: 32),

            Text(
              '强度',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 12),
            Container(
              padding: EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 10,
                    offset: Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('1', style: TextStyle(color: Colors.grey[600])),
                      Text(
                        '$_intensity',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2DD4BF),
                        ),
                      ),
                      Text('10', style: TextStyle(color: Colors.grey[600])),
                    ],
                  ),
                  SliderTheme(
                    data: SliderThemeData(
                      activeTrackColor: Color(0xFF2DD4BF),
                      inactiveTrackColor: Colors.grey[300],
                      thumbColor: Color(0xFF2DD4BF),
                      overlayColor: Color(0xFF2DD4BF).withOpacity(0.2),
                      thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12),
                    ),
                    child: Slider(
                      value: _intensity.toDouble(),
                      min: 1,
                      max: 10,
                      divisions: 9,
                      onChanged: (val) {
                        setState(() {
                          _intensity = val.toInt();
                        });
                      },
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: 32),

            Text(
              '场景',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 12),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: AppConstants.presetScenes.map((scene) {
                final isSelected = _selectedScene == scene;
                return GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedScene = scene;
                    });
                  },
                  child: AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected ? Color(0xFF2DD4BF) : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? Color(0xFF2DD4BF)
                            : Colors.grey[300]!,
                        width: 2,
                      ),
                    ),
                    child: Text(
                      scene,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: isSelected ? Colors.white : Colors.grey[700],
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            if (_selectedScene == '其他') ...[
              SizedBox(height: 16),
              TextField(
                decoration: InputDecoration(
                  labelText: '输入自定义场景',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                ),
                onChanged: (val) => _customScene = val,
              ),
            ],
            SizedBox(height: 32),

            Text(
              '备注 (可选)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1F2937),
              ),
            ),
            SizedBox(height: 12),
            TextField(
              controller: _noteController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                hintText: '记录下此刻的想法...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                filled: true,
                fillColor: Colors.white,
                contentPadding: EdgeInsets.all(16),
              ),
            ),
            SizedBox(height: 40),

            ElevatedButton(
              onPressed: _submitRecord,
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
                '保存记录',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
            SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}

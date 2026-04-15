import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../models/emotion_record.dart';
import '../services/database_service.dart';
import '../utils/constants.dart';
import '../providers/app_state_provider.dart';
import 'detective_screen.dart'; // 下一步跳转

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

  // 自动生成的字段
  late DateTime _now;
  late int _weekDay;
  late int _timePeriod;

  @override
  void initState() {
    super.initState();
    _now = DateTime.now();
    _weekDay = _now.weekday; // 1-7
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

    // 判断是否进入侦探追问模块
    final isPro = Provider.of<AppStateProvider>(context, listen: false).isPro;

    if (isPro) {
      // 跳转到侦探追问页，传入 recordId
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => DetectiveScreen(recordId: recordId)),
      );
    } else {
      // 免费用户直接保存并返回
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('记录成功')));
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('记录此刻')),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            // 1. 情绪选择
            Text(
              '选择情绪',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: AppConstants.emotionLabels.entries.map((entry) {
                final isSelected = _selectedEmotion == entry.key;
                return ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: isSelected
                        ? AppConstants.emotionColors[entry.key]
                        : Colors.grey[200],
                    foregroundColor: isSelected ? Colors.white : Colors.black,
                  ),
                  onPressed: () {
                    setState(() {
                      _selectedEmotion = entry.key;
                    });
                  },
                  child: Text(entry.value),
                );
              }).toList(),
            ),
            SizedBox(height: 20),

            // 2. 强度滑动条
            Text('强度: $_intensity', style: TextStyle(fontSize: 16)),
            Slider(
              value: _intensity.toDouble(),
              min: 1,
              max: 10,
              divisions: 9,
              label: _intensity.toString(),
              onChanged: (val) {
                setState(() {
                  _intensity = val.toInt();
                });
              },
            ),
            SizedBox(height: 20),

            // 3. 场景选择
            Text(
              '场景',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: AppConstants.presetScenes.map((scene) {
                  final isSelected = _selectedScene == scene;
                  return Padding(
                    padding: EdgeInsets.only(right: 8),
                    child: FilterChip(
                      label: Text(scene),
                      selected: isSelected,
                      onSelected: (bool selected) {
                        setState(() {
                          _selectedScene = scene;
                        });
                      },
                    ),
                  );
                }).toList(),
              ),
            ),

            // 自定义场景输入
            if (_selectedScene == '其他') ...[
              SizedBox(height: 10),
              TextField(
                decoration: InputDecoration(labelText: '输入自定义场景'),
                onChanged: (val) => _customScene = val,
              ),
            ],
            SizedBox(height: 20),

            // 4. 文字备注
            TextField(
              controller: _noteController,
              maxLines: 4,
              maxLength: 500,
              decoration: InputDecoration(
                labelText: '备注 (可选)',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 30),

            // 5. 提交按钮
            ElevatedButton(
              onPressed: _submitRecord,
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Theme.of(context).primaryColor,
              ),
              child: Text(
                '保存记录',
                style: TextStyle(color: Colors.white, fontSize: 18),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

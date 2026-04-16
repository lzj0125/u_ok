import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class GratitudeJournal extends StatefulWidget {
  @override
  _GratitudeJournalState createState() => _GratitudeJournalState();
}

class _GratitudeJournalState extends State<GratitudeJournal> {
  final List<TextEditingController> _controllers = [
    TextEditingController(),
    TextEditingController(),
    TextEditingController(),
  ];
  Map<String, List<String>> _journalEntries = {};
  String _todayKey = '';

  @override
  void initState() {
    super.initState();
    _todayKey = _getTodayKey();
    _loadTodayEntries();
  }

  String _getTodayKey() {
    final now = DateTime.now();
    return '${now.year}-${now.month}-${now.day}';
  }

  Future<void> _loadTodayEntries() async {
    final prefs = await SharedPreferences.getInstance();
    final data = prefs.getString('gratitude_journal');
    if (data != null) {
      final Map<String, dynamic> jsonData = jsonDecode(data);
      setState(() {
        _journalEntries = jsonData.map(
          (key, value) => MapEntry(key, List<String>.from(value)),
        );

        final todayEntries = _journalEntries[_todayKey] ?? [];
        for (int i = 0; i < todayEntries.length && i < 3; i++) {
          _controllers[i].text = todayEntries[i];
        }
      });
    }
  }

  Future<void> _saveEntries() async {
    final entries = _controllers
        .map((c) => c.text.trim())
        .where((t) => t.isNotEmpty)
        .toList();

    setState(() {
      _journalEntries[_todayKey] = entries;
    });

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('gratitude_journal', jsonEncode(_journalEntries));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('感恩日记保存成功！'),
        backgroundColor: Color(0xFF2DD4BF),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  @override
  void dispose() {
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '感恩日记',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '每天记录3件让你感恩的事',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          Container(
            padding: EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Color(0xFFFFF9E6),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Color(0xFFFFD700).withOpacity(0.3)),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFFFFD700)),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '研究表明，记录感恩事项能显著提升幸福感',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(height: 24),
          for (int i = 0; i < 3; i++) ...[
            Container(
              margin: EdgeInsets.only(bottom: 16),
              padding: EdgeInsets.all(16),
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 32,
                        height: 32,
                        decoration: BoxDecoration(
                          color: Color(0xFF2DD4BF),
                          shape: BoxShape.circle,
                        ),
                        child: Center(
                          child: Text(
                            '${i + 1}',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text(
                        '今天感恩的第${i + 1}件事',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 12),
                  TextField(
                    controller: _controllers[i],
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: '例如：感谢朋友的关心...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Color(0xFFF8F9FA),
                      contentPadding: EdgeInsets.all(12),
                    ),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _saveEntries,
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
              '保存今日感恩',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
            ),
          ),
          SizedBox(height: 20),
        ],
      ),
    );
  }
}

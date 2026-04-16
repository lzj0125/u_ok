import 'package:flutter/material.dart';
import '../models/detective_log.dart';
import '../services/database_service.dart';

class DetectiveScreen extends StatefulWidget {
  final int recordId;
  const DetectiveScreen({Key? key, required this.recordId}) : super(key: key);

  @override
  _DetectiveScreenState createState() => _DetectiveScreenState();
}

class _DetectiveScreenState extends State<DetectiveScreen> {
  final TextEditingController _thoughtCtrl = TextEditingController();
  final TextEditingController _worstCtrl = TextEditingController();
  final TextEditingController _actionCtrl = TextEditingController();
  double _probability = 50;
  bool _skipAll = false;

  void _saveAndFinish() async {
    if (_skipAll) {
      Navigator.pop(context);
      return;
    }

    final log = DetectiveLog(
      recordId: widget.recordId,
      thoughtBefore: _thoughtCtrl.text.isEmpty ? null : _thoughtCtrl.text,
      worstCase: _worstCtrl.text.isEmpty ? null : _worstCtrl.text,
      probability: _probability.toInt(),
      smallAction: _actionCtrl.text.isEmpty ? null : _actionCtrl.text,
    );

    await DatabaseService.instance.insertDetectiveLog(log);

    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('深度记录完成')));
    Navigator.popUntil(context, (route) => route.isFirst);
  }

  @override
  Widget build(BuildContext context) {
    if (_skipAll) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _saveAndFinish());
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('侦探追问'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1F2937),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _skipAll = true;
              });
            },
            child: Text(
              '跳过',
              style: TextStyle(
                color: Color(0xFF2DD4BF),
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(24),
        child: ListView(
          children: [
            _buildQuestionCard(
              number: '1',
              title: '事件前想法',
              subtitle: '记录时你脑子里闪过了什么？',
              child: TextField(
                controller: _thoughtCtrl,
                maxLines: 3,
                decoration: InputDecoration(
                  hintText: '写下你的第一反应...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(height: 16),
            _buildQuestionCard(
              number: '2',
              title: '现实检验',
              subtitle: '最坏的结果是什么？',
              child: Column(
                children: [
                  TextField(
                    controller: _worstCtrl,
                    decoration: InputDecoration(
                      hintText: '描述最坏的情况...',
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.all(16),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    '实际发生的概率？',
                    style: TextStyle(fontSize: 14, color: Colors.grey[700]),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      Text(
                        '${_probability.toInt()}%',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF2DD4BF),
                        ),
                      ),
                      Expanded(
                        child: SliderTheme(
                          data: SliderThemeData(
                            activeTrackColor: Color(0xFF2DD4BF),
                            inactiveTrackColor: Colors.grey[300],
                            thumbColor: Color(0xFF2DD4BF),
                            overlayColor: Color(0xFF2DD4BF).withOpacity(0.2),
                          ),
                          child: Slider(
                            value: _probability,
                            min: 0,
                            max: 100,
                            divisions: 100,
                            onChanged: (val) {
                              setState(() {
                                _probability = val;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: 16),
            _buildQuestionCard(
              number: '3',
              title: '微小行动',
              subtitle: '如果重来，你会做哪一点不同？',
              child: TextField(
                controller: _actionCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  hintText: '写下你的行动计划...',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(16),
                ),
              ),
            ),
            SizedBox(height: 32),
            ElevatedButton(
              onPressed: _saveAndFinish,
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
                '完成记录',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildQuestionCard({
    required String number,
    required String title,
    required String subtitle,
    required Widget child,
  }) {
    return Container(
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
                    number,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF1F2937),
                      ),
                    ),
                    Text(
                      subtitle,
                      style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                    ),
                  ],
                ),
              ),
            ],
          ),
          SizedBox(height: 16),
          child,
        ],
      ),
    );
  }
}

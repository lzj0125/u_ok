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
    Navigator.popUntil(context, (route) => route.isFirst); // 返回首页
  }

  @override
  Widget build(BuildContext context) {
    if (_skipAll) {
      // 如果跳过，显示一个简单的确认或直接返回逻辑，这里简化为直接调用保存
      WidgetsBinding.instance.addPostFrameCallback((_) => _saveAndFinish());
      return Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text('侦探追问'),
        actions: [
          TextButton(
            onPressed: () {
              setState(() {
                _skipAll = true;
              });
            },
            child: Text('跳过全部', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16),
        child: ListView(
          children: [
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '1. 事件前想法',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text('记录时你脑子里闪过了什么？', style: TextStyle(color: Colors.grey)),
                    SizedBox(height: 8),
                    TextField(
                      controller: _thoughtCtrl,
                      maxLines: 3,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '2. 现实检验',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 8),
                    Text('最坏的结果是什么？'),
                    TextField(
                      controller: _worstCtrl,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                    SizedBox(height: 12),
                    Text('实际发生的概率？ (${_probability.toInt()}%)'),
                    Slider(
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
                  ],
                ),
              ),
            ),
            SizedBox(height: 16),
            Card(
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '3. 微小行动',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                    Text(
                      '如果重来，你会做哪一点不同？',
                      style: TextStyle(color: Colors.grey),
                    ),
                    SizedBox(height: 8),
                    TextField(
                      controller: _actionCtrl,
                      maxLines: 2,
                      decoration: InputDecoration(border: OutlineInputBorder()),
                    ),
                  ],
                ),
              ),
            ),
            SizedBox(height: 30),
            ElevatedButton(
              onPressed: _saveAndFinish,
              child: Text('完成记录'),
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

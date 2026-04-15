import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';

class SubscriptionScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<AppStateProvider>(context);

    return Scaffold(
      appBar: AppBar(title: Text('升级专业版')),
      body: Padding(
        padding: EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.diamond, size: 80, color: Colors.amber),
            SizedBox(height: 20),
            Text(
              '解锁全部高级功能',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 20),
            _buildFeatureItem('🕵️ 侦探追问模块'),
            _buildFeatureItem('📊 深度洞察分析'),
            _buildFeatureItem('📤 数据导出与备份'),
            _buildFeatureItem('🏷️ 自定义场景标签'),
            Spacer(),
            ElevatedButton(
              onPressed: provider.isPro
                  ? null
                  : () {
                      provider.upgradeToPro();
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('感谢支持！已升级为专业版')));
                      Navigator.pop(context);
                    },
              style: ElevatedButton.styleFrom(
                minimumSize: Size(double.infinity, 50),
                backgroundColor: Colors.amber,
              ),
              child: Text(provider.isPro ? '已是专业版' : '立即解锁 (¥18/月)'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildFeatureItem(String text) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green),
          SizedBox(width: 10),
          Text(text, style: TextStyle(fontSize: 16)),
        ],
      ),
    );
  }
}

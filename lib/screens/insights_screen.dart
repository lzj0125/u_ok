import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_state_provider.dart';
import '../widgets/pro_lock_overlay.dart';

class InsightsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPro = Provider.of<AppStateProvider>(context).isPro;

    return ProLockOverlay(
      isPro: isPro,
      child: Scaffold(
        appBar: AppBar(
          title: Text('洞察分析'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1F2937),
        ),
        body: Center(
          child: Text(
            '这里是热力图、词云和趋势曲线...',
            style: TextStyle(color: Colors.grey[600]),
          ),
        ),
      ),
    );
  }
}

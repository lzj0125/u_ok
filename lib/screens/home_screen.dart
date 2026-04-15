import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'record_screen.dart';
import 'insights_screen.dart';
import 'settings_screen.dart';
import 'subscription_screen.dart';
import '../providers/app_state_provider.dart';
import '../widgets/pro_lock_overlay.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = [
    RecordScreen(), // 实际上RecordScreen通常作为独立页面push进去，这里为了Tab结构简化，假设首页是Dashboard
    InsightsScreenPlaceholder(),
    SettingsScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        items: [
          BottomNavigationBarItem(icon: Icon(Icons.edit_note), label: '记录'),
          BottomNavigationBarItem(icon: Icon(Icons.insights), label: '洞察'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: '设置'),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // 点击大按钮直接进入记录流程
          Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => RecordScreen()),
          );
        },
        label: Text('记一笔'),
        icon: Icon(Icons.add),
      ),
    );
  }
}

// 占位符：洞察分析页
class InsightsScreenPlaceholder extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final isPro = Provider.of<AppStateProvider>(context).isPro;

    return ProLockOverlay(
      isPro: isPro,
      child: Scaffold(
        appBar: AppBar(title: Text('洞察分析')),
        body: Center(child: Text('这里是热力图、词云和趋势曲线...')),
      ),
    );
  }
}

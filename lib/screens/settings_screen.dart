import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('设置与隐私')),
      body: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.visibility_off),
            title: Text('伪装图标'),
            subtitle: Text('将APP图标伪装为计算器'),
            trailing: Switch(value: false, onChanged: (val) {}),
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.warning_amber_rounded, color: Colors.red),
            title: Text('危机干预'),
            subtitle: Text('显示心理援助热线'),
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: Text('紧急求助'),
                  content: Text('如果您感到极度痛苦，请拨打心理援助热线：xxx-xxxx-xxxx'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text('关闭'),
                    ),
                  ],
                ),
              );
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.notifications),
            title: Text('通知开关'),
            trailing: Switch(value: true, onChanged: (val) {}),
          ),
        ],
      ),
    );
  }
}

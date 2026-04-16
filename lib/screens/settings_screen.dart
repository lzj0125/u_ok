import 'package:flutter/material.dart';

class SettingsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('设置与隐私'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1F2937),
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        children: [
          _buildSettingCard(
            icon: Icons.visibility_off_rounded,
            title: '伪装图标',
            subtitle: '将APP图标伪装为计算器',
            trailing: Switch(
              value: false,
              onChanged: (val) {},
              activeColor: Color(0xFF2DD4BF),
            ),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.warning_amber_rounded,
            title: '危机干预',
            subtitle: '显示心理援助热线',
            iconColor: Colors.red,
            onTap: () {
              showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  title: Text('紧急求助'),
                  content: Text('如果您感到极度痛苦，请拨打心理援助热线：xxx-xxxx-xxxx'),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: Text(
                        '关闭',
                        style: TextStyle(color: Color(0xFF2DD4BF)),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.notifications_rounded,
            title: '通知开关',
            subtitle: '接收每日提醒',
            trailing: Switch(
              value: true,
              onChanged: (val) {},
              activeColor: Color(0xFF2DD4BF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSettingCard({
    required IconData icon,
    required String title,
    required String subtitle,
    Widget? trailing,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
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
        child: Row(
          children: [
            Container(
              padding: EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: (iconColor ?? Color(0xFF2DD4BF)).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: iconColor ?? Color(0xFF2DD4BF)),
            ),
            SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1F2937),
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: TextStyle(fontSize: 13, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
            if (trailing != null) trailing,
            if (trailing == null && onTap != null)
              Icon(Icons.chevron_right, color: Colors.grey[400]),
          ],
        ),
      ),
    );
  }
}

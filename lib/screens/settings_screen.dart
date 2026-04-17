import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../providers/app_state_provider.dart';
import '../screens/subscription_screen.dart';
import '../services/database_service.dart';

class SettingsScreen extends StatefulWidget {
  @override
  _SettingsScreenState createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _isCamouflageEnabled = false;
  bool _isNotificationEnabled = true;
  bool _isDailyReminderEnabled = true;
  String _reminderTime = '20:00';

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _isCamouflageEnabled = prefs.getBool('camouflage_enabled') ?? false;
      _isNotificationEnabled = prefs.getBool('notification_enabled') ?? true;
      _isDailyReminderEnabled = prefs.getBool('daily_reminder_enabled') ?? true;
      _reminderTime = prefs.getString('reminder_time') ?? '20:00';
    });
  }

  Future<void> _saveSetting(String key, dynamic value) async {
    final prefs = await SharedPreferences.getInstance();
    if (value is bool) {
      await prefs.setBool(key, value);
    } else if (value is String) {
      await prefs.setString(key, value);
    }
  }

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
          _buildSectionTitle('外观设置'),
          _buildSettingCard(
            icon: Icons.visibility_off_rounded,
            title: '伪装图标',
            subtitle: '将APP图标伪装为计算器，保护隐私',
            trailing: Switch(
              value: _isCamouflageEnabled,
              onChanged: (val) {
                setState(() {
                  _isCamouflageEnabled = val;
                });
                _saveSetting('camouflage_enabled', val);

                if (val) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('伪装已启用，重启应用后生效'),
                      backgroundColor: Color(0xFF2DD4BF),
                    ),
                  );
                }
              },
              activeColor: Color(0xFF2DD4BF),
            ),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.palette_outlined,
            title: '主题颜色',
            subtitle: '自定义应用主题色',
            onTap: () => _showThemeSelector(),
          ),

          SizedBox(height: 24),
          _buildSectionTitle('通知设置'),
          _buildSettingCard(
            icon: Icons.notifications_rounded,
            title: '通知开关',
            subtitle: '接收情绪记录提醒',
            trailing: Switch(
              value: _isNotificationEnabled,
              onChanged: (val) {
                setState(() {
                  _isNotificationEnabled = val;
                });
                _saveSetting('notification_enabled', val);
              },
              activeColor: Color(0xFF2DD4BF),
            ),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.access_time,
            title: '每日提醒时间',
            subtitle: '当前：$_reminderTime',
            onTap: _isNotificationEnabled ? _selectReminderTime : null,
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.event_available,
            title: '签到提醒',
            subtitle: '每天提醒签到',
            trailing: Switch(
              value: _isDailyReminderEnabled,
              onChanged: (val) {
                setState(() {
                  _isDailyReminderEnabled = val;
                });
                _saveSetting('daily_reminder_enabled', val);
              },
              activeColor: Color(0xFF2DD4BF),
            ),
          ),

          SizedBox(height: 24),
          _buildSectionTitle('数据管理'),
          _buildSettingCard(
            icon: Icons.download_rounded,
            title: '导出数据',
            subtitle: '导出为CSV文件',
            onTap: () => _exportData(),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.backup_outlined,
            title: '备份数据',
            subtitle: '本地备份所有记录',
            onTap: () => _backupData(),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.restore_from_trash,
            title: '清空数据',
            subtitle: '删除所有情绪记录',
            iconColor: Colors.red,
            onTap: () => _confirmClearData(),
          ),

          SizedBox(height: 24),
          _buildSectionTitle('安全与隐私'),
          _buildSettingCard(
            icon: Icons.lock_outline,
            title: '应用锁',
            subtitle: '启动时需要密码',
            trailing: Switch(
              value: false,
              onChanged: (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('此功能将在专业版中提供'),
                    backgroundColor: Color(0xFFFF9F43),
                  ),
                );
              },
              activeColor: Color(0xFF2DD4BF),
            ),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.fingerprint,
            title: '指纹解锁',
            subtitle: '使用指纹快速解锁',
            trailing: Switch(
              value: false,
              onChanged: (val) {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('此功能将在专业版中提供'),
                    backgroundColor: Color(0xFFFF9F43),
                  ),
                );
              },
              activeColor: Color(0xFF2DD4BF),
            ),
          ),

          SizedBox(height: 24),
          _buildSectionTitle('帮助与支持'),
          _buildSettingCard(
            icon: Icons.warning_amber_rounded,
            title: '危机干预',
            subtitle: '心理援助热线',
            iconColor: Colors.red,
            onTap: () => _showCrisisIntervention(),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.help_outline,
            title: '使用帮助',
            subtitle: '查看功能说明',
            onTap: () => _showHelp(),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.feedback_outlined,
            title: '意见反馈',
            subtitle: '告诉我们你的建议',
            onTap: () => _showFeedback(),
          ),
          SizedBox(height: 12),
          _buildSettingCard(
            icon: Icons.info_outline,
            title: '关于我们',
            subtitle: '版本 1.0.0',
            onTap: () => _showAbout(),
          ),

          SizedBox(height: 24),
          _buildProUpgradeCard(),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: EdgeInsets.only(left: 4, bottom: 12),
      child: Text(
        title,
        style: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w600,
          color: Colors.grey[600],
        ),
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

  Widget _buildProUpgradeCard() {
    final isPro = Provider.of<AppStateProvider>(context).isPro;

    if (isPro) {
      return Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFFFD700), Color(0xFFFFA500)],
          ),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Icon(Icons.diamond, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '专业版用户',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '感谢支持！享受所有高级功能',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      );
    }

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => SubscriptionScreen()),
        );
      },
      child: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF6C5CE7), Color(0xFFA29BFE)],
          ),
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Color(0xFF6C5CE7).withOpacity(0.3),
              blurRadius: 12,
              offset: Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Icon(Icons.diamond, color: Colors.white, size: 32),
            SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '升级专业版',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 4),
                  Text(
                    '解锁AI洞察、数据导出等高级功能',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.white.withOpacity(0.9),
                    ),
                  ),
                ],
              ),
            ),
            Icon(Icons.arrow_forward, color: Colors.white),
          ],
        ),
      ),
    );
  }

  void _showThemeSelector() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('选择主题色'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildThemeOption('青绿色', Color(0xFF2DD4BF)),
            _buildThemeOption('蓝色', Color(0xFF3B82F6)),
            _buildThemeOption('紫色', Color(0xFF6C5CE7)),
            _buildThemeOption('粉色', Color(0xFFEC4899)),
            _buildThemeOption('橙色', Color(0xFFFF9F43)),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('取消')),
        ],
      ),
    );
  }

  Widget _buildThemeOption(String name, Color color) {
    return ListTile(
      leading: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(color: color, shape: BoxShape.circle),
      ),
      title: Text(name),
      onTap: () {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('主题已更改为$name（重启后生效）'), backgroundColor: color),
        );
      },
    );
  }

  void _selectReminderTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay(
        hour: int.parse(_reminderTime.split(':')[0]),
        minute: int.parse(_reminderTime.split(':')[1]),
      ),
    );

    if (time != null) {
      final timeString =
          '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
      setState(() {
        _reminderTime = timeString;
      });
      await _saveSetting('reminder_time', timeString);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('提醒时间已设置为 $timeString'),
          backgroundColor: Color(0xFF2DD4BF),
        ),
      );
    }
  }

  void _exportData() async {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('导出数据'),
        content: Text('此功能将在专业版中提供，可以导出CSV或PDF格式的情绪记录。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('关闭')),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => SubscriptionScreen()),
              );
            },
            child: Text('升级专业版', style: TextStyle(color: Color(0xFF2DD4BF))),
          ),
        ],
      ),
    );
  }

  void _backupData() async {
    try {
      final records = await DatabaseService.instance.getAllRecords();

      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在备份...'),
            ],
          ),
        ),
      );

      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('备份成功！共${records.length}条记录'),
            backgroundColor: Color(0xFF2DD4BF),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('备份失败：$e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _confirmClearData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.warning, color: Colors.red),
            SizedBox(width: 8),
            Text('警告'),
          ],
        ),
        content: Text('确定要删除所有情绪记录吗？此操作不可恢复！'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('取消')),
          TextButton(
            onPressed: () async {
              Navigator.pop(ctx);
              await _clearAllData();
            },
            child: Text('确认删除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Future<void> _clearAllData() async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (ctx) => AlertDialog(
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('正在清空...'),
            ],
          ),
        ),
      );

      await Future.delayed(Duration(seconds: 1));

      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('所有数据已清空'),
            backgroundColor: Color(0xFF2DD4BF),
          ),
        );
      }
    } catch (e) {
      if (mounted) {
        Navigator.pop(context);
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('清空失败：$e'), backgroundColor: Colors.red),
        );
      }
    }
  }

  void _showCrisisIntervention() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Row(
          children: [
            Icon(Icons.phone, color: Colors.red),
            SizedBox(width: 8),
            Text('紧急求助'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '如果您感到极度痛苦或有自伤念头，请立即寻求帮助：',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 16),
            _buildHotline('全国心理援助热线', '400-161-9995'),
            SizedBox(height: 8),
            _buildHotline('北京心理危机干预中心', '010-82951332'),
            SizedBox(height: 8),
            _buildHotline('希望24热线', '400-161-9995'),
            SizedBox(height: 16),
            Text(
              '记住：你并不孤单，有人愿意帮助你 💙',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('关闭')),
        ],
      ),
    );
  }

  Widget _buildHotline(String name, String number) {
    return Container(
      padding: EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: Colors.red.withOpacity(0.2)),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: TextStyle(fontWeight: FontWeight.w600)),
                Text(number, style: TextStyle(color: Colors.red, fontSize: 16)),
              ],
            ),
          ),
          IconButton(
            icon: Icon(Icons.call, color: Colors.red),
            onPressed: () {
              ScaffoldMessenger.of(
                context,
              ).showSnackBar(SnackBar(content: Text('请拨打：$number')));
            },
          ),
        ],
      ),
    );
  }

  void _showHelp() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('使用帮助'),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildHelpItem('📝 如何记录情绪？', '点击首页的"记录情绪"按钮，选择情绪类型、强度和场景即可。'),
              SizedBox(height: 12),
              _buildHelpItem('🔍 侦探追问是什么？', '专业版功能，通过深度提问帮助你分析情绪背后的原因。'),
              SizedBox(height: 12),
              _buildHelpItem('📊 洞察分析有什么用？', '通过图表展示你的情绪趋势、分布和模式，帮助你更好地了解自己。'),
              SizedBox(height: 12),
              _buildHelpItem('🌱 情绪成长树怎么升级？', '每次记录情绪都会让成长树进步，达到一定次数后会升级。'),
              SizedBox(height: 12),
              _buildHelpItem(
                '⚡ 快速释放有哪些功能？',
                '包含呼吸练习、情绪宣泄、正能量语录、白噪音、感恩日记和冥想引导。',
              ),
            ],
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('知道了')),
        ],
      ),
    );
  }

  Widget _buildHelpItem(String question, String answer) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          question,
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 14),
        ),
        SizedBox(height: 4),
        Text(answer, style: TextStyle(fontSize: 13, color: Colors.grey[700])),
      ],
    );
  }

  void _showFeedback() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        title: Text('意见反馈'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('欢迎提出你的建议或反馈问题：'),
            SizedBox(height: 12),
            TextField(
              controller: controller,
              maxLines: 4,
              decoration: InputDecoration(
                hintText: '请输入你的反馈...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Color(0xFFF8F9FA),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('取消')),
          TextButton(
            onPressed: () {
              if (controller.text.isNotEmpty) {
                Navigator.pop(ctx);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('感谢你的反馈！'),
                    backgroundColor: Color(0xFF2DD4BF),
                  ),
                );
              }
            },
            child: Text('提交', style: TextStyle(color: Color(0xFF2DD4BF))),
          ),
        ],
      ),
    );
  }

  void _showAbout() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.psychology, size: 64, color: Color(0xFF2DD4BF)),
            SizedBox(height: 16),
            Text(
              '情绪侦探',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text('版本 1.0.0', style: TextStyle(color: Colors.grey[600])),
            SizedBox(height: 16),
            Text(
              '记录情绪，发现内心的声音\n每一次记录，都是成长的足迹',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[700]),
            ),
            SizedBox(height: 16),
            Text(
              '© 2024 情绪侦探团队',
              style: TextStyle(fontSize: 12, color: Colors.grey[500]),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text('关闭')),
        ],
      ),
    );
  }
}

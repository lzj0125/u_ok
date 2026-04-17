import 'package:flutter/material.dart';
import 'dart:math' as math;
import 'white_noise_player.dart';
import 'gratitude_journal.dart';
import 'meditation_guide.dart';

class QuickReleaseScreen extends StatefulWidget {
  @override
  _QuickReleaseScreenState createState() => _QuickReleaseScreenState();
}

class _QuickReleaseScreenState extends State<QuickReleaseScreen>
    with SingleTickerProviderStateMixin {
  int _currentMode = 0;
  late AnimationController _breathController;
  String _currentQuote = '';
  final TextEditingController _worryController = TextEditingController();
  bool _isShredding = false;
  bool _isShredded = false;

  final List<String> _quotes = [
    "每一次呼吸，都是重新开始的机会 🌱",
    "你比想象中更坚强 💪",
    "允许自己不完美，这才是完美 ✨",
    "今天的努力，明天的礼物 🎁",
    "慢慢来，比较快 🐢",
    "你已经做得很好了 👏",
    "阳光总在风雨后 🌈",
    "照顾好自己的心情，这是最重要的事 💝",
    "压力是成长的催化剂 🔥",
    "今天也要好好爱自己 💕",
  ];

  @override
  void initState() {
    super.initState();
    _breathController = AnimationController(
      duration: Duration(seconds: 19),
      vsync: this,
    )..repeat();
    _currentQuote = _quotes[math.Random().nextInt(_quotes.length)];

    _worryController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _breathController.dispose();
    _worryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFFF8F9FA),
      appBar: AppBar(
        title: Text('快速释放'),
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Color(0xFF1F2937),
      ),
      body: Column(
        children: [
          Container(
            margin: EdgeInsets.all(16),
            padding: EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  _buildModeTab(0, '🫁 呼吸', Icons.air),
                  _buildModeTab(1, '💭 宣泄', Icons.delete_outline),
                  _buildModeTab(2, '✨ 能量', Icons.lightbulb_outline),
                  _buildModeTab(3, '🎵 白噪音', Icons.music_note),
                  _buildModeTab(4, '🙏 感恩', Icons.favorite),
                  _buildModeTab(5, '🧘 冥想', Icons.self_improvement),
                ],
              ),
            ),
          ),
          Expanded(
            child: IndexedStack(
              index: _currentMode,
              children: [
                _buildBreathingExercise(),
                _buildWorryShredder(),
                _buildQuoteCard(),
                WhiteNoisePlayer(),
                GratitudeJournal(),
                MeditationGuide(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeTab(int index, String label, IconData icon) {
    final isSelected = _currentMode == index;
    return GestureDetector(
      onTap: () => setState(() => _currentMode = index),
      child: AnimatedContainer(
        duration: Duration(milliseconds: 200),
        margin: EdgeInsets.symmetric(horizontal: 4),
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF2DD4BF) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? Colors.white : Colors.grey[600],
            ),
            SizedBox(width: 4),
            Text(
              label.substring(2),
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: isSelected ? Colors.white : Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBreathingExercise() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            '跟随节奏呼吸',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '4秒吸气 · 7秒屏息 · 8秒呼气',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 70),
          AnimatedBuilder(
            animation: _breathController,
            builder: (context, child) {
              final value = _breathController.value;
              double scale = 1.0;
              String instruction = '';

              if (value < 0.21) {
                scale = 1.0 + (value / 0.21) * 0.8;
                instruction = '吸气...';
              } else if (value < 0.58) {
                scale = 1.8;
                instruction = '屏住...';
              } else {
                scale = 1.8 - ((value - 0.58) / 0.42) * 0.8;
                instruction = '呼气...';
              }

              return Column(
                children: [
                  Transform.scale(
                    scale: scale,
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: LinearGradient(
                          colors: [
                            Color(0xFF2DD4BF).withOpacity(0.3),
                            Color(0xFF2DD4BF).withOpacity(0.6),
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Color(0xFF2DD4BF).withOpacity(0.4),
                            blurRadius: 30,
                            spreadRadius: 5,
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 70),
                  Text(
                    instruction,
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2DD4BF),
                    ),
                  ),
                ],
              );
            },
          ),
          SizedBox(height: 60),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              '深呼吸能激活副交感神经，帮助你快速放松',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 13, color: Colors.grey[600]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWorryShredder() {
    if (_isShredded) {
      return _buildShreddedSuccess();
    }

    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '写下你的烦恼',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '写下来，然后让它消失',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          Expanded(
            child: AnimatedOpacity(
              opacity: _isShredding ? 0.3 : 1.0,
              duration: Duration(milliseconds: 300),
              child: TextField(
                controller: _worryController,
                maxLines: null,
                expands: true,
                textAlignVertical: TextAlignVertical.top,
                decoration: InputDecoration(
                  hintText: '把困扰你的事情写在这里...\n\n写完点击下方的按钮，看着它被粉碎',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  filled: true,
                  fillColor: Colors.white,
                  contentPadding: EdgeInsets.all(20),
                ),
                enabled: !_isShredding,
              ),
            ),
          ),
          SizedBox(height: 16),
          ElevatedButton(
            onPressed: _worryController.text.trim().isEmpty || _isShredding
                ? null
                : _shredWorry,
            style: ElevatedButton.styleFrom(
              minimumSize: Size(double.infinity, 56),
              backgroundColor: _isShredding ? Colors.grey : Color(0xFFFF6B6B),
              disabledBackgroundColor: Colors.grey[300],
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
            ),
            child: _isShredding
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          valueColor: AlwaysStoppedAnimation(Colors.white),
                        ),
                      ),
                      SizedBox(width: 12),
                      Text('粉碎中...', style: TextStyle(color: Colors.white)),
                    ],
                  )
                : Text(
                    '🗑️ 粉碎烦恼',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildShreddedSuccess() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 600),
            builder: (context, double value, child) {
              return Transform.scale(
                scale: value,
                child: Opacity(
                  opacity: value,
                  child: Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      color: Color(0xFF2DD4BF).withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.check_circle,
                      size: 80,
                      color: Color(0xFF2DD4BF),
                    ),
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 32),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 800),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: Transform.translate(
                  offset: Offset(0, 20 * (1 - value)),
                  child: Column(
                    children: [
                      Text(
                        '烦恼已粉碎！',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF1F2937),
                        ),
                      ),
                      SizedBox(height: 12),
                      Text(
                        '记住，你能掌控自己的情绪',
                        style: TextStyle(fontSize: 16, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 48),
          TweenAnimationBuilder(
            tween: Tween<double>(begin: 0.0, end: 1.0),
            duration: Duration(milliseconds: 1000),
            builder: (context, double value, child) {
              return Opacity(
                opacity: value,
                child: ElevatedButton.icon(
                  onPressed: () {
                    setState(() {
                      _isShredded = false;
                      _worryController.clear();
                    });
                  },
                  icon: Icon(Icons.refresh),
                  label: Text('再写一个'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF2DD4BF),
                    foregroundColor: Colors.white,
                    padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _shredWorry() async {
    setState(() => _isShredding = true);

    await Future.delayed(Duration(milliseconds: 1500));

    if (mounted) {
      setState(() {
        _isShredding = false;
        _isShredded = true;
      });
    }
  }

  Widget _buildQuoteCard() {
    return Center(
      child: Padding(
        padding: EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.format_quote,
              size: 48,
              color: Color(0xFF2DD4BF).withOpacity(0.3),
            ),
            SizedBox(height: 24),
            Text(
              _currentQuote,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1F2937),
                height: 1.6,
              ),
            ),
            SizedBox(height: 40),
            ElevatedButton.icon(
              onPressed: () {
                setState(() {
                  _currentQuote =
                      _quotes[math.Random().nextInt(_quotes.length)];
                });
              },
              icon: Icon(Icons.refresh),
              label: Text('换一句'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Color(0xFF2DD4BF),
                foregroundColor: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            SizedBox(height: 40),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Color(0xFF2DD4BF).withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  Icon(Icons.lightbulb, color: Color(0xFF2DD4BF), size: 20),
                  SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      '每天给自己一点正能量，积少成多',
                      style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';

class WhiteNoisePlayer extends StatefulWidget {
  @override
  _WhiteNoisePlayerState createState() => _WhiteNoisePlayerState();
}

class _WhiteNoisePlayerState extends State<WhiteNoisePlayer> {
  final AudioPlayer _audioPlayer = AudioPlayer();
  String? _currentSound;
  bool _isPlaying = false;
  double _volume = 0.5;

  final List<Map<String, dynamic>> _sounds = [
    {
      'id': 'rain',
      'name': '雨声',
      'icon': '🌧️',
      'asset': 'assets/sounds/rain.mp3',
    },
    {
      'id': 'ocean',
      'name': '海浪',
      'icon': '🌊',
      'asset': 'assets/sounds/ocean.mp3',
    },
    {
      'id': 'forest',
      'name': '森林',
      'icon': '🌲',
      'asset': 'assets/sounds/forest.mp3',
    },
    {
      'id': 'fire',
      'name': '篝火',
      'icon': '🔥',
      'asset': 'assets/sounds/fire.mp3',
    },
    {
      'id': 'wind',
      'name': '微风',
      'icon': '💨',
      'asset': 'assets/sounds/wind.mp3',
    },
    {
      'id': 'night',
      'name': '夜晚',
      'icon': '🌙',
      'asset': 'assets/sounds/night.mp3',
    },
  ];

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  Future<void> _playSound(String soundId, String asset) async {
    if (_currentSound == soundId && _isPlaying) {
      await _audioPlayer.pause();
      setState(() {
        _isPlaying = false;
      });
    } else {
      await _audioPlayer.stop();
      await _audioPlayer.setSourceAsset(asset);
      await _audioPlayer.setVolume(_volume);
      await _audioPlayer.setReleaseMode(ReleaseMode.loop);
      await _audioPlayer.resume();
      setState(() {
        _currentSound = soundId;
        _isPlaying = true;
      });
    }
  }

  Future<void> _setVolume(double value) async {
    await _audioPlayer.setVolume(value);
    setState(() {
      _volume = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(24),
      child: Column(
        children: [
          Text(
            '白噪音放松',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 8),
          Text(
            '选择喜欢的声音，帮助放松和专注',
            style: TextStyle(fontSize: 14, color: Colors.grey[600]),
          ),
          SizedBox(height: 24),
          GridView.builder(
            shrinkWrap: true,
            physics: NeverScrollableScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 1.3,
            ),
            itemCount: _sounds.length,
            itemBuilder: (context, index) {
              final sound = _sounds[index];
              final isSelected = _currentSound == sound['id'];
              return GestureDetector(
                onTap: () => _playSound(sound['id'], sound['asset']),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isSelected ? Color(0xFF2DD4BF) : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isSelected ? Color(0xFF2DD4BF) : Colors.grey[300]!,
                      width: 2,
                    ),
                    boxShadow: isSelected
                        ? [
                            BoxShadow(
                              color: Color(0xFF2DD4BF).withOpacity(0.3),
                              blurRadius: 10,
                              offset: Offset(0, 5),
                            ),
                          ]
                        : [],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(sound['icon'], style: TextStyle(fontSize: 40)),
                      SizedBox(height: 8),
                      Text(
                        sound['name'],
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: isSelected ? Colors.white : Colors.grey[700],
                        ),
                      ),
                      if (isSelected && _isPlaying)
                        Padding(
                          padding: EdgeInsets.only(top: 4),
                          child: Icon(
                            Icons.volume_up,
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                    ],
                  ),
                ),
              );
            },
          ),
          if (_isPlaying) ...[
            SizedBox(height: 24),
            Container(
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(Icons.volume_down, color: Colors.grey[600]),
                      Expanded(
                        child: Slider(
                          value: _volume,
                          min: 0,
                          max: 1,
                          divisions: 10,
                          activeColor: Color(0xFF2DD4BF),
                          onChanged: _setVolume,
                        ),
                      ),
                      Icon(Icons.volume_up, color: Colors.grey[600]),
                    ],
                  ),
                  SizedBox(height: 8),
                  Text(
                    '音量: ${(_volume * 100).toInt()}%',
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ],
          SizedBox(height: 16),
          Container(
            padding: EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Color(0xFF2DD4BF).withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              children: [
                Icon(Icons.lightbulb, color: Color(0xFF2DD4BF), size: 20),
                SizedBox(width: 12),
                Expanded(
                  child: Text(
                    '白噪音能帮助屏蔽干扰，提升专注力和放松效果',
                    style: TextStyle(fontSize: 13, color: Colors.grey[700]),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

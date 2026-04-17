import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../providers/app_state_provider.dart';
import '../widgets/pro_lock_overlay.dart';
import '../services/database_service.dart';
import '../models/emotion_record.dart';
import '../utils/constants.dart';

class InsightsScreen extends StatefulWidget {
  @override
  _InsightsScreenState createState() => _InsightsScreenState();
}

class _InsightsScreenState extends State<InsightsScreen>
    with SingleTickerProviderStateMixin {
  List<EmotionRecord> _records = [];
  bool _isLoading = true;
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final records = await DatabaseService.instance.getAllRecords();
    setState(() {
      _records = records;
      _isLoading = false;
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isPro = Provider.of<AppStateProvider>(context).isPro;

    return ProLockOverlay(
      isPro: isPro,
      child: Scaffold(
        backgroundColor: Color(0xFFF8F9FA),
        appBar: AppBar(
          title: Text('洞察分析'),
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Color(0xFF1F2937),
          actions: [
            IconButton(icon: Icon(Icons.refresh), onPressed: _loadData),
          ],
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Color(0xFF2DD4BF),
            labelColor: Color(0xFF2DD4BF),
            unselectedLabelColor: Colors.grey[600],
            tabs: [
              Tab(text: '趋势'),
              Tab(text: '分布'),
              Tab(text: '分析'),
            ],
          ),
        ),
        body: _isLoading
            ? Center(child: CircularProgressIndicator())
            : _records.isEmpty
            ? _buildEmptyState()
            : TabBarView(
                controller: _tabController,
                children: [
                  _buildTrendTab(),
                  _buildDistributionTab(),
                  _buildAnalysisTab(),
                ],
              ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.insights, size: 80, color: Colors.grey[300]),
          SizedBox(height: 16),
          Text('暂无数据', style: TextStyle(fontSize: 18, color: Colors.grey[600])),
          SizedBox(height: 8),
          Text(
            '开始记录情绪后即可查看分析',
            style: TextStyle(fontSize: 14, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSummaryCards(),
          SizedBox(height: 24),
          _buildIntensityTrendChart(),
          SizedBox(height: 24),
          _buildWeeklyHeatmap(),
        ],
      ),
    );
  }

  Widget _buildDistributionTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildEmotionTypePieChart(),
          SizedBox(height: 24),
          _buildSceneDistribution(),
          SizedBox(height: 24),
          _buildTimePeriodChart(),
        ],
      ),
    );
  }

  Widget _buildAnalysisTab() {
    return SingleChildScrollView(
      padding: EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildInsightCard(
            icon: Icons.trending_up,
            title: '情绪趋势',
            content: _getEmotionTrendInsight(),
            color: Color(0xFF2DD4BF),
          ),
          SizedBox(height: 16),
          _buildInsightCard(
            icon: Icons.warning_amber,
            title: '高发场景',
            content: _getHighRiskSceneInsight(),
            color: Color(0xFFFF9F43),
          ),
          SizedBox(height: 16),
          _buildInsightCard(
            icon: Icons.schedule,
            title: '时间模式',
            content: _getTimePatternInsight(),
            color: Color(0xFF6C5CE7),
          ),
          SizedBox(height: 16),
          _buildInsightCard(
            icon: Icons.lightbulb,
            title: '改善建议',
            content: _getImprovementSuggestions(),
            color: Color(0xFFFFD700),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCards() {
    final totalRecords = _records.length;
    final avgIntensity = _records.isEmpty
        ? 0
        : _records.map((r) => r.intensity).reduce((a, b) => a + b) /
              totalRecords;
    final recentRecords = _records.take(7).toList();
    final recentAvg = recentRecords.isEmpty
        ? 0
        : recentRecords.map((r) => r.intensity).reduce((a, b) => a + b) /
              recentRecords.length;

    return Row(
      children: [
        Expanded(
          child: _buildSummaryCard(
            title: '总记录',
            value: '$totalRecords',
            subtitle: '次',
            icon: Icons.analytics,
            color: Color(0xFF2DD4BF),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: '平均强度',
            value: avgIntensity.toStringAsFixed(1),
            subtitle: '/10',
            icon: Icons.speed,
            color: Color(0xFFFF9F43),
          ),
        ),
        SizedBox(width: 12),
        Expanded(
          child: _buildSummaryCard(
            title: '近7天',
            value: recentAvg.toStringAsFixed(1),
            subtitle: '平均',
            icon: Icons.calendar_today,
            color: Color(0xFF6C5CE7),
          ),
        ),
      ],
    );
  }

  Widget _buildSummaryCard({
    required String title,
    required String value,
    required String subtitle,
    required IconData icon,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: color.withOpacity(0.1),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 28),
          SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 4),
          Text(title, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
          Text(
            subtitle,
            style: TextStyle(fontSize: 10, color: Colors.grey[500]),
          ),
        ],
      ),
    );
  }

  Widget _buildIntensityTrendChart() {
    final last30Days = _records
        .where((r) => DateTime.now().difference(r.createdAt).inDays <= 30)
        .toList();

    if (last30Days.isEmpty) {
      return _buildEmptyChartCard('最近30天无数据');
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < last30Days.length; i++) {
      final record = last30Days[last30Days.length - 1 - i];
      final daysAgo = DateTime.now().difference(record.createdAt).inDays;
      spots.add(FlSpot(daysAgo.toDouble(), record.intensity.toDouble()));
    }

    spots.sort((a, b) => a.x.compareTo(b.x));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '情绪强度趋势（30天）',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 2,
            child: LineChart(
              LineChartData(
                gridData: FlGridData(show: true, drawVerticalLine: false),
                titlesData: FlTitlesData(
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          value.toInt().toString(),
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: (value, meta) {
                        return Text(
                          '${value.toInt()}天前',
                          style: TextStyle(fontSize: 10),
                        );
                      },
                    ),
                  ),
                  rightTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  topTitles: AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: true,
                    color: Color(0xFF2DD4BF),
                    barWidth: 3,
                    dotData: FlDotData(show: true),
                    belowBarData: BarAreaData(
                      show: true,
                      color: Color(0xFF2DD4BF).withOpacity(0.1),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildWeeklyHeatmap() {
    final weekDayCounts = Map<int, int>.fromIterables(
      [1, 2, 3, 4, 5, 6, 7],
      [0, 0, 0, 0, 0, 0, 0],
    );

    for (var record in _records) {
      weekDayCounts[record.weekDay] = (weekDayCounts[record.weekDay] ?? 0) + 1;
    }

    final maxCount = weekDayCounts.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '每周情绪热力图',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [1, 2, 3, 4, 5, 6, 7].map((day) {
              final count = weekDayCounts[day] ?? 0;
              final intensity = maxCount > 0 ? count / maxCount : 0;
              return Column(
                children: [
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: Color(
                        0xFF2DD4BF,
                      ).withOpacity(0.2 + intensity * 0.8),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Center(
                      child: Text(
                        '$count',
                        style: TextStyle(
                          color: intensity > 0.5
                              ? Colors.white
                              : Colors.black87,
                          fontWeight: FontWeight.bold,
                          fontSize: 12,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    _getWeekDayName(day),
                    style: TextStyle(fontSize: 11, color: Colors.grey[600]),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildEmotionTypePieChart() {
    final emotionCounts = <int, int>{};
    for (var record in _records) {
      emotionCounts[record.emotionType] =
          (emotionCounts[record.emotionType] ?? 0) + 1;
    }

    if (emotionCounts.isEmpty) {
      return _buildEmptyChartCard('暂无情绪数据');
    }

    final sections = emotionCounts.entries.map((entry) {
      final percentage = entry.value / _records.length * 100;
      return PieChartSectionData(
        value: entry.value.toDouble(),
        title: '${percentage.toStringAsFixed(0)}%',
        radius: 60,
        color: AppConstants.emotionColors[entry.key] ?? Colors.grey,
        titleStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      );
    }).toList();

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(
            '情绪类型分布',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16),
          AspectRatio(
            aspectRatio: 1.3,
            child: PieChart(
              PieChartData(
                sections: sections,
                centerSpaceRadius: 40,
                sectionsSpace: 2,
              ),
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 12,
            runSpacing: 8,
            children: emotionCounts.entries.map((entry) {
              return Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 12,
                    height: 12,
                    decoration: BoxDecoration(
                      color: AppConstants.emotionColors[entry.key],
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(width: 4),
                  Text(
                    '${AppConstants.emotionLabels[entry.key]}: ${entry.value}',
                    style: TextStyle(fontSize: 12),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildSceneDistribution() {
    final sceneCounts = <String, int>{};
    for (var record in _records) {
      final scene = record.customScene ?? record.scene;
      sceneCounts[scene] = (sceneCounts[scene] ?? 0) + 1;
    }

    final sortedScenes = sceneCounts.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '场景分布 TOP 5',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16),
          ...sortedScenes.take(5).map((entry) {
            final percentage = entry.value / _records.length;
            return Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        entry.key,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      Text(
                        '${entry.value}次 (${(percentage * 100).toStringAsFixed(0)}%)',
                        style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                      ),
                    ],
                  ),
                  SizedBox(height: 6),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: percentage,
                      minHeight: 8,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation(Color(0xFF2DD4BF)),
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  Widget _buildTimePeriodChart() {
    final periodCounts = Map<int, int>.fromIterables(
      [0, 1, 2, 3],
      [0, 0, 0, 0],
    );

    for (var record in _records) {
      periodCounts[record.timePeriod] =
          (periodCounts[record.timePeriod] ?? 0) + 1;
    }

    final maxCount = periodCounts.values.reduce((a, b) => a > b ? a : b);

    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '时间段分布',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1F2937),
            ),
          ),
          SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [0, 1, 2, 3].map((period) {
              final count = periodCounts[period] ?? 0;
              final height = maxCount > 0 ? (count / maxCount) * 120 : 0.0;
              return Column(
                children: [
                  Container(
                    width: 50,
                    height: 120,
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        width: 40,
                        height: height,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF2DD4BF).withOpacity(0.6),
                              Color(0xFF2DD4BF),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                          ),
                          borderRadius: BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: count > 0
                            ? Center(
                                child: Text(
                                  '$count',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                  ),
                                ),
                              )
                            : null,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    AppConstants.timePeriods[period]!,
                    style: TextStyle(fontSize: 12, color: Colors.grey[600]),
                  ),
                ],
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildInsightCard({
    required IconData icon,
    required String title,
    required String content,
    required Color color,
  }) {
    return Container(
      padding: EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: color, size: 24),
          ),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF1F2937),
                  ),
                ),
                SizedBox(height: 6),
                Text(
                  content,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey[700],
                    height: 1.5,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmptyChartCard(String message) {
    return Container(
      padding: EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Center(
        child: Text(message, style: TextStyle(color: Colors.grey[600])),
      ),
    );
  }

  String _getWeekDayName(int day) {
    const names = ['一', '二', '三', '四', '五', '六', '日'];
    return '周${names[day - 1]}';
  }

  String _getEmotionTrendInsight() {
    if (_records.length < 3) {
      return '记录更多数据后，我们将为你分析情绪变化趋势。建议每天记录，连续7天就能看到明显的模式。';
    }

    final recent7 = _records.take(7).toList();
    final older7 = _records.skip(7).take(7).toList();

    if (older7.isEmpty) {
      return '继续记录吧！积累更多数据后，我们就能帮你发现情绪的周期性变化规律。';
    }

    final recentAvg =
        recent7.map((r) => r.intensity).reduce((a, b) => a + b) /
        recent7.length;
    final olderAvg =
        older7.map((r) => r.intensity).reduce((a, b) => a + b) / older7.length;

    if (recentAvg < olderAvg) {
      return '好消息！最近7天的平均情绪强度(${recentAvg.toStringAsFixed(1)})比之前(${olderAvg.toStringAsFixed(1)})有所下降，说明你的情绪状态在改善。继续保持！';
    } else if (recentAvg > olderAvg) {
      return '注意到最近7天的情绪强度(${recentAvg.toStringAsFixed(1)})略高于之前(${olderAvg.toStringAsFixed(1)})。试试快速释放功能中的呼吸练习或冥想，帮助缓解压力。';
    } else {
      return '你的情绪状态保持稳定。这是一个好迹象，说明你正在有效地管理自己的情绪。';
    }
  }

  String _getHighRiskSceneInsight() {
    final sceneCounts = <String, int>{};
    final sceneIntensities = <String, List<int>>{};

    for (var record in _records) {
      final scene = record.customScene ?? record.scene;
      sceneCounts[scene] = (sceneCounts[scene] ?? 0) + 1;
      sceneIntensities.putIfAbsent(scene, () => []).add(record.intensity);
    }

    if (sceneCounts.isEmpty) {
      return '记录更多数据后，我们会分析哪些场景最容易引发你的情绪波动。';
    }

    var highestScene = '';
    var highestAvg = 0.0;

    sceneIntensities.forEach((scene, intensities) {
      final avg = intensities.reduce((a, b) => a + b) / intensities.length;
      if (avg > highestAvg && sceneCounts[scene]! >= 2) {
        highestAvg = avg;
        highestScene = scene;
      }
    });

    if (highestScene.isEmpty) {
      return '继续记录，我们会帮你识别最容易触发情绪的场景。';
    }

    return '"$highestScene"是你情绪强度最高的场景（平均${highestAvg.toStringAsFixed(1)}/10）。建议在这个场景中尝试深呼吸或短暂休息，提前预防情绪波动。';
  }

  String _getTimePatternInsight() {
    final periodCounts = Map<int, int>.fromIterables(
      [0, 1, 2, 3],
      [0, 0, 0, 0],
    );
    final periodIntensities = <int, List<int>>{0: [], 1: [], 2: [], 3: []};

    for (var record in _records) {
      periodCounts[record.timePeriod] =
          (periodCounts[record.timePeriod] ?? 0) + 1;
      periodIntensities[record.timePeriod]!.add(record.intensity);
    }

    var peakPeriod = 0;
    var peakCount = 0;
    periodCounts.forEach((period, count) {
      if (count > peakCount) {
        peakCount = count;
        peakPeriod = period;
      }
    });

    final periodName = AppConstants.timePeriods[peakPeriod];
    return '你最常在$periodName记录情绪（$peakCount次）。这个时间段可能是你情绪波动较大的时候，建议提前做好准备，比如安排一些放松活动。';
  }

  String _getImprovementSuggestions() {
    final suggestions = <String>[];

    if (_records.length < 7) {
      suggestions.add('📝 坚持每天记录，连续7天解锁深度分析功能');
    }

    final highIntensityCount = _records.where((r) => r.intensity >= 7).length;
    if (highIntensityCount > 0) {
      final percentage = (highIntensityCount / _records.length * 100)
          .toStringAsFixed(0);
      suggestions.add('⚠️ $percentage%的记录强度较高，建议多使用快速释放功能');
    }

    final hasNoteRecords = _records
        .where((r) => r.note != null && r.note!.isNotEmpty)
        .length;
    if (hasNoteRecords < _records.length * 0.5) {
      suggestions.add('💭 添加备注能帮助你更好地反思，试着记录更多细节');
    }

    suggestions.add('🧘 每天花5分钟冥想，能有效降低情绪强度');
    suggestions.add('🌟 尝试感恩日记，记录3件让你开心的小事');

    return suggestions.join('\n\n');
  }
}

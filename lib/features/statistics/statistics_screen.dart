import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:fl_chart/fl_chart.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../data/models/hydration_stats.dart';
import '../../providers/stats_provider.dart';

class StatisticsScreen extends StatefulWidget {
  const StatisticsScreen({super.key});

  @override
  State<StatisticsScreen> createState() => _StatisticsScreenState();
}

class _StatisticsScreenState extends State<StatisticsScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<StatsProvider>().load();
    });
  }

  @override
  Widget build(BuildContext context) {
    final statsProvider = context.watch<StatsProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Hydration Statistics'),
      ),
      body: statsProvider.loading
          ? const Center(child: CircularProgressIndicator())
          : statsProvider.stats == null
              ? const Center(child: Text('Data tidak tersedia'))
              : _StatisticsBody(stats: statsProvider.stats!),
    );
  }
}

class _StatisticsBody extends StatelessWidget {
  final HydrationStats stats;

  const _StatisticsBody({required this.stats});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      children: [
        // Average AI score summary card
        _buildSummaryCard(),
        const SizedBox(height: 20),

        // Status distribution pie chart
        Text('Status Distribution', style: AppTextStyles.label),
        const SizedBox(height: 12),
        _buildPieCard(),
        const SizedBox(height: 20),

        // Weekly scores bar chart
        Text('Weekly AI Score', style: AppTextStyles.label),
        const SizedBox(height: 12),
        _buildBarCard(),
      ],
    );
  }

  Widget _buildSummaryCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Average AI Score',
                  style: AppTextStyles.bodyMedium
                      .copyWith(color: Colors.white70),
                ),
                const SizedBox(height: 4),
                Text(
                  '${stats.averageAiScore}%',
                  style: AppTextStyles.heading1
                      .copyWith(color: Colors.white, fontSize: 40),
                ),
                const SizedBox(height: 8),
                Text(
                  stats.hydrationLevel,
                  style: AppTextStyles.label.copyWith(color: Colors.white),
                ),
              ],
            ),
          ),
          Container(
            width: 72,
            height: 72,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop, color: Colors.white, size: 40),
          ),
        ],
      ),
    );
  }

  Widget _buildPieCard() {
    final sections = stats.statusDistribution;
    final colors = [
      AppColors.chartNormal,
      AppColors.chartRingan,
      AppColors.chartSedang,
      AppColors.chartBerat,
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sections: List.generate(sections.length, (i) {
                  final s = sections[i];
                  final color = i < colors.length ? colors[i] : AppColors.primary;
                  return PieChartSectionData(
                    value: s.percentage,
                    color: color,
                    title: '${s.percentage.toStringAsFixed(0)}%',
                    titleStyle: AppTextStyles.caption.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                    radius: 70,
                  );
                }),
                sectionsSpace: 3,
                centerSpaceRadius: 36,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: List.generate(sections.length, (i) {
              final color = i < colors.length ? colors[i] : AppColors.primary;
              return _LegendItem(
                color: color,
                label: sections[i].status,
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildBarCard() {
    final scores = stats.weeklyScores;
    final maxScore = scores.isEmpty
        ? 100
        : scores.map((s) => s.score).reduce((a, b) => a > b ? a : b);
    final yMax = (maxScore + 15.0).clamp(60.0, 120.0);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.cardShadow,
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: SizedBox(
        height: 220,
        child: BarChart(
          BarChartData(
            maxY: yMax,
            minY: 0,
            gridData: FlGridData(
              show: true,
              drawVerticalLine: false,
              horizontalInterval: 20,
              getDrawingHorizontalLine: (_) => FlLine(
                color: AppColors.divider,
                strokeWidth: 1,
              ),
            ),
            borderData: FlBorderData(show: false),
            titlesData: FlTitlesData(
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 32,
                  interval: 20,
                  getTitlesWidget: (value, _) => Text(
                    '${value.toInt()}',
                    style: AppTextStyles.caption,
                  ),
                ),
              ),
              bottomTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 28,
                  getTitlesWidget: (value, _) {
                    final i = value.toInt();
                    if (i < 0 || i >= scores.length) return const SizedBox();
                    return Padding(
                      padding: const EdgeInsets.only(top: 4),
                      child: Text(
                        scores[i].label,
                        style: AppTextStyles.caption,
                      ),
                    );
                  },
                ),
              ),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            ),
            barGroups: List.generate(scores.length, (i) {
              final score = scores[i].score;
              final color = score >= 85
                  ? AppColors.chartNormal
                  : score >= 70
                      ? AppColors.chartRingan
                      : AppColors.chartBerat;
              return BarChartGroupData(
                x: i,
                barRods: [
                  BarChartRodData(
                    toY: score.toDouble(),
                    color: color,
                    width: 18,
                    borderRadius: BorderRadius.circular(4),
                  ),
                ],
              );
            }),
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 4),
        Text(label, style: AppTextStyles.caption),
      ],
    );
  }
}

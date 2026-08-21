import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_brand.dart';
import '../../core/widgets/notification_panel.dart';
import '../../core/widgets/status_badge.dart';
import '../../providers/history_provider.dart';
import '../../providers/stats_provider.dart';
import '../../providers/user_provider.dart';
import '../../providers/nav_provider.dart';
import '../../data/models/history_item.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NavProvider>().setIndex(0);
    });
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    final stats = context.watch<StatsProvider>().stats;
    final history = context.watch<HistoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            Expanded(
              child: RefreshIndicator(
                onRefresh: () async {
                  final hp = context.read<HistoryProvider>();
                  final sp = context.read<StatsProvider>();
                  await hp.load();
                  if (!mounted) return;
                  await sp.load();
                },
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  children: [
                    _buildGreeting(user?.greeting ?? 'Hello 👋'),
                    const SizedBox(height: 16),
                    if (stats != null) _buildHydrationCard(stats.hydrationLevel, stats.currentAiScore),
                    const SizedBox(height: 16),
                    if (stats != null) _buildWeekStats(stats),
                    const SizedBox(height: 16),
                    _buildScanCard(context),
                    const SizedBox(height: 20),
                    _buildRecentHistory(context, history),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        children: [
          const AppBrand(),
          const Spacer(),
          Stack(
            children: [
              IconButton(
                icon: const Icon(Icons.notifications_outlined),
                onPressed: () => NotificationPanel.show(context),
              ),
              Positioned(
                right: 8,
                top: 8,
                child: Container(
                  width: 10,
                  height: 10,
                  decoration: const BoxDecoration(
                    color: AppColors.alertError,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildGreeting(String greeting) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(greeting, style: AppTextStyles.heading3),
        Text(
          'keep your body hydrated',
          style: AppTextStyles.bodySmall,
        ),
      ],
    );
  }

  Widget _buildHydrationCard(String level, int score) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 2)),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Hydration Level', style: AppTextStyles.bodySmall),
                const SizedBox(height: 4),
                Text(
                  level,
                  style: AppTextStyles.heading2.copyWith(
                    color: AppColors.normal,
                    fontSize: 28,
                  ),
                ),
                const SizedBox(height: 8),
                const Divider(),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text('Skor AI', style: AppTextStyles.bodySmall),
                    const SizedBox(width: 12),
                    Text(
                      '$score%',
                      style: AppTextStyles.label.copyWith(color: AppColors.primary),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.primary, width: 3),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.water_drop, color: AppColors.primary, size: 44),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekStats(dynamic stats) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("This Week's Statistics", style: AppTextStyles.heading3.copyWith(fontSize: 16)),
          const SizedBox(height: 12),
          Row(
            children: [
              _StatChip(label: 'Scan', value: stats.thisWeek.scan, icon: Icons.document_scanner_outlined),
              const SizedBox(width: 8),
              _StatChip(label: 'Normal', value: stats.thisWeek.normal, icon: Icons.check_circle_outline),
              const SizedBox(width: 8),
              _StatChip(label: 'Dehidrasi', value: stats.thisWeek.dehidrasi, icon: Icons.warning_outlined),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildScanCard(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.read<NavProvider>().setIndex(1);
        Navigator.of(context).pushNamed(AppRoutes.scan);
      },
      child: Container(
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: AppColors.scanCard,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Scan Urine',
                    style: AppTextStyles.heading3.copyWith(color: Colors.white),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Start urine color analysis',
                    style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                  ),
                ],
              ),
            ),
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.2),
                shape: BoxShape.circle,
              ),
              child: const Icon(Icons.camera_alt, color: Colors.white, size: 28),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentHistory(BuildContext context, HistoryProvider history) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Recent History', style: AppTextStyles.heading3.copyWith(fontSize: 16)),
            TextButton(
              onPressed: () {
                context.read<NavProvider>().setIndex(2);
                Navigator.of(context).pushNamed(AppRoutes.history);
              },
              child: Text('See All', style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            ),
          ],
        ),
        const SizedBox(height: 8),
        if (history.loading)
          const Center(child: CircularProgressIndicator())
        else if (history.recentItems.isEmpty)
          _EmptyHistory()
        else
          ...history.recentItems.map((item) => _HistoryCard(
                item: item,
                onTap: () => Navigator.of(context).pushNamed(
                  AppRoutes.result,
                  arguments: item,
                ),
              )),
      ],
    );
  }
}

class _StatChip extends StatelessWidget {
  final String label;
  final int value;
  final IconData icon;

  const _StatChip({required this.label, required this.value, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(
          color: AppColors.background,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          children: [
            Icon(icon, size: 22, color: AppColors.primary),
            const SizedBox(height: 4),
            Text('$value kali', style: AppTextStyles.bodySmall.copyWith(fontSize: 11)),
            Text(label, style: AppTextStyles.caption),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;

  const _HistoryCard({required this.item, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [BoxShadow(color: AppColors.cardShadow, blurRadius: 6, offset: const Offset(0, 1))],
        ),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.statusColor(item.status).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(Icons.water_drop, color: AppColors.statusColor(item.status), size: 22),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.date, style: AppTextStyles.label),
                  Text(item.time, style: AppTextStyles.caption),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(status: item.status),
                const SizedBox(height: 2),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

class _EmptyHistory extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'Belum ada riwayat scan.\nTekan Scan Urine untuk mulai.',
          style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}

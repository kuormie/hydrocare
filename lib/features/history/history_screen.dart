import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/status_badge.dart';
import '../../providers/history_provider.dart';
import '../../providers/nav_provider.dart';
import '../../data/models/history_item.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        context.read<NavProvider>().setIndex(2);
        context.read<HistoryProvider>().load();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>();

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('History'),
        actions: [
          IconButton(
            icon: const Icon(Icons.bar_chart, color: AppColors.primary),
            tooltip: 'Hydration Statistics',
            onPressed: () =>
                Navigator.of(context).pushNamed(AppRoutes.statistics),
          ),
        ],
      ),
      body: history.loading
          ? const Center(child: CircularProgressIndicator())
          : history.items.isEmpty
              ? Center(
                  child: Text(
                    'Belum ada riwayat scan.',
                    style: AppTextStyles.bodyMedium
                        .copyWith(color: AppColors.textSecondary),
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: history.items.length,
                  itemBuilder: (_, i) => _HistoryListItem(
                    item: history.items[i],
                    onTap: () => Navigator.of(context).pushNamed(
                      AppRoutes.result,
                      arguments: history.items[i],
                    ),
                  ),
                ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

class _HistoryListItem extends StatelessWidget {
  final HistoryItem item;
  final VoidCallback onTap;

  const _HistoryListItem({required this.item, required this.onTap});

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
          boxShadow: [
            BoxShadow(
              color: AppColors.cardShadow,
              blurRadius: 6,
              offset: const Offset(0, 1),
            ),
          ],
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
              child: Icon(
                Icons.water_drop,
                color: AppColors.statusColor(item.status),
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.date, style: AppTextStyles.label),
                  Text(item.time, style: AppTextStyles.caption),
                  Text(
                    'Skor AI: ${item.aiScore}%',
                    style: AppTextStyles.caption
                        .copyWith(color: AppColors.primary),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                StatusBadge(status: item.status),
              ],
            ),
            const SizedBox(width: 8),
            const Icon(Icons.arrow_forward_ios,
                size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

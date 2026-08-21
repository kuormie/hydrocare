import 'package:flutter/material.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/primary_button.dart';
import '../../core/widgets/status_badge.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/constants/app_strings.dart';
import '../../data/models/history_item.dart';
import 'dart:io';

class ResultScreen extends StatefulWidget {
  final HistoryItem? item;

  const ResultScreen({super.key, this.item});

  @override
  State<ResultScreen> createState() => _ResultScreenState();
}

class _ResultScreenState extends State<ResultScreen> {
  bool _saving = false;

  HistoryItem? get _item => widget.item;

  Future<void> _saveResults() async {
    setState(() => _saving = true);
    await Future.delayed(const Duration(milliseconds: 1200));
    if (!mounted) return;
    setState(() => _saving = false);

    await AppDialog.showSuccess(
      context,
      title: 'Tersimpan!',
      message: AppStrings.successSave,
      buttonLabel: 'Kembali',
      onPressed: () {
        Navigator.of(context).pop(); // tutup dialog
        Navigator.of(context).pushNamedAndRemoveUntil(
          AppRoutes.dashboard,
          (r) => false,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final item = _item;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: const Text('Analysis Results'),
      ),
      body: item == null
          ? const Center(child: Text('Data tidak tersedia'))
          : SafeArea(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  // Sample photo placeholder
                  Text('Sample Photos', style: AppTextStyles.label),
                  const SizedBox(height: 12),
                  Container(
  height: 220,
  decoration: BoxDecoration(
    borderRadius: BorderRadius.circular(16),
    border: Border.all(
      color: AppColors.statusColor(item.status),
      width: 2,
    ),
  ),
  clipBehavior: Clip.hardEdge,
  child: Image.file(
    File(item.imagePath),
    fit: BoxFit.cover,
    errorBuilder: (context, error, stackTrace) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.broken_image,
              size: 60,
              color: Colors.grey,
            ),
            const SizedBox(height: 8),
            Text(
              "Gambar tidak ditemukan",
              style: AppTextStyles.bodyMedium,
            ),
          ],
        ),
      );
    },
  ),
),
                  const SizedBox(height: 24),

                  // Color detected
                  Text('Color Detected', style: AppTextStyles.label),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.statusColor(item.status)
                                .withValues(alpha: 0.15),
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
                              Text(item.time,
                                  style: AppTextStyles.caption),
                              Text(item.urineColor,
                                  style: AppTextStyles.label),
                              Text(item.date,
                                  style: AppTextStyles.caption),
                            ],
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            StatusBadge(status: item.status),
                            const SizedBox(height: 4),
                            Text(
                              'Skor AI: ${item.aiScore}%',
                              style: AppTextStyles.caption.copyWith(
                                color: AppColors.primary,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Recommendations
                  Text('Recommedation', style: AppTextStyles.label),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.cardShadow,
                          blurRadius: 6,
                          offset: const Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Column(
                      children: item.recommendations
                          .map((rec) => Padding(
                                padding: const EdgeInsets.only(bottom: 12),
                                child: Row(
                                  crossAxisAlignment:
                                      CrossAxisAlignment.start,
                                  children: [
                                    const Icon(Icons.check_circle,
                                        color: AppColors.normal, size: 20),
                                    const SizedBox(width: 10),
                                    Expanded(
                                      child: Text(rec,
                                          style: AppTextStyles.bodyMedium),
                                    ),
                                  ],
                                ),
                              ))
                          .toList(),
                    ),
                  ),
                  const SizedBox(height: 32),

                  PrimaryButton(
                    label: 'Save Results',
                    onPressed: _saveResults,
                    loading: _saving,
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
    );
  }
}

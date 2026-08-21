import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_text_styles.dart';

enum DialogType { success, error }

class AppDialog extends StatelessWidget {
  final DialogType type;
  final String title;
  final String message;
  final String buttonLabel;
  final VoidCallback? onPressed;

  const AppDialog({
    super.key,
    required this.type,
    required this.title,
    required this.message,
    this.buttonLabel = 'OK',
    this.onPressed,
  });

  static Future<void> showSuccess(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'OK',
    VoidCallback? onPressed,
  }) =>
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (_) => AppDialog(
          type: DialogType.success,
          title: title,
          message: message,
          buttonLabel: buttonLabel,
          onPressed: onPressed,
        ),
      );

  static Future<void> showError(
    BuildContext context, {
    required String title,
    required String message,
    String buttonLabel = 'OK',
    VoidCallback? onPressed,
  }) =>
      showDialog(
        context: context,
        builder: (_) => AppDialog(
          type: DialogType.error,
          title: title,
          message: message,
          buttonLabel: buttonLabel,
          onPressed: onPressed,
        ),
      );

  @override
  Widget build(BuildContext context) {
    final isSuccess = type == DialogType.success;
    final color = isSuccess ? AppColors.alertSuccess : AppColors.alertError;
    final icon = isSuccess ? Icons.check_circle : Icons.error;

    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                color: color.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, color: color, size: 36),
            ),
            const SizedBox(height: 16),
            Text(
              title,
              style: AppTextStyles.heading3,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              message,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              height: 46,
              child: ElevatedButton(
                onPressed: onPressed ??
                    () => Navigator.of(context).pop(),
                style: ElevatedButton.styleFrom(
                  backgroundColor: color,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: Text(
                  buttonLabel,
                  style: AppTextStyles.button,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

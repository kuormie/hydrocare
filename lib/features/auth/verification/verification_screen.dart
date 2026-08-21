import 'dart:async';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/routes/app_routes.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../core/widgets/app_brand.dart';
import '../../../core/widgets/primary_button.dart';
import '../../../core/widgets/otp_boxes.dart';
import '../../../providers/auth_provider.dart';

class VerificationScreen extends StatefulWidget {
  const VerificationScreen({super.key});

  @override
  State<VerificationScreen> createState() => _VerificationScreenState();
}

class _VerificationScreenState extends State<VerificationScreen> {
  String _code = '';
  bool _loading = false;
  int _countdown = 0;
  Timer? _timer;

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _startResendTimer() {
    _timer?.cancel();
    setState(() => _countdown = 300);
    _timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      setState(() {
        if (_countdown > 0) {
          _countdown--;
        } else {
          t.cancel();
        }
      });
    });
  }

  String get _resendLabel {
    if (_countdown <= 0) return 'Resend';
    final m = _countdown ~/ 60;
    final s = _countdown % 60;
    return 'Resend (${m.toString().padLeft(2, '0')}:${s.toString().padLeft(2, '0')})';
  }

  Future<void> _submit() async {
    if (_code.length < 4) return;
    setState(() => _loading = true);
    await context.read<AuthProvider>().verify(_code);
    if (!mounted) return;
    setState(() => _loading = false);
    Navigator.of(context).pushReplacementNamed(AppRoutes.congrats);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 16),
              const Center(child: AppBrand(height: 44)),
              const SizedBox(height: 32),
              Text('Verification Email', style: AppTextStyles.heading2),
              const SizedBox(height: 8),
              Text(
                'Please enter the code we just sent to email',
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.textSecondary,
                ),
              ),
              Text(
                'user123@gmail.com',
                style: AppTextStyles.label.copyWith(color: AppColors.primary),
              ),
              const SizedBox(height: 48),
              OtpBoxes(
                onCompleted: (code) => setState(() => _code = code),
              ),
              const SizedBox(height: 24),
              Center(
                child: TextButton(
                  onPressed: _countdown > 0 ? null : _startResendTimer,
                  child: RichText(
                    text: TextSpan(
                      text: "If you didn't receive a code? ",
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.textSecondary,
                      ),
                      children: [
                        TextSpan(
                          text: _resendLabel,
                          style: AppTextStyles.label.copyWith(
                            color: _countdown > 0
                                ? AppColors.textSecondary
                                : AppColors.primary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 48),
              PrimaryButton(
                label: 'Continue',
                onPressed: _code.length == 4 ? _submit : null,
                loading: _loading,
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

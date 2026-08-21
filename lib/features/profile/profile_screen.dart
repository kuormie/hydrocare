import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_assets.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_bottom_nav.dart';
import '../../core/widgets/app_dialog.dart';
import '../../providers/nav_provider.dart';
import '../../providers/user_provider.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NavProvider>().setIndex(3);
    });
  }

  Future<void> _showPhotoOptions() async {
    await showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Ambil Foto'),
              onTap: () async {
                Navigator.pop(ctx);
                final image = await ImagePicker().pickImage(source: ImageSource.camera);
                if (image == null || !mounted) return;
                await context.read<UserProvider>().updatePhoto(image.path);
                if (!mounted) return;
                await AppDialog.showSuccess(context,
                    title: 'Berhasil!', message: 'Foto profil berhasil diperbarui');
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Pilih dari Galeri'),
              onTap: () async {
                Navigator.pop(ctx);
                final image = await ImagePicker().pickImage(source: ImageSource.gallery);
                if (image == null || !mounted) return;
                await context.read<UserProvider>().updatePhoto(image.path);
                if (!mounted) return;
                await AppDialog.showSuccess(context,
                    title: 'Berhasil!', message: 'Foto profil berhasil diperbarui');
              },
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Profile'),
        automaticallyImplyLeading: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // Header card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Stack(
                    children: [
                      CircleAvatar(
                        radius: 44,
                        backgroundImage: user?.profileImagePath != null
                            ? FileImage(File(user!.profileImagePath!))
                            : const AssetImage(AppAssets.profileDefault) as ImageProvider,
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: GestureDetector(
                          onTap: _showPhotoOptions,
                          child: CircleAvatar(
                            radius: 14,
                            backgroundColor: AppColors.primary,
                            child: Image.asset(
                              AppAssets.cameraOverlay,
                              width: 16,
                              height: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.name ?? '-',
                          style: AppTextStyles.heading3.copyWith(fontSize: 16),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        Text(
                          user?.email ?? '-',
                          style: AppTextStyles.bodySmall,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                          decoration: BoxDecoration(
                            color: AppColors.primaryLight,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            'Keep Your Body Hydrated',
                            style: AppTextStyles.caption.copyWith(color: AppColors.primary),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // User Information card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('User Information',
                      style: AppTextStyles.label.copyWith(fontSize: 15)),
                  const SizedBox(height: 8),
                  _InfoRow(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Berat Badan',
                    value: user?.beratBadan ?? '-',
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.height,
                    label: 'Tinggi Badan',
                    value: user?.tinggiBadan ?? '-',
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.wc,
                    label: 'Jenis Kelamin',
                    value: user?.jenisKelamin ?? '-',
                  ),
                  const Divider(height: 1),
                  _InfoRow(
                    icon: Icons.directions_run,
                    label: 'Aktivitas Harian',
                    value: user?.aktivitasHarian ?? '-',
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Setting card
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
              ),
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Setting', style: AppTextStyles.label.copyWith(fontSize: 15)),
                  const SizedBox(height: 8),
                  _SettingRow(
                    label: 'Notification',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur segera hadir')),
                    ),
                  ),
                  const Divider(height: 1),
                  _SettingRow(
                    label: 'About Software',
                    onTap: () => ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Fitur segera hadir')),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamed(AppRoutes.editProfile),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text('Edit Profile',
                    style: AppTextStyles.label.copyWith(color: AppColors.primary)),
              ),
            ),

            const SizedBox(height: 12),

            SizedBox(
              width: double.infinity,
              child: OutlinedButton(
                onPressed: () => Navigator.of(context).pushNamedAndRemoveUntil(
                  AppRoutes.login,
                  (r) => false,
                ),
                style: OutlinedButton.styleFrom(
                  side: const BorderSide(color: AppColors.alertError),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  minimumSize: const Size(double.infinity, 52),
                ),
                child: Text('Logout',
                    style: AppTextStyles.label.copyWith(color: AppColors.alertError)),
              ),
            ),

            const SizedBox(height: 24),
          ],
        ),
      ),
      bottomNavigationBar: const AppBottomNav(),
    );
  }
}

class _InfoRow extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;

  const _InfoRow({required this.icon, required this.label, required this.value});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: [
          Icon(icon, size: 20, color: AppColors.primary),
          const SizedBox(width: 12),
          Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
          Text(value,
              style: AppTextStyles.bodyMedium.copyWith(color: AppColors.textSecondary)),
          const SizedBox(width: 4),
          const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
        ],
      ),
    );
  }
}

class _SettingRow extends StatelessWidget {
  final String label;
  final VoidCallback onTap;

  const _SettingRow({required this.label, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppTextStyles.bodyMedium)),
            const Icon(Icons.arrow_forward_ios, size: 14, color: AppColors.textSecondary),
          ],
        ),
      ),
    );
  }
}

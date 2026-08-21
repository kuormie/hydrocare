import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/constants/app_assets.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/widgets/app_text_field.dart';
import '../../core/widgets/primary_button.dart';
import '../../providers/user_provider.dart';

class EditProfileScreen extends StatefulWidget {
  const EditProfileScreen({super.key});

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _emailCtrl;
  late final TextEditingController _dobCtrl;
  String? _gender;

  @override
  void initState() {
    super.initState();
    final user = context.read<UserProvider>().user;
    _nameCtrl = TextEditingController(text: user?.name ?? '');
    _emailCtrl = TextEditingController(text: user?.email ?? '');
    _dobCtrl = TextEditingController(text: user?.tanggalLahir ?? '');
    _gender = user?.jenisKelamin;
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _dobCtrl.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final picked = await showDatePicker(
      context: context,
      initialDate: DateTime(2000),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked == null) return;
    const months = [
      '',
      'Januari',
      'Februari',
      'Maret',
      'April',
      'Mei',
      'Juni',
      'Juli',
      'Agustus',
      'September',
      'Oktober',
      'November',
      'Desember',
    ];
    _dobCtrl.text =
        '${picked.day.toString().padLeft(2, '0')} ${months[picked.month]} ${picked.year}';
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

  Future<void> _confirmRemovePhoto() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Hapus Foto?'),
        content: const Text('Foto profil akan dihapus.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text('Batal'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: TextButton.styleFrom(foregroundColor: AppColors.alertError),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
    if (confirmed != true || !mounted) return;
    await context.read<UserProvider>().removePhoto();
    if (!mounted) return;
    await AppDialog.showSuccess(context,
        title: 'Berhasil!', message: 'Foto profil berhasil dihapus');
  }

  Future<void> _save() async {
    await context.read<UserProvider>().updateProfile(
          name: _nameCtrl.text.isNotEmpty ? _nameCtrl.text : null,
          email: _emailCtrl.text.isNotEmpty ? _emailCtrl.text : null,
          tanggalLahir: _dobCtrl.text.isNotEmpty ? _dobCtrl.text : null,
          jenisKelamin: _gender,
        );
    if (!mounted) return;
    await AppDialog.showSuccess(
      context,
      title: 'Berhasil!',
      message: 'Profil berhasil diperbarui',
    );
    if (!mounted) return;
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final profileImagePath = context.watch<UserProvider>().user?.profileImagePath;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Edit Profile'),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Photo section
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 85,
                    backgroundColor: AppColors.primaryLight,
                    backgroundImage: profileImagePath != null
                        ? FileImage(File(profileImagePath))
                        : const AssetImage(AppAssets.profileDefault) as ImageProvider,
                  ),
                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _showPhotoOptions,
                      child: CircleAvatar(
                        radius: 18,
                        backgroundColor: AppColors.primary,
                        child: Image.asset(
                          AppAssets.cameraOverlay,
                          width: 22,
                          height: 22,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: Text('Change Profile', style: AppTextStyles.label),
            ),
            Center(
              child: TextButton(
                onPressed: _confirmRemovePhoto,
                style: TextButton.styleFrom(foregroundColor: AppColors.alertError),
                child: const Text('Remove Profile'),
              ),
            ),

            const SizedBox(height: 24),

            // Name
            AppTextField(
              label: 'Name',
              hint: 'Nama lengkap',
              controller: _nameCtrl,
              prefixIcon: const Icon(Icons.person_outline,
                  size: 20, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 16),

            // Email
            AppTextField(
              label: 'Email',
              hint: 'Email',
              controller: _emailCtrl,
              keyboardType: TextInputType.emailAddress,
              prefixIcon: const Icon(Icons.email_outlined,
                  size: 20, color: AppColors.textSecondary),
            ),

            const SizedBox(height: 16),

            // Date of Birth
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Date of Birth', style: AppTextStyles.label),
                const SizedBox(height: 8),
                TextFormField(
                  controller: _dobCtrl,
                  readOnly: true,
                  onTap: _pickDate,
                  style: AppTextStyles.bodyMedium,
                  decoration: const InputDecoration(
                    hintText: 'DD MMMM YYYY',
                    prefixIcon: Icon(Icons.calendar_today,
                        size: 20, color: AppColors.textSecondary),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Gender
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Gender', style: AppTextStyles.label),
                const SizedBox(height: 8),
                DropdownButtonFormField<String>(
                  initialValue: _gender,
                  items: ['Laki-laki', 'Perempuan']
                      .map((g) => DropdownMenuItem(value: g, child: Text(g)))
                      .toList(),
                  onChanged: (v) => setState(() => _gender = v),
                  decoration: const InputDecoration(
                    hintText: 'Pilih gender',
                  ),
                ),
              ],
            ),

            const SizedBox(height: 32),

            PrimaryButton(label: 'Save', onPressed: _save),

            const SizedBox(height: 24),
          ],
        ),
      ),
    );
  }
}

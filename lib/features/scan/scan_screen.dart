import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../core/routes/app_routes.dart';
import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';
import '../../core/widgets/app_dialog.dart';
import '../../core/constants/app_strings.dart';
import '../../providers/scan_provider.dart';
import '../../providers/history_provider.dart';
import '../../providers/nav_provider.dart';
import '../../data/models/history_item.dart';
import 'dart:io';

class ScanScreen extends StatefulWidget {
  const ScanScreen({super.key});

  @override
  State<ScanScreen> createState() => _ScanScreenState();
}

class _ScanScreenState extends State<ScanScreen> with WidgetsBindingObserver {
  List<CameraDescription> _cameras = [];
  CameraController? _controller;
  int _cameraIndex = 0;
  bool _isInitialized = false;
  bool _isCapturing = false;
  FlashMode _flashMode = FlashMode.off;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) context.read<NavProvider>().setIndex(1);
    });
    _initCamera();
  }

  Future<void> _initCamera() async {
    try {
      _cameras = await availableCameras();
      if (_cameras.isEmpty) {
        if (mounted) setState(() => _errorMessage = 'Tidak ada kamera yang tersedia.');
        return;
      }
      await _startCamera(_cameraIndex);
    } catch (_) {
      if (mounted) {
        setState(() => _errorMessage =
            'Tidak dapat mengakses kamera.\nPastikan izin kamera telah diberikan di Pengaturan.');
      }
    }
  }

  Future<void> _startCamera(int index) async {
    final camera = _cameras[index];
    final controller = CameraController(
      camera,
      ResolutionPreset.high,
      enableAudio: false,
    );
    try {
      await controller.initialize();
      if (!mounted) {
        controller.dispose();
        return;
      }
      await controller.setFlashMode(_flashMode);
      await _controller?.dispose();
      setState(() {
        _controller = controller;
        _cameraIndex = index;
        _isInitialized = true;
        _errorMessage = null;
      });
    } catch (_) {
      controller.dispose();
      if (mounted) {
        setState(() => _errorMessage =
            'Tidak dapat mengakses kamera.\nPastikan izin kamera telah diberikan di Pengaturan.');
      }
    }
  }

  Future<void> _toggleFlash() async {
    final next = _nextFlashMode();
    setState(() => _flashMode = next);
    await _controller?.setFlashMode(next);
  }

  FlashMode _nextFlashMode() {
    switch (_flashMode) {
      case FlashMode.off:
        return FlashMode.torch;
      case FlashMode.torch:
        return FlashMode.auto;
      case FlashMode.auto:
        return FlashMode.off;
      default:
        return FlashMode.off;
    }
  }

  IconData get _flashIcon {
    switch (_flashMode) {
      case FlashMode.torch:
        return Icons.flash_on;
      case FlashMode.auto:
        return Icons.flash_auto;
      default:
        return Icons.flash_off;
    }
  }

  Future<void> _onCapture() async {
  if (_isCapturing ||
      _controller == null ||
      !_controller!.value.isInitialized) {
    return;
  }

  setState(() => _isCapturing = true);

  try {
    final XFile image = await _controller!.takePicture();

    await _performScan(File(image.path));
  } catch (e) {
    setState(() => _isCapturing = false);
  }
}

  Future<void> _openGallery() async {
  if (_isCapturing) return;

  final XFile? image = await ImagePicker().pickImage(
    source: ImageSource.gallery,
  );

  if (image == null || !mounted) return;

  setState(() => _isCapturing = true);

  await _performScan(File(image.path));
}

  Future<void> _performScan(File image) async {
  final scanProvider = context.read<ScanProvider>();
  final historyProvider = context.read<HistoryProvider>();

  try {
    print("1. Mulai Scan");

    _showScanningDialog();

    final sample = await scanProvider.performScan(image);

    print("2. Sample : $sample");

    if (!mounted) return;

    Navigator.of(context, rootNavigator: true).pop();

    setState(() => _isCapturing = false);

    if (sample == null) {
      print("3. Sample NULL");

      await AppDialog.showError(
        context,
        title: 'Gagal',
        message: AppStrings.failGeneral,
      );
      return;
    }

    final now = DateTime.now();

    final newItem = HistoryItem(
      id: 'scan_${now.millisecondsSinceEpoch}',
      date: _formatDate(now),
      time: _formatTime(now),
      status: sample.status,
      aiScore: sample.aiScore,
      urineColor: sample.urineColor,
      recommendations: sample.recommendations,
      imagePath: image.path,
    );

    print("4. History dibuat");

    // sementara jangan simpan dulu
  await historyProvider.addItem(newItem);

    print("5. Mau tampil dialog");

    await AppDialog.showSuccess(
      context,
      title: 'Berhasil!',
      message: "TES BERHASIL",
      buttonLabel: 'Lihat Hasil',
      onPressed: () {
        print("6. Pindah Result");

        Navigator.of(context).pop();

        Navigator.of(context).pushReplacementNamed(
          AppRoutes.result,
          arguments: newItem,
        );
      },
    );
  } catch (e, s) {
    print("================ ERROR =================");
    print(e);
    print(s);

    try {
      Navigator.of(context, rootNavigator: true).pop();
    } catch (_) {}

    setState(() => _isCapturing = false);

    await AppDialog.showError(
      context,
      title: "ERROR",
      message: e.toString(),
    );
  }
}
  void _showScanningDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.black54,
      builder: (_) => const _ScanningDialog(),
    );
  }

  String _formatDate(DateTime dt) {
    const months = [
      '', 'Januari', 'Februari', 'Maret', 'April', 'Mei', 'Juni',
      'Juli', 'Agustus', 'September', 'Oktober', 'November', 'Desember',
    ];
    return '${dt.day.toString().padLeft(2, '0')} ${months[dt.month]} ${dt.year}';
  }

  String _formatTime(DateTime dt) =>
      '${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    final controller = _controller;
    if (controller == null || !controller.value.isInitialized) return;
    if (state == AppLifecycleState.inactive) {
      controller.dispose();
      if (mounted) setState(() => _isInitialized = false);
    } else if (state == AppLifecycleState.resumed) {
      _startCamera(_cameraIndex);
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_errorMessage != null) return _buildError();
    if (!_isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(color: Colors.white)),
      );
    }
    return _buildCameraUI();
  }

  Widget _buildError() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () => Navigator.of(context).pop(),
              ),
            ),
            const Spacer(),
            const Icon(Icons.camera_alt, color: Colors.white24, size: 80),
            const SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                _errorMessage!,
                style: AppTextStyles.bodyMedium.copyWith(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            ),
            const SizedBox(height: 16),
            TextButton(
              onPressed: () {
                setState(() => _errorMessage = null);
                _initCamera();
              },
              child: Text('Coba lagi',
                  style: AppTextStyles.label.copyWith(color: AppColors.primary)),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }

  Widget _buildCameraUI() {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          CameraPreview(_controller!),

          // Top & bottom dark bands
          Column(
            children: [
              Container(height: 100, color: Colors.black54),
              const Spacer(),
              Container(height: 180, color: Colors.black54),
            ],
          ),

          SafeArea(
            child: Column(
              children: [
                // Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(4, 4, 4, 0),
                  child: Row(
                    children: [
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.white, size: 28),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                      const Expanded(
                        child: Center(
                          child: Text(
                            'Scan Urine',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 48),
                    ],
                  ),
                ),

                const Spacer(),

                // Viewfinder
                SizedBox(
                  width: 240,
                  height: 240,
                  child: Stack(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.white38, width: 1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                      ),
                      _corner(Alignment.topLeft),
                      _corner(Alignment.topRight),
                      _corner(Alignment.bottomLeft),
                      _corner(Alignment.bottomRight),
                    ],
                  ),
                ),

                const Spacer(),

                // Controls: [gallery] [capture] [flash]
                Padding(
                  padding: const EdgeInsets.fromLTRB(40, 0, 40, 28),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      GestureDetector(
                        onTap: _openGallery,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Icon(Icons.photo_library_outlined,
                              color: Colors.white, size: 26),
                        ),
                      ),
                      GestureDetector(
                        onTap: _isCapturing ? null : _onCapture,
                        child: Container(
                          width: 76,
                          height: 76,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            border: Border.all(color: Colors.white, width: 3),
                            color: _isCapturing
                                ? Colors.white30
                                : AppColors.primary.withValues(alpha: 0.85),
                          ),
                          child: const Icon(Icons.camera, color: Colors.white, size: 38),
                        ),
                      ),
                      GestureDetector(
                        onTap: _toggleFlash,
                        child: Container(
                          width: 52,
                          height: 52,
                          decoration: BoxDecoration(
                            color: _flashMode != FlashMode.off
                                ? AppColors.primary.withValues(alpha: 0.8)
                                : Colors.white.withValues(alpha: 0.2),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Icon(_flashIcon, color: Colors.white, size: 26),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _corner(Alignment alignment) {
    const size = 24.0;
    const thickness = 3.0;
    final isTop = alignment == Alignment.topLeft || alignment == Alignment.topRight;
    final isLeft = alignment == Alignment.topLeft || alignment == Alignment.bottomLeft;
    return Align(
      alignment: alignment,
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          painter: _CornerPainter(isTop: isTop, isLeft: isLeft, thickness: thickness),
        ),
      ),
    );
  }
}

class _CornerPainter extends CustomPainter {
  final bool isTop;
  final bool isLeft;
  final double thickness;

  const _CornerPainter({
    required this.isTop,
    required this.isLeft,
    required this.thickness,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary
      ..strokeWidth = thickness
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final x = isLeft ? 0.0 : size.width;
    final y = isTop ? 0.0 : size.height;
    final dx = isLeft ? size.width : -size.width;
    final dy = isTop ? size.height : -size.height;

    canvas.drawLine(Offset(x, y), Offset(x + dx, y), paint);
    canvas.drawLine(Offset(x, y), Offset(x, y + dy), paint);
  }

  @override
  bool shouldRepaint(_CornerPainter old) => false;
}

class _ScanningDialog extends StatefulWidget {
  const _ScanningDialog();

  @override
  State<_ScanningDialog> createState() => _ScanningDialogState();
}

class _ScanningDialogState extends State<_ScanningDialog>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;
  late final Animation<double> _pulse;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    )..repeat(reverse: true);
    _pulse = Tween<double>(begin: 0.85, end: 1.0)
        .animate(CurvedAnimation(parent: _ctrl, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 48),
        padding: const EdgeInsets.symmetric(vertical: 36, horizontal: 24),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ScaleTransition(
              scale: _pulse,
              child: Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: AppColors.primaryLight,
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.search, color: AppColors.primary, size: 38),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              AppStrings.loadingScanning,
              style: AppTextStyles.bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import '../base/scan_datasource.dart';
import '../../models/scan_sample.dart';
import '../../../services/api_service.dart';

class ScanLocalDataSource implements ScanDataSource {
  final ApiService _apiService;

  ScanLocalDataSource(this._apiService);

  @override
  Future<ScanSample> predictImage(File image) async {
    final result = await _apiService.predictImage(image);

  print("========== HASIL DARI API ==========");
  print(result);

final String label = result['label'];
final double confidence = (result['confidence'] as num).toDouble();

    return _mapToScanSample(label, confidence);
  }

  ScanSample _mapToScanSample(String label, double confidence) {
    switch (label) {
      case "normal":
        return ScanSample(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          urineColor: "Kuning Muda",
          status: "Normal",
          aiScore: (confidence * 100).round(),
          recommendations: [
            "Status hidrasi normal.",
            "Tetap minum air putih minimal 2 liter per hari.",
            "Pertahankan pola hidup sehat."
          ],
        );

      case "dehidrasi_ringan":
        return ScanSample(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          urineColor: "Kuning",
          status: "Dehidrasi Ringan",
          aiScore: (confidence * 100).round(),
          recommendations: [
            "Perbanyak minum air putih.",
            "Kurangi aktivitas berat sementara.",
            "Pantau warna urine secara berkala."
          ],
        );

      case "dehidrasi_sedang":
        return ScanSample(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          urineColor: "Kuning Tua",
          status: "Dehidrasi Sedang",
          aiScore: (confidence * 100).round(),
          recommendations: [
            "Segera tingkatkan konsumsi cairan.",
            "Istirahat yang cukup.",
            "Perhatikan gejala seperti pusing atau lemas."
          ],
        );

      case "dehidrasi_berat":
        return ScanSample(
          id: DateTime.now().millisecondsSinceEpoch.toString(),
          urineColor: "Coklat Tua",
          status: "Dehidrasi Berat",
          aiScore: (confidence * 100).round(),
          recommendations: [
            "Segera minum cairan elektrolit.",
            "Hindari aktivitas fisik.",
            "Disarankan segera berkonsultasi ke tenaga medis."
          ],
        );

      default:
        throw Exception("Label tidak dikenali: $label");
    }
  }
}
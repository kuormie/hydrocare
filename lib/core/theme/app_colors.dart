import 'package:flutter/material.dart';

class AppColors {
  AppColors._();

  // Brand
  static const primary = Color(0xFF2E86AB);
  static const primaryDark = Color(0xFF1B6587);
  static const primaryLight = Color(0xFFE8F4F8);

  // Background
  static const background = Color(0xFFEAF4FB);
  static const surface = Colors.white;
  static const cardShadow = Color(0x1A000000);

  // Scan card (dark teal)
  static const scanCard = Color(0xFF4A7C8A);

  // Status
  static const normal = Color(0xFF4CAF50);
  static const dehidrasiRingan = Color(0xFFFF9800);
  static const dehidrasiSedang = Color(0xFFFF6F00);
  static const dehidrasiBerat = Color(0xFFF44336);

  static Color statusColor(String status) {
    switch (status.toLowerCase()) {
      case 'normal':
        return normal;
      case 'dehidrasi ringan':
        return dehidrasiRingan;
      case 'dehidrasi sedang':
        return dehidrasiSedang;
      case 'dehidrasi berat':
        return dehidrasiBerat;
      default:
        return dehidrasiRingan;
    }
  }

  // Text
  static const textPrimary = Color(0xFF1A1A2E);
  static const textSecondary = Color(0xFF6B7280);
  static const textHint = Color(0xFFADB5BD);
  static const textOnPrimary = Colors.white;

  // Nav & UI
  static const bottomNavBg = Colors.white;
  static const divider = Color(0xFFE5E7EB);
  static const disabled = Color(0xFFBDBDBD);

  // Chart
  static const chartNormal = Color(0xFF4CAF50);
  static const chartRingan = Color(0xFFFF9800);
  static const chartSedang = Color(0xFFFF6F00);
  static const chartBerat = Color(0xFFF44336);

  // Alert
  static const alertSuccess = Color(0xFF4CAF50);
  static const alertError = Color(0xFFF44336);
}

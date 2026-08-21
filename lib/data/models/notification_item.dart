import 'package:flutter/material.dart';

class NotificationItem {
  final String id;
  final String title;
  final String body;
  final String time;
  final bool isRead;
  final IconData icon;
  final Color iconColor;

  const NotificationItem({
    required this.id,
    required this.title,
    required this.body,
    required this.time,
    required this.isRead,
    required this.icon,
    required this.iconColor,
  });

  static const List<NotificationItem> dummyList = [
    NotificationItem(
      id: 'n1',
      title: 'Saatnya minum air! 💧',
      body: 'Anda belum minum air dalam 2 jam terakhir. Tetap terhidrasi!',
      time: 'Hari ini, 08:00',
      isRead: true,
      icon: Icons.water_drop,
      iconColor: Color(0xFF2E86AB),
    ),
    NotificationItem(
      id: 'n2',
      title: 'Hasil scan terbaru',
      body: 'Scan terakhir Anda menunjukkan status Normal dengan Skor AI 94%.',
      time: '12 Jun, 12:30',
      isRead: true,
      icon: Icons.check_circle,
      iconColor: Color(0xFF4CAF50),
    ),
    NotificationItem(
      id: 'n3',
      title: 'Tips hidrasi hari ini',
      body: 'Minum air sebelum haus adalah kebiasaan baik untuk menjaga hidrasi optimal.',
      time: 'Kemarin, 09:15',
      isRead: false,
      icon: Icons.lightbulb_outline,
      iconColor: Color(0xFFFF9800),
    ),
    NotificationItem(
      id: 'n4',
      title: 'Pengingat: Scan pagi hari',
      body: 'Lakukan scan urin di pagi hari untuk hasil analisis yang lebih akurat.',
      time: '2 hari lalu',
      isRead: false,
      icon: Icons.alarm,
      iconColor: Color(0xFF2E86AB),
    ),
    NotificationItem(
      id: 'n5',
      title: 'Ringkasan mingguan',
      body: 'Rata-rata Skor AI Anda minggu ini adalah 82%. Pertahankan hidrasi yang baik!',
      time: '3 hari lalu',
      isRead: true,
      icon: Icons.bar_chart,
      iconColor: Color(0xFF4CAF50),
    ),
  ];
}

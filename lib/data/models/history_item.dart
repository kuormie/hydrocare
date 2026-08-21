class HistoryItem {
  final String id;
  final String date;
  final String time;
  final String status;
  final int aiScore;
  final String urineColor;
  final List<String> recommendations;
  final String imagePath;

  const HistoryItem({
    required this.id,
    required this.date,
    required this.time,
    required this.status,
    required this.aiScore,
    required this.urineColor,
    required this.recommendations,
    required this.imagePath,
  });

  factory HistoryItem.fromJson(Map<String, dynamic> json) => HistoryItem(
      id: json['id'] as String,
      date: json['date'] as String,
      time: json['time'] as String,
      status: json['status'] as String,
      aiScore: json['aiScore'] as int,
      urineColor: json['urineColor'] as String,
      recommendations: List<String>.from(json['recommendations'] as List),
      imagePath: json['imagePath'] ?? "",
    );

  Map<String, dynamic> toJson() => {
      'id': id,
      'date': date,
      'time': time,
      'status': status,
      'aiScore': aiScore,
      'urineColor': urineColor,
      'recommendations': recommendations,
      'imagePath': imagePath,
    };

  HistoryItem copyWith({
    String? id,
    String? date,
    String? time,
    String? status,
    int? aiScore,
    String? urineColor,
    List<String>? recommendations,
    String? imagePath,
  }) =>
      HistoryItem(
        id: id ?? this.id,
        date: date ?? this.date,
        time: time ?? this.time,
        status: status ?? this.status,
        aiScore: aiScore ?? this.aiScore,
        urineColor: urineColor ?? this.urineColor,
        recommendations: recommendations ?? this.recommendations,
        imagePath: imagePath ?? this.imagePath,
      );
}

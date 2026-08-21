class ScanSample {
  final String id;
  final String urineColor;
  final String status;
  final int aiScore;
  final List<String> recommendations;

  const ScanSample({
    required this.id,
    required this.urineColor,
    required this.status,
    required this.aiScore,
    required this.recommendations,
  });

  factory ScanSample.fromJson(Map<String, dynamic> json) => ScanSample(
        id: json['id'] as String,
        urineColor: json['urineColor'] as String,
        status: json['status'] as String,
        aiScore: json['aiScore'] as int,
        recommendations: List<String>.from(json['recommendations'] as List),
      );
}

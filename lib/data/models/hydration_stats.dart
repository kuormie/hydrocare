class StatusDistribution {
  final String status;
  final double percentage;

  const StatusDistribution({required this.status, required this.percentage});

  factory StatusDistribution.fromJson(Map<String, dynamic> json) =>
      StatusDistribution(
        status: json['status'] as String,
        percentage: (json['percentage'] as num).toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'status': status,
        'percentage': percentage,
      };
}

class WeeklyScore {
  final String label;
  final int score;

  const WeeklyScore({required this.label, required this.score});

  factory WeeklyScore.fromJson(Map<String, dynamic> json) => WeeklyScore(
        label: json['label'] as String,
        score: json['score'] as int,
      );

  Map<String, dynamic> toJson() => {'label': label, 'score': score};
}

class ThisWeekStats {
  final int scan;
  final int normal;
  final int dehidrasi;

  const ThisWeekStats({
    required this.scan,
    required this.normal,
    required this.dehidrasi,
  });

  factory ThisWeekStats.fromJson(Map<String, dynamic> json) => ThisWeekStats(
        scan: json['scan'] as int,
        normal: json['normal'] as int,
        dehidrasi: json['dehidrasi'] as int,
      );

  Map<String, dynamic> toJson() => {
        'scan': scan,
        'normal': normal,
        'dehidrasi': dehidrasi,
      };
}

class HydrationStats {
  final String hydrationLevel;
  final int currentAiScore;
  final ThisWeekStats thisWeek;
  final List<StatusDistribution> statusDistribution;
  final List<WeeklyScore> weeklyScores;
  final int averageAiScore;

  const HydrationStats({
    required this.hydrationLevel,
    required this.currentAiScore,
    required this.thisWeek,
    required this.statusDistribution,
    required this.weeklyScores,
    required this.averageAiScore,
  });

  factory HydrationStats.fromJson(Map<String, dynamic> json) => HydrationStats(
        hydrationLevel: json['hydrationLevel'] as String,
        currentAiScore: json['currentAiScore'] as int,
        thisWeek:
            ThisWeekStats.fromJson(json['thisWeek'] as Map<String, dynamic>),
        statusDistribution: (json['statusDistribution'] as List)
            .map((e) =>
                StatusDistribution.fromJson(e as Map<String, dynamic>))
            .toList(),
        weeklyScores: (json['weeklyScores'] as List)
            .map((e) => WeeklyScore.fromJson(e as Map<String, dynamic>))
            .toList(),
        averageAiScore: json['averageAiScore'] as int,
      );

  Map<String, dynamic> toJson() => {
        'hydrationLevel': hydrationLevel,
        'currentAiScore': currentAiScore,
        'thisWeek': thisWeek.toJson(),
        'statusDistribution':
            statusDistribution.map((e) => e.toJson()).toList(),
        'weeklyScores': weeklyScores.map((e) => e.toJson()).toList(),
        'averageAiScore': averageAiScore,
      };
}

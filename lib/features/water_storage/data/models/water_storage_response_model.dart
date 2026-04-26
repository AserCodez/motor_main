class DailyWaterLevelPoint {
  const DailyWaterLevelPoint({
    required this.date,
    required this.levelPercentage,
  });

  final DateTime date;
  final double levelPercentage;

  factory DailyWaterLevelPoint.fromJson(Map<String, dynamic> json) {
    return DailyWaterLevelPoint(
      date: DateTime.tryParse(json['date'] as String? ?? '') ?? DateTime.now(),
      levelPercentage: ((json['level_percentage'] as num?)?.toDouble() ?? 0)
          .clamp(0, 100),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'level_percentage': levelPercentage,
    };
  }
}

class WaterStorageResponseModel {
  const WaterStorageResponseModel({
    required this.currentLiters,
    required this.capacityLiters,
    required this.flowRateLitersPerMinute,
    required this.lastUpdated,
    required this.history,
  });

  final double currentLiters;
  final double capacityLiters;
  final double flowRateLitersPerMinute;
  final DateTime lastUpdated;
  final List<DailyWaterLevelPoint> history;

  double get levelPercentage {
    if (capacityLiters <= 0) {
      return 0;
    }

    return ((currentLiters / capacityLiters) * 100).clamp(0, 100);
  }

  factory WaterStorageResponseModel.fromJson(Map<String, dynamic> json) {
    final currentLiters = (json['current_liters'] as num?)?.toDouble() ?? 0;
    final capacityLiters =
        (json['capacity_liters'] as num?)?.toDouble() ?? 1000;
    final parsedHistory = _parseHistory(json['history']);

    return WaterStorageResponseModel(
      currentLiters: currentLiters,
      capacityLiters: capacityLiters,
      flowRateLitersPerMinute:
          (json['flow_rate_liters_per_minute'] as num?)?.toDouble() ?? 12,
      lastUpdated:
          DateTime.tryParse(json['last_updated'] as String? ?? '') ??
          DateTime.now(),
      history: parsedHistory.isEmpty
          ? _buildDefaultHistory(
              levelPercentage: capacityLiters == 0
                  ? 0
                  : ((currentLiters / capacityLiters) * 100).clamp(0, 100),
            )
          : parsedHistory,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'current_liters': currentLiters,
      'capacity_liters': capacityLiters,
      'flow_rate_liters_per_minute': flowRateLitersPerMinute,
      'last_updated': lastUpdated.toIso8601String(),
      'history': history.map((point) => point.toJson()).toList(),
    };
  }

  WaterStorageResponseModel copyWith({
    double? currentLiters,
    double? capacityLiters,
    double? flowRateLitersPerMinute,
    DateTime? lastUpdated,
    List<DailyWaterLevelPoint>? history,
  }) {
    return WaterStorageResponseModel(
      currentLiters: currentLiters ?? this.currentLiters,
      capacityLiters: capacityLiters ?? this.capacityLiters,
      flowRateLitersPerMinute:
          flowRateLitersPerMinute ?? this.flowRateLitersPerMinute,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
    );
  }

  static List<DailyWaterLevelPoint> _parseHistory(dynamic rawHistory) {
    if (rawHistory is List) {
      final points = rawHistory
          .whereType<Map>()
          .map(
            (entry) => DailyWaterLevelPoint.fromJson(
              entry.map((key, value) => MapEntry(key.toString(), value)),
            ),
          )
          .toList();

      points.sort((a, b) => a.date.compareTo(b.date));
      return _trimToSevenDays(points);
    }

    if (rawHistory is Map) {
      final points = rawHistory.entries.map((entry) {
        final date = DateTime.tryParse(entry.key.toString()) ?? DateTime.now();
        final value = entry.value;

        if (value is num) {
          return DailyWaterLevelPoint(
            date: date,
            levelPercentage: value.toDouble().clamp(0, 100),
          );
        }

        if (value is Map) {
          final mapped = value.map(
            (key, item) => MapEntry(key.toString(), item),
          );
          return DailyWaterLevelPoint(
            date: date,
            levelPercentage:
                (mapped['level_percentage'] as num?)?.toDouble().clamp(
                  0,
                  100,
                ) ??
                0,
          );
        }

        return DailyWaterLevelPoint(date: date, levelPercentage: 0);
      }).toList();

      points.sort((a, b) => a.date.compareTo(b.date));
      return _trimToSevenDays(points);
    }

    return const [];
  }

  static List<DailyWaterLevelPoint> _buildDefaultHistory({
    required double levelPercentage,
  }) {
    final now = DateTime.now();

    return List<DailyWaterLevelPoint>.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      final trendShift = (index - 3) * 3;
      final value = (levelPercentage + trendShift).clamp(0, 100).toDouble();

      return DailyWaterLevelPoint(
        date: DateTime(day.year, day.month, day.day),
        levelPercentage: value,
      );
    });
  }

  static List<DailyWaterLevelPoint> _trimToSevenDays(
    List<DailyWaterLevelPoint> points,
  ) {
    if (points.length <= 7) {
      return points;
    }

    return points.sublist(points.length - 7);
  }
}

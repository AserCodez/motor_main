class WaterStorageResponseModel {
  const WaterStorageResponseModel({
    required this.currentLiters,
    required this.capacityLiters,
    required this.flowRateLitersPerMinute,
    required this.lastUpdated,
    required this.history,
    required this.overFlow,
  });

  final double currentLiters;
  final double capacityLiters;
  final double flowRateLitersPerMinute;
  final DateTime lastUpdated;
  final List<DailyWaterLevelPoint> history;
  final bool overFlow;

  double get levelPercentage {
    if (capacityLiters <= 0) {
      return 0;
    }

    return ((currentLiters / capacityLiters) * 100).clamp(0, 100).toDouble();
  }

  factory WaterStorageResponseModel.fromJson(Map<String, dynamic> json) {
    return WaterStorageResponseModel(
      currentLiters: _asDouble(json['current_liters'], fallback: 0),
      capacityLiters: _asDouble(json['capacity_liters'], fallback: 1000),
      flowRateLitersPerMinute: _asDouble(
        json['flow_rate_liters_per_minute'],
        fallback: 15,
      ),
      lastUpdated: _asDateTime(json['last_updated']) ?? DateTime.now(),
      history: _parseHistory(json['history']),
      overFlow: _asBool(json['over_flow'], fallback: false),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'current_liters': currentLiters,
      'capacity_liters': capacityLiters,
      'flow_rate_liters_per_minute': flowRateLitersPerMinute,
      'last_updated': lastUpdated.toIso8601String(),
      'over_flow': overFlow,
      'history': history.map((point) => point.toJson()).toList(),
    };
  }

  WaterStorageResponseModel copyWith({
    double? currentLiters,
    double? capacityLiters,
    double? flowRateLitersPerMinute,
    DateTime? lastUpdated,
    List<DailyWaterLevelPoint>? history,
    bool? overFlow,
  }) {
    return WaterStorageResponseModel(
      currentLiters: currentLiters ?? this.currentLiters,
      capacityLiters: capacityLiters ?? this.capacityLiters,
      flowRateLitersPerMinute:
          flowRateLitersPerMinute ?? this.flowRateLitersPerMinute,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      history: history ?? this.history,
      overFlow: overFlow ?? this.overFlow,
    );
  }

  static List<DailyWaterLevelPoint> _parseHistory(Object? value) {
    if (value is List) {
      return value.whereType<Map>().map((entry) {
        final map = entry.map((key, val) => MapEntry(key.toString(), val));
        return DailyWaterLevelPoint.fromJson(map);
      }).toList();
    }

    if (value is Map) {
      final entries = value.entries.toList()
        ..sort((a, b) => a.key.toString().compareTo(b.key.toString()));

      return entries.map((entry) {
        if (entry.value is Map) {
          final map = (entry.value as Map).map(
            (key, val) => MapEntry(key.toString(), val),
          );
          return DailyWaterLevelPoint.fromJson(map);
        }

        return DailyWaterLevelPoint(
          date: DateTime.now(),
          levelPercentage: _asDouble(entry.value, fallback: 0),
        );
      }).toList();
    }

    return const <DailyWaterLevelPoint>[];
  }

  static bool _asBool(Object? value, {required bool fallback}) {
    if (value is bool) {
      return value;
    }

    if (value is num) {
      return value != 0;
    }

    if (value is String) {
      final normalized = value.trim().toLowerCase();
      if (normalized == 'true' || normalized == '1') {
        return true;
      }
      if (normalized == 'false' || normalized == '0') {
        return false;
      }
    }

    return fallback;
  }

  static double _asDouble(Object? value, {required double fallback}) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim()) ?? fallback;
    }

    return fallback;
  }

  static DateTime? _asDateTime(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is DateTime) {
      return value;
    }

    if (value is int) {
      return DateTime.fromMillisecondsSinceEpoch(value);
    }

    if (value is String) {
      final trimmed = value.trim();
      final parsed = DateTime.tryParse(trimmed);
      if (parsed != null) {
        return parsed;
      }

      final parts = trimmed.split('/');
      if (parts.length == 3) {
        final day = int.tryParse(parts[0]);
        final month = int.tryParse(parts[1]);
        final year = int.tryParse(parts[2]);
        if (day != null && month != null && year != null) {
          final fullYear = year < 100 ? 2000 + year : year;
          return DateTime(fullYear, month, day);
        }
      }
    }

    return null;
  }
}

class DailyWaterLevelPoint {
  const DailyWaterLevelPoint({
    required this.date,
    required this.levelPercentage,
  });

  final DateTime date;
  final double levelPercentage;

  factory DailyWaterLevelPoint.fromJson(Map<String, dynamic> json) {
    return DailyWaterLevelPoint(
      date:
          WaterStorageResponseModel._asDateTime(json['date']) ?? DateTime.now(),
      levelPercentage: WaterStorageResponseModel._asDouble(
        json['level_percentage'],
        fallback: 0,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'date': date.toIso8601String(),
      'level_percentage': levelPercentage,
    };
  }
}

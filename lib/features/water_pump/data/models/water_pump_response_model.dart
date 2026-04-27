class WaterPumpResponseModel {
  const WaterPumpResponseModel({
    required this.isOn,
    required this.flowLitersPerMinute,
    required this.lastUpdated,
    required this.source,
  });

  final bool isOn;
  final double flowLitersPerMinute;
  final DateTime lastUpdated;
  final String source;

  factory WaterPumpResponseModel.initial() {
    return WaterPumpResponseModel(
      isOn: false,
      flowLitersPerMinute: 0,
      lastUpdated: DateTime.now(),
      source: 'initial',
    );
  }

  factory WaterPumpResponseModel.fromJson(Map<String, dynamic> json) {
    return WaterPumpResponseModel(
      isOn: _asBool(
        json['water_pump_status'] ?? json['is_on'],
        fallback: false,
      ),
      flowLitersPerMinute: _asDouble(json['flow'], fallback: 0),
      lastUpdated: _asDateTime(json['last_updated']) ?? DateTime.now(),
      source: (json['source'] ?? 'firebase').toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'water_pump_status': isOn,
      'flow': flowLitersPerMinute,
      'last_updated': lastUpdated.toIso8601String(),
      'source': source,
    };
  }

  WaterPumpResponseModel copyWith({
    bool? isOn,
    double? flowLitersPerMinute,
    DateTime? lastUpdated,
    String? source,
  }) {
    return WaterPumpResponseModel(
      isOn: isOn ?? this.isOn,
      flowLitersPerMinute: flowLitersPerMinute ?? this.flowLitersPerMinute,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      source: source ?? this.source,
    );
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

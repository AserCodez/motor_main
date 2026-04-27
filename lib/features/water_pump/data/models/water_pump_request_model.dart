class WaterPumpRequestModel {
  const WaterPumpRequestModel({
    required this.desiredOn,
    required this.commandSource,
    required this.issuedAt,
    this.flowLitersPerMinute,
  });

  final bool desiredOn;
  final String commandSource;
  final DateTime issuedAt;
  final double? flowLitersPerMinute;

  factory WaterPumpRequestModel.fromJson(Map<String, dynamic> json) {
    return WaterPumpRequestModel(
      desiredOn: _asBool(
        json['water_pump_status'] ?? json['desired_on'],
        fallback: false,
      ),
      commandSource: (json['command_source'] ?? 'manual_app_toggle').toString(),
      issuedAt: _asDateTime(json['issued_at']) ?? DateTime.now(),
      flowLitersPerMinute: _asNullableDouble(json['flow']),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'water_pump_status': desiredOn,
      'command_source': commandSource,
      'issued_at': issuedAt.toIso8601String(),
      if (flowLitersPerMinute != null) 'flow': flowLitersPerMinute,
    };
  }

  WaterPumpRequestModel copyWith({
    bool? desiredOn,
    String? commandSource,
    DateTime? issuedAt,
    double? flowLitersPerMinute,
  }) {
    return WaterPumpRequestModel(
      desiredOn: desiredOn ?? this.desiredOn,
      commandSource: commandSource ?? this.commandSource,
      issuedAt: issuedAt ?? this.issuedAt,
      flowLitersPerMinute: flowLitersPerMinute ?? this.flowLitersPerMinute,
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

  static double? _asNullableDouble(Object? value) {
    if (value == null) {
      return null;
    }

    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim());
    }

    return null;
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

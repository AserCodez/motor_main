class WaterStorageRequestModel {
  const WaterStorageRequestModel({
    required this.tankId,
    required this.capacityLiters,
    required this.flowRateLitersPerMinute,
  });

  final String tankId;
  final double capacityLiters;
  final double flowRateLitersPerMinute;

  factory WaterStorageRequestModel.fromJson(Map<String, dynamic> json) {
    return WaterStorageRequestModel(
      tankId: (json['tank_id'] ?? 'main_tank').toString(),
      capacityLiters: _asDouble(json['capacity_liters'], fallback: 1000),
      flowRateLitersPerMinute: _asDouble(
        json['flow_rate_liters_per_minute'],
        fallback: 15,
      ),
    );
  }

  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'tank_id': tankId,
      'capacity_liters': capacityLiters,
      'flow_rate_liters_per_minute': flowRateLitersPerMinute,
    };
  }

  WaterStorageRequestModel copyWith({
    String? tankId,
    double? capacityLiters,
    double? flowRateLitersPerMinute,
  }) {
    return WaterStorageRequestModel(
      tankId: tankId ?? this.tankId,
      capacityLiters: capacityLiters ?? this.capacityLiters,
      flowRateLitersPerMinute:
          flowRateLitersPerMinute ?? this.flowRateLitersPerMinute,
    );
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
}

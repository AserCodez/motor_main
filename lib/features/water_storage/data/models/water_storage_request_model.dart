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
      tankId: json['tank_id'] as String? ?? 'main_tank',
      capacityLiters: (json['capacity_liters'] as num?)?.toDouble() ?? 1000,
      flowRateLitersPerMinute:
          (json['flow_rate_liters_per_minute'] as num?)?.toDouble() ?? 12,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'tank_id': tankId,
      'capacity_liters': capacityLiters,
      'flow_rate_liters_per_minute': flowRateLitersPerMinute,
    };
  }
}

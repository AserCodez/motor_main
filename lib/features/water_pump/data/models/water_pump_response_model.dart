class WaterPumpResponseModel {
  const WaterPumpResponseModel({
    required this.isOn,
    required this.lastUpdated,
    required this.source,
  });

  factory WaterPumpResponseModel.initial() {
    return WaterPumpResponseModel(
      isOn: false,
      lastUpdated: DateTime.now(),
      source: 'initial',
    );
  }

  final bool isOn;
  final DateTime lastUpdated;
  final String source;

  factory WaterPumpResponseModel.fromJson(Map<String, dynamic> json) {
    return WaterPumpResponseModel(
      isOn: json['is_on'] as bool? ?? false,
      lastUpdated:
          DateTime.tryParse(json['last_updated'] as String? ?? '') ??
          DateTime.now(),
      source: json['source'] as String? ?? 'remote',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'is_on': isOn,
      'last_updated': lastUpdated.toIso8601String(),
      'source': source,
    };
  }

  WaterPumpResponseModel copyWith({
    bool? isOn,
    DateTime? lastUpdated,
    String? source,
  }) {
    return WaterPumpResponseModel(
      isOn: isOn ?? this.isOn,
      lastUpdated: lastUpdated ?? this.lastUpdated,
      source: source ?? this.source,
    );
  }
}

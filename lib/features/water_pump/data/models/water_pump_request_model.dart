class WaterPumpRequestModel {
  const WaterPumpRequestModel({
    required this.desiredOn,
    required this.commandSource,
    required this.issuedAt,
  });

  final bool desiredOn;
  final String commandSource;
  final DateTime issuedAt;

  factory WaterPumpRequestModel.fromJson(Map<String, dynamic> json) {
    return WaterPumpRequestModel(
      desiredOn: json['desired_on'] as bool? ?? false,
      commandSource: json['command_source'] as String? ?? 'manual',
      issuedAt:
          DateTime.tryParse(json['issued_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'desired_on': desiredOn,
      'command_source': commandSource,
      'issued_at': issuedAt.toIso8601String(),
    };
  }
}

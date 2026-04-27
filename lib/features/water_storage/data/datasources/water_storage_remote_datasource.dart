import 'package:firebase_database/firebase_database.dart';
import 'package:motor_main/core/constants/firebase_paths.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_request_model.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';

class WaterStorageRemoteDatasource {
  WaterStorageRemoteDatasource({FirebaseDatabase? database})
    : _database = database;

  final FirebaseDatabase? _database;

  DatabaseReference? get _storageReference =>
      _database?.ref(FirebasePaths.waterStorage);
  DatabaseReference? get _pumpReference =>
      _database?.ref(FirebasePaths.waterPump);
  DatabaseReference? get _logsReference => _database?.ref(FirebasePaths.logs);

  Future<WaterStorageResponseModel> fetchStorageSnapshot(
    WaterStorageRequestModel request,
  ) async {
    final storageReference = _storageReference;
    if (storageReference == null) {
      return _buildMockStorageSnapshot(request);
    }

    final storageSnapshot = await storageReference.get();
    final pumpSnapshot = await _pumpReference?.get();
    final logsSnapshot = await _logsReference
        ?.child(FirebasePaths.logsLastUpdated)
        .get();

    final storageData = _decodeSnapshotData(storageSnapshot.value);
    final pumpData = _decodeSnapshotData(pumpSnapshot?.value);

    final storagePercentage = _asDouble(
      storageData[FirebasePaths.storagePercentage],
      fallback: 50,
    ).clamp(0, 100).toDouble();

    final capacityLiters = request.capacityLiters;
    final currentLiters = capacityLiters * (storagePercentage / 100);

    final flowRate = _asDouble(
      pumpData[FirebasePaths.waterPumpFlow],
      fallback: request.flowRateLitersPerMinute,
    );

    final lastUpdated =
        logsSnapshot?.value ?? storageData[FirebasePaths.logsLastUpdated];

    final rawHistory = storageData['history'];
    final history = rawHistory ?? _buildFallbackHistory(storagePercentage);

    return WaterStorageResponseModel.fromJson(<String, dynamic>{
      'current_liters': currentLiters,
      'capacity_liters': capacityLiters,
      'flow_rate_liters_per_minute': flowRate,
      'last_updated': lastUpdated,
      'over_flow': _asBool(
        storageData[FirebasePaths.overFlow],
        fallback: false,
      ),
      'history': history,
    });
  }

  Future<WaterStorageResponseModel> _buildMockStorageSnapshot(
    WaterStorageRequestModel request,
  ) async {
    const storagePercentage = 50.0;

    return WaterStorageResponseModel.fromJson(<String, dynamic>{
      'current_liters': request.capacityLiters * (storagePercentage / 100),
      'capacity_liters': request.capacityLiters,
      'flow_rate_liters_per_minute': request.flowRateLitersPerMinute,
      'last_updated': DateTime.now().toIso8601String(),
      'over_flow': false,
      'history': _buildFallbackHistory(storagePercentage),
    });
  }

  List<Map<String, dynamic>> _buildFallbackHistory(double levelPercentage) {
    final now = DateTime.now();

    return List<Map<String, dynamic>>.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      final baseline = levelPercentage - ((6 - index) * 2.2);
      final normalized = baseline.clamp(0, 100).toDouble();

      return <String, dynamic>{
        'date': DateTime(date.year, date.month, date.day).toIso8601String(),
        'level_percentage': normalized,
      };
    });
  }

  Map<String, dynamic> _decodeSnapshotData(Object? rawData) {
    if (rawData is Map) {
      return rawData.map(
        (key, value) => MapEntry(
          key.toString(),
          value is Map ? _decodeSnapshotData(value) : value,
        ),
      );
    }

    return const <String, dynamic>{};
  }

  double _asDouble(Object? value, {required double fallback}) {
    if (value is num) {
      return value.toDouble();
    }

    if (value is String) {
      return double.tryParse(value.trim()) ?? fallback;
    }

    return fallback;
  }

  bool _asBool(Object? value, {required bool fallback}) {
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
}

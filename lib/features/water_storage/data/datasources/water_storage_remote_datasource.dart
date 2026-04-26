import 'dart:async';
import 'dart:math';

import 'package:firebase_database/firebase_database.dart';
import 'package:motor_main/core/constants/firebase_paths.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_request_model.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';

class WaterStorageRemoteDatasource {
  WaterStorageRemoteDatasource({FirebaseDatabase? database})
    : _database = database;

  final FirebaseDatabase? _database;

  DatabaseReference? get _tankReference =>
      _database?.ref(FirebasePaths.waterTank);

  Stream<WaterStorageResponseModel> watchStorage(
    WaterStorageRequestModel request,
  ) {
    final tankReference = _tankReference;
    if (tankReference == null) {
      return _buildMockStorageStream(request);
    }

    return tankReference.onValue.map((event) {
      final json = _decodeSnapshotData(event.snapshot.value);
      return _buildStorageResponse(request: request, rawData: json);
    });
  }

  Future<WaterStorageResponseModel> fetchStorageSnapshot(
    WaterStorageRequestModel request,
  ) async {
    final tankReference = _tankReference;
    if (tankReference == null) {
      return _buildMockStorageSnapshot(request);
    }

    final snapshot = await tankReference.get();
    final json = _decodeSnapshotData(snapshot.value);
    return _buildStorageResponse(request: request, rawData: json);
  }

  WaterStorageResponseModel _buildStorageResponse({
    required WaterStorageRequestModel request,
    required Map<String, dynamic> rawData,
  }) {
    final mergedData = <String, dynamic>{
      'current_liters':
          rawData['current_liters'] ?? request.capacityLiters * 0.5,
      'capacity_liters': rawData['capacity_liters'] ?? request.capacityLiters,
      'flow_rate_liters_per_minute':
          rawData['flow_rate_liters_per_minute'] ??
          request.flowRateLitersPerMinute,
      'last_updated':
          rawData['last_updated'] ?? DateTime.now().toIso8601String(),
      'history': rawData['history'],
    };

    return WaterStorageResponseModel.fromJson(mergedData);
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

  Stream<WaterStorageResponseModel> _buildMockStorageStream(
    WaterStorageRequestModel request,
  ) async* {
    var tick = 0;
    while (true) {
      final phase = tick / 2;
      final levelPercentage = (55 + sin(phase) * 30).clamp(10, 100).toDouble();
      final currentLiters = request.capacityLiters * (levelPercentage / 100);

      yield WaterStorageResponseModel(
        currentLiters: currentLiters,
        capacityLiters: request.capacityLiters,
        flowRateLitersPerMinute: request.flowRateLitersPerMinute,
        lastUpdated: DateTime.now(),
        history: _buildMockHistory(
          levelPercentage: levelPercentage,
          seed: tick,
        ),
      );

      tick++;
      await Future<void>.delayed(const Duration(seconds: 4));
    }
  }

  Future<WaterStorageResponseModel> _buildMockStorageSnapshot(
    WaterStorageRequestModel request,
  ) async {
    final levelPercentage = 62.0;
    final currentLiters = request.capacityLiters * (levelPercentage / 100);

    return WaterStorageResponseModel(
      currentLiters: currentLiters,
      capacityLiters: request.capacityLiters,
      flowRateLitersPerMinute: request.flowRateLitersPerMinute,
      lastUpdated: DateTime.now(),
      history: _buildMockHistory(levelPercentage: levelPercentage, seed: 0),
    );
  }

  List<DailyWaterLevelPoint> _buildMockHistory({
    required double levelPercentage,
    required int seed,
  }) {
    final random = Random(seed);
    final now = DateTime.now();

    return List<DailyWaterLevelPoint>.generate(7, (index) {
      final date = now.subtract(Duration(days: 6 - index));
      final offset = random.nextDouble() * 18 - 9;
      final normalizedValue = (levelPercentage + offset)
          .clamp(0, 100)
          .toDouble();

      return DailyWaterLevelPoint(
        date: DateTime(date.year, date.month, date.day),
        levelPercentage: normalizedValue,
      );
    });
  }
}

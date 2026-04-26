import 'dart:async';

import 'package:firebase_database/firebase_database.dart';
import 'package:motor_main/core/constants/firebase_paths.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_request_model.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';

class WaterPumpRemoteDatasource {
  WaterPumpRemoteDatasource({FirebaseDatabase? database})
    : _database = database;

  final FirebaseDatabase? _database;
  bool _mockPumpOn = false;

  DatabaseReference? get _pumpReference => _database?.ref(FirebasePaths.pump);

  Stream<WaterPumpResponseModel> watchPumpStatus() {
    final pumpReference = _pumpReference;
    if (pumpReference == null) {
      return _buildMockPumpStatusStream();
    }

    return pumpReference.onValue.map((event) {
      final rawData = _decodeSnapshotData(event.snapshot.value);
      return _buildPumpResponse(rawData: rawData);
    });
  }

  Future<WaterPumpResponseModel> setPumpStatus(
    WaterPumpRequestModel request,
  ) async {
    final pumpReference = _pumpReference;
    if (pumpReference == null) {
      _mockPumpOn = request.desiredOn;
      return WaterPumpResponseModel(
        isOn: _mockPumpOn,
        lastUpdated: DateTime.now(),
        source: 'mock_${request.commandSource}',
      );
    }

    await pumpReference.update({
      'is_on': request.desiredOn,
      'last_updated': request.issuedAt.toIso8601String(),
      'source': request.commandSource,
    });

    final snapshot = await pumpReference.get();
    final rawData = _decodeSnapshotData(snapshot.value);
    return _buildPumpResponse(
      rawData: rawData,
      fallbackState: request.desiredOn,
    );
  }

  Stream<WaterPumpResponseModel> _buildMockPumpStatusStream() async* {
    while (true) {
      yield WaterPumpResponseModel(
        isOn: _mockPumpOn,
        lastUpdated: DateTime.now(),
        source: 'mock_stream',
      );
      await Future<void>.delayed(const Duration(seconds: 3));
    }
  }

  WaterPumpResponseModel _buildPumpResponse({
    required Map<String, dynamic> rawData,
    bool fallbackState = false,
  }) {
    final payload = <String, dynamic>{
      'is_on': rawData['is_on'] ?? fallbackState,
      'last_updated':
          rawData['last_updated'] ?? DateTime.now().toIso8601String(),
      'source': rawData['source'] ?? 'remote',
    };

    return WaterPumpResponseModel.fromJson(payload);
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
}

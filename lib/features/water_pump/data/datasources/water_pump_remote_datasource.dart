import 'package:firebase_database/firebase_database.dart';
import 'package:motor_main/core/constants/firebase_paths.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_request_model.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';

class WaterPumpRemoteDatasource {
  WaterPumpRemoteDatasource({FirebaseDatabase? database})
    : _database = database;

  final FirebaseDatabase? _database;
  bool _mockPumpOn = false;
  double _mockFlow = 0;

  DatabaseReference? get _pumpReference =>
      _database?.ref(FirebasePaths.waterPump);
  DatabaseReference? get _logsReference => _database?.ref(FirebasePaths.logs);

  Future<WaterPumpResponseModel> fetchPumpStatus() async {
    final pumpReference = _pumpReference;
    if (pumpReference == null) {
      return WaterPumpResponseModel(
        isOn: _mockPumpOn,
        flowLitersPerMinute: _mockFlow,
        lastUpdated: DateTime.now(),
        source: 'mock_snapshot',
      );
    }

    final pumpSnapshot = await pumpReference.get();
    final logsSnapshot = await _logsReference
        ?.child(FirebasePaths.logsLastUpdated)
        .get();

    final pumpData = _decodeSnapshotData(pumpSnapshot.value);
    return WaterPumpResponseModel.fromJson(<String, dynamic>{
      FirebasePaths.waterPumpStatus:
          pumpData[FirebasePaths.waterPumpStatus] ?? false,
      FirebasePaths.waterPumpFlow: pumpData[FirebasePaths.waterPumpFlow] ?? 0,
      FirebasePaths.logsLastUpdated:
          logsSnapshot?.value ?? pumpData[FirebasePaths.logsLastUpdated],
      'source': pumpData['source'] ?? 'firebase',
    });
  }

  Future<WaterPumpResponseModel> setPumpStatus(
    WaterPumpRequestModel request,
  ) async {
    final pumpReference = _pumpReference;
    if (pumpReference == null) {
      _mockPumpOn = request.desiredOn;
      if (request.flowLitersPerMinute != null) {
        _mockFlow = request.flowLitersPerMinute!;
      }

      return WaterPumpResponseModel(
        isOn: _mockPumpOn,
        flowLitersPerMinute: _mockFlow,
        lastUpdated: request.issuedAt,
        source: 'mock_${request.commandSource}',
      );
    }

    final pumpUpdates = <String, dynamic>{
      FirebasePaths.waterPumpStatus: request.desiredOn,
      'source': request.commandSource,
    };

    if (request.flowLitersPerMinute != null) {
      pumpUpdates[FirebasePaths.waterPumpFlow] = request.flowLitersPerMinute;
    }

    await pumpReference.update(pumpUpdates);
    await _logsReference?.update(<String, dynamic>{
      FirebasePaths.logsLastUpdated: request.issuedAt.toIso8601String(),
    });

    final snapshot = await fetchPumpStatus();
    return snapshot.copyWith(source: request.commandSource);
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

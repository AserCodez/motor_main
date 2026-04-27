import 'package:firebase_database/firebase_database.dart';
import 'package:motor_main/core/constants/firebase_paths.dart';

class WaterDataSource {
  WaterDataSource({FirebaseDatabase? database}) : _database = database;

  final FirebaseDatabase? _database;

  DatabaseReference? get _pumpReference =>
      _database?.ref(FirebasePaths.waterPump);
  DatabaseReference? get _logsReference => _database?.ref(FirebasePaths.logs);

  Future<double> getFlowOnce() async {
    try {
      final flowSnapshot = await _pumpReference
          ?.child(FirebasePaths.waterPumpFlow)
          .get();

      if (flowSnapshot?.exists ?? false) {
        final value = flowSnapshot?.value;
        if (value is num) {
          return value.toDouble();
        }

        if (value is String) {
          return double.tryParse(value.trim()) ?? 0;
        }
      }

      return 0;
    } catch (e) {
      return 0;
    }
  }

  Future<void> updateFlowValue(double newValue) async {
    await _pumpReference?.update(<String, dynamic>{
      FirebasePaths.waterPumpFlow: newValue,
    });

    await _logsReference?.update(<String, dynamic>{
      FirebasePaths.logsLastUpdated: DateTime.now().toIso8601String(),
    });
  }
}

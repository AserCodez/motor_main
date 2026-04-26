import 'package:motor_main/features/water_pump/data/datasources/water_pump_remote_datasource.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_request_model.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';
import 'package:motor_main/features/water_pump/domain/repositories/water_pump_repository.dart';

class WaterPumpRepositoryImpl implements WaterPumpRepository {
  WaterPumpRepositoryImpl({required WaterPumpRemoteDatasource remoteDatasource})
    : _remoteDatasource = remoteDatasource;

  final WaterPumpRemoteDatasource _remoteDatasource;

  @override
  Stream<WaterPumpResponseModel> watchPumpStatus() {
    return _remoteDatasource.watchPumpStatus();
  }

  @override
  Future<WaterPumpResponseModel> setPumpStatus(WaterPumpRequestModel request) {
    return _remoteDatasource.setPumpStatus(request);
  }
}

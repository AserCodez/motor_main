import 'package:motor_main/features/water_pump/data/models/water_pump_request_model.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';

abstract class WaterPumpRepository {
  Stream<WaterPumpResponseModel> watchPumpStatus();

  Future<WaterPumpResponseModel> setPumpStatus(WaterPumpRequestModel request);
}

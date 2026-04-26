import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';

part 'water_pump_state.freezed.dart';

@freezed
class WaterPumpState with _$WaterPumpState {
  const factory WaterPumpState.initial() = _Initial;

  const factory WaterPumpState.loading() = _Loading;

  const factory WaterPumpState.loaded({
    required WaterPumpResponseModel pump,
    @Default(false) bool isOptimisticUpdate,
  }) = _Loaded;

  const factory WaterPumpState.error({
    required String message,
    required WaterPumpResponseModel fallbackPump,
  }) = _Error;
}

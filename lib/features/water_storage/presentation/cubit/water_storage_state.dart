import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';

part 'water_storage_state.freezed.dart';

@freezed
class WaterStorageState with _$WaterStorageState {
  const factory WaterStorageState.initial() = _Initial;

  const factory WaterStorageState.loading() = _Loading;

  const factory WaterStorageState.loaded({
    required WaterStorageResponseModel storage,
    required double fillTimeMinutes,
  }) = _Loaded;

  const factory WaterStorageState.error({
    required String message,
    WaterStorageResponseModel? lastKnownStorage,
  }) = _Error;
}

import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_request_model.dart';
import 'package:motor_main/features/water_pump/data/models/water_pump_response_model.dart';
import 'package:motor_main/features/water_pump/domain/repositories/water_pump_repository.dart';
import 'package:motor_main/features/water_pump/presentation/cubit/water_pump_state.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_cubit.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_state.dart';

class WaterPumpCubit extends Cubit<WaterPumpState> {
  WaterPumpCubit({
    required WaterPumpRepository repository,
    required WaterStorageCubit waterStorageCubit,
  }) : _repository = repository,
       _waterStorageCubit = waterStorageCubit,
       super(const WaterPumpState.initial());

  final WaterPumpRepository _repository;
  final WaterStorageCubit _waterStorageCubit;

  StreamSubscription<WaterPumpResponseModel>? _pumpSubscription;
  StreamSubscription<WaterStorageState>? _storageSubscription;

  WaterPumpResponseModel _lastKnownPump = WaterPumpResponseModel.initial();
  bool _isMutationInFlight = false;

  Future<void> startMonitoring() async {
    emit(const WaterPumpState.loading());
    await _pumpSubscription?.cancel();
    await _storageSubscription?.cancel();

    _pumpSubscription = _repository.watchPumpStatus().listen(
      _onPumpStatus,
      onError: _onPumpError,
    );

    _storageSubscription = _waterStorageCubit.stream.listen(_onStorageState);
  }

  Future<void> togglePump({
    bool? forceStatus,
    String commandSource = 'manual_app_toggle',
  }) async {
    if (_isMutationInFlight) {
      return;
    }

    _isMutationInFlight = true;
    final previousPump = _lastKnownPump;
    final desiredOn = forceStatus ?? !previousPump.isOn;

    final optimisticPump = previousPump.copyWith(
      isOn: desiredOn,
      source: 'optimistic_$commandSource',
      lastUpdated: DateTime.now(),
    );

    _lastKnownPump = optimisticPump;
    emit(WaterPumpState.loaded(pump: optimisticPump, isOptimisticUpdate: true));

    try {
      final persistedPump = await _repository.setPumpStatus(
        WaterPumpRequestModel(
          desiredOn: desiredOn,
          commandSource: commandSource,
          issuedAt: DateTime.now(),
        ),
      );

      _lastKnownPump = persistedPump;
      emit(WaterPumpState.loaded(pump: persistedPump));
    } catch (error) {
      _lastKnownPump = previousPump;

      emit(
        WaterPumpState.error(
          message: 'Pump command failed and was rolled back: $error',
          fallbackPump: previousPump,
        ),
      );

      emit(WaterPumpState.loaded(pump: previousPump));
    } finally {
      _isMutationInFlight = false;
    }
  }

  void _onPumpStatus(WaterPumpResponseModel pumpStatus) {
    _lastKnownPump = pumpStatus;
    emit(WaterPumpState.loaded(pump: pumpStatus));
  }

  void _onPumpError(Object error, StackTrace stackTrace) {
    emit(
      WaterPumpState.error(
        message: 'Failed to read pump telemetry: $error',
        fallbackPump: _lastKnownPump,
      ),
    );
  }

  void _onStorageState(WaterStorageState storageState) {
    storageState.whenOrNull(
      loaded: (storage, _) {
        final tankIsFull = storage.levelPercentage >= 100;
        if (tankIsFull && _lastKnownPump.isOn && !_isMutationInFlight) {
          unawaited(
            togglePump(
              forceStatus: false,
              commandSource: 'auto_switch_full_tank',
            ),
          );
        }
      },
    );
  }

  @override
  Future<void> close() async {
    await _pumpSubscription?.cancel();
    await _storageSubscription?.cancel();
    return super.close();
  }
}

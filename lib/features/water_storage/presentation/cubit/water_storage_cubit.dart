import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_request_model.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/features/water_storage/domain/repositories/water_storage_repository.dart';
import 'package:motor_main/features/water_storage/domain/usecases/calculate_fill_time_usecase.dart';
import 'package:motor_main/features/water_storage/presentation/cubit/water_storage_state.dart';

class WaterStorageCubit extends Cubit<WaterStorageState> {
  WaterStorageCubit({
    required WaterStorageRepository repository,
    required WaterStorageRequestModel requestModel,
    required CalculateFillTimeUseCase calculateFillTimeUseCase,
  }) : _repository = repository,
       _requestModel = requestModel,
       _calculateFillTimeUseCase = calculateFillTimeUseCase,
       super(const WaterStorageState.initial());

  final WaterStorageRepository _repository;
  final WaterStorageRequestModel _requestModel;
  final CalculateFillTimeUseCase _calculateFillTimeUseCase;

  StreamSubscription<WaterStorageResponseModel>? _storageSubscription;
  WaterStorageResponseModel? _lastKnownStorage;

  Future<void> startMonitoring() async {
    emit(const WaterStorageState.loading());
    await _storageSubscription?.cancel();

    _storageSubscription = _repository
        .watchStorage(_requestModel)
        .listen(_onStorageSnapshot, onError: _onStorageError);
  }

  Future<void> refresh() async {
    emit(const WaterStorageState.loading());
    try {
      final snapshot = await _repository.fetchStorageSnapshot(_requestModel);
      _onStorageSnapshot(snapshot);
    } catch (error, stackTrace) {
      _onStorageError(error, stackTrace);
    }
  }

  void _onStorageSnapshot(WaterStorageResponseModel storage) {
    _lastKnownStorage = storage;

    final fillTimeMinutes = _calculateFillTimeUseCase(
      capacityLiters: storage.capacityLiters,
      currentLiters: storage.currentLiters,
      flowRateLitersPerMinute: storage.flowRateLitersPerMinute,
    );

    emit(
      WaterStorageState.loaded(
        storage: storage,
        fillTimeMinutes: fillTimeMinutes,
      ),
    );
  }

  void _onStorageError(Object error, StackTrace stackTrace) {
    emit(
      WaterStorageState.error(
        message: 'Failed to read storage telemetry: $error',
        lastKnownStorage: _lastKnownStorage,
      ),
    );
  }

  @override
  Future<void> close() async {
    await _storageSubscription?.cancel();
    return super.close();
  }
}

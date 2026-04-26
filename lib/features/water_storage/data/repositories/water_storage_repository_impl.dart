import 'package:motor_main/features/water_storage/data/datasources/water_storage_remote_datasource.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_request_model.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';
import 'package:motor_main/features/water_storage/domain/repositories/water_storage_repository.dart';

class WaterStorageRepositoryImpl implements WaterStorageRepository {
  WaterStorageRepositoryImpl({
    required WaterStorageRemoteDatasource remoteDatasource,
  }) : _remoteDatasource = remoteDatasource;

  final WaterStorageRemoteDatasource _remoteDatasource;

  @override
  Stream<WaterStorageResponseModel> watchStorage(
    WaterStorageRequestModel request,
  ) {
    return _remoteDatasource.watchStorage(request);
  }

  @override
  Future<WaterStorageResponseModel> fetchStorageSnapshot(
    WaterStorageRequestModel request,
  ) {
    return _remoteDatasource.fetchStorageSnapshot(request);
  }
}

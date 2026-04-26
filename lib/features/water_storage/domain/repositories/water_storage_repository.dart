import 'package:motor_main/features/water_storage/data/models/water_storage_request_model.dart';
import 'package:motor_main/features/water_storage/data/models/water_storage_response_model.dart';

abstract class WaterStorageRepository {
  Stream<WaterStorageResponseModel> watchStorage(
    WaterStorageRequestModel request,
  );

  Future<WaterStorageResponseModel> fetchStorageSnapshot(
    WaterStorageRequestModel request,
  );
}

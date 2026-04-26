import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'water_storage_state.dart';

class WaterStorageCubit extends Cubit<WaterStorageState> {
  WaterStorageCubit() : super(WaterStorageInitial());
}

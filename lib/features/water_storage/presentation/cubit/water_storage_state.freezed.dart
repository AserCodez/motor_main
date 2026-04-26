// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'water_storage_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WaterStorageState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WaterStorageState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WaterStorageState()';
}


}

/// @nodoc
class $WaterStorageStateCopyWith<$Res>  {
$WaterStorageStateCopyWith(WaterStorageState _, $Res Function(WaterStorageState) __);
}


/// Adds pattern-matching-related methods to [WaterStorageState].
extension WaterStorageStatePatterns on WaterStorageState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( WaterStorageResponseModel storage,  double fillTimeMinutes)?  loaded,TResult Function( String message,  WaterStorageResponseModel? lastKnownStorage)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.storage,_that.fillTimeMinutes);case _Error() when error != null:
return error(_that.message,_that.lastKnownStorage);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( WaterStorageResponseModel storage,  double fillTimeMinutes)  loaded,required TResult Function( String message,  WaterStorageResponseModel? lastKnownStorage)  error,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.storage,_that.fillTimeMinutes);case _Error():
return error(_that.message,_that.lastKnownStorage);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( WaterStorageResponseModel storage,  double fillTimeMinutes)?  loaded,TResult? Function( String message,  WaterStorageResponseModel? lastKnownStorage)?  error,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.storage,_that.fillTimeMinutes);case _Error() when error != null:
return error(_that.message,_that.lastKnownStorage);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements WaterStorageState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WaterStorageState.initial()';
}


}




/// @nodoc


class _Loading implements WaterStorageState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'WaterStorageState.loading()';
}


}




/// @nodoc


class _Loaded implements WaterStorageState {
  const _Loaded({required this.storage, required this.fillTimeMinutes});
  

 final  WaterStorageResponseModel storage;
 final  double fillTimeMinutes;

/// Create a copy of WaterStorageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&(identical(other.storage, storage) || other.storage == storage)&&(identical(other.fillTimeMinutes, fillTimeMinutes) || other.fillTimeMinutes == fillTimeMinutes));
}


@override
int get hashCode => Object.hash(runtimeType,storage,fillTimeMinutes);

@override
String toString() {
  return 'WaterStorageState.loaded(storage: $storage, fillTimeMinutes: $fillTimeMinutes)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $WaterStorageStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 WaterStorageResponseModel storage, double fillTimeMinutes
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of WaterStorageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? storage = null,Object? fillTimeMinutes = null,}) {
  return _then(_Loaded(
storage: null == storage ? _self.storage : storage // ignore: cast_nullable_to_non_nullable
as WaterStorageResponseModel,fillTimeMinutes: null == fillTimeMinutes ? _self.fillTimeMinutes : fillTimeMinutes // ignore: cast_nullable_to_non_nullable
as double,
  ));
}


}

/// @nodoc


class _Error implements WaterStorageState {
  const _Error({required this.message, this.lastKnownStorage});
  

 final  String message;
 final  WaterStorageResponseModel? lastKnownStorage;

/// Create a copy of WaterStorageState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message)&&(identical(other.lastKnownStorage, lastKnownStorage) || other.lastKnownStorage == lastKnownStorage));
}


@override
int get hashCode => Object.hash(runtimeType,message,lastKnownStorage);

@override
String toString() {
  return 'WaterStorageState.error(message: $message, lastKnownStorage: $lastKnownStorage)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $WaterStorageStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message, WaterStorageResponseModel? lastKnownStorage
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of WaterStorageState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? lastKnownStorage = freezed,}) {
  return _then(_Error(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,lastKnownStorage: freezed == lastKnownStorage ? _self.lastKnownStorage : lastKnownStorage // ignore: cast_nullable_to_non_nullable
as WaterStorageResponseModel?,
  ));
}


}

// dart format on

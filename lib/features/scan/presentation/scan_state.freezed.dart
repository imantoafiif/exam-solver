// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ScanState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScanState()';
}


}

/// @nodoc
class $ScanStateCopyWith<$Res>  {
$ScanStateCopyWith(ScanState _, $Res Function(ScanState) __);
}


/// Adds pattern-matching-related methods to [ScanState].
extension ScanStatePatterns on ScanState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ScanCameraReady value)?  cameraReady,TResult Function( ScanCapturing value)?  capturing,TResult Function( ScanAnalyzing value)?  analyzing,TResult Function( ScanResult value)?  result,TResult Function( ScanError value)?  error,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ScanCameraReady() when cameraReady != null:
return cameraReady(_that);case ScanCapturing() when capturing != null:
return capturing(_that);case ScanAnalyzing() when analyzing != null:
return analyzing(_that);case ScanResult() when result != null:
return result(_that);case ScanError() when error != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ScanCameraReady value)  cameraReady,required TResult Function( ScanCapturing value)  capturing,required TResult Function( ScanAnalyzing value)  analyzing,required TResult Function( ScanResult value)  result,required TResult Function( ScanError value)  error,}){
final _that = this;
switch (_that) {
case ScanCameraReady():
return cameraReady(_that);case ScanCapturing():
return capturing(_that);case ScanAnalyzing():
return analyzing(_that);case ScanResult():
return result(_that);case ScanError():
return error(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ScanCameraReady value)?  cameraReady,TResult? Function( ScanCapturing value)?  capturing,TResult? Function( ScanAnalyzing value)?  analyzing,TResult? Function( ScanResult value)?  result,TResult? Function( ScanError value)?  error,}){
final _that = this;
switch (_that) {
case ScanCameraReady() when cameraReady != null:
return cameraReady(_that);case ScanCapturing() when capturing != null:
return capturing(_that);case ScanAnalyzing() when analyzing != null:
return analyzing(_that);case ScanResult() when result != null:
return result(_that);case ScanError() when error != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  cameraReady,TResult Function()?  capturing,TResult Function( Uint8List frame)?  analyzing,TResult Function( AnswerResult answer,  Uint8List frame)?  result,TResult Function( String message,  Uint8List? frame)?  error,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ScanCameraReady() when cameraReady != null:
return cameraReady();case ScanCapturing() when capturing != null:
return capturing();case ScanAnalyzing() when analyzing != null:
return analyzing(_that.frame);case ScanResult() when result != null:
return result(_that.answer,_that.frame);case ScanError() when error != null:
return error(_that.message,_that.frame);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  cameraReady,required TResult Function()  capturing,required TResult Function( Uint8List frame)  analyzing,required TResult Function( AnswerResult answer,  Uint8List frame)  result,required TResult Function( String message,  Uint8List? frame)  error,}) {final _that = this;
switch (_that) {
case ScanCameraReady():
return cameraReady();case ScanCapturing():
return capturing();case ScanAnalyzing():
return analyzing(_that.frame);case ScanResult():
return result(_that.answer,_that.frame);case ScanError():
return error(_that.message,_that.frame);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  cameraReady,TResult? Function()?  capturing,TResult? Function( Uint8List frame)?  analyzing,TResult? Function( AnswerResult answer,  Uint8List frame)?  result,TResult? Function( String message,  Uint8List? frame)?  error,}) {final _that = this;
switch (_that) {
case ScanCameraReady() when cameraReady != null:
return cameraReady();case ScanCapturing() when capturing != null:
return capturing();case ScanAnalyzing() when analyzing != null:
return analyzing(_that.frame);case ScanResult() when result != null:
return result(_that.answer,_that.frame);case ScanError() when error != null:
return error(_that.message,_that.frame);case _:
  return null;

}
}

}

/// @nodoc


class ScanCameraReady implements ScanState {
  const ScanCameraReady();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanCameraReady);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScanState.cameraReady()';
}


}




/// @nodoc


class ScanCapturing implements ScanState {
  const ScanCapturing();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanCapturing);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ScanState.capturing()';
}


}




/// @nodoc


class ScanAnalyzing implements ScanState {
  const ScanAnalyzing(this.frame);
  

 final  Uint8List frame;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanAnalyzingCopyWith<ScanAnalyzing> get copyWith => _$ScanAnalyzingCopyWithImpl<ScanAnalyzing>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanAnalyzing&&const DeepCollectionEquality().equals(other.frame, frame));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(frame));

@override
String toString() {
  return 'ScanState.analyzing(frame: $frame)';
}


}

/// @nodoc
abstract mixin class $ScanAnalyzingCopyWith<$Res> implements $ScanStateCopyWith<$Res> {
  factory $ScanAnalyzingCopyWith(ScanAnalyzing value, $Res Function(ScanAnalyzing) _then) = _$ScanAnalyzingCopyWithImpl;
@useResult
$Res call({
 Uint8List frame
});




}
/// @nodoc
class _$ScanAnalyzingCopyWithImpl<$Res>
    implements $ScanAnalyzingCopyWith<$Res> {
  _$ScanAnalyzingCopyWithImpl(this._self, this._then);

  final ScanAnalyzing _self;
  final $Res Function(ScanAnalyzing) _then;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? frame = null,}) {
  return _then(ScanAnalyzing(
null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}


}

/// @nodoc


class ScanResult implements ScanState {
  const ScanResult(this.answer, this.frame);
  

 final  AnswerResult answer;
 final  Uint8List frame;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanResultCopyWith<ScanResult> get copyWith => _$ScanResultCopyWithImpl<ScanResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanResult&&(identical(other.answer, answer) || other.answer == answer)&&const DeepCollectionEquality().equals(other.frame, frame));
}


@override
int get hashCode => Object.hash(runtimeType,answer,const DeepCollectionEquality().hash(frame));

@override
String toString() {
  return 'ScanState.result(answer: $answer, frame: $frame)';
}


}

/// @nodoc
abstract mixin class $ScanResultCopyWith<$Res> implements $ScanStateCopyWith<$Res> {
  factory $ScanResultCopyWith(ScanResult value, $Res Function(ScanResult) _then) = _$ScanResultCopyWithImpl;
@useResult
$Res call({
 AnswerResult answer, Uint8List frame
});


$AnswerResultCopyWith<$Res> get answer;

}
/// @nodoc
class _$ScanResultCopyWithImpl<$Res>
    implements $ScanResultCopyWith<$Res> {
  _$ScanResultCopyWithImpl(this._self, this._then);

  final ScanResult _self;
  final $Res Function(ScanResult) _then;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? answer = null,Object? frame = null,}) {
  return _then(ScanResult(
null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as AnswerResult,null == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as Uint8List,
  ));
}

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$AnswerResultCopyWith<$Res> get answer {
  
  return $AnswerResultCopyWith<$Res>(_self.answer, (value) {
    return _then(_self.copyWith(answer: value));
  });
}
}

/// @nodoc


class ScanError implements ScanState {
  const ScanError(this.message, {this.frame});
  

 final  String message;
 final  Uint8List? frame;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ScanErrorCopyWith<ScanError> get copyWith => _$ScanErrorCopyWithImpl<ScanError>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ScanError&&(identical(other.message, message) || other.message == message)&&const DeepCollectionEquality().equals(other.frame, frame));
}


@override
int get hashCode => Object.hash(runtimeType,message,const DeepCollectionEquality().hash(frame));

@override
String toString() {
  return 'ScanState.error(message: $message, frame: $frame)';
}


}

/// @nodoc
abstract mixin class $ScanErrorCopyWith<$Res> implements $ScanStateCopyWith<$Res> {
  factory $ScanErrorCopyWith(ScanError value, $Res Function(ScanError) _then) = _$ScanErrorCopyWithImpl;
@useResult
$Res call({
 String message, Uint8List? frame
});




}
/// @nodoc
class _$ScanErrorCopyWithImpl<$Res>
    implements $ScanErrorCopyWith<$Res> {
  _$ScanErrorCopyWithImpl(this._self, this._then);

  final ScanError _self;
  final $Res Function(ScanError) _then;

/// Create a copy of ScanState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? frame = freezed,}) {
  return _then(ScanError(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,frame: freezed == frame ? _self.frame : frame // ignore: cast_nullable_to_non_nullable
as Uint8List?,
  ));
}


}

// dart format on

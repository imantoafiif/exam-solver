// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gemini_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeminiResponse {

 List<GeminiCandidate>? get candidates; GeminiPromptFeedback? get promptFeedback;
/// Create a copy of GeminiResponse
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiResponseCopyWith<GeminiResponse> get copyWith => _$GeminiResponseCopyWithImpl<GeminiResponse>(this as GeminiResponse, _$identity);

  /// Serializes this GeminiResponse to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiResponse&&const DeepCollectionEquality().equals(other.candidates, candidates)&&(identical(other.promptFeedback, promptFeedback) || other.promptFeedback == promptFeedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(candidates),promptFeedback);

@override
String toString() {
  return 'GeminiResponse(candidates: $candidates, promptFeedback: $promptFeedback)';
}


}

/// @nodoc
abstract mixin class $GeminiResponseCopyWith<$Res>  {
  factory $GeminiResponseCopyWith(GeminiResponse value, $Res Function(GeminiResponse) _then) = _$GeminiResponseCopyWithImpl;
@useResult
$Res call({
 List<GeminiCandidate>? candidates, GeminiPromptFeedback? promptFeedback
});


$GeminiPromptFeedbackCopyWith<$Res>? get promptFeedback;

}
/// @nodoc
class _$GeminiResponseCopyWithImpl<$Res>
    implements $GeminiResponseCopyWith<$Res> {
  _$GeminiResponseCopyWithImpl(this._self, this._then);

  final GeminiResponse _self;
  final $Res Function(GeminiResponse) _then;

/// Create a copy of GeminiResponse
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? candidates = freezed,Object? promptFeedback = freezed,}) {
  return _then(_self.copyWith(
candidates: freezed == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<GeminiCandidate>?,promptFeedback: freezed == promptFeedback ? _self.promptFeedback : promptFeedback // ignore: cast_nullable_to_non_nullable
as GeminiPromptFeedback?,
  ));
}
/// Create a copy of GeminiResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiPromptFeedbackCopyWith<$Res>? get promptFeedback {
    if (_self.promptFeedback == null) {
    return null;
  }

  return $GeminiPromptFeedbackCopyWith<$Res>(_self.promptFeedback!, (value) {
    return _then(_self.copyWith(promptFeedback: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeminiResponse].
extension GeminiResponsePatterns on GeminiResponse {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiResponse value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiResponse value)  $default,){
final _that = this;
switch (_that) {
case _GeminiResponse():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiResponse value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiResponse() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GeminiCandidate>? candidates,  GeminiPromptFeedback? promptFeedback)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiResponse() when $default != null:
return $default(_that.candidates,_that.promptFeedback);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GeminiCandidate>? candidates,  GeminiPromptFeedback? promptFeedback)  $default,) {final _that = this;
switch (_that) {
case _GeminiResponse():
return $default(_that.candidates,_that.promptFeedback);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GeminiCandidate>? candidates,  GeminiPromptFeedback? promptFeedback)?  $default,) {final _that = this;
switch (_that) {
case _GeminiResponse() when $default != null:
return $default(_that.candidates,_that.promptFeedback);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiResponse implements GeminiResponse {
  const _GeminiResponse({final  List<GeminiCandidate>? candidates, this.promptFeedback}): _candidates = candidates;
  factory _GeminiResponse.fromJson(Map<String, dynamic> json) => _$GeminiResponseFromJson(json);

 final  List<GeminiCandidate>? _candidates;
@override List<GeminiCandidate>? get candidates {
  final value = _candidates;
  if (value == null) return null;
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(value);
}

@override final  GeminiPromptFeedback? promptFeedback;

/// Create a copy of GeminiResponse
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiResponseCopyWith<_GeminiResponse> get copyWith => __$GeminiResponseCopyWithImpl<_GeminiResponse>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiResponseToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiResponse&&const DeepCollectionEquality().equals(other._candidates, _candidates)&&(identical(other.promptFeedback, promptFeedback) || other.promptFeedback == promptFeedback));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_candidates),promptFeedback);

@override
String toString() {
  return 'GeminiResponse(candidates: $candidates, promptFeedback: $promptFeedback)';
}


}

/// @nodoc
abstract mixin class _$GeminiResponseCopyWith<$Res> implements $GeminiResponseCopyWith<$Res> {
  factory _$GeminiResponseCopyWith(_GeminiResponse value, $Res Function(_GeminiResponse) _then) = __$GeminiResponseCopyWithImpl;
@override @useResult
$Res call({
 List<GeminiCandidate>? candidates, GeminiPromptFeedback? promptFeedback
});


@override $GeminiPromptFeedbackCopyWith<$Res>? get promptFeedback;

}
/// @nodoc
class __$GeminiResponseCopyWithImpl<$Res>
    implements _$GeminiResponseCopyWith<$Res> {
  __$GeminiResponseCopyWithImpl(this._self, this._then);

  final _GeminiResponse _self;
  final $Res Function(_GeminiResponse) _then;

/// Create a copy of GeminiResponse
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? candidates = freezed,Object? promptFeedback = freezed,}) {
  return _then(_GeminiResponse(
candidates: freezed == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<GeminiCandidate>?,promptFeedback: freezed == promptFeedback ? _self.promptFeedback : promptFeedback // ignore: cast_nullable_to_non_nullable
as GeminiPromptFeedback?,
  ));
}

/// Create a copy of GeminiResponse
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiPromptFeedbackCopyWith<$Res>? get promptFeedback {
    if (_self.promptFeedback == null) {
    return null;
  }

  return $GeminiPromptFeedbackCopyWith<$Res>(_self.promptFeedback!, (value) {
    return _then(_self.copyWith(promptFeedback: value));
  });
}
}


/// @nodoc
mixin _$GeminiCandidate {

 GeminiContent? get content; String? get finishReason;
/// Create a copy of GeminiCandidate
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiCandidateCopyWith<GeminiCandidate> get copyWith => _$GeminiCandidateCopyWithImpl<GeminiCandidate>(this as GeminiCandidate, _$identity);

  /// Serializes this GeminiCandidate to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiCandidate&&(identical(other.content, content) || other.content == content)&&(identical(other.finishReason, finishReason) || other.finishReason == finishReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,finishReason);

@override
String toString() {
  return 'GeminiCandidate(content: $content, finishReason: $finishReason)';
}


}

/// @nodoc
abstract mixin class $GeminiCandidateCopyWith<$Res>  {
  factory $GeminiCandidateCopyWith(GeminiCandidate value, $Res Function(GeminiCandidate) _then) = _$GeminiCandidateCopyWithImpl;
@useResult
$Res call({
 GeminiContent? content, String? finishReason
});


$GeminiContentCopyWith<$Res>? get content;

}
/// @nodoc
class _$GeminiCandidateCopyWithImpl<$Res>
    implements $GeminiCandidateCopyWith<$Res> {
  _$GeminiCandidateCopyWithImpl(this._self, this._then);

  final GeminiCandidate _self;
  final $Res Function(GeminiCandidate) _then;

/// Create a copy of GeminiCandidate
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? content = freezed,Object? finishReason = freezed,}) {
  return _then(_self.copyWith(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GeminiContent?,finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}
/// Create a copy of GeminiCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $GeminiContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeminiCandidate].
extension GeminiCandidatePatterns on GeminiCandidate {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiCandidate value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiCandidate() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiCandidate value)  $default,){
final _that = this;
switch (_that) {
case _GeminiCandidate():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiCandidate value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiCandidate() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( GeminiContent? content,  String? finishReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiCandidate() when $default != null:
return $default(_that.content,_that.finishReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( GeminiContent? content,  String? finishReason)  $default,) {final _that = this;
switch (_that) {
case _GeminiCandidate():
return $default(_that.content,_that.finishReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( GeminiContent? content,  String? finishReason)?  $default,) {final _that = this;
switch (_that) {
case _GeminiCandidate() when $default != null:
return $default(_that.content,_that.finishReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiCandidate implements GeminiCandidate {
  const _GeminiCandidate({this.content, this.finishReason});
  factory _GeminiCandidate.fromJson(Map<String, dynamic> json) => _$GeminiCandidateFromJson(json);

@override final  GeminiContent? content;
@override final  String? finishReason;

/// Create a copy of GeminiCandidate
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiCandidateCopyWith<_GeminiCandidate> get copyWith => __$GeminiCandidateCopyWithImpl<_GeminiCandidate>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiCandidateToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiCandidate&&(identical(other.content, content) || other.content == content)&&(identical(other.finishReason, finishReason) || other.finishReason == finishReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,content,finishReason);

@override
String toString() {
  return 'GeminiCandidate(content: $content, finishReason: $finishReason)';
}


}

/// @nodoc
abstract mixin class _$GeminiCandidateCopyWith<$Res> implements $GeminiCandidateCopyWith<$Res> {
  factory _$GeminiCandidateCopyWith(_GeminiCandidate value, $Res Function(_GeminiCandidate) _then) = __$GeminiCandidateCopyWithImpl;
@override @useResult
$Res call({
 GeminiContent? content, String? finishReason
});


@override $GeminiContentCopyWith<$Res>? get content;

}
/// @nodoc
class __$GeminiCandidateCopyWithImpl<$Res>
    implements _$GeminiCandidateCopyWith<$Res> {
  __$GeminiCandidateCopyWithImpl(this._self, this._then);

  final _GeminiCandidate _self;
  final $Res Function(_GeminiCandidate) _then;

/// Create a copy of GeminiCandidate
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? content = freezed,Object? finishReason = freezed,}) {
  return _then(_GeminiCandidate(
content: freezed == content ? _self.content : content // ignore: cast_nullable_to_non_nullable
as GeminiContent?,finishReason: freezed == finishReason ? _self.finishReason : finishReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

/// Create a copy of GeminiCandidate
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiContentCopyWith<$Res>? get content {
    if (_self.content == null) {
    return null;
  }

  return $GeminiContentCopyWith<$Res>(_self.content!, (value) {
    return _then(_self.copyWith(content: value));
  });
}
}


/// @nodoc
mixin _$GeminiPromptFeedback {

 String? get blockReason;
/// Create a copy of GeminiPromptFeedback
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiPromptFeedbackCopyWith<GeminiPromptFeedback> get copyWith => _$GeminiPromptFeedbackCopyWithImpl<GeminiPromptFeedback>(this as GeminiPromptFeedback, _$identity);

  /// Serializes this GeminiPromptFeedback to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiPromptFeedback&&(identical(other.blockReason, blockReason) || other.blockReason == blockReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blockReason);

@override
String toString() {
  return 'GeminiPromptFeedback(blockReason: $blockReason)';
}


}

/// @nodoc
abstract mixin class $GeminiPromptFeedbackCopyWith<$Res>  {
  factory $GeminiPromptFeedbackCopyWith(GeminiPromptFeedback value, $Res Function(GeminiPromptFeedback) _then) = _$GeminiPromptFeedbackCopyWithImpl;
@useResult
$Res call({
 String? blockReason
});




}
/// @nodoc
class _$GeminiPromptFeedbackCopyWithImpl<$Res>
    implements $GeminiPromptFeedbackCopyWith<$Res> {
  _$GeminiPromptFeedbackCopyWithImpl(this._self, this._then);

  final GeminiPromptFeedback _self;
  final $Res Function(GeminiPromptFeedback) _then;

/// Create a copy of GeminiPromptFeedback
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? blockReason = freezed,}) {
  return _then(_self.copyWith(
blockReason: freezed == blockReason ? _self.blockReason : blockReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeminiPromptFeedback].
extension GeminiPromptFeedbackPatterns on GeminiPromptFeedback {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiPromptFeedback value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiPromptFeedback() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiPromptFeedback value)  $default,){
final _that = this;
switch (_that) {
case _GeminiPromptFeedback():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiPromptFeedback value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiPromptFeedback() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? blockReason)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiPromptFeedback() when $default != null:
return $default(_that.blockReason);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? blockReason)  $default,) {final _that = this;
switch (_that) {
case _GeminiPromptFeedback():
return $default(_that.blockReason);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? blockReason)?  $default,) {final _that = this;
switch (_that) {
case _GeminiPromptFeedback() when $default != null:
return $default(_that.blockReason);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiPromptFeedback implements GeminiPromptFeedback {
  const _GeminiPromptFeedback({this.blockReason});
  factory _GeminiPromptFeedback.fromJson(Map<String, dynamic> json) => _$GeminiPromptFeedbackFromJson(json);

@override final  String? blockReason;

/// Create a copy of GeminiPromptFeedback
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiPromptFeedbackCopyWith<_GeminiPromptFeedback> get copyWith => __$GeminiPromptFeedbackCopyWithImpl<_GeminiPromptFeedback>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiPromptFeedbackToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiPromptFeedback&&(identical(other.blockReason, blockReason) || other.blockReason == blockReason));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,blockReason);

@override
String toString() {
  return 'GeminiPromptFeedback(blockReason: $blockReason)';
}


}

/// @nodoc
abstract mixin class _$GeminiPromptFeedbackCopyWith<$Res> implements $GeminiPromptFeedbackCopyWith<$Res> {
  factory _$GeminiPromptFeedbackCopyWith(_GeminiPromptFeedback value, $Res Function(_GeminiPromptFeedback) _then) = __$GeminiPromptFeedbackCopyWithImpl;
@override @useResult
$Res call({
 String? blockReason
});




}
/// @nodoc
class __$GeminiPromptFeedbackCopyWithImpl<$Res>
    implements _$GeminiPromptFeedbackCopyWith<$Res> {
  __$GeminiPromptFeedbackCopyWithImpl(this._self, this._then);

  final _GeminiPromptFeedback _self;
  final $Res Function(_GeminiPromptFeedback) _then;

/// Create a copy of GeminiPromptFeedback
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? blockReason = freezed,}) {
  return _then(_GeminiPromptFeedback(
blockReason: freezed == blockReason ? _self.blockReason : blockReason // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on

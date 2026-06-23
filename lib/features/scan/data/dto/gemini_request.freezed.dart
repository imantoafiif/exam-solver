// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'gemini_request.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$GeminiRequest {

@JsonKey(name: "system_instruction") GeminiContent get systemInstruction; List<GeminiContent> get contents; GeminiGenerationConfig get generationConfig;
/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiRequestCopyWith<GeminiRequest> get copyWith => _$GeminiRequestCopyWithImpl<GeminiRequest>(this as GeminiRequest, _$identity);

  /// Serializes this GeminiRequest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiRequest&&(identical(other.systemInstruction, systemInstruction) || other.systemInstruction == systemInstruction)&&const DeepCollectionEquality().equals(other.contents, contents)&&(identical(other.generationConfig, generationConfig) || other.generationConfig == generationConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systemInstruction,const DeepCollectionEquality().hash(contents),generationConfig);

@override
String toString() {
  return 'GeminiRequest(systemInstruction: $systemInstruction, contents: $contents, generationConfig: $generationConfig)';
}


}

/// @nodoc
abstract mixin class $GeminiRequestCopyWith<$Res>  {
  factory $GeminiRequestCopyWith(GeminiRequest value, $Res Function(GeminiRequest) _then) = _$GeminiRequestCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "system_instruction") GeminiContent systemInstruction, List<GeminiContent> contents, GeminiGenerationConfig generationConfig
});


$GeminiContentCopyWith<$Res> get systemInstruction;$GeminiGenerationConfigCopyWith<$Res> get generationConfig;

}
/// @nodoc
class _$GeminiRequestCopyWithImpl<$Res>
    implements $GeminiRequestCopyWith<$Res> {
  _$GeminiRequestCopyWithImpl(this._self, this._then);

  final GeminiRequest _self;
  final $Res Function(GeminiRequest) _then;

/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? systemInstruction = null,Object? contents = null,Object? generationConfig = null,}) {
  return _then(_self.copyWith(
systemInstruction: null == systemInstruction ? _self.systemInstruction : systemInstruction // ignore: cast_nullable_to_non_nullable
as GeminiContent,contents: null == contents ? _self.contents : contents // ignore: cast_nullable_to_non_nullable
as List<GeminiContent>,generationConfig: null == generationConfig ? _self.generationConfig : generationConfig // ignore: cast_nullable_to_non_nullable
as GeminiGenerationConfig,
  ));
}
/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiContentCopyWith<$Res> get systemInstruction {
  
  return $GeminiContentCopyWith<$Res>(_self.systemInstruction, (value) {
    return _then(_self.copyWith(systemInstruction: value));
  });
}/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiGenerationConfigCopyWith<$Res> get generationConfig {
  
  return $GeminiGenerationConfigCopyWith<$Res>(_self.generationConfig, (value) {
    return _then(_self.copyWith(generationConfig: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeminiRequest].
extension GeminiRequestPatterns on GeminiRequest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiRequest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiRequest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiRequest value)  $default,){
final _that = this;
switch (_that) {
case _GeminiRequest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiRequest value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiRequest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "system_instruction")  GeminiContent systemInstruction,  List<GeminiContent> contents,  GeminiGenerationConfig generationConfig)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiRequest() when $default != null:
return $default(_that.systemInstruction,_that.contents,_that.generationConfig);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "system_instruction")  GeminiContent systemInstruction,  List<GeminiContent> contents,  GeminiGenerationConfig generationConfig)  $default,) {final _that = this;
switch (_that) {
case _GeminiRequest():
return $default(_that.systemInstruction,_that.contents,_that.generationConfig);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "system_instruction")  GeminiContent systemInstruction,  List<GeminiContent> contents,  GeminiGenerationConfig generationConfig)?  $default,) {final _that = this;
switch (_that) {
case _GeminiRequest() when $default != null:
return $default(_that.systemInstruction,_that.contents,_that.generationConfig);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiRequest implements GeminiRequest {
  const _GeminiRequest({@JsonKey(name: "system_instruction") required this.systemInstruction, required final  List<GeminiContent> contents, required this.generationConfig}): _contents = contents;
  factory _GeminiRequest.fromJson(Map<String, dynamic> json) => _$GeminiRequestFromJson(json);

@override@JsonKey(name: "system_instruction") final  GeminiContent systemInstruction;
 final  List<GeminiContent> _contents;
@override List<GeminiContent> get contents {
  if (_contents is EqualUnmodifiableListView) return _contents;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_contents);
}

@override final  GeminiGenerationConfig generationConfig;

/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiRequestCopyWith<_GeminiRequest> get copyWith => __$GeminiRequestCopyWithImpl<_GeminiRequest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiRequestToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiRequest&&(identical(other.systemInstruction, systemInstruction) || other.systemInstruction == systemInstruction)&&const DeepCollectionEquality().equals(other._contents, _contents)&&(identical(other.generationConfig, generationConfig) || other.generationConfig == generationConfig));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,systemInstruction,const DeepCollectionEquality().hash(_contents),generationConfig);

@override
String toString() {
  return 'GeminiRequest(systemInstruction: $systemInstruction, contents: $contents, generationConfig: $generationConfig)';
}


}

/// @nodoc
abstract mixin class _$GeminiRequestCopyWith<$Res> implements $GeminiRequestCopyWith<$Res> {
  factory _$GeminiRequestCopyWith(_GeminiRequest value, $Res Function(_GeminiRequest) _then) = __$GeminiRequestCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "system_instruction") GeminiContent systemInstruction, List<GeminiContent> contents, GeminiGenerationConfig generationConfig
});


@override $GeminiContentCopyWith<$Res> get systemInstruction;@override $GeminiGenerationConfigCopyWith<$Res> get generationConfig;

}
/// @nodoc
class __$GeminiRequestCopyWithImpl<$Res>
    implements _$GeminiRequestCopyWith<$Res> {
  __$GeminiRequestCopyWithImpl(this._self, this._then);

  final _GeminiRequest _self;
  final $Res Function(_GeminiRequest) _then;

/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? systemInstruction = null,Object? contents = null,Object? generationConfig = null,}) {
  return _then(_GeminiRequest(
systemInstruction: null == systemInstruction ? _self.systemInstruction : systemInstruction // ignore: cast_nullable_to_non_nullable
as GeminiContent,contents: null == contents ? _self._contents : contents // ignore: cast_nullable_to_non_nullable
as List<GeminiContent>,generationConfig: null == generationConfig ? _self.generationConfig : generationConfig // ignore: cast_nullable_to_non_nullable
as GeminiGenerationConfig,
  ));
}

/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiContentCopyWith<$Res> get systemInstruction {
  
  return $GeminiContentCopyWith<$Res>(_self.systemInstruction, (value) {
    return _then(_self.copyWith(systemInstruction: value));
  });
}/// Create a copy of GeminiRequest
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiGenerationConfigCopyWith<$Res> get generationConfig {
  
  return $GeminiGenerationConfigCopyWith<$Res>(_self.generationConfig, (value) {
    return _then(_self.copyWith(generationConfig: value));
  });
}
}


/// @nodoc
mixin _$GeminiContent {

 List<GeminiPart> get parts;@JsonKey(includeIfNull: false) String? get role;
/// Create a copy of GeminiContent
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiContentCopyWith<GeminiContent> get copyWith => _$GeminiContentCopyWithImpl<GeminiContent>(this as GeminiContent, _$identity);

  /// Serializes this GeminiContent to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiContent&&const DeepCollectionEquality().equals(other.parts, parts)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(parts),role);

@override
String toString() {
  return 'GeminiContent(parts: $parts, role: $role)';
}


}

/// @nodoc
abstract mixin class $GeminiContentCopyWith<$Res>  {
  factory $GeminiContentCopyWith(GeminiContent value, $Res Function(GeminiContent) _then) = _$GeminiContentCopyWithImpl;
@useResult
$Res call({
 List<GeminiPart> parts,@JsonKey(includeIfNull: false) String? role
});




}
/// @nodoc
class _$GeminiContentCopyWithImpl<$Res>
    implements $GeminiContentCopyWith<$Res> {
  _$GeminiContentCopyWithImpl(this._self, this._then);

  final GeminiContent _self;
  final $Res Function(GeminiContent) _then;

/// Create a copy of GeminiContent
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? parts = null,Object? role = freezed,}) {
  return _then(_self.copyWith(
parts: null == parts ? _self.parts : parts // ignore: cast_nullable_to_non_nullable
as List<GeminiPart>,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [GeminiContent].
extension GeminiContentPatterns on GeminiContent {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiContent value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiContent() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiContent value)  $default,){
final _that = this;
switch (_that) {
case _GeminiContent():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiContent value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiContent() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<GeminiPart> parts, @JsonKey(includeIfNull: false)  String? role)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiContent() when $default != null:
return $default(_that.parts,_that.role);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<GeminiPart> parts, @JsonKey(includeIfNull: false)  String? role)  $default,) {final _that = this;
switch (_that) {
case _GeminiContent():
return $default(_that.parts,_that.role);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<GeminiPart> parts, @JsonKey(includeIfNull: false)  String? role)?  $default,) {final _that = this;
switch (_that) {
case _GeminiContent() when $default != null:
return $default(_that.parts,_that.role);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiContent implements GeminiContent {
  const _GeminiContent({required final  List<GeminiPart> parts, @JsonKey(includeIfNull: false) this.role}): _parts = parts;
  factory _GeminiContent.fromJson(Map<String, dynamic> json) => _$GeminiContentFromJson(json);

 final  List<GeminiPart> _parts;
@override List<GeminiPart> get parts {
  if (_parts is EqualUnmodifiableListView) return _parts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_parts);
}

@override@JsonKey(includeIfNull: false) final  String? role;

/// Create a copy of GeminiContent
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiContentCopyWith<_GeminiContent> get copyWith => __$GeminiContentCopyWithImpl<_GeminiContent>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiContentToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiContent&&const DeepCollectionEquality().equals(other._parts, _parts)&&(identical(other.role, role) || other.role == role));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_parts),role);

@override
String toString() {
  return 'GeminiContent(parts: $parts, role: $role)';
}


}

/// @nodoc
abstract mixin class _$GeminiContentCopyWith<$Res> implements $GeminiContentCopyWith<$Res> {
  factory _$GeminiContentCopyWith(_GeminiContent value, $Res Function(_GeminiContent) _then) = __$GeminiContentCopyWithImpl;
@override @useResult
$Res call({
 List<GeminiPart> parts,@JsonKey(includeIfNull: false) String? role
});




}
/// @nodoc
class __$GeminiContentCopyWithImpl<$Res>
    implements _$GeminiContentCopyWith<$Res> {
  __$GeminiContentCopyWithImpl(this._self, this._then);

  final _GeminiContent _self;
  final $Res Function(_GeminiContent) _then;

/// Create a copy of GeminiContent
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? parts = null,Object? role = freezed,}) {
  return _then(_GeminiContent(
parts: null == parts ? _self._parts : parts // ignore: cast_nullable_to_non_nullable
as List<GeminiPart>,role: freezed == role ? _self.role : role // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$GeminiPart {

@JsonKey(includeIfNull: false) String? get text;@JsonKey(name: "inline_data", includeIfNull: false) GeminiInlineData? get inlineData;
/// Create a copy of GeminiPart
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiPartCopyWith<GeminiPart> get copyWith => _$GeminiPartCopyWithImpl<GeminiPart>(this as GeminiPart, _$identity);

  /// Serializes this GeminiPart to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiPart&&(identical(other.text, text) || other.text == text)&&(identical(other.inlineData, inlineData) || other.inlineData == inlineData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,inlineData);

@override
String toString() {
  return 'GeminiPart(text: $text, inlineData: $inlineData)';
}


}

/// @nodoc
abstract mixin class $GeminiPartCopyWith<$Res>  {
  factory $GeminiPartCopyWith(GeminiPart value, $Res Function(GeminiPart) _then) = _$GeminiPartCopyWithImpl;
@useResult
$Res call({
@JsonKey(includeIfNull: false) String? text,@JsonKey(name: "inline_data", includeIfNull: false) GeminiInlineData? inlineData
});


$GeminiInlineDataCopyWith<$Res>? get inlineData;

}
/// @nodoc
class _$GeminiPartCopyWithImpl<$Res>
    implements $GeminiPartCopyWith<$Res> {
  _$GeminiPartCopyWithImpl(this._self, this._then);

  final GeminiPart _self;
  final $Res Function(GeminiPart) _then;

/// Create a copy of GeminiPart
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? text = freezed,Object? inlineData = freezed,}) {
  return _then(_self.copyWith(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,inlineData: freezed == inlineData ? _self.inlineData : inlineData // ignore: cast_nullable_to_non_nullable
as GeminiInlineData?,
  ));
}
/// Create a copy of GeminiPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiInlineDataCopyWith<$Res>? get inlineData {
    if (_self.inlineData == null) {
    return null;
  }

  return $GeminiInlineDataCopyWith<$Res>(_self.inlineData!, (value) {
    return _then(_self.copyWith(inlineData: value));
  });
}
}


/// Adds pattern-matching-related methods to [GeminiPart].
extension GeminiPartPatterns on GeminiPart {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiPart value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiPart() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiPart value)  $default,){
final _that = this;
switch (_that) {
case _GeminiPart():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiPart value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiPart() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? text, @JsonKey(name: "inline_data", includeIfNull: false)  GeminiInlineData? inlineData)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiPart() when $default != null:
return $default(_that.text,_that.inlineData);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(includeIfNull: false)  String? text, @JsonKey(name: "inline_data", includeIfNull: false)  GeminiInlineData? inlineData)  $default,) {final _that = this;
switch (_that) {
case _GeminiPart():
return $default(_that.text,_that.inlineData);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(includeIfNull: false)  String? text, @JsonKey(name: "inline_data", includeIfNull: false)  GeminiInlineData? inlineData)?  $default,) {final _that = this;
switch (_that) {
case _GeminiPart() when $default != null:
return $default(_that.text,_that.inlineData);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiPart implements GeminiPart {
  const _GeminiPart({@JsonKey(includeIfNull: false) this.text, @JsonKey(name: "inline_data", includeIfNull: false) this.inlineData});
  factory _GeminiPart.fromJson(Map<String, dynamic> json) => _$GeminiPartFromJson(json);

@override@JsonKey(includeIfNull: false) final  String? text;
@override@JsonKey(name: "inline_data", includeIfNull: false) final  GeminiInlineData? inlineData;

/// Create a copy of GeminiPart
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiPartCopyWith<_GeminiPart> get copyWith => __$GeminiPartCopyWithImpl<_GeminiPart>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiPartToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiPart&&(identical(other.text, text) || other.text == text)&&(identical(other.inlineData, inlineData) || other.inlineData == inlineData));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,text,inlineData);

@override
String toString() {
  return 'GeminiPart(text: $text, inlineData: $inlineData)';
}


}

/// @nodoc
abstract mixin class _$GeminiPartCopyWith<$Res> implements $GeminiPartCopyWith<$Res> {
  factory _$GeminiPartCopyWith(_GeminiPart value, $Res Function(_GeminiPart) _then) = __$GeminiPartCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(includeIfNull: false) String? text,@JsonKey(name: "inline_data", includeIfNull: false) GeminiInlineData? inlineData
});


@override $GeminiInlineDataCopyWith<$Res>? get inlineData;

}
/// @nodoc
class __$GeminiPartCopyWithImpl<$Res>
    implements _$GeminiPartCopyWith<$Res> {
  __$GeminiPartCopyWithImpl(this._self, this._then);

  final _GeminiPart _self;
  final $Res Function(_GeminiPart) _then;

/// Create a copy of GeminiPart
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? text = freezed,Object? inlineData = freezed,}) {
  return _then(_GeminiPart(
text: freezed == text ? _self.text : text // ignore: cast_nullable_to_non_nullable
as String?,inlineData: freezed == inlineData ? _self.inlineData : inlineData // ignore: cast_nullable_to_non_nullable
as GeminiInlineData?,
  ));
}

/// Create a copy of GeminiPart
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$GeminiInlineDataCopyWith<$Res>? get inlineData {
    if (_self.inlineData == null) {
    return null;
  }

  return $GeminiInlineDataCopyWith<$Res>(_self.inlineData!, (value) {
    return _then(_self.copyWith(inlineData: value));
  });
}
}


/// @nodoc
mixin _$GeminiInlineData {

@JsonKey(name: "mime_type") String get mimeType; String get data;
/// Create a copy of GeminiInlineData
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiInlineDataCopyWith<GeminiInlineData> get copyWith => _$GeminiInlineDataCopyWithImpl<GeminiInlineData>(this as GeminiInlineData, _$identity);

  /// Serializes this GeminiInlineData to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiInlineData&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,data);

@override
String toString() {
  return 'GeminiInlineData(mimeType: $mimeType, data: $data)';
}


}

/// @nodoc
abstract mixin class $GeminiInlineDataCopyWith<$Res>  {
  factory $GeminiInlineDataCopyWith(GeminiInlineData value, $Res Function(GeminiInlineData) _then) = _$GeminiInlineDataCopyWithImpl;
@useResult
$Res call({
@JsonKey(name: "mime_type") String mimeType, String data
});




}
/// @nodoc
class _$GeminiInlineDataCopyWithImpl<$Res>
    implements $GeminiInlineDataCopyWith<$Res> {
  _$GeminiInlineDataCopyWithImpl(this._self, this._then);

  final GeminiInlineData _self;
  final $Res Function(GeminiInlineData) _then;

/// Create a copy of GeminiInlineData
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? mimeType = null,Object? data = null,}) {
  return _then(_self.copyWith(
mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [GeminiInlineData].
extension GeminiInlineDataPatterns on GeminiInlineData {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiInlineData value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiInlineData() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiInlineData value)  $default,){
final _that = this;
switch (_that) {
case _GeminiInlineData():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiInlineData value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiInlineData() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function(@JsonKey(name: "mime_type")  String mimeType,  String data)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiInlineData() when $default != null:
return $default(_that.mimeType,_that.data);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function(@JsonKey(name: "mime_type")  String mimeType,  String data)  $default,) {final _that = this;
switch (_that) {
case _GeminiInlineData():
return $default(_that.mimeType,_that.data);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function(@JsonKey(name: "mime_type")  String mimeType,  String data)?  $default,) {final _that = this;
switch (_that) {
case _GeminiInlineData() when $default != null:
return $default(_that.mimeType,_that.data);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiInlineData implements GeminiInlineData {
  const _GeminiInlineData({@JsonKey(name: "mime_type") required this.mimeType, required this.data});
  factory _GeminiInlineData.fromJson(Map<String, dynamic> json) => _$GeminiInlineDataFromJson(json);

@override@JsonKey(name: "mime_type") final  String mimeType;
@override final  String data;

/// Create a copy of GeminiInlineData
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiInlineDataCopyWith<_GeminiInlineData> get copyWith => __$GeminiInlineDataCopyWithImpl<_GeminiInlineData>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiInlineDataToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiInlineData&&(identical(other.mimeType, mimeType) || other.mimeType == mimeType)&&(identical(other.data, data) || other.data == data));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,mimeType,data);

@override
String toString() {
  return 'GeminiInlineData(mimeType: $mimeType, data: $data)';
}


}

/// @nodoc
abstract mixin class _$GeminiInlineDataCopyWith<$Res> implements $GeminiInlineDataCopyWith<$Res> {
  factory _$GeminiInlineDataCopyWith(_GeminiInlineData value, $Res Function(_GeminiInlineData) _then) = __$GeminiInlineDataCopyWithImpl;
@override @useResult
$Res call({
@JsonKey(name: "mime_type") String mimeType, String data
});




}
/// @nodoc
class __$GeminiInlineDataCopyWithImpl<$Res>
    implements _$GeminiInlineDataCopyWith<$Res> {
  __$GeminiInlineDataCopyWithImpl(this._self, this._then);

  final _GeminiInlineData _self;
  final $Res Function(_GeminiInlineData) _then;

/// Create a copy of GeminiInlineData
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? mimeType = null,Object? data = null,}) {
  return _then(_GeminiInlineData(
mimeType: null == mimeType ? _self.mimeType : mimeType // ignore: cast_nullable_to_non_nullable
as String,data: null == data ? _self.data : data // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$GeminiGenerationConfig {

 double get temperature; int get maxOutputTokens;
/// Create a copy of GeminiGenerationConfig
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$GeminiGenerationConfigCopyWith<GeminiGenerationConfig> get copyWith => _$GeminiGenerationConfigCopyWithImpl<GeminiGenerationConfig>(this as GeminiGenerationConfig, _$identity);

  /// Serializes this GeminiGenerationConfig to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is GeminiGenerationConfig&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,maxOutputTokens);

@override
String toString() {
  return 'GeminiGenerationConfig(temperature: $temperature, maxOutputTokens: $maxOutputTokens)';
}


}

/// @nodoc
abstract mixin class $GeminiGenerationConfigCopyWith<$Res>  {
  factory $GeminiGenerationConfigCopyWith(GeminiGenerationConfig value, $Res Function(GeminiGenerationConfig) _then) = _$GeminiGenerationConfigCopyWithImpl;
@useResult
$Res call({
 double temperature, int maxOutputTokens
});




}
/// @nodoc
class _$GeminiGenerationConfigCopyWithImpl<$Res>
    implements $GeminiGenerationConfigCopyWith<$Res> {
  _$GeminiGenerationConfigCopyWithImpl(this._self, this._then);

  final GeminiGenerationConfig _self;
  final $Res Function(GeminiGenerationConfig) _then;

/// Create a copy of GeminiGenerationConfig
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? temperature = null,Object? maxOutputTokens = null,}) {
  return _then(_self.copyWith(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxOutputTokens: null == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [GeminiGenerationConfig].
extension GeminiGenerationConfigPatterns on GeminiGenerationConfig {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _GeminiGenerationConfig value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _GeminiGenerationConfig() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _GeminiGenerationConfig value)  $default,){
final _that = this;
switch (_that) {
case _GeminiGenerationConfig():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _GeminiGenerationConfig value)?  $default,){
final _that = this;
switch (_that) {
case _GeminiGenerationConfig() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( double temperature,  int maxOutputTokens)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _GeminiGenerationConfig() when $default != null:
return $default(_that.temperature,_that.maxOutputTokens);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( double temperature,  int maxOutputTokens)  $default,) {final _that = this;
switch (_that) {
case _GeminiGenerationConfig():
return $default(_that.temperature,_that.maxOutputTokens);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( double temperature,  int maxOutputTokens)?  $default,) {final _that = this;
switch (_that) {
case _GeminiGenerationConfig() when $default != null:
return $default(_that.temperature,_that.maxOutputTokens);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _GeminiGenerationConfig implements GeminiGenerationConfig {
  const _GeminiGenerationConfig({required this.temperature, required this.maxOutputTokens});
  factory _GeminiGenerationConfig.fromJson(Map<String, dynamic> json) => _$GeminiGenerationConfigFromJson(json);

@override final  double temperature;
@override final  int maxOutputTokens;

/// Create a copy of GeminiGenerationConfig
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$GeminiGenerationConfigCopyWith<_GeminiGenerationConfig> get copyWith => __$GeminiGenerationConfigCopyWithImpl<_GeminiGenerationConfig>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$GeminiGenerationConfigToJson(this, );
}

@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _GeminiGenerationConfig&&(identical(other.temperature, temperature) || other.temperature == temperature)&&(identical(other.maxOutputTokens, maxOutputTokens) || other.maxOutputTokens == maxOutputTokens));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode => Object.hash(runtimeType,temperature,maxOutputTokens);

@override
String toString() {
  return 'GeminiGenerationConfig(temperature: $temperature, maxOutputTokens: $maxOutputTokens)';
}


}

/// @nodoc
abstract mixin class _$GeminiGenerationConfigCopyWith<$Res> implements $GeminiGenerationConfigCopyWith<$Res> {
  factory _$GeminiGenerationConfigCopyWith(_GeminiGenerationConfig value, $Res Function(_GeminiGenerationConfig) _then) = __$GeminiGenerationConfigCopyWithImpl;
@override @useResult
$Res call({
 double temperature, int maxOutputTokens
});




}
/// @nodoc
class __$GeminiGenerationConfigCopyWithImpl<$Res>
    implements _$GeminiGenerationConfigCopyWith<$Res> {
  __$GeminiGenerationConfigCopyWithImpl(this._self, this._then);

  final _GeminiGenerationConfig _self;
  final $Res Function(_GeminiGenerationConfig) _then;

/// Create a copy of GeminiGenerationConfig
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? temperature = null,Object? maxOutputTokens = null,}) {
  return _then(_GeminiGenerationConfig(
temperature: null == temperature ? _self.temperature : temperature // ignore: cast_nullable_to_non_nullable
as double,maxOutputTokens: null == maxOutputTokens ? _self.maxOutputTokens : maxOutputTokens // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on

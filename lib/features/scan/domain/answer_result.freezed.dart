// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'answer_result.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnswerResult {

 String get rawMarkdown; String get bestAnswer; String get confidence; String get reconstructedQuestion; String get quickAnswer;
/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnswerResultCopyWith<AnswerResult> get copyWith => _$AnswerResultCopyWithImpl<AnswerResult>(this as AnswerResult, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnswerResult&&(identical(other.rawMarkdown, rawMarkdown) || other.rawMarkdown == rawMarkdown)&&(identical(other.bestAnswer, bestAnswer) || other.bestAnswer == bestAnswer)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.reconstructedQuestion, reconstructedQuestion) || other.reconstructedQuestion == reconstructedQuestion)&&(identical(other.quickAnswer, quickAnswer) || other.quickAnswer == quickAnswer));
}


@override
int get hashCode => Object.hash(runtimeType,rawMarkdown,bestAnswer,confidence,reconstructedQuestion,quickAnswer);

@override
String toString() {
  return 'AnswerResult(rawMarkdown: $rawMarkdown, bestAnswer: $bestAnswer, confidence: $confidence, reconstructedQuestion: $reconstructedQuestion, quickAnswer: $quickAnswer)';
}


}

/// @nodoc
abstract mixin class $AnswerResultCopyWith<$Res>  {
  factory $AnswerResultCopyWith(AnswerResult value, $Res Function(AnswerResult) _then) = _$AnswerResultCopyWithImpl;
@useResult
$Res call({
 String rawMarkdown, String bestAnswer, String confidence, String reconstructedQuestion, String quickAnswer
});




}
/// @nodoc
class _$AnswerResultCopyWithImpl<$Res>
    implements $AnswerResultCopyWith<$Res> {
  _$AnswerResultCopyWithImpl(this._self, this._then);

  final AnswerResult _self;
  final $Res Function(AnswerResult) _then;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? rawMarkdown = null,Object? bestAnswer = null,Object? confidence = null,Object? reconstructedQuestion = null,Object? quickAnswer = null,}) {
  return _then(_self.copyWith(
rawMarkdown: null == rawMarkdown ? _self.rawMarkdown : rawMarkdown // ignore: cast_nullable_to_non_nullable
as String,bestAnswer: null == bestAnswer ? _self.bestAnswer : bestAnswer // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,reconstructedQuestion: null == reconstructedQuestion ? _self.reconstructedQuestion : reconstructedQuestion // ignore: cast_nullable_to_non_nullable
as String,quickAnswer: null == quickAnswer ? _self.quickAnswer : quickAnswer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [AnswerResult].
extension AnswerResultPatterns on AnswerResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnswerResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnswerResult value)  $default,){
final _that = this;
switch (_that) {
case _AnswerResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnswerResult value)?  $default,){
final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String rawMarkdown,  String bestAnswer,  String confidence,  String reconstructedQuestion,  String quickAnswer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
return $default(_that.rawMarkdown,_that.bestAnswer,_that.confidence,_that.reconstructedQuestion,_that.quickAnswer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String rawMarkdown,  String bestAnswer,  String confidence,  String reconstructedQuestion,  String quickAnswer)  $default,) {final _that = this;
switch (_that) {
case _AnswerResult():
return $default(_that.rawMarkdown,_that.bestAnswer,_that.confidence,_that.reconstructedQuestion,_that.quickAnswer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String rawMarkdown,  String bestAnswer,  String confidence,  String reconstructedQuestion,  String quickAnswer)?  $default,) {final _that = this;
switch (_that) {
case _AnswerResult() when $default != null:
return $default(_that.rawMarkdown,_that.bestAnswer,_that.confidence,_that.reconstructedQuestion,_that.quickAnswer);case _:
  return null;

}
}

}

/// @nodoc


class _AnswerResult extends AnswerResult {
  const _AnswerResult({required this.rawMarkdown, required this.bestAnswer, required this.confidence, required this.reconstructedQuestion, required this.quickAnswer}): super._();
  

@override final  String rawMarkdown;
@override final  String bestAnswer;
@override final  String confidence;
@override final  String reconstructedQuestion;
@override final  String quickAnswer;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnswerResultCopyWith<_AnswerResult> get copyWith => __$AnswerResultCopyWithImpl<_AnswerResult>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnswerResult&&(identical(other.rawMarkdown, rawMarkdown) || other.rawMarkdown == rawMarkdown)&&(identical(other.bestAnswer, bestAnswer) || other.bestAnswer == bestAnswer)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.reconstructedQuestion, reconstructedQuestion) || other.reconstructedQuestion == reconstructedQuestion)&&(identical(other.quickAnswer, quickAnswer) || other.quickAnswer == quickAnswer));
}


@override
int get hashCode => Object.hash(runtimeType,rawMarkdown,bestAnswer,confidence,reconstructedQuestion,quickAnswer);

@override
String toString() {
  return 'AnswerResult(rawMarkdown: $rawMarkdown, bestAnswer: $bestAnswer, confidence: $confidence, reconstructedQuestion: $reconstructedQuestion, quickAnswer: $quickAnswer)';
}


}

/// @nodoc
abstract mixin class _$AnswerResultCopyWith<$Res> implements $AnswerResultCopyWith<$Res> {
  factory _$AnswerResultCopyWith(_AnswerResult value, $Res Function(_AnswerResult) _then) = __$AnswerResultCopyWithImpl;
@override @useResult
$Res call({
 String rawMarkdown, String bestAnswer, String confidence, String reconstructedQuestion, String quickAnswer
});




}
/// @nodoc
class __$AnswerResultCopyWithImpl<$Res>
    implements _$AnswerResultCopyWith<$Res> {
  __$AnswerResultCopyWithImpl(this._self, this._then);

  final _AnswerResult _self;
  final $Res Function(_AnswerResult) _then;

/// Create a copy of AnswerResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? rawMarkdown = null,Object? bestAnswer = null,Object? confidence = null,Object? reconstructedQuestion = null,Object? quickAnswer = null,}) {
  return _then(_AnswerResult(
rawMarkdown: null == rawMarkdown ? _self.rawMarkdown : rawMarkdown // ignore: cast_nullable_to_non_nullable
as String,bestAnswer: null == bestAnswer ? _self.bestAnswer : bestAnswer // ignore: cast_nullable_to_non_nullable
as String,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as String,reconstructedQuestion: null == reconstructedQuestion ? _self.reconstructedQuestion : reconstructedQuestion // ignore: cast_nullable_to_non_nullable
as String,quickAnswer: null == quickAnswer ? _self.quickAnswer : quickAnswer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on

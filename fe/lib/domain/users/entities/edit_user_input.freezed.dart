// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'edit_user_input.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

/// @nodoc
mixin _$EditUserInput {
  int get id => throw _privateConstructorUsedError;
  String get username => throw _privateConstructorUsedError;

  @JsonKey(ignore: true)
  $EditUserInputCopyWith<EditUserInput> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $EditUserInputCopyWith<$Res> {
  factory $EditUserInputCopyWith(
          EditUserInput value, $Res Function(EditUserInput) then) =
      _$EditUserInputCopyWithImpl<$Res, EditUserInput>;
  @useResult
  $Res call({int id, String username});
}

/// @nodoc
class _$EditUserInputCopyWithImpl<$Res, $Val extends EditUserInput>
    implements $EditUserInputCopyWith<$Res> {
  _$EditUserInputCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
  }) {
    return _then(_value.copyWith(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$EditUserInputImplCopyWith<$Res>
    implements $EditUserInputCopyWith<$Res> {
  factory _$$EditUserInputImplCopyWith(
          _$EditUserInputImpl value, $Res Function(_$EditUserInputImpl) then) =
      __$$EditUserInputImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({int id, String username});
}

/// @nodoc
class __$$EditUserInputImplCopyWithImpl<$Res>
    extends _$EditUserInputCopyWithImpl<$Res, _$EditUserInputImpl>
    implements _$$EditUserInputImplCopyWith<$Res> {
  __$$EditUserInputImplCopyWithImpl(
      _$EditUserInputImpl _value, $Res Function(_$EditUserInputImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? username = null,
  }) {
    return _then(_$EditUserInputImpl(
      id: null == id
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as int,
      username: null == username
          ? _value.username
          : username // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc

class _$EditUserInputImpl extends _EditUserInput {
  const _$EditUserInputImpl({required this.id, required this.username})
      : super._();

  @override
  final int id;
  @override
  final String username;

  @override
  String toString() {
    return 'EditUserInput(id: $id, username: $username)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$EditUserInputImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.username, username) ||
                other.username == username));
  }

  @override
  int get hashCode => Object.hash(runtimeType, id, username);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$EditUserInputImplCopyWith<_$EditUserInputImpl> get copyWith =>
      __$$EditUserInputImplCopyWithImpl<_$EditUserInputImpl>(this, _$identity);
}

abstract class _EditUserInput extends EditUserInput {
  const factory _EditUserInput(
      {required final int id,
      required final String username}) = _$EditUserInputImpl;
  const _EditUserInput._() : super._();

  @override
  int get id;
  @override
  String get username;
  @override
  @JsonKey(ignore: true)
  _$$EditUserInputImplCopyWith<_$EditUserInputImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

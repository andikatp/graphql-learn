import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'user.freezed.dart';
part 'user.g.dart';

@freezed
class UserEntity with _$UserEntity {
  const factory UserEntity({
    required String id,
    required String name,
    required int age,
    required String username,
  }) = _UserEntity;
  const UserEntity._();

  factory UserEntity.empty() =>
      const UserEntity(id: '', name: '', age: 1, username: '');

  factory UserEntity.fromJson(Map<String, dynamic> json) =>
      _$UserEntityFromJson(json);
}

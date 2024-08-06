// ignore_for_file: constant_identifier_names

import 'package:flutter/foundation.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'new_user_input.freezed.dart';

@freezed
class NewUserInput with _$NewUserInput {
  const factory NewUserInput({
    required String name,
    required int age,
    required String username,
    @Default(Nationality.England) Nationality nationality,
  }) = _NewUserInput;
  const NewUserInput._();

  factory NewUserInput.empty() => const NewUserInput(
        name: '',
        age: 0,
        username: '',
      );
}

enum Nationality {
  England,
  USA,
  Canada,
  Germany,
  Spain,
  Italy,
  France,
  Japan,
  Russia,
  Mexico,
}

import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_user_input.freezed.dart';

@freezed
class EditUserInput with _$EditUserInput {
  const factory EditUserInput({
    required String username,
  }) = _EditUserInput;
  const EditUserInput._();

  factory EditUserInput.empty() => const EditUserInput(username: '');
}

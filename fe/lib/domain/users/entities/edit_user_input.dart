import 'package:freezed_annotation/freezed_annotation.dart';

part 'edit_user_input.freezed.dart';

@freezed
class EditUserInput with _$EditUserInput {
  const factory EditUserInput({
    required int id,
    required String username,
  }) = _EditUserInput;
  const EditUserInput._();

  factory EditUserInput.empty() => const EditUserInput(id: 1, username: '');
}

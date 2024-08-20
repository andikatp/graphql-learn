import 'package:graphql_learn/domain/core/exceptions.dart';
import 'package:graphql_learn/domain/users/entities/edit_user_input.dart';
import 'package:graphql_learn/domain/users/entities/new_user_input.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/infrastructure/core/extension.dart';
import 'package:graphql_learn/infrastructure/users/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  Future<List<UserEntity>> _fetchUser() async {
    ref.logger();
    final token = ref.cancelToken();
    try {
      final repository = ref.read(userRepositoryProvider);
      return await repository.getUsers(cancelToken: token);
    } on ServerException catch (e, s) {
      state = AsyncError(e.message, s);
      return Future.error(e.message);
    }
  }

  @override
  FutureOr<List<UserEntity>> build() async => await _fetchUser();

  Future<void> addNewUserEvent(NewUserInput user) async {
    state = const AsyncValue.loading();
    try {
      ref.logger();
      final token = ref.cancelToken();
      await ref.read(userRepositoryProvider).createUser(
            user,
            cancelToken: token,
          );
      state = AsyncValue.data(await _fetchUser());
    } on ServerException catch (e, s) {
      state = AsyncError(e.message, s);
    }
  }

  Future<void> deleteUserEvent(String id) async {
    state = const AsyncValue.loading();
    try {
      ref.logger();
      final token = ref.cancelToken();
      await ref.read(userRepositoryProvider).deleteUser(
            id,
            cancelToken: token,
          );
      state = AsyncValue.data(await _fetchUser());
    } on ServerException catch (e, s) {
      state = AsyncError(e.message, s);
    }
  }

  Future<void> editUsernameEvent(EditUserInput input) async {
    state = const AsyncValue.loading();
    try {
      ref.logger();
      final token = ref.cancelToken();
      final repository = ref.read(userRepositoryProvider);
      await repository.updateUsername(
        input,
        cancelToken: token,
      );
      state = AsyncValue.data(await _fetchUser());
    } on ServerException catch (e, s) {
      state = AsyncError(e.message, s);
    }
  }
}

import 'package:graphql_learn/domain/core/exceptions.dart';
import 'package:graphql_learn/domain/users/entities/new_user.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/infrastructure/core/extension.dart';
import 'package:graphql_learn/infrastructure/users/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_controller.g.dart';

@riverpod
class UserController extends _$UserController {
  Future<List<UserEntity>> _fetchUser() async {
    ref.logger();
    final link = ref.cacheFor();
    final token = ref.cancelToken();
    try {
      final repository = ref.read(userRepositoryProvider);
      return await repository.getUsers(cancelToken: token);
    } catch (e) {
      if (e is ServerException) {
        final message = e.message;
        return Future.error(message);
      } else {
        link.close();
        rethrow;
      }
    }
  }

  @override
  FutureOr<List<UserEntity>> build() async => await _fetchUser();

  Future<void> addNewUserEvent(NewUserInput user) async {
    state = const AsyncValue.loading();
    final link = ref.cacheFor();
    try {
      state = await AsyncValue.guard(
        () async {
          ref.logger();
          final token = ref.cancelToken();
          final repository = ref.read(userRepositoryProvider);
          await repository.createUser(
            user,
            cancelToken: token,
          );
          return _fetchUser();
        },
      );
    } catch (e) {
      if (e is ServerException) {
        final message = e.message;
        return Future.error(message);
      } else {
        link.close();
        rethrow;
      }
    }
  }

  Future<void> deleteUserEvent(String id) async {
    state = const AsyncValue.loading();
    final link = ref.cacheFor();
    try {
      await AsyncValue.guard(
        () async {
          ref.logger();
          final token = ref.cancelToken();
          final repository = ref.read(userRepositoryProvider);
          await repository.deleteUser(
            id,
            cancelToken: token,
          );
          return _fetchUser();
        },
      );
    } catch (e) {
      if (e is ServerException) {
        final message = e.message;
        return Future.error(message);
      } else {
        link.close();
        rethrow;
      }
    }
  }
}

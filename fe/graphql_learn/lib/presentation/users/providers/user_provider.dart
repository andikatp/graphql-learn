import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/infrastructure/core/extension.dart';
import 'package:graphql_learn/infrastructure/users/user_repository.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_provider.g.dart';

@riverpod
Future<List<UserEntity>> getUsersEvent(GetUsersEventRef ref) async {
  ref.logger();
  final link = ref.cacheFor();
  final token = ref.cancelToken();
  try {
    final repository = ref.read(userRepositoryProvider);
    return await repository.getUsers(cancelToken: token);
  } catch (e) {
    link.close();
    rethrow;
  }
}

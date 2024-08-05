import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_interface.g.dart';

abstract class UsersInterface {
  Future<List<UserEntity>> getUsers();
}

@riverpod
UsersInterface usersInterface(UsersInterfaceRef ref) =>
    ref.watch(usersInterfaceProvider);

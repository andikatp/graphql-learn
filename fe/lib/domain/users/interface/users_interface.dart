import 'package:graphql_learn/domain/users/entities/edit_user_input.dart';
import 'package:graphql_learn/domain/users/entities/new_user_input.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'users_interface.g.dart';

abstract class UsersInterface {
  const UsersInterface();
  Future<List<UserEntity>> getUsers();
  Future<UserEntity> createUser(NewUserInput user);
  Future<void> deleteUser(String id);
  Future<void> updateUsername(EditUserInput user);
}

@riverpod
UsersInterface usersInterface(UsersInterfaceRef ref) =>
    ref.watch(usersInterfaceProvider);

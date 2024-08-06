import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graphql_learn/domain/core/exceptions.dart';
import 'package:graphql_learn/domain/users/entities/edit_user_input.dart';
import 'package:graphql_learn/domain/users/entities/new_user_input.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/domain/users/interface/users_interface.dart';
import 'package:graphql_learn/infrastructure/core/dio_injectable.dart';
import 'package:graphql_learn/infrastructure/core/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

class UserRepository extends UsersInterface {
  UserRepository({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<List<UserEntity>> getUsers({
    CancelToken? cancelToken,
  }) async {
    try {
      log('get users from server');
      log(Env.baseUrl);
      final response = await _dio.post<Map<String, dynamic>>(
        Env.baseUrl,
        cancelToken: cancelToken,
        data: {
          // ignore: unnecessary_raw_strings
          'query': r'''
          query {
          users {
           name
           id
           age
            username
          }
        }
        ''',
        },
      );
      final data = ((response.data!)['data'] as Map<String, dynamic>)['users']
          as List<dynamic>;
      log(data.toString());
      return data
          .map((e) => UserEntity.fromJson(e as Map<String, dynamic>))
          .toList();
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        log(
          'Request to fetch users was canceled',
          name: 'UserRepository.getUsers',
        );
      }
      throw ServerException(message: e.message ?? 'Error');
    }
  }

  @override
  Future<UserEntity> createUser(
    NewUserInput? user, {
    CancelToken? cancelToken,
  }) async {
    try {
      log('create new user: ${user?.name ?? 'no name'}');
      final response = await _dio.post<Map<String, dynamic>>(
        Env.baseUrl,
        data: {
          'query': r'''
          mutation CreateUser($input: createUserInput!) {
            createUser(input: $input) {
              name
              id
              age
              nationality
              username
            }
          }
        ''',
          'variables': {
            'input': {
              'name': user?.name ?? 'no name',
              'age': user?.age,
              'nationality': user?.nationality.toString().split('.').last,
              'username': user?.username,
            },
          },
        },
        cancelToken: cancelToken,
      );
      final data =
          (response.data!['data'] as Map<String, dynamic>)['createUser'];
      log('data terbaru: $data');
      return UserEntity.fromJson(data as Map<String, dynamic>);
    } on DioException catch (e) {
      if (e.type == DioExceptionType.cancel) {
        log(
          'Request to fetch users was canceled',
          name: 'UserRepository.getUsers',
        );
      }
      throw ServerException(message: e.message ?? 'Error');
    } catch (e) {
      log(
        'An error occurred while creating a user: $e',
        name: 'UserRepository.createUser',
      );
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> deleteUser(String id, {CancelToken? cancelToken}) async {
    try {
      log('delete user with id: $id');
      final response = await _dio.post<Map<String, dynamic>>(
        Env.baseUrl,
        data: {
          'query': r'''
          mutation DeleteUser($input: deleteUserInput) {
          deleteUser (input: $input){
          id
          }
        }
        ''',
          'variables': {
            'input': {
              'id': id,
            },
          },
        },
        cancelToken: cancelToken,
      );
      log('data: ${response.data}');
    } on DioException catch (e) {
      log(
        'An error occurred while deleting a user: $e',
        name: 'UserRepository.deleteUser',
      );
      throw ServerException(message: e.toString());
    }
  }

  @override
  Future<void> updateUsername(
    EditUserInput user, {
    CancelToken? cancelToken,
  }) async {
    try {
      log('update username for user with id: ${user.id}');
      final response = await _dio.post<Map<String, dynamic>>(
        Env.baseUrl,
        data: {
          'query': r'''
         mutation UpdateUserName($input: updateUserNameInput) {
        updateUserName(input: $input) {
         id
          }
        }
        ''',
          'variables': {
            'input': {
              'id': user.id,
              'userName': user.username,
            },
          },
        },
        cancelToken: cancelToken,
      );
      log('data: ${response.data}');
    } on DioException catch (e) {
      log(
        'An error occurred while updating a user: $e',
        name: 'UserRepository.updateUsername',
      );
      throw ServerException(message: e.toString());
    }
  }
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio: dio);
}

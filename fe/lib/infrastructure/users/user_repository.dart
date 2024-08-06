import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graphql_learn/domain/core/exceptions.dart';
import 'package:graphql_learn/domain/users/entities/new_user.dart';
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
      log('data blom diproses: ${response.data}');
      final data =
          (response.data!['data'] as Map<String, dynamic>)['createUser'];
      log('dta terbaru: $data');
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
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio: dio);
}

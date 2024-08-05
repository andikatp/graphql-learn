import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:graphql_learn/domain/core/exceptions.dart';
import 'package:graphql_learn/domain/users/entities/user.dart';
import 'package:graphql_learn/domain/users/interface/users_interface.dart';
import 'package:graphql_learn/infrastructure/core/dio_injectable.dart';
import 'package:graphql_learn/infrastructure/core/env.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'user_repository.g.dart';

class UserRepository implements UsersInterface {
  UserRepository({required Dio dio}) : _dio = dio;
  final Dio _dio;

  @override
  Future<List<UserEntity>> getUsers() async {
    try {
      log('get users from server');
      final response = await _dio.get<Map<String, dynamic>>(
        Env.baseUrl,
        data: {
          // ignore: unnecessary_raw_strings
          'query': r'''
          query GetAllUser {
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
}

@riverpod
UserRepository userRepository(UserRepositoryRef ref) {
  final dio = ref.watch(dioProvider);
  return UserRepository(dio: dio);
}

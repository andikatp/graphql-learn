import 'dart:developer';

import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'dio_injectable.g.dart';

@riverpod
Dio dio(DioRef ref) {
  final dioLogger = ref.watch(dioLoggerProvider);
  final delayedRequest = ref.watch(delayedRequestProvider);
  final apiInterceptor = ref.watch(apiInterceptorProvider);
  final dio = Dio(
    BaseOptions(
        connectTimeout: const Duration(seconds: 5),
        receiveTimeout: const Duration(seconds: 5),
        sendTimeout: const Duration(seconds: 5),
      ),
  )
    ..interceptors.addAll([
      dioLogger,
      delayedRequest,
      apiInterceptor,
    ]);
  return dio;
}

class DioLogger extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    log('request sent to server', name: 'DioLogger');
    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    log('data fetched from server', name: 'DioLogger');
    handler.resolve(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.type == DioExceptionType.cancel) {
      log('request cancelled by user', name: 'DioLogger');
    }
    super.onError(err, handler);
  }
}

@riverpod
DioLogger dioLogger(DioLoggerRef ref) => DioLogger();

class DelayedRequest extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    /// if the request is from [PostDetailsPage], delay the request 2 seconds
    /// (just to demonstrate the cache mechanism better)
    if (options.path.contains('/')) {
      Future.delayed(
        const Duration(seconds: 2),
        () => handler.next(options),
      );
    } else {
      handler.next(options);
    }
  }
}

@riverpod
DelayedRequest delayedRequest(DelayedRequestRef ref) => DelayedRequest();

class ApiInterceptor extends InterceptorsWrapper {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    final errorMessage = _getErrorMessage(err);
    final customError = DioException(
      requestOptions: err.requestOptions,
      response: err.response,
      type: err.type,
      error: errorMessage,
      message: errorMessage,
    );
    return handler.reject(customError);
  }
}

String _getErrorMessage(DioException err) {
  switch (err.type) {
    case DioExceptionType.connectionTimeout:
      return 'Something wrong\n Waktu Koneksi Habis';
    case DioExceptionType.sendTimeout:
      return 'Something wrong\n Waktu Permintaan Habis';
    case DioExceptionType.receiveTimeout:
      return 'Something wrong\n Waktu Respon Habis';
    case DioExceptionType.badResponse:
      return 'Something wrong\n ${err.response?.statusCode}';
    case DioExceptionType.badCertificate:
      return 'Something wrong\n Pembuatan Sertifikat';
    case DioExceptionType.connectionError:
      return 'Something wrong\n Koneksi Internet';
    case DioExceptionType.cancel:
      return 'Something wrong\n Cancel';
    case DioExceptionType.unknown:
      return 'Something wrong\n Unknown';
  }
}

@riverpod
ApiInterceptor apiInterceptor(ApiInterceptorRef ref) => ApiInterceptor();

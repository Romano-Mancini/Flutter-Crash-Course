import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_crash_course/services/network/token_repository.dart';

class AuthInterceptor extends QueuedInterceptor {
  AuthInterceptor({required this.dio, required this.tokenRepository});

  final Dio dio;
  final TokenRepository tokenRepository;

  bool isRefreshing = false;

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    debugPrint("${options.method} - ${options.path}");

    if (!options.path.contains('login') &&
        !options.path.contains('signup') &&
        !options.path.contains('forgot-password')) {
      final accessToken = await tokenRepository.token;
      final refreshToken = await tokenRepository.refreshToken;

      if (accessToken == null || refreshToken == null) {
        final error = DioException(
          error: 'Session expired please login',
          requestOptions: options,
          response: Response<dynamic>(
            statusMessage: 'Session expired please login',
            statusCode: 401,
            requestOptions: options,
          ),
        );

        await _performLogout();
        return handler.reject(error);
      } else {
        options.headers['Authorization'] = "Bearer $accessToken";
        handler.next(options);
      }
    } else {
      handler.next(options);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    try {
      debugPrint("${err.response!.statusCode!} - ${err.response!.data!}");
      if (err.response?.statusCode == 401 &&
          !err.requestOptions.path.contains('login')) {
        if (!isRefreshing) {
          isRefreshing = true;
          final requestOptions = err.requestOptions;
          final accessToken = await _refreshToken();
          if (accessToken == null) {
            await _performLogout();
            return handler.reject(err);
          } else {
            final opts = Options(
              extra: err.requestOptions.extra,
              method: requestOptions.method,
            );

            dio.options.headers['Authorization'] = "Bearer $accessToken";

            final response = await dio.request<dynamic>(
              requestOptions.path,
              options: opts,
              cancelToken: requestOptions.cancelToken,
              onReceiveProgress: requestOptions.onReceiveProgress,
              data: requestOptions.data,
              queryParameters: requestOptions.queryParameters,
            );

            if (response.statusCode != 401) {
              return handler.resolve(response);
            } else {
              return handler.reject(err);
            }
          }
        } else {
          return handler.next(err);
        }
      } else {
        return handler.next(err);
      }
    } catch (e) {
      if (kDebugMode) {
        print('🔴${e.toString()}🔴');
      }
      return handler.reject(
        err.copyWith(error: e, stackTrace: StackTrace.current),
      );
    }
  }

  Future<String?> _refreshToken() async {
    try {
      final dioRefresh = Dio(dio.options);

      debugPrint("Refreshing...");

      final refreshToken = await tokenRepository.refreshToken;
      final response = await dioRefresh.post<dynamic>(
        '/auth/refresh',
        data: {"refresh": refreshToken},
      );

      if (response.statusCode == 200) {
        isRefreshing = false;
        final newAccessToken = response.data['access'] as String;
        await tokenRepository.setToken(newAccessToken);
        await tokenRepository.setRefreshToken(response.data['refresh']);
        return newAccessToken;
      } else {
        return null;
      }
    } catch (e) {
      debugPrint("Error refreshing token: $e");
      await _performLogout();
      return null;
    }
  }

  Future<void> _performLogout() async {
    await tokenRepository.logout();
  }
}

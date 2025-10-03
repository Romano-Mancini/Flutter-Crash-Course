import 'package:dio/dio.dart';
import 'package:flutter_crash_course/services/network/interceptor.dart';
import 'package:flutter_crash_course/services/network/token_repository.dart';

abstract class BaseService {
  String get baseUrl =>
      'http://localhost:3001/'; // If you are working with an android emulator use http://10.0.2.2:3001/

  TokenRepository get tokenRepository => TokenRepository();

  Dio get client {
    Dio dio = Dio();
    dio.options.baseUrl = baseUrl;
    dio.options.headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    dio.interceptors.add(
      AuthInterceptor(dio: dio, tokenRepository: tokenRepository),
    );
    return dio;
  }
}

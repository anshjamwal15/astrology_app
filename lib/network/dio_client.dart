import 'package:astrology_app/constants/app_constants.dart';
import 'package:astrology_app/network/network_interceptor.dart';
import 'package:dio/dio.dart';

class DioClient {
  static final DioClient _instance = DioClient._internal();

  factory DioClient() => _instance;

  late final Dio dio;

  DioClient._internal() {
    dio = Dio(
      BaseOptions(
        baseUrl: AppConstants.NGROK_DOMAIN,
        connectTimeout: const Duration(seconds: 10),
        receiveTimeout: const Duration(seconds: 10),
        contentType: 'application/json',
      ),
    );

    _initializeInterceptors();
  }

  void _initializeInterceptors() {
    dio.interceptors.add(NetworkLoggerInterceptor());

    // 🔄 Add more interceptors here in the future:
    // dio.interceptors.add(TokenInterceptor());
    // dio.interceptors.add(RetryInterceptor());
  }
}

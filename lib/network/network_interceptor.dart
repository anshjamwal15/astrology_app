import 'package:astrology_app/utils/app_utils.dart';
import 'package:dio/dio.dart';

class NetworkLoggerInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    AppLogger.debug(
      'REQUEST → ${options.method} ${options.uri}\n'
      'Headers: ${options.headers}\n'
      'Data: ${options.data}',
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    AppLogger.info(
      'RESPONSE ← ${response.statusCode} ${response.requestOptions.uri}\n'
      'Data: ${response.data}',
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    final request = err.requestOptions;
    final response = err.response;

    AppLogger.error(
      'ERROR ✖️ ${err.type}\n'
      'URL: ${request.uri}\n'
      'Method: ${request.method}\n'
      'Status Code: ${response?.statusCode}\n'
      'Message: ${err.message}\n'
      'Request Data: ${request.data}\n'
      'Response Data: ${response?.data}',
    );
    super.onError(err, handler);
  }
}

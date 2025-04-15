import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/network/dio_client.dart';
import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio = DioClient().dio;
  final String endpoint = '/user';

  Future<User> signUp(String email, String password) async {
    try {
      final response = await _dio.post(endpoint, data: {
        'email': email,
        'password': password,
      });
      return User.fromJSON(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> logIn(String email, String password) async {
    try {
      final response = await _dio.post('$endpoint/login', data: {
        'email': email,
        'password': password,
      });
      return User.fromJSON(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<User> updateUser(Map<String, dynamic> data) async {
    try {
      final response = await _dio.put(endpoint, data: data);
      return User.fromJSON(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

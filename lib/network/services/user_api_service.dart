import 'package:astrology_app/models/index.dart';
import 'package:astrology_app/network/dio_client.dart';
import 'package:dio/dio.dart';

class UserApiService {
  final Dio _dio = DioClient().dio;
  final String endpoint = '/user';

  Future<User> signUp(String email, String password) async {
    try {
      final response = await _dio.post("$endpoint/register", data: {
        'email': email,
        'password': password,
      });
      return User.fromJSON(response.data);
    } catch (e) {
      rethrow;
    }
  }

  Future<User?> getUserByEmail(String email) async {
    try {
      final response = await _dio.get('$endpoint/$email');
      if (response.statusCode == 200 && response.data != null) {
        return User.fromJSON(response.data);
      } else {
        return User.empty;
      }
    } catch (e) {
      return User.empty;
    }
  }

  // Future<User> logIn(String email, String password) async {
  //   try {
  //     final response = await _dio.post('$endpoint/login', data: {
  //       'email': email,
  //       'password': password,
  //     });
  //     return User.fromJSON(response.data);
  //   } catch (e) {
  //     rethrow;
  //   }
  // }

  Future<User> updateUser(Map<String, dynamic> data) async {
    try {
      final response = await _dio.post("$endpoint/update", data: data);
      return User.fromJSON(response.data);
    } catch (e) {
      rethrow;
    }
  }
}

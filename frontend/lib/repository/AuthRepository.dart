import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../constants/apilist.dart';
import '../models/user.dart';

class AuthRepository {
  final String apiUrlRegister = api_register;
  final String apiUrlLogin = api_login;
  final _storage = const FlutterSecureStorage();

  // Register a new user
  Future<void> register(User user) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrlRegister),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(user.toJson()),
      );

      if (response.statusCode == 200) {
        print('Đăng ký thành công');
      } else {
        // Handle error responses (non-200 HTTP codes)
        final responseBody = jsonDecode(response.body);
        throw Exception(
            'Đăng ký thất bại: ${responseBody['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      // Handle exceptions (e.g., network or parsing errors)
      print('Lỗi đăng ký: $e');
      throw Exception("Failed to register: $e");
    }
  }

  // Login user and retrieve token
  Future<String?> login(String email, String password) async {
    try {
      final response = await http.post(
        Uri.parse(apiUrlLogin),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      if (response.statusCode == 200) {
        final responseBody = jsonDecode(response.body);
        final token = responseBody['token'];

        if (token != null) {
          await _storage.write(key: 'auth_token', value: token);
          return token;
        } else {
          throw Exception('Token not found in response');
        }
      } else {
        // Handle non-200 status codes
        final responseBody = jsonDecode(response.body);
        throw Exception(
            'Login failed: ${responseBody['message'] ?? 'Unknown error'}');
      }
    } catch (e) {
      // Catch network or parsing errors
      print('Lỗi đăng nhập: $e');
      throw Exception("Failed to login: $e");
    }
  }

  // Logout user by deleting the token
  Future<void> logout() async {
    try {
      await _storage.delete(key: 'auth_token');
      print('Đã đăng xuất');
    } catch (e) {
      print('Lỗi khi đăng xuất: $e');
    }
  }

  // Retrieve the stored authentication token
  Future<String?> getToken() async {
    try {
      return await _storage.read(key: 'auth_token');
    } catch (e) {
      print('Lỗi khi lấy token: $e');
      return null;
    }
  }

  // Check if the user is logged in by checking the token
  Future<bool> isLoggedIn() async {
    final token = await getToken();
    return token != null;
  }
}

import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../managers/constants.dart';
import '../../models/login_response.dart';
import '../../models/model_user.dart';

class AuthApi {
  Future<LoginResponse> login(String username, String password) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'username': username, 'password': password}),
      );

      print('Login response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        final loginResponse = LoginResponse.fromJson(json);
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('access_token', loginResponse.accessToken);
        await prefs.setString('username', username); // Lưu username từ input
        print('Token saved: ${loginResponse.accessToken}');
        return loginResponse;
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Đăng nhập thất bại';
        throw Exception(error);
      }
    } catch (e) {
      print('Login error: $e');
      rethrow;
    }
  }

  Future<User> register({
    required String username,
    required String email,
    required String password,
    String? phone,
  }) async {
    try {
      final response = await http.post(
        Uri.parse('${ApiConstants.baseUrl}/auth/register'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'username': username,
          'email': email,
          'password': password,
          if (phone != null) 'phone': phone,
        }),
      );

      print('Register response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 201) {
        final json = jsonDecode(response.body);
        final user = User.fromJson(json); // Phản hồi là object User trực tiếp
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('username', user.username); // Lưu username
        return user;
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Đăng ký thất bại';
        throw Exception(error);
      }
    } catch (e) {
      print('Register error: $e');
      rethrow;
    }
  }
}
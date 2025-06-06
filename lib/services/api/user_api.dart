import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import '../../managers/constants.dart';
import '../../models/model_user.dart';

class UserApi {
  Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('access_token');
  }

  Future<User> getCurrentUser() async {
    try {
      final token = await _getToken();
      if (token == null) throw Exception('No token found');

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/users/me'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      print('Get user response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final json = jsonDecode(response.body);
        return User.fromJson(json);
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Không thể lấy thông tin người dùng';
        throw Exception(error);
      }
    } catch (e) {
      print('Get user error: $e');
      rethrow;
    }
  }
}
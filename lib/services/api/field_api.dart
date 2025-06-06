import 'dart:convert';
import 'package:http/http.dart' as http;

import '../../managers/constants.dart';
import '../../models/model_field.dart';


class FieldApi {
  Future<List<Field>> getFields() async {
    try {

      final response = await http.get(
        Uri.parse('${ApiConstants.baseUrl}/inf_fields'),
        headers: {'Content-Type': 'application/json'},
      );

      print('Get fields response: ${response.statusCode} - ${response.body}');

      if (response.statusCode == 200) {
        final List<dynamic> jsonList = jsonDecode(response.body);
        return jsonList.map((json) => Field.fromJson(json)).toList();
      } else {
        final error = jsonDecode(response.body)['message'] ?? 'Lỗi khi lấy danh sách sân';
        throw Exception(error);
      }
    } catch (e) {
      print('Get fields error: $e');
      rethrow;
    }
  }
}

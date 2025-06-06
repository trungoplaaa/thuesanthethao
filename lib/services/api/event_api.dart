import 'dart:convert';
import 'package:http/http.dart' as http;
import '../../models/event_model.dart';
import '../../managers/constants.dart';

class EventApi {
  Future<List<EventModel>> getEvents() async {
    final response = await http.get(
      Uri.parse('${ApiConstants.baseUrl}/events'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> jsonList = jsonDecode(response.body);
      return jsonList.map((json) => EventModel.fromJson(json)).toList();
    } else {
      throw Exception('Failed to load events');
    }
  }
}

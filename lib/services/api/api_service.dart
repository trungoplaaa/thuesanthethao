import 'auth_api.dart';
import 'event_api.dart';
import 'field_api.dart';

class ApiService {
  final AuthApi authApi = AuthApi();
  final FieldApi fieldApi = FieldApi(); // Thay đổi từ venueApi thành fieldApi
  final eventApi = EventApi();
}
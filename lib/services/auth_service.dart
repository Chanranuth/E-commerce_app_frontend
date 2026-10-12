import '../core/errors/api_exception.dart';
import '../core/network/api_client.dart';
import '../models/user.dart';

class AuthService {
  Future<Map<String, dynamic>> login(String email, String password) async {
    final response = await ApiClient.request(
      'POST',
      '/login',
      body: {'email': email.trim(), 'password': password},
      auth: false,
    );

    final decoded = ApiClient.decodeJson(response);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('Unexpected login response');
    }

    return decoded;
  }

  Future<Map<String, dynamic>> register(
    String name,
    String email,
    String password,
  ) async {
    final response = await ApiClient.request(
      'POST',
      '/register',
      body: {'name': name.trim(), 'email': email.trim(), 'password': password},
      auth: false,
    );

    final decoded = ApiClient.decodeJson(response);
    if (decoded is! Map<String, dynamic>) {
      throw ApiException('Unexpected registration response');
    }

    return decoded;
  }

  Future<AppUser> fetchCurrentUser() async {
    final response = await ApiClient.request('GET', '/user');
    final decoded = ApiClient.decodeJson(response);

    if (decoded is! Map<String, dynamic>) {
      throw ApiException('Unexpected user response');
    }

    return AppUser.fromJson(decoded);
  }
}

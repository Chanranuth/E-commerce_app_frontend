import 'package:flutter/material.dart';

import '../core/errors/api_exception.dart';
import '../core/storage/secure_storage_service.dart';
import '../models/user.dart';
import '../services/auth_service.dart';

class AuthProvider extends ChangeNotifier {
  final AuthService _authService = AuthService();

  bool _isLoading = true;
  bool _isAuthenticated = false;
  AppUser? _user;
  String? _token;

  bool get isLoading => _isLoading;
  bool get isAuthenticated => _isAuthenticated;
  AppUser? get user => _user;
  String? get token => _token;

  Future<void> initialize() async {
    _isLoading = true;
    notifyListeners();

    final savedToken = await SecureStorageService.readToken();
    if (savedToken == null || savedToken.isEmpty) {
      _isAuthenticated = false;
      _user = null;
      _token = null;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _token = savedToken;

    try {
      _user = await _authService.fetchCurrentUser();
      _isAuthenticated = true;
    } on ApiException catch (_) {
      await logout();
    } catch (_) {
      await logout();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> login(String email, String password) async {
    final response = await _authService.login(email, password);
    final token = response['token'] as String?;
    final userJson = response['user'];

    if (token == null || userJson is! Map<String, dynamic>) {
      throw ApiException('Login response did not include a valid token');
    }

    _token = token;
    _user = AppUser.fromJson(userJson);
    _isAuthenticated = true;

    await SecureStorageService.saveToken(token);
    notifyListeners();
  }

  Future<void> register(String name, String email, String password) async {
    final response = await _authService.register(name, email, password);
    final token = response['token'] as String?;
    final userJson = response['user'];

    if (token == null || userJson is! Map<String, dynamic>) {
      throw ApiException('Registration response did not include a valid token');
    }

    _token = token;
    _user = AppUser.fromJson(userJson);
    _isAuthenticated = true;

    await SecureStorageService.saveToken(token);
    notifyListeners();
  }

  Future<void> logout() async {
    _user = null;
    _token = null;
    _isAuthenticated = false;
    await SecureStorageService.clearToken();
    notifyListeners();
  }
}

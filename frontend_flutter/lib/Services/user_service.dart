import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'http://172.25.240.1:3000/api/users';
  final _storage = const FlutterSecureStorage();

  Future<bool> login(String email, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/login'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'email': email,
        'password': password,
      }),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data['token'];
      final user = data['user'];

      // Stocker le token et les informations utilisateur
      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'userId', value: user['id'].toString());
      await _storage.write(key: 'userName', value: user['name']);
      await _storage.write(key: 'role', value: user['role']);

      return true;
    } else {
      return false;
    }
  }

  Future<String?> getUserId() async {
    return await _storage.read(key: 'userId');
  }

  Future<String?> getUserName() async {
    return await _storage.read(key: 'userName');
  }

  Future<String?> getRole() async {
    return await _storage.read(key: 'role');
  }

  Future<void> logout() async {
    await _storage.deleteAll(); // Supprime le token et le rôle
  }

  Future<List<dynamic>?> getAllUsers() async {
    final response = await http.get(Uri.parse('$baseUrl/'));
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

// Register function
  // Register function
  Future<bool> register(String name, String email, String password, String role) async {
    final response = await http.post(
      Uri.parse('$baseUrl/register'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        'name': name,
        'email': email,
        'password': password,
        'role': role,
      })
    );

    if (response.statusCode == 201) {
      final data = jsonDecode(response.body);
      final id = data['id'];
      await _storage.write(key: 'userId', value: id.toString());
      // Store the token and user information
      return true;
    } else {
      // Handle failure (for example, duplicate email or validation errors)
      final errorData = jsonDecode(response.body);
      throw Exception(errorData['error'] ?? 'An unknown error occurred');
    }
  }
}
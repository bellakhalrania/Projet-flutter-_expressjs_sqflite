import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthService {
  final String baseUrl = 'http://192.168.1.16:3000/api/users';
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
      final role = data['role'];

      // Stocker le token et le rôle
      await _storage.write(key: 'token', value: token);
      await _storage.write(key: 'role', value: role);

      return true;
    } else {
      return false;
    }
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



}

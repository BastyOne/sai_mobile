import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/user.dart';
import 'shared_preferences.dart';

class AuthService {
  final String baseUrl = 'http://192.168.100.81:3000';
  final storage = const FlutterSecureStorage();

  Future<User?> login(String rut, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'rut': rut, 'contraseña': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await storage.write(key: 'token', value: data['token']);
      await SharedPreferencesService.setUserType(data['userType']);
      await SharedPreferencesService.setUserId(data['userId']);
      await SharedPreferencesService.setCarreraId(data['carrera_id']);
      return User.fromJson({
        'token': data['token'],
        'userId': data['userId'],
        'userType': data['userType'],
        'rol': data['rol'],
        'carrera_id': data['carrera_id'],
      });
    } else {
      throw Exception(
          'Failed to login. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<void> forgotPassword(String email) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/forgot-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'email': email}),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to send reset email. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<void> resetPassword(
      String email, String token, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/reset-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'token': token, 'newPassword': newPassword}),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to reset password. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<Map<String, dynamic>> updatePassword(
      String rut, String currentPassword, String newPassword) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/update-password'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({
        'rut': rut,
        'currentPassword': currentPassword,
        'newPassword': newPassword,
        'confirmNewPassword': newPassword
      }),
    );

    if (response.statusCode == 200) {
      return {'success': true};
    } else {
      final errorData = json.decode(response.body);
      return {'success': false, 'message': errorData['message']};
    }
  }

  Future<dynamic> getProtectedData() async {
    String? token = await storage.read(key: 'token');

    final response = await http.get(
      Uri.parse('$baseUrl/protected-route'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to access protected data. Status code: ${response.statusCode}');
    }
  }
}

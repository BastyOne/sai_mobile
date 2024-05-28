import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/alumno.dart';
import '../models/personal.dart';

class UserService {
  final String baseUrl = 'http://192.168.100.81:3000';
  final storage = const FlutterSecureStorage();

  Future<AlumnoInfo?> getAlumnoInfo(int userId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/alumnos/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return AlumnoInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get alumno info. Status code: ${response.statusCode}');
    }
  }

  Future<PersonalInfo?> getPersonalInfo(int userId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/personal/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return PersonalInfo.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to get personal info. Status code: ${response.statusCode}');
    }
  }
}

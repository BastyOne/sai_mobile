import 'package:http/http.dart' as http;
import 'dart:convert';
import '../models/user.dart';
import '../models/alumno.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
  final String baseUrl = 'https://backend-s-a-p-s.vercel.app';
  final storage =
      const FlutterSecureStorage(); // Instancia de almacenamiento seguro

  Future<User?> login(String rut, String password) async {
    final response = await http.post(
      Uri.parse('$baseUrl/api/auth/login'),
      headers: {'Content-Type': 'application/json'},
      body: json.encode({'rut': rut, 'contraseña': password}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      await storage.write(
          key: 'token', value: data['token']); // Guardar el token recibido
      // Devuelve un nuevo User con todos los datos recibidos
      return User.fromJson({
        'token': data['token'],
        'userId': data['userId'],
        'userType': data['userType'],
        'rol': data['rol'],
      });
    } else {
      throw Exception(
          'Failed to login. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<dynamic> getProtectedData() async {
    String? token =
        await storage.read(key: 'token'); // Leer el token almacenado

    final response = await http.get(
      Uri.parse('$baseUrl/protected-route'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usar el token en los headers
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception(
          'Failed to access protected data. Status code: ${response.statusCode}');
    }
  }

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
}

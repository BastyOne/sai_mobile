import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/mensaje_diario.dart';
import '../models/personal.dart';
import '../models/user.dart';
import '../models/alumno.dart';
import '../models/faq.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ApiService {
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

  Future<List<FAQ>> fetchFAQs(int categoryId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/faq/categoria/$categoryId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> faqsJson = json.decode(response.body);
      return faqsJson.map((json) => FAQ.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load FAQs. Status code: ${response.statusCode}');
    }
  }

  Future<List<MensajeDiario>> fetchMensajesDiarios() async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/mensajes-diarios'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => MensajeDiario.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load mensajes diarios. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoriasPadre() async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/incidencia/categoriasPadre'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load categorias padre. Status code: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoriasHijo(int padreId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/incidencia/categoriasHijo/$padreId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load categorias hijo. Status code: ${response.statusCode}');
    }
  }

  Future<List<Map<String, dynamic>>> fetchPersonal() async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/personal'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return List<Map<String, dynamic>>.from(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to load personal. Status code: ${response.statusCode}');
    }
  }

  Future<void> createIncidencia(
      Map<String, dynamic> incidenciaData, File? archivo) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/incidencia'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields.addAll(
        incidenciaData.map((key, value) => MapEntry(key, value.toString())));

    if (archivo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('archivo', archivo.path));
    }

    final response = await request.send();

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to create incidencia. Status code: ${response.statusCode}');
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

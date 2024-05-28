import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';
import '../models/incidencia.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'shared_preferences.dart';

class IncidenciaService {
  final String baseUrl = 'http://192.168.100.81:3000';
  final storage = const FlutterSecureStorage();

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

  Future<List<Incidencia>> fetchIncidenciasPorAlumno(int userId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/incidencia/porAlumno/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> incidenciasJson = json.decode(response.body);
      return incidenciasJson.map((json) => Incidencia.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to load incidencias. Status code: ${response.statusCode}');
    }
  }

  Future<List<Incidencia>> fetchIncidenciasPorPersonal(int userId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/incidencia/porPersonal/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      var body = json.decode(response.body);
      if (body is List) {
        return body.map((json) => Incidencia.fromJson(json)).toList();
      } else {
        throw Exception('Unexpected response format: $body');
      }
    } else {
      throw Exception(
          'Failed to load incidencias. Status code: ${response.statusCode}');
    }
  }

  Future<void> addRespuestaIncidencia(int incidenciaId, String contenido,
      String remitenteTipo, int remitenteId) async {
    String? token = await SharedPreferencesService.getToken();
    if (token == null) throw Exception('No token found in storage');

    final response = await http.post(
      Uri.parse('$baseUrl/api/incidencia/responder'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'incidencia_id': incidenciaId,
        'contenido': contenido,
        'remitente_tipo': remitenteTipo,
        'remitente_id': remitenteId,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to add respuesta. Status code: ${response.statusCode}');
    }
  }

  Future<void> cerrarIncidencia(int incidenciaId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.put(
      Uri.parse('$baseUrl/api/incidencia/cerrar/$incidenciaId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to close incidencia. Status code: ${response.statusCode}');
    }
  }

  Future<void> reabrirIncidencia(int incidenciaId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.put(
      Uri.parse('$baseUrl/api/incidencia/reabrir/$incidenciaId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to reopen incidencia. Status code: ${response.statusCode}');
    }
  }
}

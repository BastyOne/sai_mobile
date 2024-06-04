import 'dart:io';

import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/mensaje_diario.dart';

class MensajeDiarioService {
  final String baseUrl = 'http://192.168.100.81:3000';
  final storage = const FlutterSecureStorage();

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

  Future<void> toggleActivo(int id, bool activo) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.put(
      Uri.parse('$baseUrl/api/mensajes-diarios/$id/activo'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({'activo': activo}),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update mensaje diario. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }

  Future<void> agregarMensajeDiario(
      String mensaje, String contexto, File? archivo) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    var request = http.MultipartRequest(
        'POST', Uri.parse('$baseUrl/api/mensajes-diarios'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['mensaje'] = mensaje;
    request.fields['contexto'] = contexto;

    if (archivo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('archivo', archivo.path));
    }

    var response = await request.send();

    if (response.statusCode != 201) {
      throw Exception(
          'Failed to add mensaje diario. Status code: ${response.statusCode}');
    }
  }

  Future<void> eliminarMensajeDiario(int id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/mensajes-diarios/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete mensaje diario. Status code: ${response.statusCode}, Response: ${response.body}');
    }
  }
}

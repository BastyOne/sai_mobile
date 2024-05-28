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
}

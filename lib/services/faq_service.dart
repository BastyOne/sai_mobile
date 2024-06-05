import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/faq.dart';

class FaqService {
  final String baseUrl = 'http://192.168.100.81:3000';
  final storage = const FlutterSecureStorage();

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

  Future<void> addFAQ(FAQ faq) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.post(
      Uri.parse('$baseUrl/api/faq'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'categoriafaq_id': faq.categoriaFaqId,
        'pregunta': faq.pregunta,
        'respuesta': faq.respuesta,
        'activo': faq.activo,
        'fechacreacion': faq.fechaCreacion,
      }),
    );

    if (response.statusCode != 201) {
      throw Exception('Failed to add FAQ. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateFAQ(int id, FAQ faq) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.put(
      Uri.parse('$baseUrl/api/faq/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: jsonEncode({
        'categoriafaq_id': faq.categoriaFaqId,
        'pregunta': faq.pregunta,
        'respuesta': faq.respuesta,
        'activo': faq.activo,
        'fechacreacion': faq.fechaCreacion,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update FAQ. Status code: ${response.statusCode}');
    }
  }

  Future<void> deleteFAQ(int id) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.delete(
      Uri.parse('$baseUrl/api/faq/$id'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to delete FAQ. Status code: ${response.statusCode}');
    }
  }
}

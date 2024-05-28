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
}

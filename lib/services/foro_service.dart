import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/foro.dart';

class ForoService {
  final String baseUrl = 'http://192.168.100.81:3000';
  final storage = const FlutterSecureStorage();

  Future<List<Post>> obtenerPosts() async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/foro/posts'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Post.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to get posts. Status code: ${response.statusCode}');
    }
  }

  Future<List<Reply>> obtenerReplies(int postId) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.get(
      Uri.parse('$baseUrl/api/foro/reply/$postId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      final List<dynamic> body = json.decode(response.body);
      return body.map((json) => Reply.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to get replies. Status code: ${response.statusCode}');
    }
  }

  Future<Post> crearPost(
      int autorId, String pregunta, String contenido, bool esAnonimo,
      [String? archivoPath]) async {
    String? token = await storage.read(key: 'token');
    if (token == null) {
      throw Exception('No token found in storage');
    }

    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/foro/posts'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['autor_id'] = autorId.toString();
    request.fields['pregunta'] = pregunta;
    request.fields['contenido'] = contenido;
    request.fields['es_anonimo'] = esAnonimo.toString(); // Añadir este campo

    if (archivoPath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('archivo', archivoPath));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return Post.fromJson(json.decode(response.body)['foro']);
    } else {
      throw Exception(
          'Failed to create post. Status code: ${response.statusCode}');
    }
  }

  Future<Reply> crearReply(int postForoId, int autorId, String contenido,
      [String? archivoPath]) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    var request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/api/foro/reply'));
    request.headers['Authorization'] = 'Bearer $token';
    request.fields['postforo_id'] = postForoId.toString();
    request.fields['autor_id'] = autorId.toString();
    request.fields['contenido'] = contenido;

    if (archivoPath != null) {
      request.files
          .add(await http.MultipartFile.fromPath('archivo', archivoPath));
    }

    var streamedResponse = await request.send();
    var response = await http.Response.fromStream(streamedResponse);

    if (response.statusCode == 201) {
      return Reply.fromJson(json.decode(response.body));
    } else {
      throw Exception(
          'Failed to create reply. Status code: ${response.statusCode}');
    }
  }
}

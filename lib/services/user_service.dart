import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'dart:io';
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

  Future<List<AlumnoInfo>> getAlumnos({String? carrera, String? nivel}) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    Map<String, String> queryParameters = {};
    if (carrera != null) queryParameters['carrera_id'] = carrera;
    if (nivel != null) queryParameters['nivel'] = nivel;

    final uri =
        Uri.parse('$baseUrl/alumnos').replace(queryParameters: queryParameters);

    final response = await http.get(
      uri,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => AlumnoInfo.fromJson(json)).toList();
    } else {
      print(
          'Failed to get alumnos. Status code: ${response.statusCode}, Body: ${response.body}'); // Debugging line to check the response
      throw Exception(
          'Failed to get alumnos. Status code: ${response.statusCode}');
    }
  }

  Future<void> agregarAlumno({
    required String nivel,
    required String rut,
    required String nombre,
    required String apellido,
    required String email,
    required String password,
    required bool activo,
    required String celular,
    required String contactoEmergencia,
    required int categoriaAlumnoId,
    required String ciudadActual,
    required String ciudadProcedencia,
    String? suspensionRangoFecha,
    required int rolId,
    required int carreraId,
    File? archivo,
  }) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final request =
        http.MultipartRequest('POST', Uri.parse('$baseUrl/alumnos/add'));

    request.headers['Authorization'] = 'Bearer $token';
    request.fields['nivel'] = nivel;
    request.fields['rut'] = rut;
    request.fields['nombre'] = nombre;
    request.fields['apellido'] = apellido;
    request.fields['email'] = email;
    request.fields['password'] = password;
    request.fields['activo'] = activo.toString();
    request.fields['celular'] = celular;
    request.fields['contactoemergencia'] = contactoEmergencia;
    request.fields['categoriaalumno_id'] = categoriaAlumnoId.toString();
    request.fields['ciudadactual'] = ciudadActual;
    request.fields['ciudadprocedencia'] = ciudadProcedencia;
    request.fields['suspensiónrangofecha'] = suspensionRangoFecha ?? '';
    request.fields['rol_id'] = rolId.toString();
    request.fields['carrera_id'] = carreraId.toString();

    if (archivo != null) {
      request.files
          .add(await http.MultipartFile.fromPath('archivo', archivo.path));
    }

    final response = await request.send();

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to add alumno. Status code: ${response.statusCode}');
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

  Future<List<PersonalInfo>> getPersonalList() async {
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
      List<dynamic> jsonList = json.decode(response.body);
      return jsonList.map((json) => PersonalInfo.fromJson(json)).toList();
    } else {
      throw Exception(
          'Failed to get personal list. Status code: ${response.statusCode}');
    }
  }

  Future<void> updateAlumno(int userId,
      {required String celular,
      required String contactoEmergencia,
      required String ciudadActual}) async {
    String? token = await storage.read(key: 'token');
    if (token == null) throw Exception('No token found in storage');

    final response = await http.put(
      Uri.parse('$baseUrl/alumnos/$userId'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      },
      body: json.encode({
        'celular': celular,
        'contactoemergencia': contactoEmergencia,
        'ciudadactual': ciudadActual,
      }),
    );

    if (response.statusCode != 200) {
      throw Exception(
          'Failed to update alumno. Status code: ${response.statusCode}');
    }
  }
}

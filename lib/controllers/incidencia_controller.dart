import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/incidencia.dart';

class IncidenciaController with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Incidencia> _incidencias = [];
  final Map<int, String> _categorias = {}; // Almacenar categorías
  int? _selectedCategoriaPadre;
  int? _selectedCategoriaHijo;
  int? _selectedPersonal;
  String? _descripcion;
  String? _prioridad;
  File? _archivo;

  // Getters
  int? get selectedCategoriaPadre => _selectedCategoriaPadre;
  int? get selectedCategoriaHijo => _selectedCategoriaHijo;
  int? get selectedPersonal => _selectedPersonal;
  String? get descripcion => _descripcion;
  String? get prioridad => _prioridad;
  File? get archivo => _archivo;
  List<Incidencia> get incidencias => _incidencias;
  Map<int, String> get categorias => _categorias;

  // Setters
  set selectedCategoriaPadre(int? value) {
    _selectedCategoriaPadre = value;
    notifyListeners();
  }

  set selectedCategoriaHijo(int? value) {
    _selectedCategoriaHijo = value;
    notifyListeners();
  }

  set selectedPersonal(int? value) {
    _selectedPersonal = value;
    notifyListeners();
  }

  set descripcion(String? value) {
    _descripcion = value;
    notifyListeners();
  }

  set prioridad(String? value) {
    _prioridad = value;
    notifyListeners();
  }

  set archivo(File? value) {
    _archivo = value;
    notifyListeners();
  }

  // Métodos para obtener datos
  Future<void> fetchCategorias() async {
    try {
      // Cargar categorías padre
      List<Map<String, dynamic>> categoriasPadreData =
          await apiService.fetchCategoriasPadre();
      for (var categoria in categoriasPadreData) {
        _categorias[categoria['id']] = categoria['nombre'];
      }

      // Cargar categorías hijo
      for (var categoriaPadre in categoriasPadreData) {
        int padreId = categoriaPadre['id'];
        List<Map<String, dynamic>> categoriasHijoData =
            await apiService.fetchCategoriasHijo(padreId);
        for (var categoria in categoriasHijoData) {
          _categorias[categoria['id']] = categoria['nombre'];
        }
      }

      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<List<Map<String, dynamic>>> fetchCategoriasPadre() async {
    return await apiService.fetchCategoriasPadre();
  }

  Future<List<Map<String, dynamic>>> fetchCategoriasHijo(int padreId) async {
    return await apiService.fetchCategoriasHijo(padreId);
  }

  Future<List<Map<String, dynamic>>> fetchPersonal() async {
    return await apiService.fetchPersonal();
  }

  // Método para crear incidencia
  Future<void> submitIncidencia(int alumnoId, int carreraId) async {
    final incidenciaData = {
      'alumno_id': alumnoId,
      'categoriaincidencia_id': _selectedCategoriaHijo!,
      'descripcion': _descripcion!,
      'personal_id': _selectedPersonal!,
      'carrera_id': carreraId,
      'prioridad': _prioridad!,
    };

    await apiService.createIncidencia(incidenciaData, _archivo);
  }

  Future<void> fetchIncidenciasPorAlumno(int alumnoId) async {
    try {
      _incidencias = await apiService.fetchIncidenciasPorAlumno(alumnoId);
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> fetchIncidenciasPorPersonal(int personalId) async {
    try {
      _incidencias = await apiService.fetchIncidenciasPorPersonal(personalId);
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> addMensajeIncidencia(int incidenciaId, String contenido,
      String remitenteTipo, int remitenteId) async {
    try {
      await apiService.addRespuestaIncidencia(
          incidenciaId, contenido, remitenteTipo, remitenteId);
      final incidencia = _incidencias.firstWhere((i) => i.id == incidenciaId);
      incidencia.respuestas.add(
        RespuestaIncidencia(
          id: 0,
          incidenciaId: incidenciaId,
          remitenteId: remitenteId,
          remitenteTipo: remitenteTipo,
          contenido: contenido,
          fechaRespuesta: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }
}

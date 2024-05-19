import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/incidencia.dart';

class IncidenciaController with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Incidencia> _incidencias = [];
  Map<int, String> _categorias = {}; // Almacenar categorías
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
      categoriasPadreData.forEach((categoria) {
        // Añadir log
        _categorias[categoria['id']] = categoria['nombre'];
      });

      // Cargar categorías hijo
      for (var categoriaPadre in categoriasPadreData) {
        int padreId = categoriaPadre['id'];
        List<Map<String, dynamic>> categoriasHijoData =
            await apiService.fetchCategoriasHijo(padreId);
        categoriasHijoData.forEach((categoria) {
          // Añadir log
          _categorias[categoria['id']] = categoria['nombre'];
        });
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching categorias: $e");
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
      print("Fetching incidencias for alumnoId: $alumnoId");
      _incidencias = await apiService.fetchIncidenciasPorAlumno(alumnoId);
      print("Fetched incidencias: $_incidencias");
      _incidencias.forEach((incidencia) {
        print(
            "Incidencia: ${incidencia.descripcion}, Categoria ID: ${incidencia.categoriaIncidenciaId}");
      });
      notifyListeners();
    } catch (e) {
      print("Error fetching incidencias: $e");
    }
  }

  Future<void> addMensajeIncidencia(int incidenciaId, String contenido) async {
    try {
      await apiService.addRespuestaIncidencia(incidenciaId, contenido);
      // Re-fetch incidencias after adding a message
      final incidencia = _incidencias.firstWhere((i) => i.id == incidenciaId);
      incidencia.respuestas.add(
        RespuestaIncidencia(
          id: 0, // Assuming ID is auto-generated and can be any placeholder here
          incidenciaId: incidenciaId,
          personalId: 0, // Assuming 0 indicates it's from the student
          contenido: contenido,
          fechaRespuesta: DateTime.now(),
        ),
      );
      notifyListeners();
    } catch (e) {
      print("Error adding mensaje: $e");
    }
  }
}

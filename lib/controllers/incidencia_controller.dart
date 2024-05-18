import 'dart:io';
import 'package:flutter/material.dart';
import '../services/api_service.dart';

class IncidenciaController with ChangeNotifier {
  final ApiService apiService = ApiService();
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
    // Añadir carreraId
    final incidenciaData = {
      'alumno_id': alumnoId,
      'categoriaincidencia_id': _selectedCategoriaHijo!,
      'descripcion': _descripcion!,
      'personal_id': _selectedPersonal!,
      'carrera_id': carreraId, // Añadir este campo
      'prioridad': _prioridad!,
    };

    await apiService.createIncidencia(incidenciaData, _archivo);
  }
}

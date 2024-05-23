import 'dart:io';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/api_service.dart';
import '../models/incidencia.dart';

class IncidenciaController with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<Incidencia> _incidencias = [];
  List<Incidencia> _incidenciasFiltradas = [];
  final Map<int, String> _categorias = {};
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
  List<Incidencia> get incidenciasFiltradas => _incidenciasFiltradas;
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

  Future<void> fetchCategorias() async {
    try {
      List<Map<String, dynamic>> categoriasPadreData =
          await apiService.fetchCategoriasPadre();
      for (var categoria in categoriasPadreData) {
        _categorias[categoria['id']] = categoria['nombre'];
      }

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
      _incidenciasFiltradas = List.from(_incidencias);
      _ordenarIncidencias();
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> fetchIncidenciasPorPersonal(int personalId) async {
    try {
      _incidencias = await apiService.fetchIncidenciasPorPersonal(personalId);
      _incidenciasFiltradas = List.from(_incidencias);
      _ordenarIncidencias();
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
      _ordenarIncidencias();
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> cerrarIncidencia(int incidenciaId) async {
    try {
      await apiService.cerrarIncidencia(incidenciaId);
      final incidencia = _incidencias.firstWhere((i) => i.id == incidenciaId);
      incidencia.estado = 'cerrada';
      incidencia.fechaHoraCierre = DateTime.now();
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  Future<void> reabrirIncidencia(int incidenciaId) async {
    try {
      await apiService.reabrirIncidencia(incidenciaId);
      final incidencia = _incidencias.firstWhere((i) => i.id == incidenciaId);
      incidencia.estado = 'pendiente';
      incidencia.fechaHoraCierre = null;
      notifyListeners();
    } catch (e) {
      // Error handling
    }
  }

  void filtrarIncidencias(
      String? categoria, String? prioridad, String? estado, DateTime? fecha) {
    _incidenciasFiltradas = _incidencias.where((incidencia) {
      final categoriaMatch = categoria == null ||
          _categorias[incidencia.categoriaIncidenciaId] == categoria;
      final prioridadMatch =
          prioridad == null || incidencia.prioridad == prioridad;
      final estadoMatch = estado == null || incidencia.estado == estado;
      final fechaMatch = fecha == null ||
          DateFormat('yyyy-MM-dd').format(incidencia.fechaHoraCreacion) ==
              DateFormat('yyyy-MM-dd').format(fecha);

      return categoriaMatch && prioridadMatch && estadoMatch && fechaMatch;
    }).toList();

    _ordenarIncidencias(); // Asegúrate de ordenar después de filtrar
    notifyListeners();
  }

  void resetFiltros() {
    _incidenciasFiltradas = List.from(_incidencias);
    _ordenarIncidencias(); // Asegúrate de ordenar después de resetear
    notifyListeners();
  }

  void _ordenarIncidencias() {
    _incidenciasFiltradas.sort((a, b) {
      if (a.estado == 'pendiente' && b.estado != 'pendiente') {
        return -1;
      } else if (a.estado != 'pendiente' && b.estado == 'pendiente') {
        return 1;
      } else {
        return b.fechaHoraCreacion.compareTo(a.fechaHoraCreacion);
      }
    });
  }
}

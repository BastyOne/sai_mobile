import 'dart:io';
import 'package:flutter/material.dart';
import '../../../../models/alumno.dart';
import '../../../../services/user_service.dart';

class AlumnosController extends ChangeNotifier {
  final UserService _userService = UserService();
  List<AlumnoInfo> _alumnos = [];
  bool _isLoading = true;
  String? _selectedCarrera;
  String? _selectedNivel;

  List<AlumnoInfo> get alumnos => _alumnos;
  bool get isLoading => _isLoading;
  String? get selectedCarrera => _selectedCarrera;
  String? get selectedNivel => _selectedNivel;

  Future<void> fetchAlumnos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final alumnos = await _userService.getAlumnos();
      _alumnos = alumnos;
    } catch (e) {
      print('Error fetching alumnos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  Future<void> filterAlumnos() async {
    _isLoading = true;
    notifyListeners();

    try {
      final alumnos = await _userService.getAlumnos(
        carrera: _selectedCarrera,
        nivel: _selectedNivel,
      );
      _alumnos = alumnos;
    } catch (e) {
      print('Error filtering alumnos: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  void setCarrera(String? carrera) {
    _selectedCarrera = carrera;
    filterAlumnos();
  }

  void setNivel(String? nivel) {
    _selectedNivel = nivel;
    filterAlumnos();
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
    _isLoading = true;
    notifyListeners();

    try {
      await _userService.agregarAlumno(
        nivel: nivel,
        rut: rut,
        nombre: nombre,
        apellido: apellido,
        email: email,
        password: password,
        activo: activo,
        celular: celular,
        contactoEmergencia: contactoEmergencia,
        categoriaAlumnoId: categoriaAlumnoId,
        ciudadActual: ciudadActual,
        ciudadProcedencia: ciudadProcedencia,
        suspensionRangoFecha: suspensionRangoFecha,
        rolId: rolId,
        carreraId: carreraId,
        archivo: archivo,
      );
      fetchAlumnos(); // Refresh the list after adding a new student
    } catch (e) {
      print('Error adding alumno: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}

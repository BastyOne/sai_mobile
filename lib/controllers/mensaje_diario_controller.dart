import 'dart:io';
import 'package:flutter/material.dart';
import 'package:sai_mobile/services/mensaje_diario_service.dart';
import '../models/mensaje_diario.dart';

class MensajeDiarioController with ChangeNotifier {
  final MensajeDiarioService apiService = MensajeDiarioService();
  List<MensajeDiario> todosMensajesDiarios = [];
  List<MensajeDiario> mensajesDiariosActivos = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchMensajesDiarios() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      todosMensajesDiarios = await apiService.fetchMensajesDiarios();
      mensajesDiariosActivos =
          todosMensajesDiarios.where((mensaje) => mensaje.activo).toList();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleActivo(int id, bool activo) async {
    try {
      await apiService.toggleActivo(id, activo);
      await fetchMensajesDiarios(); // Vuelve a cargar los mensajes después de actualizar el estado
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> agregarMensajeDiario(
      String mensaje, String contexto, File? archivo) async {
    try {
      await apiService.agregarMensajeDiario(mensaje, contexto, archivo);
      await fetchMensajesDiarios(); // Vuelve a cargar los mensajes después de agregar uno nuevo
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    }
  }

  Future<void> eliminarMensajeDiario(int id) async {
    try {
      await apiService.eliminarMensajeDiario(id);
      await fetchMensajesDiarios(); // Vuelve a cargar los mensajes después de eliminar uno
    } catch (error) {
      errorMessage = error.toString();
      notifyListeners();
    }
  }
}

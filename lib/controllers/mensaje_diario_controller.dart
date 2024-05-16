import 'package:flutter/material.dart';
import '../services/api_service.dart';
import '../models/mensaje_diario.dart';

class MensajeDiarioController with ChangeNotifier {
  final ApiService apiService = ApiService();
  List<MensajeDiario> mensajesDiarios = [];
  bool isLoading = false;
  String errorMessage = '';

  Future<void> fetchMensajesDiarios() async {
    isLoading = true;
    errorMessage = '';
    notifyListeners();

    try {
      mensajesDiarios = await apiService.fetchMensajesDiarios();
    } catch (error) {
      errorMessage = error.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }
}

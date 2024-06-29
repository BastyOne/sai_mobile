import 'package:flutter/material.dart';
import '../models/personal.dart';
import '../services/user_service.dart';

class PersonalController extends ChangeNotifier {
  List<PersonalInfo> _personal = [];
  bool _isLoading = false;

  List<PersonalInfo> get personal => _personal;
  bool get isLoading => _isLoading;

  Future<void> fetchPersonal() async {
    _isLoading = true;
    notifyListeners();

    try {
      _personal = await UserService().getPersonalList();
      if (_personal.isEmpty) {
        print('No se encontró personal.');
      } else {
        print('Personal obtenido: ${_personal.length} elementos.');
      }
    } catch (e) {
      // Manejo de errores
      print('Failed to fetch personal: $e');
    }

    _isLoading = false;
    notifyListeners();
  }
}

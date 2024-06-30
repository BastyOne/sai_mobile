import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import '../services/shared_preferences.dart';

class LoginController {
  final AuthService apiService = AuthService();

  Future<bool> login(String rut, String password, BuildContext context) async {
    try {
      final user = await apiService.login(rut, password);
      if (user != null) {
        await SharedPreferencesService.setToken(user.token);

        switch (user.userType) {
          case 'alumno':
            Navigator.pushReplacementNamed(
              context,
              '/home_alumno',
              arguments: {'userId': user.userId, 'carreraId': user.carreraId},
            );
            break;
          case 'personal':
            Navigator.pushReplacementNamed(
              context,
              '/home_personal',
              arguments: {'userId': user.userId},
            );
            break;
          default:
            return false;
        }
        return true; // Login exitoso
      } else {
        return false; // Login fallido
      }
    } catch (e) {
      return false; // Error en el login
    }
  }
}

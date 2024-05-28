import '../services/auth_service.dart';
import 'package:flutter/material.dart';
import '../services/shared_preferences.dart';

class LoginController {
  final AuthService apiService = AuthService();

  void login(String rut, String password, BuildContext context) async {
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
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Tipo de usuario desconocido: ${user.userType}')));
            break;
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Credenciales inválidas')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

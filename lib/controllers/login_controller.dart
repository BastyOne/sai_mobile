import 'package:sai_mobile/views/home_alumno_view.dart';

import '../models/user.dart';
import '../services/api_service.dart';
import 'package:flutter/material.dart';

class LoginController {
  final ApiService apiService = ApiService();

  void login(String rut, String password, BuildContext context) async {
    try {
      final user = await apiService.login(rut, password);
      if (user != null) {
        // Asumiendo que `user` tiene un campo `userId`
        if (user.userId != null) {
          print('Login successful. User ID: ${user.userId}');
          print('Navigating to HomeAlumnoView with userId: ${user.userId}');
          Navigator.pushReplacementNamed(
            context,
            '/home_alumno',
            arguments: {'userId': user.userId},
          );
        } else if (user.userType == 'personal') {
          // Aquí iría la navegación hacia la pantalla de usuario de tipo 'personal'
          Navigator.pushReplacementNamed(context, '/home_personal');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text('Tipo de usuario desconocido')));
        }
      } else {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text('Credenciales inválidas')));
      }
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }
}

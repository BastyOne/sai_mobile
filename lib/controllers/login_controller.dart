import '../services/api_service.dart';
import 'package:flutter/material.dart';
import '../services/shared_preferences.dart';

class LoginController {
  final ApiService apiService = ApiService();

  void login(String rut, String password, BuildContext context) async {
    try {
      final user = await apiService.login(rut, password);
      if (user != null) {
        print('Login successful. User ID: ${user.userId}');
        await SharedPreferencesService.setToken(user.token);
        print('User Type: ${user.userType}'); // Imprime el tipo de usuario

        // Redirecciona según el tipo de usuario
        switch (user.userType) {
          case 'alumno':
            print('Navigating to HomeAlumnoView with userId: ${user.userId}');
            Navigator.pushReplacementNamed(
              context,
              '/home_alumno',
              arguments: {'userId': user.userId},
            );
            break;
          case 'personal':
            print('Navigating to HomePersonalView with userId: ${user.userId}');
            Navigator.pushReplacementNamed(
              context,
              '/home_personal',
              arguments: {'userId': user.userId},
            );
            break;
          default:
            print('Unknown user type: ${user.userType}');
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content:
                    Text('Tipo de usuario desconocido: ${user.userType}')));
            break;
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

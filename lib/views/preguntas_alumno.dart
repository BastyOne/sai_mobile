import 'package:flutter/material.dart';
import '../services/shared_preferences.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class IngresarPreguntaScreen extends StatelessWidget {
  const IngresarPreguntaScreen({super.key});

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
    print("Cierre de sesión solicitado y procesado.");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Image.network(
          'https://portalalumnos.ucm.cl/v2/assets/img/logo_ucm_white.png',
          width: 160,
        ),
      ),
      drawer: CustomDrawer(
        onLogout: () => _logout(context),
      ),
      body: const Center(
        child: Text("Ingresar Pregunta"),
      ),
    );
  }
}

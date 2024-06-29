import 'package:flutter/material.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';
import 'settingsFAQS/settings_faqs_view.dart';
import 'settingsMensajeDiario/settings_mensaje_diario_view.dart';
import 'settingsUsers/settings_alumno_view.dart';
import 'settingsUsers/settings_personal_view.dart'; // Importa la nueva pantalla de personal

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
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
      body: ListView(
        children: [
          _createSettingsItem(Icons.help, 'Preguntas Frecuentes', context),
          _createSettingsItem(
              Icons.person_add, 'Alumnos', context), // Agrega el contexto
          _createSettingsItem(
              Icons.person, 'Personal', context), // Agrega el contexto
          _createSettingsItem(Icons.wallpaper, 'Mensaje Diario', context),
        ],
      ),
    );
  }

  Widget _createSettingsItem(IconData icon, String title,
      [BuildContext? context]) {
    return ListTile(
      leading: Icon(icon, color: const Color(0xFF0575E6)),
      title: Text(
        title,
        style: const TextStyle(color: Color(0xFF0575E6)),
      ),
      onTap: () {
        if (title == 'Preguntas Frecuentes' && context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const AdminPreguntasFrecuentesScreen()),
          );
        } else if (title == 'Mensaje Diario' && context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => const MensajeDiarioScreen()),
          );
        } else if (title == 'Alumnos' && context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const AlumnosScreen()), // Navega a la nueva pantalla
          );
        } else if (title == 'Personal' && context != null) {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    const PersonalScreen()), // Navega a la pantalla de personal
          );
        }
      },
    );
  }
}

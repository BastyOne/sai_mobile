import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../views/alumno/settingsAlumno/actualizar_datos_alumno.dart';
import '../views/personal/incidenciasViewPersonal/agenda_reuniones_personal_view.dart';
import '../views/personal/settingsPersonal/settings_view.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const CustomDrawer({super.key, required this.onLogout});

  Future<void> _navigateToHome(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    final userType = prefs.getString('userType');

    if (userType == 'alumno') {
      final userId = prefs.getInt('userId')!;
      final carreraId = prefs.getInt('carreraId')!;
      Navigator.pushReplacementNamed(context, '/home_alumno',
          arguments: {'userId': userId, 'carreraId': carreraId});
    } else if (userType == 'personal') {
      final userId = prefs.getInt('userId')!;
      Navigator.pushReplacementNamed(context, '/home_personal',
          arguments: {'userId': userId});
    }
  }

  Future<String?> _getUserType() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userType');
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      future: _getUserType(),
      builder: (BuildContext context, AsyncSnapshot<String?> snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else {
          final userType = snapshot.data;
          return Drawer(
            child: Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Color(0xFF021B79), Color(0xFF0575E6)],
                ),
              ),
              child: ListView(
                padding: const EdgeInsets.only(top: 60),
                children: <Widget>[
                  _createDrawerItem(
                      icon: Icons.home,
                      text: 'Inicio',
                      onTap: () => _navigateToHome(context)),
                  if (userType == 'alumno')
                    _createDrawerItem(
                        icon: Icons.contacts,
                        text: 'Actualizar Datos',
                        onTap: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const UpdateAlumnoScreen()),
                            )),
                  if (userType == 'alumno')
                    _createDrawerItem(
                        icon: Icons.book,
                        text: 'LMS',
                        onTap: () {
                          launchUrl(Uri.parse(
                              'https://lms.ucm.cl/login/index.php#tabs-tree-start'));
                        }),
                  if (userType == 'alumno')
                    _createDrawerItem(
                        icon: Icons.account_balance,
                        text: 'Portal Alumno',
                        onTap: () {
                          launchUrl(Uri.parse(
                              'https://portalalumnos.ucm.cl/v2/index.php/login'));
                        }),
                  if (userType == 'personal')
                    _createDrawerItem(
                        icon: Icons.settings,
                        text: 'Ajustes',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const SettingsScreen()))),
                  if (userType == 'personal')
                    _createDrawerItem(
                        icon: Icons.calendar_today,
                        text: 'Agenda',
                        onTap: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const AgendaScreen()))),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.white),
                    title: const Text('Cerrar Sesión',
                        style: TextStyle(color: Colors.white)),
                    onTap: onLogout,
                  ),
                ],
              ),
            ),
          );
        }
      },
    );
  }

  Widget _createDrawerItem(
      {required IconData icon,
      required String text,
      required VoidCallback onTap}) {
    return ListTile(
      leading: Icon(icon, color: Colors.white),
      title: Text(text, style: const TextStyle(color: Colors.white)),
      onTap: onTap,
    );
  }
}

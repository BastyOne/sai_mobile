import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFF021B79), // Color más oscuro en la parte superior
              Color(0xFF0575E6) // Color más claro en la parte inferior
            ],
          ),
        ),
        child: ListView(
          padding: const EdgeInsets.only(top: 60),
          children: <Widget>[
            _createDrawerItem(
                icon: Icons.home,
                text: 'Inicio',
                onTap: () => _navigateToHome(context)),
            _createDrawerItem(
                icon: Icons.book, text: 'Info Curricular', onTap: () {}),
            _createDrawerItem(
                icon: Icons.account_balance,
                text: 'Info Arancelería',
                onTap: () {}),
            _createDrawerItem(
                icon: Icons.school,
                text: 'Dirección Estudiantil',
                onTap: () {}),
            _createDrawerItem(
                icon: Icons.settings, text: 'Servicios', onTap: () {}),
            _createDrawerItem(
                icon: Icons.payment, text: 'Pagáres', onTap: () {}),
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

import 'package:flutter/material.dart';

class CustomDrawer extends StatelessWidget {
  final VoidCallback onLogout;

  const CustomDrawer({Key? key, required this.onLogout}) : super(key: key);

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
            _createDrawerItem(icon: Icons.home, text: 'Inicio', onTap: () {}),
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
              onTap: onLogout, // Usa directamente el onLogout proporcionado
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

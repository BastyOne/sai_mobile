import 'package:flutter/material.dart';
import 'seleccionar_categoria_view.dart';

class IncidenciasAlumnoView extends StatelessWidget {
  final int userId;
  final int carreraId; // Añadir este campo

  const IncidenciasAlumnoView(
      {super.key, required this.userId, required this.carreraId});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Incidencias')),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => SeleccionarCategoriaPadreScreen(
                    userId: userId, carreraId: carreraId), // Pasar carreraId
              ),
            );
          },
          child: const Text('Ingresar Incidencia'),
        ),
      ),
    );
  }
}

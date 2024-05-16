// views/incidenciasViews/incidencias_alumno_view.dart
import 'package:flutter/material.dart';
import 'seleccionar_categoria_view.dart';

class IncidenciasAlumnoView extends StatelessWidget {
  final int userId;

  const IncidenciasAlumnoView({super.key, required this.userId});

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
                builder: (context) =>
                    SeleccionarCategoriaPadreScreen(userId: userId),
              ),
            );
          },
          child: const Text('Ingresar Incidencia'),
        ),
      ),
    );
  }
}

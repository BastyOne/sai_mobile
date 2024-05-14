import 'package:flutter/material.dart';
import '../models/alumno.dart';

class StudentInfoCard extends StatelessWidget {
  final AlumnoInfo alumno;

  const StudentInfoCard({super.key, required this.alumno});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(8.0),
        color: Colors.blue[900], // Ajusta el color según tu diseño
        child: Row(
          children: [
            // Si alumno.fotoUrl es null, podrías mostrar un Placeholder o una imagen por defecto
            CircleAvatar(
              backgroundImage: alumno.fotoUrl != null
                  ? NetworkImage(alumno.fotoUrl!)
                  : const AssetImage('path_to_default_image')
                      as ImageProvider<Object>?,
              radius: 50.0,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${alumno.nombre} ${alumno.apellido}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    alumno.rut,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    alumno.email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Regular en ${alumno.carreraNombre}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../../models/incidencia.dart';

class IncidenciaItemPersonal extends StatelessWidget {
  final Incidencia incidencia;
  final Map<int, String> categorias;

  const IncidenciaItemPersonal({
    super.key,
    required this.incidencia,
    required this.categorias,
  });

  @override
  Widget build(BuildContext context) {
    Color getEstadoColor() {
      switch (incidencia.estado) {
        case 'pendiente':
          return Colors.red;
        case 'cerrada':
          return Colors.green;
        default:
          return Colors.grey;
      }
    }

    Color getPrioridadColor() {
      switch (incidencia.prioridad) {
        case 'Baja':
          return Colors.green;
        case 'Media':
          return Colors.orange;
        case 'Alta':
          return Colors.red;
        default:
          return Colors.grey;
      }
    }

    String formattedDate =
        DateFormat('yyyy-MM-dd').format(incidencia.fechaHoraCreacion);

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8.0),
      padding: const EdgeInsets.all(8.0),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8.0),
        color: Colors.white,
      ),
      child: IntrinsicHeight(
        child: Row(
          children: [
            Container(
              width: 8.0,
              height: double.infinity,
              color: getEstadoColor(),
            ),
            const SizedBox(width: 8.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    categorias[incidencia.categoriaIncidenciaId] ??
                        'Desconocida',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16.0,
                      color: Color(0xFF0575E6),
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Descripción: ${incidencia.descripcion}",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 4.0),
                  Text(
                    "Fecha: $formattedDate",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Prioridad: ${incidencia.prioridad ?? 'N/A'}",
                  style: TextStyle(
                    color: getPrioridadColor(),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

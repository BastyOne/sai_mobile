import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../controllers/incidencia_controller.dart';
import '../../../models/incidencia.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';

class ChatIncidenciaScreen extends StatelessWidget {
  final Incidencia incidencia;

  const ChatIncidenciaScreen({super.key, required this.incidencia});

  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

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
      body: Consumer<IncidenciaController>(
        builder: (context, incidenciaController, child) {
          final updatedIncidencia = incidenciaController.incidencias
              .firstWhere((i) => i.id == incidencia.id);

          return Column(
            children: [
              Expanded(
                child: ListView.builder(
                  padding: const EdgeInsets.all(8.0),
                  itemCount: updatedIncidencia.respuestas.length + 1,
                  itemBuilder: (context, index) {
                    if (index == 0) {
                      return Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: const Color(0xFF0575E6),
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                updatedIncidencia.descripcion,
                                style: const TextStyle(color: Colors.white),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('yyyy-MM-dd HH:mm').format(
                                    updatedIncidencia.fechaHoraCreacion),
                                style: const TextStyle(
                                  color: Colors.white70,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      var respuesta = updatedIncidencia.respuestas[index - 1];
                      bool isAlumno = respuesta.remitenteTipo == 'alumno';

                      return Align(
                        alignment: isAlumno
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isAlumno
                                ? const Color(0xFF0575E6)
                                : Colors.grey[200],
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                respuesta.contenido,
                                style: TextStyle(
                                  color: isAlumno ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('HH:mm')
                                    .format(respuesta.fechaRespuesta),
                                style: TextStyle(
                                  color: isAlumno
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              _buildMessageInput(context, controller, updatedIncidencia),
            ],
          );
        },
      ),
    );
  }

  Widget _buildMessageInput(BuildContext context,
      TextEditingController controller, Incidencia updatedIncidencia) {
    bool isIncidenciaCerrada = updatedIncidencia.estado == 'cerrada';

    return Container(
      color: const Color.fromARGB(255, 255, 255, 255),
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      child: Row(
        children: [
          if (updatedIncidencia.reuniones.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.info, color: Color(0xFF0575E6)),
              onPressed: () {
                _showReunionInfo(context, updatedIncidencia.reuniones.first);
              },
            ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8.0),
              decoration: BoxDecoration(
                color:
                    isIncidenciaCerrada ? Colors.grey[300] : Colors.grey[200],
                borderRadius: BorderRadius.circular(14.0),
              ),
              child: TextField(
                controller: controller,
                decoration: const InputDecoration(
                  hintText: "Escribe un mensaje...",
                  border: InputBorder.none,
                ),
                enabled: !isIncidenciaCerrada,
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send, color: Color(0xFF0575E6)),
            onPressed: isIncidenciaCerrada
                ? null
                : () async {
                    String contenido = controller.text.trim();
                    if (contenido.isNotEmpty) {
                      int? remitenteId =
                          await SharedPreferencesService.getUserId();
                      String? remitenteTipo =
                          await SharedPreferencesService.getUserType();

                      if (remitenteId != null && remitenteTipo != null) {
                        Provider.of<IncidenciaController>(context,
                                listen: false)
                            .addMensajeIncidencia(updatedIncidencia.id,
                                contenido, remitenteTipo, remitenteId);
                        controller.clear();
                      } else {
                        // Manejar el caso donde remitenteId o remitenteTipo son nulos
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Error: Usuario no autenticado.'),
                          ),
                        );
                      }
                    }
                  },
          ),
        ],
      ),
    );
  }

  void _showReunionInfo(BuildContext context, Reunion reunion) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Reunión', style: TextStyle(color: Color(0xFF0575E6))),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF0575E6)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Información de la Reunión',
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Color(0xFF0575E6))),
                const SizedBox(height: 10),
                Text('Tema: ${reunion.tema}',
                    style: const TextStyle(color: Color(0xFF0575E6))),
                const SizedBox(height: 10),
                Text('Fecha: ${reunion.fecha}',
                    style: const TextStyle(color: Color(0xFF0575E6))),
                const SizedBox(height: 10),
                Text('Hora: ${reunion.hora}',
                    style: const TextStyle(color: Color(0xFF0575E6))),
                const SizedBox(height: 10),
                Text('Lugar: ${reunion.lugar}',
                    style: const TextStyle(color: Color(0xFF0575E6))),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar',
                  style: TextStyle(color: Color(0xFF0575E6))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    await SharedPreferencesService.removeUserId();
    await SharedPreferencesService.removeUserType();
    Navigator.pushReplacementNamed(context, '/');
  }
}

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import '../../../controllers/incidencia_controller.dart';
import '../../../models/incidencia.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';

class ChatIncidenciaPersonalScreen extends StatefulWidget {
  final Incidencia incidencia;

  const ChatIncidenciaPersonalScreen({super.key, required this.incidencia});

  @override
  ChatIncidenciaPersonalScreenState createState() =>
      ChatIncidenciaPersonalScreenState();
}

class ChatIncidenciaPersonalScreenState
    extends State<ChatIncidenciaPersonalScreen> {
  late TextEditingController _controller;
  bool incidenciaUpdated = false;

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        Navigator.pop(context, incidenciaUpdated);
        return false;
      },
      child: Scaffold(
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
                .firstWhere((i) => i.id == widget.incidencia.id,
                    orElse: () => widget.incidencia);

            return Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: updatedIncidencia.respuestas.length +
                        1, // +1 para incluir la descripción
                    itemBuilder: (context, index) {
                      if (index == 0) {
                        // Mostrar la descripción de la incidencia como el primer mensaje
                        return Align(
                          alignment: Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.symmetric(vertical: 4.0),
                            padding: const EdgeInsets.all(10.0),
                            decoration: BoxDecoration(
                              color: Colors.grey[200],
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  updatedIncidencia.descripcion,
                                  style: const TextStyle(color: Colors.black),
                                ),
                                const SizedBox(height: 5),
                                Text(
                                  DateFormat('HH:mm').format(
                                      updatedIncidencia.fechaHoraCreacion),
                                  style: const TextStyle(
                                      color: Colors.black54, fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                        );
                      }

                      var respuesta = updatedIncidencia.respuestas[index - 1];
                      bool isPersonal = respuesta.remitenteTipo == 'personal';

                      return Align(
                        alignment: isPersonal
                            ? Alignment.centerRight
                            : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 4.0),
                          padding: const EdgeInsets.all(10.0),
                          decoration: BoxDecoration(
                            color: isPersonal
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
                                  color:
                                      isPersonal ? Colors.white : Colors.black,
                                ),
                              ),
                              const SizedBox(height: 5),
                              Text(
                                DateFormat('HH:mm')
                                    .format(respuesta.fechaRespuesta),
                                style: TextStyle(
                                  color: isPersonal
                                      ? Colors.white70
                                      : Colors.black54,
                                  fontSize: 10,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                _buildMessageInput(context, _controller, updatedIncidencia),
              ],
            );
          },
        ),
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
          IconButton(
            icon: const Icon(Icons.info, color: Color(0xFF0575E6)),
            onPressed: () {
              _showIncidenciaInfo(context, updatedIncidencia);
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
                        await Provider.of<IncidenciaController>(context,
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

  void _showIncidenciaInfo(BuildContext context, Incidencia incidencia) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Incidencia',
                  style: TextStyle(color: Color(0xFF0575E6))),
              IconButton(
                icon: const Icon(Icons.close, color: Color(0xFF0575E6)),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width * 0.8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text('Información de la Incidencia',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0575E6))),
                  const SizedBox(height: 10),
                  Text('Descripción: ${incidencia.descripcion}',
                      style: const TextStyle(color: Color(0xFF0575E6))),
                  const SizedBox(height: 10),
                  Text('Estado: ${incidencia.estado}',
                      style: const TextStyle(color: Color(0xFF0575E6))),
                  const SizedBox(height: 10),
                  Text(
                      'Fecha de Creación: ${DateFormat('yyyy-MM-dd HH:mm').format(incidencia.fechaHoraCreacion)}',
                      style: const TextStyle(color: Color(0xFF0575E6))),
                  if (incidencia.fechaHoraCierre != null)
                    Text(
                        'Fecha de Cierre: ${DateFormat('yyyy-MM-dd HH:mm').format(incidencia.fechaHoraCierre!)}',
                        style: const TextStyle(color: Color(0xFF0575E6))),
                  const SizedBox(height: 20),
                  const Text('Información del Alumno',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0575E6))),
                  const SizedBox(height: 10),
                  if (incidencia.alumno != null) ...[
                    Text(
                        'Nombre: ${incidencia.alumno!.nombre} ${incidencia.alumno!.apellido}',
                        style: const TextStyle(color: Color(0xFF0575E6))),
                    Text('Rut: ${incidencia.alumno!.rut}',
                        style: const TextStyle(color: Color(0xFF0575E6))),
                    Text('Email: ${incidencia.alumno!.email}',
                        style: const TextStyle(color: Color(0xFF0575E6))),
                    Text('Carrera: ${incidencia.alumno!.carreraNombre}',
                        style: const TextStyle(color: Color(0xFF0575E6))),
                  ] else
                    const Text('Alumno: Información no disponible',
                        style: TextStyle(color: Color(0xFF0575E6))),
                  const SizedBox(height: 20),
                  const Text('Archivos',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF0575E6))),
                  if (incidencia.archivos.isNotEmpty) ...[
                    for (var archivo in incidencia.archivos) ...[
                      ListTile(
                        title: Text(archivo.archivoNombre,
                            style: const TextStyle(color: Color(0xFF0575E6))),
                        trailing: IconButton(
                          icon: const Icon(Icons.download,
                              color: Color(0xFF0575E6)),
                          onPressed: () {
                            _downloadFile(context, archivo.archivoUrl,
                                archivo.archivoNombre);
                          },
                        ),
                      ),
                    ],
                  ] else
                    const Text('No hay archivos adjuntos.',
                        style: TextStyle(color: Color(0xFF0575E6))),
                ],
              ),
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Agendar Reunión',
                  style: TextStyle(color: Color(0xFF0575E6))),
              onPressed: () {
                Navigator.of(context).pop();
                _showAgendarReunionModal(context, incidencia.id);
              },
            ),
            TextButton(
              child: Text(
                incidencia.estado == 'cerrada'
                    ? 'Reabrir Incidencia'
                    : 'Cerrar Incidencia',
                style: const TextStyle(color: Color(0xFF0575E6)),
              ),
              onPressed: () async {
                final incidenciaController =
                    Provider.of<IncidenciaController>(context, listen: false);
                if (incidencia.estado == 'cerrada') {
                  await incidenciaController.reabrirIncidencia(incidencia.id);
                  incidenciaUpdated = true;
                  _showSuccessDialog(context, 'Incidencia reabierta con éxito');
                } else {
                  await incidenciaController.cerrarIncidencia(incidencia.id);
                  incidenciaUpdated = true;
                  _showSuccessDialog(context, 'Incidencia cerrada con éxito');
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showAgendarReunionModal(BuildContext context, int incidenciaId) {
    final fechaController = TextEditingController();
    final horaController = TextEditingController();
    final lugarController = TextEditingController();
    final temaController = TextEditingController();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Agendar Reunión'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                TextField(
                  controller: fechaController,
                  decoration: const InputDecoration(
                    labelText: 'Fecha',
                    labelStyle: TextStyle(color: Color(0xFF0575E6)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0575E6)),
                    ),
                  ),
                  onTap: () async {
                    DateTime? pickedDate = await showDatePicker(
                      context: context,
                      initialDate: DateTime.now(),
                      firstDate: DateTime(2000),
                      lastDate: DateTime(2101),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(
                                  0xFF0575E6), // Color principal del calendario
                              onPrimary: Colors
                                  .white, // Color del texto en el calendario
                              surface:
                                  Colors.white, // Color de fondo del calendario
                            ),
                            dialogBackgroundColor:
                                Colors.white, // Color de fondo del diálogo
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedDate != null) {
                      fechaController.text =
                          DateFormat('yyyy-MM-dd').format(pickedDate);
                    }
                  },
                ),
                TextField(
                  controller: horaController,
                  decoration: const InputDecoration(
                    labelText: 'Hora',
                    labelStyle: TextStyle(color: Color(0xFF0575E6)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0575E6)),
                    ),
                  ),
                  onTap: () async {
                    TimeOfDay? pickedTime = await showTimePicker(
                      context: context,
                      initialTime: TimeOfDay.now(),
                      builder: (BuildContext context, Widget? child) {
                        return Theme(
                          data: ThemeData.light().copyWith(
                            colorScheme: const ColorScheme.light(
                              primary: Color(
                                  0xFF0575E6), // Color principal del reloj
                              onPrimary:
                                  Colors.white, // Color del texto en el reloj
                              surface: Colors.white, // Color de fondo del reloj
                            ),
                            dialogBackgroundColor:
                                Colors.white, // Color de fondo del diálogo
                          ),
                          child: child!,
                        );
                      },
                    );
                    if (pickedTime != null) {
                      horaController.text = pickedTime.format(context);
                    }
                  },
                ),
                TextField(
                  controller: lugarController,
                  decoration: const InputDecoration(
                    labelText: 'Lugar',
                    labelStyle: TextStyle(color: Color(0xFF0575E6)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0575E6)),
                    ),
                  ),
                ),
                TextField(
                  controller: temaController,
                  decoration: const InputDecoration(
                    labelText: 'Tema',
                    labelStyle: TextStyle(color: Color(0xFF0575E6)),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF0575E6)),
                    ),
                  ),
                ),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancelar',
                  style: TextStyle(color: Color(0xFF0575E6))),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: const Text('Agendar',
                  style: TextStyle(color: Color(0xFF0575E6))),
              onPressed: () async {
                String fecha = fechaController.text.trim();
                String hora = horaController.text.trim();
                String lugar = lugarController.text.trim();
                String tema = temaController.text.trim();

                if (fecha.isNotEmpty &&
                    hora.isNotEmpty &&
                    lugar.isNotEmpty &&
                    tema.isNotEmpty) {
                  try {
                    await Provider.of<IncidenciaController>(context,
                            listen: false)
                        .programarReunion(
                            incidenciaId, fecha, hora, lugar, tema);
                    Navigator.of(context).pop();
                    _showSuccessDialog(context, 'Reunión agendada con éxito');
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error al agendar la reunión: $e'),
                      ),
                    );
                  }
                }
              },
            ),
          ],
        );
      },
    );
  }

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Operación exitosa'),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  foregroundColor: const Color(0xFF0575E6)),
              onPressed: () {
                Navigator.of(context).pop(); // Cerrar el diálogo de éxito
                Navigator.of(context).pop(); // Cerrar el modal de incidencia
                setState(() {
                  // Recargar la incidencia para reflejar el nuevo estado
                  Provider.of<IncidenciaController>(context, listen: false)
                      .fetchIncidenciasPorPersonal(
                          widget.incidencia.personalId);
                });
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  void _downloadFile(BuildContext context, String url, String filename) async {
    try {
      // Obtiene el directorio de descargas del dispositivo
      final downloadsDir = await getExternalStorageDirectory();
      final savePath = "${downloadsDir!.path}/$filename";

      // Realiza la descarga usando Dio
      final response = await Dio().download(url, savePath);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Archivo descargado en: $savePath')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al descargar el archivo')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error al descargar el archivo: $e')),
      );
    }
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    await SharedPreferencesService.removeUserId();
    await SharedPreferencesService.removeUserType();
    Navigator.pushReplacementNamed(context, '/');
  }
}

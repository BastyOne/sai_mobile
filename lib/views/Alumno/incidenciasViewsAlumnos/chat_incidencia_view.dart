import 'package:flutter/material.dart';
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
    final _controller = TextEditingController();

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
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: incidencia.respuestas.length,
              itemBuilder: (context, index) {
                var respuesta = incidencia.respuestas[index];
                return ListTile(
                  title: Text(respuesta.contenido),
                  subtitle: Text("${respuesta.fechaRespuesta}"),
                  leading: Icon(respuesta.personalId == null
                      ? Icons.person
                      : Icons.person_outline),
                );
              },
            ),
          ),
          _buildMessageInput(context, _controller),
        ],
      ),
    );
  }

  Widget _buildMessageInput(
      BuildContext context, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: "Escribe un mensaje...",
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              String contenido = controller.text.trim();
              if (contenido.isNotEmpty) {
                Provider.of<IncidenciaController>(context, listen: false)
                    .addMensajeIncidencia(incidencia.id, contenido);
                controller.clear();
              }
            },
          ),
        ],
      ),
    );
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
    print("Cierre de sesión solicitado y procesado.");
  }
}

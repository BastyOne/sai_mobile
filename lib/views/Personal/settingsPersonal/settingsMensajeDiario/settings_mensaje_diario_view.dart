import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/mensaje_diario_controller.dart';
import '../../../../services/shared_preferences.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_drawer.dart';
import 'settings_add_mensaje_diario_view.dart'; // Importa la nueva pantalla

class MensajeDiarioScreen extends StatefulWidget {
  const MensajeDiarioScreen({super.key});

  @override
  _MensajeDiarioScreenState createState() => _MensajeDiarioScreenState();
}

class _MensajeDiarioScreenState extends State<MensajeDiarioScreen> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      Provider.of<MensajeDiarioController>(context, listen: false)
          .fetchMensajesDiarios();
    });
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> _navigateAndRefresh(BuildContext context) async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => const AgregarMensajeDiarioScreen()),
    );
    if (result == true) {
      await Provider.of<MensajeDiarioController>(context, listen: false)
          .fetchMensajesDiarios();
    }
  }

  @override
  Widget build(BuildContext context) {
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
      body: Consumer<MensajeDiarioController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.errorMessage.isNotEmpty) {
            return Center(child: Text(controller.errorMessage));
          }
          return ListView.builder(
            itemCount: controller.todosMensajesDiarios.length,
            itemBuilder: (context, index) {
              final mensaje = controller.todosMensajesDiarios[index];
              return ListTile(
                leading: CircleAvatar(
                  radius: 10,
                  backgroundColor: mensaje.activo ? Colors.green : Colors.red,
                ),
                title: Text(mensaje.mensaje),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'activar') {
                      controller.toggleActivo(mensaje.id, true);
                    } else if (value == 'desactivar') {
                      controller.toggleActivo(mensaje.id, false);
                    } else if (value == 'eliminar') {
                      controller.eliminarMensajeDiario(mensaje.id);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      if (!mensaje.activo)
                        const PopupMenuItem(
                          value: 'activar',
                          child: Text('Activar'),
                        ),
                      if (mensaje.activo)
                        const PopupMenuItem(
                          value: 'desactivar',
                          child: Text('Desactivar'),
                        ),
                      const PopupMenuItem(
                        value: 'eliminar',
                        child: Text('Eliminar'),
                      ),
                    ];
                  },
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateAndRefresh(context),
        backgroundColor: const Color(0xFF0575E6),
        child: const Icon(Icons.add),
      ),
    );
  }
}

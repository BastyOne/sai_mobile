import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/incidencia_controller.dart';
import '../../../models/incidencia.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../widgets/incidencia_item.dart';

class IncidenciaStatusScreen extends StatelessWidget {
  final int userId;

  const IncidenciaStatusScreen({super.key, required this.userId});

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
      body: FutureBuilder(
        future: Future.wait([
          Provider.of<IncidenciaController>(context, listen: false)
              .fetchIncidenciasPorAlumno(userId),
          Provider.of<IncidenciaController>(context, listen: false)
              .fetchCategorias(),
        ]),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else {
            return Consumer<IncidenciaController>(
              builder: (context, controller, child) {
                if (controller.incidencias.isEmpty) {
                  return const Center(
                    child: Text("No hay incidencias registradas."),
                  );
                } else {
                  return ListView.builder(
                    padding: const EdgeInsets.all(8.0),
                    itemCount: controller.incidencias.length,
                    itemBuilder: (context, index) {
                      Incidencia incidencia = controller.incidencias[index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            '/chatIncidencia',
                            arguments: {
                              'incidencia': incidencia,
                            },
                          );
                        },
                        child: IncidenciaItem(
                          incidencia: incidencia,
                          categorias: controller
                              .categorias, // Pasar categorías al widget
                        ),
                      );
                    },
                  );
                }
              },
            );
          }
        },
      ),
    );
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
    print("Cierre de sesión solicitado y procesado.");
  }
}

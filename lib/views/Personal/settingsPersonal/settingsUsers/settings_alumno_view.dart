import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/alumnos_controller.dart';
import '../../../../services/shared_preferences.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_drawer.dart';

class AlumnosScreen extends StatefulWidget {
  const AlumnosScreen({super.key});

  @override
  AlumnosScreenState createState() => AlumnosScreenState();
}

class AlumnosScreenState extends State<AlumnosScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<AlumnosController>(context, listen: false).fetchAlumnos();
    });
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Image.network(
          'https://portalalumnos.ucm.cl/v2/assets/img/logo_ucm_white.png',
          width: 160,
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.filter_list),
            color: Colors.white,
            onPressed: () {
              _showFilterOptions(context);
            },
          ),
        ],
      ),
      drawer: CustomDrawer(
        onLogout: () => _logout(context),
      ),
      body: Consumer<AlumnosController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.alumnos.isEmpty) {
            return const Center(child: Text('No hay alumnos disponibles.'));
          }
          return ListView.builder(
            itemCount: controller.alumnos.length,
            itemBuilder: (context, index) {
              final alumno = controller.alumnos[index];
              return ListTile(
                leading: const Icon(Icons.person),
                title: Text('${alumno.nombre} ${alumno.apellido}'),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(alumno.email),
                    Text('Nivel: ${alumno.nivel}'),
                    Text('Carrera: ${alumno.carreraNombre}'),
                  ],
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }

  Future<void> _showFilterOptions(BuildContext context) async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Opciones de Filtrado'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                ListTile(
                  title: const Text('Filtrar por carrera'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showCarreraDialog(context);
                  },
                ),
                ListTile(
                  title: const Text('Filtrar por nivel'),
                  onTap: () {
                    Navigator.of(context).pop();
                    _showNivelDialog(context);
                  },
                ),
                ListTile(
                  title: const Text('Quitar filtros'),
                  onTap: () {
                    final controller =
                        Provider.of<AlumnosController>(context, listen: false);
                    controller.setCarrera('');
                    controller.setNivel('');
                    Navigator.of(context).pop();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showCarreraDialog(BuildContext context) async {
    final controller = Provider.of<AlumnosController>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Carrera'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('Ingeniería Civil Informática'),
                  value: '1',
                  groupValue: controller.selectedCarrera ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setCarrera(value!);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Ingeniería Civil Industrial'),
                  value: '2',
                  groupValue: controller.selectedCarrera ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setCarrera(value!);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Quitar filtro'),
                  value: '',
                  groupValue: controller.selectedCarrera ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setCarrera(value!);
                    Navigator.of(context).pop();
                  },
                ),
                // Añade más opciones de carrera según sea necesario
              ],
            ),
          ),
        );
      },
    );
  }

  Future<void> _showNivelDialog(BuildContext context) async {
    final controller = Provider.of<AlumnosController>(context, listen: false);
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Nivel'),
          content: SingleChildScrollView(
            child: Column(
              children: [
                RadioListTile<String>(
                  title: const Text('1er año'),
                  value: '1er año',
                  groupValue: controller.selectedNivel ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setNivel(value!);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('2do año'),
                  value: '2do año',
                  groupValue: controller.selectedNivel ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setNivel(value!);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('3er año'),
                  value: '3er año',
                  groupValue: controller.selectedNivel ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setNivel(value!);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('4to año'),
                  value: '4to año',
                  groupValue: controller.selectedNivel ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setNivel(value!);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('5to año'),
                  value: '5to año',
                  groupValue: controller.selectedNivel ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setNivel(value!);
                    Navigator.of(context).pop();
                  },
                ),
                RadioListTile<String>(
                  title: const Text('Quitar filtro'),
                  value: '',
                  groupValue: controller.selectedNivel ?? '',
                  activeColor: const Color(0xFF00A2E1),
                  onChanged: (value) {
                    controller.setNivel(value!);
                    Navigator.of(context).pop();
                  },
                ),
                // Añade más opciones de nivel según sea necesario
              ],
            ),
          ),
        );
      },
    );
  }
}

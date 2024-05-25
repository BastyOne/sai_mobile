import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';
import '../../../controllers/incidencia_controller.dart';
import '../../../models/incidencia.dart';
import '../../../widgets/incidencia_item_personal.dart';
import 'chat_incidencia_personal_view.dart';

class VerIncidenciasScreen extends StatefulWidget {
  final int personalId;

  const VerIncidenciasScreen({super.key, required this.personalId});

  @override
  VerIncidenciasScreenState createState() => VerIncidenciasScreenState();
}

class VerIncidenciasScreenState extends State<VerIncidenciasScreen> {
  String? selectedCategoria;
  String? selectedPrioridad;
  String? selectedEstado;
  DateTime? selectedFecha;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    await Provider.of<IncidenciaController>(context, listen: false)
        .fetchIncidenciasPorPersonal(widget.personalId);
    await Provider.of<IncidenciaController>(context, listen: false)
        .fetchCategorias();
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  void _showFilterDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) {
        String? tempSelectedCategoria = selectedCategoria;
        String? tempSelectedPrioridad = selectedPrioridad;
        String? tempSelectedEstado = selectedEstado;
        DateTime? tempSelectedFecha = selectedFecha;

        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('Filtrar Incidencias',
                  style: TextStyle(color: Colors.blue)),
              IconButton(
                icon: const Icon(Icons.close, color: Colors.blue),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text('Categoría'),
                        value: tempSelectedCategoria,
                        onChanged: (value) {
                          setState(() {
                            tempSelectedCategoria = value;
                          });
                        },
                        items: Provider.of<IncidenciaController>(context)
                            .categorias
                            .values
                            .map((categoria) {
                          return DropdownMenuItem(
                            value: categoria,
                            child: Text(categoria),
                          );
                        }).toList(),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text('Prioridad'),
                        value: tempSelectedPrioridad,
                        onChanged: (value) {
                          setState(() {
                            tempSelectedPrioridad = value;
                          });
                        },
                        items: ['Baja', 'Media', 'Alta'].map((prioridad) {
                          return DropdownMenuItem(
                            value: prioridad,
                            child: Text(prioridad),
                          );
                        }).toList(),
                      ),
                    ),
                    DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        hint: const Text('Estado'),
                        value: tempSelectedEstado,
                        onChanged: (value) {
                          setState(() {
                            tempSelectedEstado = value;
                          });
                        },
                        items: ['pendiente', 'cerrada'].map((estado) {
                          return DropdownMenuItem(
                            value: estado,
                            child: Text(estado),
                          );
                        }).toList(),
                      ),
                    ),
                    TextButton(
                      onPressed: () async {
                        final pickedDate = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2101),
                          builder: (BuildContext context, Widget? child) {
                            return Theme(
                              data: Theme.of(context).copyWith(
                                colorScheme: const ColorScheme.light(
                                  primary:
                                      Colors.blue, // header background color
                                  onPrimary: Colors.white, // header text color
                                  onSurface: Colors.blue, // body text color
                                ),
                                textButtonTheme: TextButtonThemeData(
                                  style: TextButton.styleFrom(
                                    foregroundColor:
                                        Colors.blue, // button text color
                                  ),
                                ),
                              ),
                              child: child!,
                            );
                          },
                        );
                        if (pickedDate != null &&
                            pickedDate != tempSelectedFecha) {
                          setState(() {
                            tempSelectedFecha = pickedDate;
                          });
                        }
                      },
                      child: Text(
                        tempSelectedFecha == null
                            ? 'Fecha'
                            : 'Fecha: ${DateFormat('yyyy-MM-dd').format(tempSelectedFecha!)}',
                        style: const TextStyle(color: Colors.blue),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategoria = null;
                      selectedPrioridad = null;
                      selectedEstado = null;
                      selectedFecha = null;
                    });
                    Navigator.of(context).pop();
                    Provider.of<IncidenciaController>(context, listen: false)
                        .resetFiltros();
                  },
                  child: const Text('Quitar Filtros',
                      style: TextStyle(color: Colors.blue)),
                ),
                TextButton(
                  onPressed: () {
                    setState(() {
                      selectedCategoria = tempSelectedCategoria;
                      selectedPrioridad = tempSelectedPrioridad;
                      selectedEstado = tempSelectedEstado;
                      selectedFecha = tempSelectedFecha;
                    });
                    Navigator.of(context).pop();
                    Provider.of<IncidenciaController>(context, listen: false)
                        .filtrarIncidencias(selectedCategoria,
                            selectedPrioridad, selectedEstado, selectedFecha);
                  },
                  child: const Text('Aplicar Filtros',
                      style: TextStyle(color: Colors.blue)),
                ),
              ],
            ),
          ],
        );
      },
    );
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
            icon: const Icon(
              Icons.filter_list,
              color: Colors.white,
            ),
            onPressed: () => _showFilterDialog(context),
          ),
        ],
      ),
      drawer: CustomDrawer(
        onLogout: () => _logout(context),
      ),
      body: Consumer<IncidenciaController>(
        builder: (context, controller, child) {
          if (controller.incidenciasFiltradas.isEmpty) {
            return const Center(
              child: Text("No hay incidencias que coincidan con los filtros."),
            );
          } else {
            return ListView.builder(
              padding: const EdgeInsets.all(8.0),
              itemCount: controller.incidenciasFiltradas.length,
              itemBuilder: (context, index) {
                Incidencia incidencia = controller.incidenciasFiltradas[index];
                return GestureDetector(
                  onTap: () async {
                    bool? updated = await Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatIncidenciaPersonalScreen(
                          incidencia: incidencia,
                        ),
                      ),
                    );

                    if (updated == true) {
                      await Provider.of<IncidenciaController>(context,
                              listen: false)
                          .fetchIncidenciasPorPersonal(widget.personalId);
                    }
                  },
                  child: IncidenciaItemPersonal(
                    incidencia: incidencia,
                    categorias: controller.categorias,
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

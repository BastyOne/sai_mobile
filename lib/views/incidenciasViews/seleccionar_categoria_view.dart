import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/incidencia_controller.dart';
import 'base_incidencias_view.dart';
import '../../services/shared_preferences.dart';

class SeleccionarCategoriaPadreScreen extends StatefulWidget {
  final int userId;

  const SeleccionarCategoriaPadreScreen({required this.userId});

  @override
  _SeleccionarCategoriaPadreScreenState createState() =>
      _SeleccionarCategoriaPadreScreenState();
}

class _SeleccionarCategoriaPadreScreenState
    extends State<SeleccionarCategoriaPadreScreen> {
  int? _selectedCategoriaPadre;

  final Map<String, IconData> iconosCategorias = {
    'Sistemas UCM': Icons.computer,
    'Personal': Icons.person,
    'Académica': Icons.school,
    'Toma de Ramos': Icons.assignment,
    'Unidad': Icons.domain,
    'Tramites': Icons.description,
  };

  @override
  Widget build(BuildContext context) {
    final incidenciaController = Provider.of<IncidenciaController>(context);

    return BaseScreen(
      title: 'Seleccion de Incidencia',
      step: 1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<List<Map<String, dynamic>>>(
            future: incidenciaController.fetchCategoriasPadre(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return const Center(
                    child: Text('No hay categorías disponibles'));
              } else {
                return Column(
                  children: [
                    Wrap(
                      spacing: 16.0,
                      runSpacing: 16.0,
                      children: snapshot.data!.map((categoria) {
                        final isSelected =
                            _selectedCategoriaPadre == categoria['id'];
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedCategoriaPadre = categoria['id'];
                            });
                          },
                          child: Container(
                            width: 150,
                            height: 150,
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF2196F3)
                                  : Colors.white,
                              borderRadius: BorderRadius.circular(8.0),
                              border:
                                  Border.all(color: const Color(0xFF2196F3)),
                            ),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  iconosCategorias[categoria['nombre']] ??
                                      Icons.category,
                                  color: isSelected
                                      ? Colors.white
                                      : const Color(0xFF2196F3),
                                  size: 40,
                                ),
                                const SizedBox(height: 8),
                                Text(
                                  categoria['nombre'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF2196F3),
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],
                );
              }
            },
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SizedBox(
          width: double.infinity,
          height: 40,
          child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF2196F3),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onPressed: _selectedCategoriaPadre == null
                ? null
                : () {
                    incidenciaController.selectedCategoriaPadre =
                        _selectedCategoriaPadre;
                    Navigator.pushNamed(
                      context,
                      '/seleccionarCategoriaHijo',
                      arguments: {'userId': widget.userId},
                    );
                  },
            child: const Text(
              'SIGUIENTE',
              style: TextStyle(color: Colors.white),
            ),
          ),
        ),
      ),
      onLogout: () async {
        await SharedPreferencesService.removeToken();
        Navigator.pushReplacementNamed(context, '/');
      },
    );
  }
}

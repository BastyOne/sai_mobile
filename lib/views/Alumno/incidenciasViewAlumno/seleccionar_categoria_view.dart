import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/incidencia_controller.dart';
import 'base_incidencias_view.dart';
import '../../../services/shared_preferences.dart';

class SeleccionarCategoriaPadreScreen extends StatefulWidget {
  final int userId;
  final int carreraId;

  const SeleccionarCategoriaPadreScreen(
      {super.key, required this.userId, required this.carreraId});

  @override
  SeleccionarCategoriaPadreScreenState createState() =>
      SeleccionarCategoriaPadreScreenState();
}

class SeleccionarCategoriaPadreScreenState
    extends State<SeleccionarCategoriaPadreScreen> {
  int? _selectedCategoriaPadre;
  List<Map<String, dynamic>>? _categoriasPadre;

  final Map<String, IconData> iconosCategorias = {
    'Sistemas UCM': Icons.computer,
    'Personal': Icons.person,
    'Académica': Icons.school,
    'Toma de Ramos': Icons.assignment,
    'Unidad': Icons.domain,
    'Tramites': Icons.description,
  };

  @override
  void initState() {
    super.initState();
    _loadCategoriasPadre();
  }

  void _loadCategoriasPadre() async {
    final incidenciaController =
        Provider.of<IncidenciaController>(context, listen: false);
    final categorias = await incidenciaController.fetchCategoriasPadre();
    setState(() {
      _categoriasPadre = categorias;
    });
  }

  @override
  Widget build(BuildContext context) {
    return BaseScreen(
      title: 'Seleccion de Incidencia',
      step: 1,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: _categoriasPadre == null
              ? const Center(child: CircularProgressIndicator())
              : _categoriasPadre!.isEmpty
                  ? const Center(child: Text('No hay categorías disponibles'))
                  : Column(
                      children: [
                        Wrap(
                          spacing: 16.0,
                          runSpacing: 16.0,
                          children: _categoriasPadre!.map((categoria) {
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
                                  border: Border.all(
                                      color: const Color(0xFF2196F3)),
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
                    final incidenciaController =
                        Provider.of<IncidenciaController>(context,
                            listen: false);
                    incidenciaController.selectedCategoriaPadre =
                        _selectedCategoriaPadre;
                    Navigator.pushNamed(
                      context,
                      '/seleccionarCategoriaHijo',
                      arguments: {
                        'userId': widget.userId,
                        'carreraId': widget.carreraId
                      },
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

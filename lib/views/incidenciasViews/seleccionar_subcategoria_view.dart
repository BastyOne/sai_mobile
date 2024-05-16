import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../controllers/incidencia_controller.dart';
import 'base_incidencias_view.dart';
import '../../services/shared_preferences.dart';

class SeleccionarCategoriaHijoScreen extends StatefulWidget {
  final int userId;

  const SeleccionarCategoriaHijoScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _SeleccionarCategoriaHijoScreenState createState() =>
      _SeleccionarCategoriaHijoScreenState();
}

class _SeleccionarCategoriaHijoScreenState
    extends State<SeleccionarCategoriaHijoScreen> {
  int? _selectedPersonal;
  int? _selectedCategoriaHijo;
  String? _selectedPrioridad;

  @override
  Widget build(BuildContext context) {
    final incidenciaController = Provider.of<IncidenciaController>(context);
    const double buttonWidth = 100; // Ancho de los botones de prioridad

    return BaseScreen(
      title: 'Especifique su incidencia',
      step: 2,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "¿Quién crees que puede resolver de mejor manera tu problemática?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Center(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: incidenciaController.fetchPersonal(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Wrap(
                        spacing: 16.0,
                        runSpacing: 16.0,
                        children: snapshot.data!.map((personal) {
                          final isSelected =
                              _selectedPersonal == personal['id'];
                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedPersonal = personal['id'];
                              });
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? const Color(0xFF2196F3)
                                    : Colors.white,
                                borderRadius: BorderRadius.circular(8.0),
                                border:
                                    Border.all(color: const Color(0xFF2196F3)),
                              ),
                              child: Center(
                                child: Text(
                                  personal['nombre'],
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    color: isSelected
                                        ? Colors.white
                                        : const Color(0xFF2196F3),
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "Especificanos más sobre que trata tu problemática",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Center(
                child: FutureBuilder<List<Map<String, dynamic>>>(
                  future: incidenciaController.fetchCategoriasHijo(
                      incidenciaController.selectedCategoriaPadre!),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return Container(
                        width: buttonWidth * 3 +
                            32, // Ancho fijo basado en los botones de prioridad
                        padding: const EdgeInsets.symmetric(
                            horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          border: Border.all(color: const Color(0xFF2196F3)),
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<int>(
                            isExpanded: true,
                            hint: const Text('Seleccione una subcategoria'),
                            value: _selectedCategoriaHijo,
                            items: snapshot.data!.map((categoria) {
                              return DropdownMenuItem<int>(
                                value: categoria['id'],
                                child: Text(categoria['nombre']),
                              );
                            }).toList(),
                            onChanged: (value) {
                              setState(() {
                                _selectedCategoriaHijo = value;
                              });
                            },
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              const SizedBox(height: 32),
              Text(
                "¿Qué prioridad le darías a tu problemática?",
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 16),
              Center(
                child: Wrap(
                  spacing: 16.0,
                  runSpacing: 16.0,
                  children: ['Alta', 'Media', 'Baja'].map((prioridad) {
                    final isSelected = _selectedPrioridad == prioridad;
                    return GestureDetector(
                      onTap: () {
                        setState(() {
                          _selectedPrioridad = prioridad;
                        });
                      },
                      child: Container(
                        width: buttonWidth,
                        height: 50,
                        decoration: BoxDecoration(
                          color: isSelected
                              ? const Color(0xFF2196F3)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(8.0),
                          border: Border.all(color: const Color(0xFF2196F3)),
                        ),
                        child: Center(
                          child: Text(
                            prioridad,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: isSelected
                                  ? Colors.white
                                  : const Color(0xFF2196F3),
                              fontSize: 16,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 80),
              const SizedBox(
                  height: 32), // Espacio adicional antes de los botones
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.grey,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text(
                  'ATRAS',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
            SizedBox(
              width: 120,
              height: 40,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF2196F3),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                onPressed: () {
                  incidenciaController.selectedCategoriaHijo =
                      _selectedCategoriaHijo;
                  incidenciaController.selectedPersonal = _selectedPersonal;
                  incidenciaController.prioridad = _selectedPrioridad;
                  Navigator.pushNamed(
                    context,
                    '/agregarDescripcion',
                    arguments: {'userId': widget.userId},
                  );
                },
                child: const Text(
                  'SIGUIENTE',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
      onLogout: () async {
        await SharedPreferencesService.removeToken();
        Navigator.pushReplacementNamed(context, '/');
      },
    );
  }
}

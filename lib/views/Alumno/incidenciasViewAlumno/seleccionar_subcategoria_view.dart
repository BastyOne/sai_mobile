import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../controllers/incidencia_controller.dart';
import 'base_incidencias_view.dart';
import '../../../services/shared_preferences.dart';

class SeleccionarCategoriaHijoScreen extends StatefulWidget {
  final int userId;
  final int carreraId; // Añadir este campo

  const SeleccionarCategoriaHijoScreen(
      {super.key, required this.userId, required this.carreraId});

  @override
  SeleccionarCategoriaHijoScreenState createState() =>
      SeleccionarCategoriaHijoScreenState();
}

class SeleccionarCategoriaHijoScreenState
    extends State<SeleccionarCategoriaHijoScreen> {
  int? _selectedPersonal;
  int? _selectedCategoriaHijo;
  String? _selectedPrioridad;

  @override
  Widget build(BuildContext context) {
    final incidenciaController = Provider.of<IncidenciaController>(context);
    const double buttonWidth = 100;

    return BaseScreen(
      title: 'Especifique su incidencia',
      step: 2,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              _buildQuestionText(context,
                  "¿Quién crees que puede resolver de mejor manera tu problemática?"),
              const SizedBox(height: 16),
              Center(child: _buildPersonalSelector(incidenciaController)),
              const SizedBox(height: 32),
              _buildQuestionText(
                  context, "Especificanos más sobre que trata tu problemática"),
              const SizedBox(height: 16),
              Center(child: _buildCategorySelector(incidenciaController)),
              const SizedBox(height: 32),
              _buildQuestionText(
                  context, "¿Qué prioridad le darías a tu problemática?"),
              const SizedBox(height: 16),
              Center(child: _buildPrioritySelector(buttonWidth)),
              const SizedBox(height: 80),
              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _buildBackButton(context),
            _buildNextButton(incidenciaController, context),
          ],
        ),
      ),
      onLogout: () async {
        await SharedPreferencesService.removeToken();
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/login', (Route<dynamic> route) => false);
      },
    );
  }

  Widget _buildQuestionText(BuildContext context, String text) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: Theme.of(context).textTheme.bodyLarge,
    );
  }

  Widget _buildPersonalSelector(IncidenciaController controller) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future: controller.fetchPersonal(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No personal found');
        } else {
          final personalList = snapshot.data!
              .where((personal) => personal['carrera_id'] == widget.carreraId)
              .toList();
          return Wrap(
            spacing: 16.0,
            runSpacing: 16.0,
            children: personalList.map((personal) {
              final isSelected = _selectedPersonal == personal['id'];
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
                    color: isSelected ? const Color(0xFF2196F3) : Colors.white,
                    borderRadius: BorderRadius.circular(8.0),
                    border: Border.all(color: const Color(0xFF2196F3)),
                  ),
                  child: Center(
                    child: Text(
                      personal['tipopersona']['nombre'],
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color:
                            isSelected ? Colors.white : const Color(0xFF2196F3),
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
    );
  }

  Widget _buildCategorySelector(IncidenciaController controller) {
    return FutureBuilder<List<Map<String, dynamic>>>(
      future:
          controller.fetchCategoriasHijo(controller.selectedCategoriaPadre!),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        } else if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Text('No categories found');
        } else {
          final categoryList = snapshot.data!;
          return Container(
            width: 100 * 3 + 32,
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
            decoration: BoxDecoration(
              border: Border.all(color: const Color(0xFF2196F3)),
              borderRadius: BorderRadius.circular(8.0),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<int>(
                isExpanded: true,
                hint: const Text('Seleccione una subcategoria'),
                value: _selectedCategoriaHijo,
                items: categoryList.map((categoria) {
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
    );
  }

  Widget _buildPrioritySelector(double buttonWidth) {
    return Wrap(
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
              color: isSelected ? const Color(0xFF2196F3) : Colors.white,
              borderRadius: BorderRadius.circular(8.0),
              border: Border.all(color: const Color(0xFF2196F3)),
            ),
            child: Center(
              child: Text(
                prioridad,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: isSelected ? Colors.white : const Color(0xFF2196F3),
                  fontSize: 16,
                ),
              ),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildBackButton(BuildContext context) {
    return SizedBox(
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
    );
  }

  Widget _buildNextButton(
      IncidenciaController controller, BuildContext context) {
    return SizedBox(
      width: 120,
      height: 40,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF2196F3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
        ),
        onPressed: _selectedPersonal != null &&
                _selectedCategoriaHijo != null &&
                _selectedPrioridad != null
            ? () {
                controller.selectedCategoriaHijo = _selectedCategoriaHijo;
                controller.selectedPersonal = _selectedPersonal;
                controller.prioridad = _selectedPrioridad;
                Navigator.pushNamed(
                  context,
                  '/agregarDescripcion',
                  arguments: {
                    'userId': widget.userId,
                    'carreraId': widget.carreraId
                  },
                );
              }
            : null,
        child: const Text(
          'SIGUIENTE',
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../controllers/incidencia_controller.dart';
import 'base_incidencias_view.dart';
import '../../services/shared_preferences.dart';

class AgregarDescripcionScreen extends StatefulWidget {
  final int userId;

  const AgregarDescripcionScreen({Key? key, required this.userId})
      : super(key: key);

  @override
  _AgregarDescripcionScreenState createState() =>
      _AgregarDescripcionScreenState();
}

class _AgregarDescripcionScreenState extends State<AgregarDescripcionScreen> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final incidenciaController = Provider.of<IncidenciaController>(context);

    return BaseScreen(
      title: 'Agregar Descripción',
      step: 3,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Describe tu problemática",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                  decoration: BoxDecoration(
                    border: Border.all(color: const Color(0xFF2196F3)),
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      hintText: 'Descripción',
                      border: InputBorder.none,
                    ),
                    maxLines: 5,
                    onChanged: (value) {
                      incidenciaController.descripcion = value;
                    },
                  ),
                ),
                const SizedBox(height: 32),
                Text(
                  "Archivos",
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2196F3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                  ),
                  onPressed: () async {
                    final picker = ImagePicker();
                    final pickedFile =
                        await picker.pickImage(source: ImageSource.gallery);
                    if (pickedFile != null) {
                      setState(() {
                        incidenciaController.archivo = File(pickedFile.path);
                      });
                    }
                  },
                  child: const Text('Seleccionar Archivo',
                      style: TextStyle(color: Colors.white)),
                ),
                if (incidenciaController.archivo != null)
                  Container(
                    padding: const EdgeInsets.all(12.0),
                    margin: const EdgeInsets.only(top: 16.0),
                    decoration: BoxDecoration(
                      border: Border.all(color: const Color(0xFF2196F3)),
                      borderRadius: BorderRadius.circular(8.0),
                    ),
                    child: Text(
                      'Archivo seleccionado: ${incidenciaController.archivo!.path.split('/').last}',
                      style: const TextStyle(color: Colors.grey),
                    ),
                  ),
                const SizedBox(height: 160),
                const SizedBox(
                    height: 32), // Espacio adicional antes de los botones
              ],
            ),
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
                  if (_formKey.currentState!.validate()) {
                    incidenciaController
                        .submitIncidencia(widget.userId)
                        .then((_) {
                      _showConfirmationDialog(context);
                    }).catchError((error) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('Error: $error')),
                      );
                    });
                  }
                },
                child: const Text(
                  'ENVIAR',
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

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Incidencia Ingresada',
              style: TextStyle(color: Colors.blue)),
          content: const Text('La incidencia ha sido ingresada con éxito.'),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Aceptar', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                setState(() {
                  Provider.of<IncidenciaController>(context, listen: false)
                      .archivo = null;
                });
                Navigator.popUntil(
                    context, ModalRoute.withName('/ingresarIncidencia'));
              },
            ),
          ],
        );
      },
    );
  }
}

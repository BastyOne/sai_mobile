import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/alumnos_controller.dart';

class AddAlumnoScreen extends StatefulWidget {
  const AddAlumnoScreen({super.key});

  @override
  AddAlumnoScreenState createState() => AddAlumnoScreenState();
}

class AddAlumnoScreenState extends State<AddAlumnoScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nivelController = TextEditingController();
  final _rutController = TextEditingController();
  final _nombreController = TextEditingController();
  final _apellidoController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _celularController = TextEditingController();
  final _contactoEmergenciaController = TextEditingController();
  final _ciudadActualController = TextEditingController();
  final _ciudadProcedenciaController = TextEditingController();
  File? _archivo;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _nivelController.dispose();
    _rutController.dispose();
    _nombreController.dispose();
    _apellidoController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _celularController.dispose();
    _contactoEmergenciaController.dispose();
    _ciudadActualController.dispose();
    _ciudadProcedenciaController.dispose();
    super.dispose();
  }

  void _pickImage() async {
    final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _archivo = File(pickedFile.path);
      });
    }
  }

  void _agregarAlumno() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final alumnosController =
          Provider.of<AlumnosController>(context, listen: false);
      await alumnosController.agregarAlumno(
        nivel: _nivelController.text,
        rut: _rutController.text,
        nombre: _nombreController.text,
        apellido: _apellidoController.text,
        email: _emailController.text,
        password: _passwordController.text,
        activo: true,
        celular: _celularController.text,
        contactoEmergencia: _contactoEmergenciaController.text,
        categoriaAlumnoId: 1,
        ciudadActual: _ciudadActualController.text,
        ciudadProcedencia: _ciudadProcedenciaController.text,
        suspensionRangoFecha: null,
        rolId: 1,
        carreraId: 2,
        archivo: _archivo,
      );

      setState(() {
        _isLoading = false;
      });

      Navigator.pop(context, true); // Pass true to indicate success
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.close, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _agregarAlumno,
            child: const Text(
              'Agregar',
              style: TextStyle(
                color: Color(0xFF021B79),
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              TextFormField(
                controller: _nivelController,
                decoration: const InputDecoration(
                  labelText: 'Nivel',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nivel';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _rutController,
                decoration: const InputDecoration(
                  labelText: 'RUT',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el RUT';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _nombreController,
                decoration: const InputDecoration(
                  labelText: 'Nombre',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el nombre';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _apellidoController,
                decoration: const InputDecoration(
                  labelText: 'Apellido',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el apellido';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _emailController,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el email';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _passwordController,
                decoration: const InputDecoration(
                  labelText: 'Contraseña',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                obscureText: true,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la contraseña';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _celularController,
                decoration: const InputDecoration(
                  labelText: 'Celular',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el celular';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contactoEmergenciaController,
                decoration: const InputDecoration(
                  labelText: 'Contacto de Emergencia',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa el contacto de emergencia';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ciudadActualController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad Actual',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la ciudad actual';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _ciudadProcedenciaController,
                decoration: const InputDecoration(
                  labelText: 'Ciudad de Procedencia',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: UnderlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa la ciudad de procedencia';
                  }
                  return null;
                },
              ),
              if (_archivo != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    _archivo!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const Spacer(),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.image, color: Color(0xFF021B79)),
                    onPressed: _pickImage,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../../../controllers/foro_controller.dart';
import '../../../services/shared_preferences.dart';

class AgregarPostScreen extends StatefulWidget {
  const AgregarPostScreen({super.key});

  @override
  AgregarPostScreenState createState() => AgregarPostScreenState();
}

class AgregarPostScreenState extends State<AgregarPostScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _preguntaController = TextEditingController();
  final TextEditingController _contenidoController = TextEditingController();
  File? _selectedImage;
  String? archivoPath;
  int? userId;
  bool esAnonimo = false; // Añadir este campo

  @override
  void initState() {
    super.initState();
    _loadUserId();
  }

  Future<void> _loadUserId() async {
    userId = await SharedPreferencesService.getUserId();
    if (userId == null) {
      // Maneja el caso en que el userId no esté disponible
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
        archivoPath = pickedFile.path;
      });
    }
  }

  void _submitPost(BuildContext context) async {
    final foroController = Provider.of<ForoController>(context, listen: false);
    if (_formKey.currentState!.validate() && userId != null) {
      await foroController.createPost(
        userId!, // Utilizar el userId obtenido de SharedPreferences
        _preguntaController.text,
        _contenidoController.text,
        esAnonimo, // Añadir este campo
        archivoPath,
      );
      Navigator.pop(context);
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
            onPressed: () => _submitPost(context),
            child: const Text(
              'Post',
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _preguntaController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Pregunta',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una pregunta';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contenidoController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Contenido (opcional)',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  border: InputBorder.none,
                ),
                maxLines: null,
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Publicar como anónimo',
                        style: TextStyle(color: Colors.black, fontSize: 16),
                      ),
                    ),
                    Checkbox(
                      value: esAnonimo,
                      onChanged: (bool? value) {
                        setState(() {
                          esAnonimo = value!;
                        });
                      },
                      activeColor: const Color(0xFF021B79), // Color del tick
                    ),
                  ],
                ),
              ),
              if (_selectedImage != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    _selectedImage!,
                    width: 100,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
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

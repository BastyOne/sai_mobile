import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/mensaje_diario_controller.dart';

class AgregarMensajeDiarioScreen extends StatefulWidget {
  const AgregarMensajeDiarioScreen({super.key});

  @override
  AgregarMensajeDiarioScreenState createState() =>
      AgregarMensajeDiarioScreenState();
}

class AgregarMensajeDiarioScreenState
    extends State<AgregarMensajeDiarioScreen> {
  final _formKey = GlobalKey<FormState>();
  final _mensajeController = TextEditingController();
  final _contextoController = TextEditingController();
  File? _archivo;
  bool _isLoading = false;

  final ImagePicker _picker = ImagePicker();

  @override
  void dispose() {
    _mensajeController.dispose();
    _contextoController.dispose();
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

  void _agregarMensajeDiario() async {
    if (_formKey.currentState?.validate() ?? false) {
      setState(() {
        _isLoading = true;
      });

      final mensajeDiarioController =
          Provider.of<MensajeDiarioController>(context, listen: false);
      await mensajeDiarioController.agregarMensajeDiario(
        _mensajeController.text,
        _contextoController.text,
        _archivo,
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
            onPressed: _isLoading ? null : () => _agregarMensajeDiario(),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              TextFormField(
                controller: _mensajeController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Mensaje',
                  labelStyle: TextStyle(color: Colors.black, fontSize: 20),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un mensaje';
                  }
                  return null;
                },
              ),
              TextFormField(
                controller: _contextoController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Contexto',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  border: InputBorder.none,
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa un contexto';
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

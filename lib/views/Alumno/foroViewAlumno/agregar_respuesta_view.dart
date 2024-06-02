import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../controllers/foro_controller.dart';
import '../../../services/shared_preferences.dart';

class AgregarRespuestaScreen extends StatefulWidget {
  final int postId;

  const AgregarRespuestaScreen({required this.postId, super.key});

  @override
  AgregarRespuestaScreenState createState() => AgregarRespuestaScreenState();
}

class AgregarRespuestaScreenState extends State<AgregarRespuestaScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _respuestaController = TextEditingController();
  String? archivoPath;

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        archivoPath = pickedFile.path;
      });
    }
  }

  void _submitResponse(BuildContext context) async {
    final foroController = Provider.of<ForoController>(context, listen: false);
    if (_formKey.currentState!.validate()) {
      int? autorId = await SharedPreferencesService.getUserId();
      if (autorId == null) {
        return;
      }
      await foroController.createReply(
        widget.postId,
        autorId,
        _respuestaController.text,
        archivoPath,
      );
      Navigator.pop(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    final foroController = Provider.of<ForoController>(context);
    final post =
        foroController.posts.firstWhere((post) => post.id == widget.postId);

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
        title: const Text(
          'Agregar respuesta',
          style: TextStyle(
            color: Colors.black,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => _submitResponse(context),
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
              Text(
                post.pregunta,
                style: const TextStyle(
                  color: Colors.black,
                  fontSize: 18,
                ),
              ),
              const SizedBox(height: 10),
              TextFormField(
                controller: _respuestaController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  hintText: 'Tu respuesta...',
                  hintStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  border: InputBorder.none,
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una respuesta';
                  }
                  return null;
                },
                maxLines: null,
              ),
              if (archivoPath != null)
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Image.file(
                    File(archivoPath!),
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

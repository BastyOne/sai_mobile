import 'package:flutter/material.dart';
import 'package:sai_mobile/controllers/faq_controller.dart';
import '../../../../models/faq.dart';

class FAQFormScreen extends StatefulWidget {
  final FAQ? faq;
  final PreguntasFrecuentesController controller;

  const FAQFormScreen({super.key, this.faq, required this.controller});

  @override
  FAQFormScreenState createState() => FAQFormScreenState();
}

class FAQFormScreenState extends State<FAQFormScreen> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _preguntaController;
  late TextEditingController _respuestaController;
  late int _categoriaFaqId;

  final List<int> _categories = [
    1,
    2,
    3,
    4,
  ]; // IDs de categorías de ejemplo
  final Map<int, String> _categoryNames = {
    1: 'Beneficios Estudiantiles',
    2: 'Actividades Extraprogramáticas',
    3: 'Trámites Secretaría',
    4: 'Problemas Plataforma',
  };

  @override
  void initState() {
    super.initState();
    _preguntaController =
        TextEditingController(text: widget.faq?.pregunta ?? '');
    _respuestaController =
        TextEditingController(text: widget.faq?.respuesta ?? '');
    _categoriaFaqId = widget.faq?.categoriaFaqId ?? 1;
  }

  @override
  void dispose() {
    _preguntaController.dispose();
    _respuestaController.dispose();
    super.dispose();
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
            onPressed: () {
              if (_formKey.currentState?.validate() ?? false) {
                final faq = FAQ(
                  id: widget.faq?.id ?? 0,
                  categoriaFaqId: _categoriaFaqId,
                  pregunta: _preguntaController.text,
                  respuesta: _respuestaController.text,
                  activo: true, // Always active
                  fechaCreacion: DateTime.now().toString(),
                );
                if (widget.faq == null) {
                  _addFAQ(context, faq);
                } else {
                  _updateFAQ(context, faq);
                }
              }
            },
            child: Text(
              widget.faq == null ? 'Agregar' : 'Actualizar',
              style: const TextStyle(
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
                controller: _respuestaController,
                style: const TextStyle(color: Colors.black),
                decoration: const InputDecoration(
                  labelText: 'Respuesta',
                  labelStyle: TextStyle(color: Colors.grey, fontSize: 16),
                  border: InputBorder.none,
                ),
                maxLines: null,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor ingresa una respuesta';
                  }
                  return null;
                },
              ),
              DropdownButtonFormField<int>(
                value: _categoriaFaqId,
                decoration: const InputDecoration(
                  labelText: 'Categoría',
                  labelStyle: TextStyle(
                    color: Color(0xFF021B79),
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF021B79),
                      width: 2,
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF021B79),
                      width: 2,
                    ),
                  ),
                ),
                items: _categories.map((int categoryId) {
                  return DropdownMenuItem<int>(
                    value: categoryId,
                    child: Text(_categoryNames[categoryId]!),
                  );
                }).toList(),
                onChanged: (value) {
                  setState(() {
                    _categoriaFaqId = value!;
                  });
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _addFAQ(BuildContext context, FAQ faq) async {
    await widget.controller.addFAQ(faq);
    Navigator.pop(context);
  }

  void _updateFAQ(BuildContext context, FAQ faq) async {
    await widget.controller.updateFAQ(faq.id, faq);
    Navigator.pop(context);
  }
}

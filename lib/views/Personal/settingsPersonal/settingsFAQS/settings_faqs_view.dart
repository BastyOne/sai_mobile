import 'package:flutter/material.dart';
import '../../../../controllers/faq_controller.dart';
import '../../../../models/faq.dart';
import '../../../../services/shared_preferences.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_drawer.dart';
import 'settings_add_faqs_view.dart';

class AdminPreguntasFrecuentesScreen extends StatefulWidget {
  const AdminPreguntasFrecuentesScreen({super.key});

  @override
  AdminPreguntasFrecuentesScreenState createState() =>
      AdminPreguntasFrecuentesScreenState();
}

class AdminPreguntasFrecuentesScreenState
    extends State<AdminPreguntasFrecuentesScreen>
    with TickerProviderStateMixin {
  late PreguntasFrecuentesController _controller;
  int _selectedCategoryId = 0; // Usar 0 para representar "todas las categorías"
  final List<int> _categories = [
    0,
    1,
    2,
    3,
    4
  ]; // IDs de categorías de ejemplo, incluyendo "todas las categorías"
  final Map<int, String> _categoryNames = {
    0: 'Todas las Categorías',
    1: 'Beneficios Estudiantiles',
    2: 'Actividades Extraprogramáticas',
    3: 'Trámites Secretaría',
    4: 'Problemas Plataforma',
  };
  String _searchQuery = '';

  @override
  void initState() {
    super.initState();
    _controller = PreguntasFrecuentesController(
      this,
      _categories,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Image.network(
          'https://portalalumnos.ucm.cl/v2/assets/img/logo_ucm_white.png',
          width: 160,
        ),
      ),
      drawer: CustomDrawer(
        onLogout: () => _logout(context),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                PopupMenuButton<String>(
                  icon: const Icon(Icons.filter_list),
                  onSelected: (value) {
                    if (value == 'categoría') {
                      _showCategoryDialog();
                    } else if (value == 'búsqueda') {
                      _showSearchDialog();
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'categoría',
                        child: Text('Categoría'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'búsqueda',
                        child: Text('Búsqueda por texto'),
                      ),
                    ];
                  },
                ),
                const SizedBox(width: 8),
                Text("Preguntas Frecuentes",
                    style: Theme.of(context).textTheme.headlineSmall),
              ],
            ),
          ),
          Expanded(
            child: faqList(),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _navigateToAddFAQ(context),
        backgroundColor: const Color(0xFF0575E6),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget faqList() {
    return FutureBuilder<List<FAQ>>(
      future: _controller.todasLasFaqs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          List<FAQ> filteredFaqs = snapshot.data!.where((faq) {
            bool matchesSearchQuery = _searchQuery.isEmpty ||
                faq.pregunta
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase()) ||
                faq.respuesta
                    .toLowerCase()
                    .contains(_searchQuery.toLowerCase());
            bool matchesCategory = _selectedCategoryId == 0 ||
                faq.categoriaFaqId == _selectedCategoryId;
            return matchesSearchQuery && matchesCategory;
          }).toList();
          return ListView(
            children: filteredFaqs.map((faq) {
              return ListTile(
                title: Text(
                  faq.pregunta,
                  overflow: TextOverflow.ellipsis,
                ),
                subtitle: Text(
                  faq.respuesta,
                  overflow: TextOverflow.ellipsis,
                ),
                trailing: PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'editar') {
                      _navigateToUpdateFAQ(context, faq);
                    } else if (value == 'eliminar') {
                      _deleteFAQ(faq);
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return [
                      const PopupMenuItem<String>(
                        value: 'editar',
                        child: Text('Editar'),
                      ),
                      const PopupMenuItem<String>(
                        value: 'eliminar',
                        child: Text('Eliminar'),
                      ),
                    ];
                  },
                ),
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text("No se encontraron FAQs."));
        }
      },
    );
  }

  Future<void> _showCategoryDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Seleccionar Categoría'),
          content: SingleChildScrollView(
            child: Column(
              children: _categories.map((categoryId) {
                return RadioListTile<int>(
                  title: Text(_categoryNames[categoryId]!),
                  value: categoryId,
                  groupValue: _selectedCategoryId,
                  onChanged: (value) {
                    setState(() {
                      _selectedCategoryId = value!;
                    });
                    Navigator.of(context).pop();
                  },
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  Future<void> _showSearchDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Buscar Preguntas Frecuentes'),
          content: TextField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: const InputDecoration(hintText: 'Buscar...'),
          ),
          actions: [
            TextButton(
              child: const Text('Cerrar'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

  Future<void> _navigateToAddFAQ(BuildContext context) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQFormScreen(
          controller: _controller,
        ),
      ),
    );
    setState(() {
      _controller = PreguntasFrecuentesController(
        this,
        _categories,
      );
    });
  }

  Future<void> _navigateToUpdateFAQ(BuildContext context, FAQ faq) async {
    await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FAQFormScreen(
          controller: _controller,
          faq: faq,
        ),
      ),
    );
    setState(() {
      _controller = PreguntasFrecuentesController(
        this,
        _categories,
      );
    });
  }

  Future<void> _deleteFAQ(FAQ faq) async {
    await _controller.deleteFAQ(faq.id);
    setState(() {
      _controller = PreguntasFrecuentesController(
        this,
        _categories,
      );
    });
  }
}

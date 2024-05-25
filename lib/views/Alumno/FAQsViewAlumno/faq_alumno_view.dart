import 'package:flutter/material.dart';
import '../../../controllers/faq_controller.dart';
import '../../../models/faq.dart';
import '../../../services/shared_preferences.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';

class PreguntasFrecuentesScreen extends StatefulWidget {
  const PreguntasFrecuentesScreen({super.key});

  @override
  PreguntasFrecuentesScreenState createState() =>
      PreguntasFrecuentesScreenState();
}

class PreguntasFrecuentesScreenState extends State<PreguntasFrecuentesScreen>
    with SingleTickerProviderStateMixin {
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
              return ExpansionTile(
                title: Text(faq.pregunta),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text(faq.respuesta),
                  )
                ],
              );
            }).toList(),
          );
        } else {
          return const Center(child: Text("No hay datos disponibles"));
        }
      },
    );
  }

  void _showCategoryDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Seleccionar Categoría',
              style: TextStyle(color: Colors.blue)),
          content: SingleChildScrollView(
            child: ListBody(
              children: _categories.map((id) {
                return Theme(
                  data: Theme.of(context).copyWith(
                    unselectedWidgetColor:
                        Colors.blue, // Color for the unselected state
                    radioTheme: RadioThemeData(
                      fillColor: MaterialStateProperty.all(
                          Colors.blue), // Color for the selected state
                    ),
                  ),
                  child: RadioListTile<int>(
                    title: Text(_categoryNames[id]!),
                    value: id,
                    groupValue: _selectedCategoryId,
                    onChanged: (int? value) {
                      if (value != null) {
                        setState(() {
                          _selectedCategoryId = value;
                          _searchQuery = ''; // Resetear la búsqueda por texto
                        });
                        Navigator.of(context).pop();
                      }
                    },
                  ),
                );
              }).toList(),
            ),
          ),
        );
      },
    );
  }

  void _showSearchDialog() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8.0),
          ),
          title: const Text('Buscar por texto',
              style: TextStyle(color: Colors.blue)),
          content: TextField(
            decoration: InputDecoration(
              hintText: 'Buscar...',
              prefixIcon: const Icon(Icons.search),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8.0),
              ),
            ),
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cerrar', style: TextStyle(color: Colors.blue)),
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
}

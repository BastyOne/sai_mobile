import 'package:flutter/material.dart';
import '../controllers/faq_controller.dart';
import '../models/faq.dart';
import '../services/shared_preferences.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/custom_drawer.dart';

class PreguntasFrecuentesScreen extends StatefulWidget {
  const PreguntasFrecuentesScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _PreguntasFrecuentesScreenState createState() =>
      _PreguntasFrecuentesScreenState();
}

class _PreguntasFrecuentesScreenState extends State<PreguntasFrecuentesScreen>
    with SingleTickerProviderStateMixin {
  late PreguntasFrecuentesController _controller;

  @override
  void initState() {
    super.initState();
    _controller =
        PreguntasFrecuentesController(this, beneficiosId: 1, actividadesId: 2);
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
            child: Text("Preguntas Frecuentes",
                style: Theme.of(context).textTheme.headlineSmall),
          ),
          TabBar(
            controller: _controller.tabController,
            labelColor: Colors.blue,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "Beneficios Estudiantiles"),
              Tab(text: "Actividades Extraprogramáticas"),
            ],
          ),
          Expanded(
            child: TabBarView(
              controller: _controller.tabController,
              children: [
                faqList(_controller.faqsBeneficios),
                faqList(_controller.faqsActividades),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget faqList(Future<List<FAQ>> faqs) {
    return FutureBuilder<List<FAQ>>(
      future: faqs,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error.toString()}"));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return ListView(
            children: snapshot.data!.map((faq) {
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

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
    print("Cierre de sesión solicitado y procesado.");
  }
}

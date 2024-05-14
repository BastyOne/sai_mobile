import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../services/shared_preferences.dart';
import '../widgets/custom_app_bar.dart';
import '../widgets/student_info_card.dart';
import '../widgets/custom_drawer.dart';
import '../models/alumno.dart';
import '../services/api_service.dart';

class HomeAlumnoView extends StatefulWidget {
  final int userId;

  const HomeAlumnoView({super.key, required this.userId});

  @override
  _HomeAlumnoViewState createState() => _HomeAlumnoViewState();
}

class _HomeAlumnoViewState extends State<HomeAlumnoView> {
  late Future<AlumnoInfo?> alumnoInfoFuture;
  final List<String> imgList = [
    'https://portalalumnos.ucm.cl/v2/assets/avisos/beca_fotocopias_2024.jpg',
    'https://portalalumnos.ucm.cl/v2/assets/avisos/lms_2024.png',
  ];
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    alumnoInfoFuture = ApiService().getAlumnoInfo(widget.userId);
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
    print("Cierre de sesión solicitado y procesado.");
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
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(top: 20.0),
            child: Stack(
              children: [
                CarouselSlider(
                  carouselController: _controller,
                  options: CarouselOptions(
                    autoPlay: true,
                    aspectRatio: 2.0,
                    enlargeCenterPage: true,
                  ),
                  items: imgList
                      .map((item) => Container(
                            child: Center(
                              child: Image.network(item,
                                  fit: BoxFit.cover, width: 1000),
                            ),
                          ))
                      .toList(),
                ),
                Positioned(
                  left: 15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_back_ios,
                          size: 30, color: Colors.black),
                      onPressed: () => _controller.previousPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                  ),
                ),
                Positioned(
                  right: 15,
                  top: 0,
                  bottom: 0,
                  child: Center(
                    child: IconButton(
                      icon: const Icon(Icons.arrow_forward_ios,
                          size: 30, color: Colors.black),
                      onPressed: () => _controller.nextPage(
                          duration: const Duration(milliseconds: 400),
                          curve: Curves.easeInOut),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<AlumnoInfo?>(
              future: alumnoInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      StudentInfoCard(alumno: snapshot.data!),
                      buttonSection(),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('No se encontró información del alumno.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buttonSection() {
    return Column(
      children: [
        customButton('Ingresar Incidencia', Icons.note, '#2196f3',
            '/ingresarIncidencia'),
        customButton('Ingresar Pregunta', Icons.question_answer, '#03A9F4',
            '/ingresarPregunta'),
        customButton('Preguntas Frecuentes', Icons.help, '#29B6F6',
            '/preguntasFrecuentes'),
        customButton(
            'Foro Estudiantil', Icons.edit, '#4FC3F7', '/foroEstudiantil'),
        customButton(
            'Portal de Pagos', Icons.payment, '#81D4FA', '/portalPagos'),
      ],
    );
  }

  Widget customButton(
      String text, IconData icon, String color, String routeName) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Color(int.parse(color.substring(1, 7), radix: 16) + 0xFF000000),
        minimumSize: const Size(double.infinity, 60), // sets minimum size
        padding: const EdgeInsets.symmetric(vertical: 10),
        shape: const RoundedRectangleBorder(
          // Hace que los bordes del botón sean rectos
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: () {
        Navigator.pushNamed(context, routeName);
      },
      child: Column(
        mainAxisSize: MainAxisSize.min, // Use min size that needed by child
        mainAxisAlignment:
            MainAxisAlignment.center, // Center children vertically
        children: <Widget>[
          Icon(icon, color: Colors.white), // Icon
          Text(text, style: const TextStyle(color: Colors.white)), // Text
        ],
      ),
    );
  }
}

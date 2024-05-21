import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import '../../models/mensaje_diario.dart';
import '../../services/shared_preferences.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';
import '../../widgets/personal_info_card.dart';
import '../../models/personal.dart';
import '../../services/api_service.dart';
import '../../controllers/mensaje_diario_controller.dart';
import 'package:provider/provider.dart';

class HomePersonalView extends StatefulWidget {
  final int userId;

  const HomePersonalView({super.key, required this.userId});

  @override
  _HomePersonalViewState createState() => _HomePersonalViewState();
}

class _HomePersonalViewState extends State<HomePersonalView> {
  late Future<PersonalInfo?> personalInfoFuture;
  final CarouselController _controller = CarouselController();

  @override
  void initState() {
    super.initState();
    personalInfoFuture = ApiService().getPersonalInfo(widget.userId);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<MensajeDiarioController>(context, listen: false)
          .fetchMensajesDiarios();
    });
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
            child: Consumer<MensajeDiarioController>(
              builder: (context, controller, child) {
                if (controller.isLoading) {
                  return const Center(child: CircularProgressIndicator());
                } else if (controller.errorMessage.isNotEmpty) {
                  return Center(
                      child: Text("Error: ${controller.errorMessage}"));
                } else {
                  return buildCarousel(controller.mensajesDiarios);
                }
              },
            ),
          ),
          Expanded(
            child: FutureBuilder<PersonalInfo?>(
              future: personalInfoFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text("Error: ${snapshot.error}"));
                } else if (snapshot.hasData) {
                  return ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: <Widget>[
                      PersonalInfoCard(personal: snapshot.data!),
                      buttonSection(),
                    ],
                  );
                } else {
                  return const Center(
                      child: Text('No se encontró información del personal.'));
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCarousel(List<MensajeDiario> mensajes) {
    final imgList = mensajes.expand((mensaje) => mensaje.imagenes).toList();
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
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
                    .map((item) => Center(
                          child: Image.network(item,
                              fit: BoxFit.cover, width: 1000),
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
      ],
    );
  }

  Widget buttonSection() {
    return Column(
      children: [
        customButton('Incidencias', Icons.note, '#2196f3', () {
          Navigator.pushNamed(context, '/incidenciasPersonal', arguments: {
            'userId': widget.userId,
          });
        }),
        customButton('Preguntas Frecuentes', Icons.help, '#29B6F6', () {
          Navigator.pushNamed(context, '/preguntasFrecuentes');
        }),
        customButton('Estadísticas', Icons.bar_chart, '#4FC3F7', () {
          Navigator.pushNamed(context, '/estadisticasPersonal');
        }),
      ],
    );
  }

  Widget customButton(
      String text, IconData icon, String color, VoidCallback onPressed) {
    return ElevatedButton(
      style: ElevatedButton.styleFrom(
        backgroundColor:
            Color(int.parse(color.substring(1, 7), radix: 16) + 0xFF000000),
        minimumSize:
            const Size(double.infinity, 80), // Aumenta el tamaño mínimo
        padding: const EdgeInsets.symmetric(
            vertical: 20), // Aumenta el padding vertical
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.zero,
        ),
      ),
      onPressed: onPressed,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Icon(icon,
              color: Colors.white, size: 32), // Aumenta el tamaño del ícono
          Text(text,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 18)), // Aumenta el tamaño del texto
        ],
      ),
    );
  }
}

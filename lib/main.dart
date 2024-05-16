import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'services/shared_preferences.dart';
import 'controllers/mensaje_diario_controller.dart';
import 'controllers/incidencia_controller.dart';
import 'views/faq_alumno_view.dart';
import 'views/foro_alumno_view.dart';
import 'views/login_view.dart';
import 'views/home_personal_view.dart';
import 'views/home_alumno_view.dart';
import 'views/preguntas_alumno_view.dart';
import 'views/incidenciasViews/seleccionar_categoria_view.dart';
import 'views/incidenciasViews/seleccionar_subcategoria_view.dart';
import 'views/incidenciasViews/agregar_descripcion_view.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MensajeDiarioController()),
        ChangeNotifierProvider(create: (_) => IncidenciaController()),
      ],
      child: MaterialApp(
        title: 'Mi App Incidencias',
        initialRoute: '/',
        routes: {
          '/': (context) => const LoginView(),
          '/home_personal': (context) => const HomePersonalView(),
          '/ingresarIncidencia': (context) {
            final args = ModalRoute.of(context)!.settings.arguments
                as Map<String, dynamic>;
            return SeleccionarCategoriaPadreScreen(userId: args['userId']);
          },
          '/ingresarPregunta': (context) => const IngresarPreguntaScreen(),
          '/preguntasFrecuentes': (context) =>
              const PreguntasFrecuentesScreen(),
          '/foroEstudiantil': (context) => const ForoEstudiantilScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/home_alumno') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return HomeAlumnoView(userId: args['userId']);
                },
              );
            }
          } else if (settings.name == '/seleccionarCategoriaHijo') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return SeleccionarCategoriaHijoScreen(userId: args['userId']);
                },
              );
            }
          } else if (settings.name == '/agregarDescripcion') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return AgregarDescripcionScreen(userId: args['userId']);
                },
              );
            }
          }
          return null;
        },
        onUnknownRoute: (settings) {
          return MaterialPageRoute(
              builder: (_) =>
                  const Scaffold(body: Center(child: Text('Not Found'))));
        },
      ),
    );
  }
}

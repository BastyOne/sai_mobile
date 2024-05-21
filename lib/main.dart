import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'models/incidencia.dart';
import 'services/shared_preferences.dart';
import 'controllers/mensaje_diario_controller.dart';
import 'controllers/incidencia_controller.dart';
import 'views/Alumno/FAQsViewsAlumno/faq_alumno_view.dart';
import 'views/Alumno/foroAlumno/foro_alumno_view.dart';
import 'views/Alumno/incidenciasViewsAlumnos/incidencias_status_view.dart';
import 'views/Alumno/incidenciasViewsAlumnos/chat_incidencia_view.dart'; // Importar la nueva pantalla
import 'views/Personal/estadisticasViewPersonal/stats_view.dart';
import 'views/Personal/incidenciasViewsPersonal/chat_incidencia_personal_view.dart';
import 'views/Personal/incidenciasViewsPersonal/ver_incidencias_view.dart';
import 'views/login_view.dart';
import 'views/Personal/home_personal_view.dart';
import 'views/Alumno/home_alumno_view.dart';
import 'views/Alumno/preguntasAlumno/preguntas_alumno_view.dart';
import 'views/Alumno/incidenciasViewsAlumnos/seleccionar_categoria_view.dart';
import 'views/Alumno/incidenciasViewsAlumnos/seleccionar_subcategoria_view.dart';
import 'views/Alumno/incidenciasViewsAlumnos/agregar_descripcion_view.dart';

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
          '/home_personal': (context) => HomePersonalView(
              userId: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['userId'] as int),
          '/ingresarPregunta': (context) => const IngresarPreguntaScreen(),
          '/preguntasFrecuentes': (context) =>
              const PreguntasFrecuentesScreen(),
          '/foroEstudiantil': (context) => const ForoEstudiantilScreen(),
          '/incidenciasPersonal': (context) => VerIncidenciasScreen(
              personalId: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['userId'] as int),
          '/estadisticasPersonal': (context) => const VerEstadisticasScreen(),
        },
        onGenerateRoute: (settings) {
          if (settings.name == '/home_alumno') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int && args['carreraId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return HomeAlumnoView(
                      userId: args['userId'], carreraId: args['carreraId']);
                },
              );
            }
          } else if (settings.name == '/ingresarIncidencia') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int && args['carreraId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return SeleccionarCategoriaPadreScreen(
                      userId: args['userId'], carreraId: args['carreraId']);
                },
              );
            }
          } else if (settings.name == '/seleccionarCategoriaHijo') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int && args['carreraId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return SeleccionarCategoriaHijoScreen(
                      userId: args['userId'], carreraId: args['carreraId']);
                },
              );
            }
          } else if (settings.name == '/agregarDescripcion') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int && args['carreraId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return AgregarDescripcionScreen(
                      userId: args['userId'], carreraId: args['carreraId']);
                },
              );
            }
          } else if (settings.name == '/incidencias') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['userId'] is int) {
              return MaterialPageRoute(
                builder: (context) {
                  return IncidenciaStatusScreen(
                    userId: args['userId'],
                  );
                },
              );
            }
          } else if (settings.name == '/chatIncidencia') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['incidencia'] is Incidencia) {
              return MaterialPageRoute(
                builder: (context) {
                  return ChatIncidenciaScreen(
                    incidencia: args['incidencia'],
                  );
                },
              );
            }
          } else if (settings.name == '/chatIncidenciaPersonal') {
            final args = settings.arguments as Map<String, dynamic>;
            if (args['incidencia'] is Incidencia) {
              return MaterialPageRoute(
                builder: (context) {
                  return ChatIncidenciaPersonalScreen(
                    incidencia: args['incidencia'],
                  );
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

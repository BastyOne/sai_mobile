import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'controllers/foro_controller.dart';
import 'models/incidencia.dart';
import 'controllers/mensaje_diario_controller.dart';
import 'controllers/incidencia_controller.dart';
import 'views/alumno/FAQsViewAlumno/faq_alumno_view.dart';
import 'views/alumno/foroViewAlumno/crear_post_view.dart';
import 'views/alumno/foroViewAlumno/detalle_post_view.dart';
import 'views/alumno/foroViewAlumno/foro_alumno_view.dart';
import 'views/alumno/incidenciasViewAlumno/incidencias_status_view.dart';
import 'views/alumno/incidenciasViewAlumno/chat_incidencia_view.dart';
import 'views/personal/estadisticasViewPersonal/stats_view.dart';
import 'views/personal/incidenciasViewPersonal/chat_incidencia_personal_view.dart';
import 'views/personal/incidenciasViewPersonal/ver_incidencias_view.dart';
import 'views/auth/login_view.dart';
import 'views/personal/home_personal_view.dart';
import 'views/alumno/home_alumno_view.dart';
import 'views/alumno/preguntasViewAlumno/preguntas_alumno_view.dart';
import 'views/alumno/incidenciasViewAlumno/seleccionar_categoria_view.dart';
import 'views/alumno/incidenciasViewAlumno/seleccionar_subcategoria_view.dart';
import 'views/alumno/incidenciasViewAlumno/agregar_descripcion_view.dart';

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => MensajeDiarioController()),
        ChangeNotifierProvider(create: (_) => IncidenciaController()),
        ChangeNotifierProvider(create: (_) => ForoController()),
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
          'detallePost': (context) => DetallePostScreen(
              postId: (ModalRoute.of(context)?.settings.arguments
                  as Map<String, dynamic>)['postId'] as int),
          'agregarPost': (context) => const AgregarPostScreen(),
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

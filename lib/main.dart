import 'package:flutter/material.dart';
import 'services/shared_preferences.dart';
import 'views/faq_alumno_view.dart';
import 'views/foro_alumno_view.dart';
import 'views/incidencias_alumno_view.dart';
import 'views/login_view.dart';
import 'views/home_personal_view.dart';
import 'views/home_alumno_view.dart';
import 'views/preguntas_alumno.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SharedPreferencesService.initialize();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Incidencias',
      initialRoute: '/',
      routes: {
        '/': (context) => const LoginView(),
        '/home_personal': (context) => const HomePersonalView(),
        '/ingresarIncidencia': (context) => const IngresarIncidenciaScreen(),
        '/ingresarPregunta': (context) => const IngresarPreguntaScreen(),
        '/preguntasFrecuentes': (context) => const PreguntasFrecuentesScreen(),
        '/foroEstudiantil': (context) => const ForoEstudiantilScreen(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/home_alumno') {
          final args = settings.arguments as Map<String, dynamic>;
          if (args['userId'] is int) {
            // Verifica que 'userId' sea un entero
            return MaterialPageRoute(
              builder: (context) {
                return HomeAlumnoView(userId: args['userId']);
              },
            );
          }
        }
        // Define other routes with parameters here
        // ...

        // Return null for unhandled routes which will invoke onUnknownRoute
        return null;
      },
      onUnknownRoute: (settings) {
        return MaterialPageRoute(
            builder: (_) =>
                const Scaffold(body: Center(child: Text('Not Found'))));
      },
    );
  }
}

import 'package:flutter/material.dart';
import 'views/login_view.dart';
import 'views/home_personal_view.dart';
import 'views/home_alumno_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Mi App Incidencias',
      initialRoute: '/',
      routes: {
        '/': (context) => LoginView(),
        '/home_personal': (context) => HomePersonalView(),
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
            builder: (_) => Scaffold(body: Center(child: Text('Not Found'))));
      },
    );
  }
}

import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';

class LoginView extends StatefulWidget {
  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = LoginController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  var buttonTextStyle = const TextStyle(
    color: Color(0xFF00A2E1), // El color azul que usas para 'INGRESAR'
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para el scaffold
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FractionallySizedBox(
                widthFactor: 0.5, // 50% del ancho de la pantalla
                child: Image.asset(
                  'assets/images/logo_ucm.png',
                ),
              ),
              const SizedBox(height: 48),

              const Text(
                'Portal de Incidencias Estudiantiles',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48),
              Container(
                margin: const EdgeInsets.only(
                    top: 5.0,
                    bottom: 5.0,
                    right: 15.0,
                    left:
                        15.0), // Margen de 1px en la parte superior e inferior
                child: TextField(
                  controller: _rutController,
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    labelText: 'Rut',
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    labelStyle:
                        TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(
                    top: 5.0, bottom: 5.0, right: 15.0, left: 15.0),
                child: TextField(
                  controller: _passwordController,
                  obscureText: true,
                  decoration: InputDecoration(
                    labelText: 'Contraseña',
                    border: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                    ),
                    enabledBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                    ),
                    focusedBorder: const UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFF9E9E9E)),
                    ),
                    contentPadding: EdgeInsets.zero,
                    isDense: true,
                    labelStyle:
                        TextStyle(fontSize: 16, color: Colors.grey[800]),
                  ),
                ),
              ),

              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implementar 'Olvidé mi contraseña'
                  },
                  child: Text('Olvidé mi contraseña', style: buttonTextStyle),
                ),
              ),
              const SizedBox(height: 1),
              ElevatedButton(
                onPressed: () => _loginController.login(
                  _rutController.text,
                  _passwordController.text,
                  context,
                ),
                style: ElevatedButton.styleFrom(
                  foregroundColor: const Color(0xFF00A2E1),
                  backgroundColor:
                      Colors.white, // Color de overlay del botón (al presionar)
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 10), // Padding interno
                  side: const BorderSide(
                      color: Color(0xFF00A2E1)), // Borde del botón
                  elevation: 0, // Elimina la sombra
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(0), // Borde del botón sin curvas
                  ),
                ),
                child: const Text(
                  'INGRESAR',
                  style: TextStyle(
                    color: Color(0xFF00A2E1), // Color hexadecimal para el texto
                    fontWeight: FontWeight.w600, // 600 es semibold
                  ),
                ),
              ),

              TextButton(
                onPressed: () {
                  // TODO: Implementar 'Cambiar contraseña'
                },
                child: Text('Cambiar contraseña', style: buttonTextStyle),
              ),
              const SizedBox(height: 10),
              Image.asset(
                  'assets/images/mesa_ucm.png'), // Imagen de la mesa de servicio
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:sai_mobile/widgets/logo_header.dart';
import '../../controllers/login_controller.dart';
import 'package:sai_mobile/widgets/input_field.dart';
import 'package:sai_mobile/widgets/custom_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  LoginViewState createState() => LoginViewState();
}

class LoginViewState extends State<LoginView> {
  final LoginController _loginController = LoginController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextStyle buttonTextStyle = const TextStyle(
    color: Color(0xFF00A2E1),
  );

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: const Text('Error', style: TextStyle(color: Colors.blue)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Aceptar', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void _login() {
    final String rut = _rutController.text;
    final String password = _passwordController.text;

    if (rut.isEmpty || password.isEmpty) {
      _showErrorDialog(context, 'Todos los campos son requeridos.');
      return;
    }

    _loginController.login(rut, password, context).then((success) {
      if (!success) {
        _showErrorDialog(context, 'Usuario o contraseña incorrectos.');
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 60.0, horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const LogoHeader(),
              const SizedBox(height: 48),
              const Text(
                'Portal de Incidencias Estudiantiles',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              InputField(
                  controller: _rutController,
                  label: 'Rut',
                  keyboardType: TextInputType.number),
              InputField(
                  controller: _passwordController,
                  label: 'Contraseña',
                  obscureText: true),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {},
                  child: Text('Olvidé mi contraseña', style: buttonTextStyle),
                ),
              ),
              CustomButton(
                text: 'INGRESAR',
                onPressed: _login,
                textStyle: const TextStyle(
                    color: Color(0xFF00A2E1), fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {},
                child: Text('Cambiar contraseña', style: buttonTextStyle),
              ),
              const SizedBox(height: 10),
              Image.asset('assets/images/mesa_ucm.png'),
            ],
          ),
        ),
      ),
    );
  }
}

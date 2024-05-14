import 'package:flutter/material.dart';
import 'package:sai_mobile/widgets/logo_header.dart';
import '../controllers/login_controller.dart';
import 'package:sai_mobile/widgets/input_field.dart';
import 'package:sai_mobile/widgets/custom_button.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  _LoginViewState createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final LoginController _loginController = LoginController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final TextStyle buttonTextStyle = const TextStyle(
    color: Color(0xFF00A2E1),
  );

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
                style: TextStyle(fontSize: 21, fontWeight: FontWeight.bold),
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
                  onPressed: () {
                    // TODO: Implementar 'Olvidé mi contraseña'
                  },
                  child: Text('Olvidé mi contraseña', style: buttonTextStyle),
                ),
              ),
              CustomButton(
                text: 'INGRESAR',
                onPressed: () => _loginController.login(
                  _rutController.text,
                  _passwordController.text,
                  context,
                ),
                textStyle: const TextStyle(
                    color: Color(0xFF00A2E1), fontWeight: FontWeight.w600),
              ),
              TextButton(
                onPressed: () {
                  // TODO: Implementar 'Cambiar contraseña'
                },
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

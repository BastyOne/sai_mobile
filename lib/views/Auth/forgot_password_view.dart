import 'package:flutter/material.dart';
import 'package:sai_mobile/widgets/logo_header.dart';
import 'package:sai_mobile/widgets/input_field.dart';
import 'package:sai_mobile/widgets/custom_button.dart';
import '../../controllers/login_controller.dart';

class ForgotPasswordView extends StatefulWidget {
  const ForgotPasswordView({super.key});

  @override
  ForgotPasswordViewState createState() => ForgotPasswordViewState();
}

class ForgotPasswordViewState extends State<ForgotPasswordView> {
  final LoginController _controller = LoginController();
  final TextEditingController _emailController = TextEditingController();

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

  void _showConfirmationDialog(BuildContext context, String email) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: const Text('Éxito', style: TextStyle(color: Colors.blue)),
          content: const Text(
              'Se ha enviado un código de restablecimiento a su correo electrónico.'),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Aceptar', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                Navigator.pushNamed(context, '/reset_password',
                    arguments: {'email': email});
              },
            ),
          ],
        );
      },
    );
  }

  void _sendResetEmail() async {
    final String email = _emailController.text;

    if (email.isEmpty) {
      _showErrorDialog(context, 'El correo es requerido.');
      return;
    }

    bool success = await _controller.sendResetEmail(email);
    if (success) {
      _showConfirmationDialog(context, email);
    } else {
      _showErrorDialog(
          context, 'No se pudo enviar el correo de restablecimiento.');
    }
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
                'Restablecer Contraseña',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              InputField(
                controller: _emailController,
                label: 'Correo Electrónico',
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'ENVIAR',
                onPressed: _sendResetEmail,
                textStyle: const TextStyle(
                    color: Color(0xFF00A2E1), fontWeight: FontWeight.w600),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

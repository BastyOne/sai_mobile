import 'package:flutter/material.dart';
import 'package:sai_mobile/widgets/logo_header.dart';
import 'package:sai_mobile/widgets/input_field.dart';
import 'package:sai_mobile/widgets/custom_button.dart';
import '../../controllers/login_controller.dart';

class ResetPasswordView extends StatefulWidget {
  final String email;
  const ResetPasswordView({super.key, required this.email});

  @override
  ResetPasswordViewState createState() => ResetPasswordViewState();
}

class ResetPasswordViewState extends State<ResetPasswordView> {
  final LoginController _controller = LoginController();
  final TextEditingController _tokenController = TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

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

  void _resetPassword() async {
    final String token = _tokenController.text;
    final String newPassword = _newPasswordController.text;
    final String confirmPassword = _confirmPasswordController.text;

    if (token.isEmpty || newPassword.isEmpty || confirmPassword.isEmpty) {
      _showErrorDialog(context, 'Todos los campos son requeridos.');
      return;
    }

    if (newPassword != confirmPassword) {
      _showErrorDialog(context, 'Las nuevas contraseñas no coinciden.');
      return;
    }

    bool success =
        await _controller.resetPassword(widget.email, token, newPassword);
    if (success) {
      showDialog(
        context: context,
        builder: (BuildContext dialogContext) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8.0)),
            title: const Text('Éxito', style: TextStyle(color: Colors.blue)),
            content: const Text('Contraseña actualizada con éxito.'),
            actions: <Widget>[
              TextButton(
                child:
                    const Text('Aceptar', style: TextStyle(color: Colors.blue)),
                onPressed: () {
                  Navigator.of(dialogContext).pop(); // Close the dialog
                  Navigator.pushReplacementNamed(context, '/');
                },
              ),
            ],
          );
        },
      );
    } else {
      _showErrorDialog(context, 'No se pudo actualizar la contraseña.');
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
                controller: _tokenController,
                label: 'Código',
                keyboardType: TextInputType.text,
              ),
              InputField(
                controller: _newPasswordController,
                label: 'Nueva Contraseña',
                obscureText: true,
              ),
              InputField(
                controller: _confirmPasswordController,
                label: 'Confirmar Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'CONFIRMAR',
                onPressed: _resetPassword,
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

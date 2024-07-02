import 'package:flutter/material.dart';
import 'package:sai_mobile/widgets/logo_header.dart';
import 'package:sai_mobile/widgets/input_field.dart';
import 'package:sai_mobile/widgets/custom_button.dart';
import '../../controllers/login_controller.dart';

class UpdatePasswordView extends StatefulWidget {
  const UpdatePasswordView({super.key});

  @override
  UpdatePasswordViewState createState() => UpdatePasswordViewState();
}

class UpdatePasswordViewState extends State<UpdatePasswordView> {
  final LoginController _controller = LoginController();
  final TextEditingController _rutController = TextEditingController();
  final TextEditingController _currentPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmNewPasswordController =
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

  void _showSuccessDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
          title: const Text('Éxito', style: TextStyle(color: Colors.blue)),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child:
                  const Text('Aceptar', style: TextStyle(color: Colors.blue)),
              onPressed: () {
                Navigator.of(dialogContext).pop(); // Close the dialog
                Navigator.pushNamedAndRemoveUntil(
                    context, '/', (Route<dynamic> route) => false);
              },
            ),
          ],
        );
      },
    );
  }

  void _updatePassword() async {
    final String rut = _rutController.text;
    final String currentPassword = _currentPasswordController.text;
    final String newPassword = _newPasswordController.text;
    final String confirmNewPassword = _confirmNewPasswordController.text;

    if (rut.isEmpty ||
        currentPassword.isEmpty ||
        newPassword.isEmpty ||
        confirmNewPassword.isEmpty) {
      _showErrorDialog(context, 'Todos los campos son requeridos.');
      return;
    }

    if (newPassword != confirmNewPassword) {
      _showErrorDialog(context, 'Las nuevas contraseñas no coinciden.');
      return;
    }

    final result =
        await _controller.updatePassword(rut, currentPassword, newPassword);
    if (result['success']) {
      _showSuccessDialog(context, 'Contraseña actualizada con éxito.');
    } else {
      _showErrorDialog(
          context, result['message'] ?? 'No se pudo actualizar la contraseña.');
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
                'Actualizar Contraseña',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 48),
              InputField(
                controller: _rutController,
                label: 'Rut',
                keyboardType: TextInputType.number,
              ),
              InputField(
                controller: _currentPasswordController,
                label: 'Contraseña Actual',
                obscureText: true,
              ),
              InputField(
                controller: _newPasswordController,
                label: 'Nueva Contraseña',
                obscureText: true,
              ),
              InputField(
                controller: _confirmNewPasswordController,
                label: 'Confirmar Nueva Contraseña',
                obscureText: true,
              ),
              const SizedBox(height: 20),
              CustomButton(
                text: 'CONFIRMAR',
                onPressed: _updatePassword,
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

import 'package:flutter/material.dart';

class LogoHeader extends StatelessWidget {
  final double widthFactor; // Esto permite flexibilidad en el tamaño del logo.

  const LogoHeader(
      {super.key, this.widthFactor = 0.5}); // Valor predeterminado de 0.5

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: widthFactor,
      child: Image.asset('assets/images/logo_ucm.png'),
    );
  }
}

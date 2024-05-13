import 'package:flutter/material.dart';

class HomePersonalView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Inicio Personal"),
      ),
      body: Center(
        child: Text("Bienvenido al panel de personal"),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/custom_app_bar.dart';
import '../../widgets/custom_drawer.dart';

class BaseScreen extends StatelessWidget {
  final String title;
  final Widget body;
  final VoidCallback onLogout;
  final int step;
  final Widget? bottomNavigationBar;

  const BaseScreen({
    Key? key,
    required this.title,
    required this.body,
    required this.onLogout,
    required this.step,
    this.bottomNavigationBar,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        titleWidget: Image.network(
          'https://portalalumnos.ucm.cl/v2/assets/img/logo_ucm_white.png',
          width: 160,
        ),
      ),
      drawer: CustomDrawer(
        onLogout: onLogout,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child:
                Text(title, style: Theme.of(context).textTheme.headlineSmall),
          ),
          _buildProgressBar(),
          Expanded(child: body),
        ],
      ),
      bottomNavigationBar: bottomNavigationBar,
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Row(
        children: [
          _buildStepCircle(1),
          _buildStepLine(),
          _buildStepCircle(2),
          _buildStepLine(),
          _buildStepCircle(3),
        ],
      ),
    );
  }

  Widget _buildStepCircle(int currentStep) {
    return CircleAvatar(
      radius: 15,
      backgroundColor:
          step >= currentStep ? const Color(0xFF2196F3) : Colors.grey,
      child: Text(
        '$currentStep',
        style: const TextStyle(color: Colors.white),
      ),
    );
  }

  Widget _buildStepLine() {
    return const Expanded(
      child: Divider(
        color: Colors.grey,
        thickness: 2,
      ),
    );
  }
}

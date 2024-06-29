import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../../controllers/personal_controller.dart';
import '../../../../services/shared_preferences.dart';
import '../../../../widgets/custom_app_bar.dart';
import '../../../../widgets/custom_drawer.dart';

class PersonalScreen extends StatefulWidget {
  const PersonalScreen({super.key});

  @override
  PersonalScreenState createState() => PersonalScreenState();
}

class PersonalScreenState extends State<PersonalScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<PersonalController>(context, listen: false).fetchPersonal();
    });
  }

  void _logout(BuildContext context) async {
    await SharedPreferencesService.removeToken();
    Navigator.pushReplacementNamed(context, '/');
  }

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
        onLogout: () => _logout(context),
      ),
      body: Consumer<PersonalController>(
        builder: (context, controller, child) {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (controller.personal.isEmpty) {
            return const Center(child: Text('No hay personal disponible.'));
          }
          return ListView.builder(
            itemCount: controller.personal.length,
            itemBuilder: (context, index) {
              final personal = controller.personal[index];
              return ListTile(
                leading: personal.fotoUrl != null
                    ? Image.network(personal.fotoUrl!)
                    : const Icon(Icons.person),
                title: Text(personal.nombre),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(personal.email),
                    Text(personal.tipopersona),
                    Text('Carrera: ${personal.carreraNombre}'),
                  ],
                ),
                isThreeLine: true,
              );
            },
          );
        },
      ),
    );
  }
}

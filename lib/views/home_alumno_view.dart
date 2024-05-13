import 'package:flutter/material.dart';
import '../models/alumno.dart';
import '../services/api_service.dart';

class HomeAlumnoView extends StatefulWidget {
  final int userId;

  HomeAlumnoView({Key? key, required this.userId}) : super(key: key);

  @override
  _HomeAlumnoViewState createState() => _HomeAlumnoViewState();
}

class _HomeAlumnoViewState extends State<HomeAlumnoView> {
  late Future<AlumnoInfo?> alumnoInfoFuture;

  @override
  void initState() {
    super.initState();
    alumnoInfoFuture = ApiService().getAlumnoInfo(widget.userId);
  }

  void _onSelectMenuItem(String value) {
    switch (value) {
      case 'logout':
        // Aquí deberías implementar la funcionalidad de cerrar sesión
        print('Cerrar sesión');
        break;
      // Aquí puedes manejar más opciones si fuera necesario
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(70.0), // Altura del AppBar
        child: AppBar(
          backgroundColor:
              const Color.fromRGBO(0, 85, 169, 1), // Color de fondo
          elevation: 0, // Elimina la sombra para emular 'border-color'
          title: Image.network(
            'https://portalalumnos.ucm.cl/v2/assets/img/logo_ucm_white.png',
            width: 160,
          ),
          leading: PopupMenuButton<String>(
            onSelected: _onSelectMenuItem,
            itemBuilder: (BuildContext context) {
              return {'Cerrar sesión'}.map((String choice) {
                return PopupMenuItem<String>(
                  value: 'logout',
                  child: Text(choice),
                );
              }).toList();
            },
            icon: const Icon(
              Icons.menu,
              color: Colors.white,
            ), // Icono del menú
          ),
        ),
      ),
      body: FutureBuilder<AlumnoInfo?>(
        future: alumnoInfoFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (snapshot.hasData) {
            AlumnoInfo alumno = snapshot.data!;
            return ListView(
              padding: const EdgeInsets.all(16.0),
              children: <Widget>[
                _buildStudentInfoCard(alumno) // Un Placeholder si no hay foto
              ],
            );
          } else {
            return const Center(
                child: Text('No se encontró información del alumno.'));
          }
        },
      ),
    );
  }

  // Este método construye el widget de tarjeta con la información del alumno
  Widget _buildStudentInfoCard(AlumnoInfo alumno) {
    return Card(
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 2,
      child: Container(
        width: double.infinity,
        padding: EdgeInsets.all(8.0),
        color: Colors.blue[900], // Ajusta el color según tu diseño
        child: Row(
          children: [
            // Si alumno.fotoUrl es null, podrías mostrar un Placeholder o una imagen por defecto
            CircleAvatar(
              backgroundImage: alumno.fotoUrl != null
                  ? NetworkImage(alumno.fotoUrl!)
                  : const AssetImage('path_to_default_image')
                      as ImageProvider<Object>?,
              radius: 50.0,
            ),
            SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '${alumno.nombre} ${alumno.apellido}',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.0,
                    ),
                  ),
                  Text(
                    alumno.rut,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    alumno.email,
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16.0,
                    ),
                  ),
                  Text(
                    'Regular en ${alumno.carreraNombre}',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16.0,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

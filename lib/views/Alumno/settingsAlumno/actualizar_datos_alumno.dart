import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../services/user_service.dart';
import '../../../widgets/custom_app_bar.dart';
import '../../../widgets/custom_drawer.dart';

class UpdateAlumnoScreen extends StatefulWidget {
  const UpdateAlumnoScreen({super.key});

  @override
  UpdateAlumnoScreenState createState() => UpdateAlumnoScreenState();
}

class UpdateAlumnoScreenState extends State<UpdateAlumnoScreen> {
  final _formKey = GlobalKey<FormState>();
  final UserService _userService = UserService();

  late String nombre, apellido, rut, email, carreraNombre;
  late String celular, contactoEmergencia, ciudadActual;
  bool _isLoading = true;
  bool _isSubmitting = false;

  Future<void> _fetchAlumnoInfo() async {
    setState(() {
      _isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId')!;
    final alumnoInfo = await _userService.getAlumnoInfo(userId);

    setState(() {
      nombre = alumnoInfo!.nombre;
      apellido = alumnoInfo.apellido;
      rut = alumnoInfo.rut;
      email = alumnoInfo.email;
      carreraNombre = alumnoInfo.carreraNombre;
      celular = alumnoInfo.celular;
      contactoEmergencia = alumnoInfo.contactoEmergencia;
      ciudadActual = alumnoInfo.ciudadActual;
      _isLoading = false;
    });
  }

  Future<void> _updateAlumno() async {
    final prefs = await SharedPreferences.getInstance();
    final userId = prefs.getInt('userId');

    if (_formKey.currentState!.validate()) {
      setState(() {
        _isSubmitting = true;
      });

      try {
        await _userService.updateAlumno(
          userId!,
          celular: celular,
          contactoEmergencia: contactoEmergencia,
          ciudadActual: ciudadActual,
        );

        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Datos actualizados exitosamente')));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Error al actualizar datos: $e')));
      }

      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchAlumnoInfo();
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
        onLogout: () {
          SharedPreferences.getInstance().then((prefs) {
            prefs.remove('token');
            prefs.remove('userId');
            prefs.remove('userType');
            Navigator.pushReplacementNamed(context, '/');
          });
        },
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    TextFormField(
                      initialValue: nombre,
                      decoration: const InputDecoration(
                        labelText: 'Nombre',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      initialValue: apellido,
                      decoration: const InputDecoration(
                        labelText: 'Apellido',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      initialValue: rut,
                      decoration: const InputDecoration(
                        labelText: 'RUT',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      initialValue: email,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      initialValue: carreraNombre,
                      decoration: const InputDecoration(
                        labelText: 'Carrera',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      readOnly: true,
                    ),
                    TextFormField(
                      initialValue: celular,
                      decoration: const InputDecoration(
                        labelText: 'Celular',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      onChanged: (value) => celular = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su celular';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: contactoEmergencia,
                      decoration: const InputDecoration(
                        labelText: 'Contacto de Emergencia',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      onChanged: (value) => contactoEmergencia = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su contacto de emergencia';
                        }
                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: ciudadActual,
                      decoration: const InputDecoration(
                        labelText: 'Ciudad Actual',
                        labelStyle: TextStyle(color: Color(0xFF2196F3)),
                        enabledBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Color(0xFF2196F3)),
                        ),
                      ),
                      onChanged: (value) => ciudadActual = value,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Por favor ingrese su ciudad actual';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    _isSubmitting
                        ? const Center(child: CircularProgressIndicator())
                        : ElevatedButton(
                            onPressed: _updateAlumno,
                            style: ElevatedButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: const Color(0xFF2196F3),
                            ),
                            child: const Text('Actualizar'),
                          ),
                  ],
                ),
              ),
            ),
    );
  }
}

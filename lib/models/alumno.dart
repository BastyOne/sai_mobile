class AlumnoInfo {
  final String nombre;
  final String apellido;
  final String rut;
  final String email;
  final String carreraNombre;
  final String celular;
  final String contactoEmergencia;
  final String ciudadActual;
  final String? fotoUrl;
  final String? nivel;

  AlumnoInfo({
    required this.nombre,
    required this.apellido,
    required this.rut,
    required this.email,
    required this.carreraNombre,
    required this.celular,
    required this.contactoEmergencia,
    required this.ciudadActual,
    this.fotoUrl,
    this.nivel,
  });

  factory AlumnoInfo.fromJson(Map<String, dynamic> json) {
    return AlumnoInfo(
      nombre: json['nombre'],
      apellido: json['apellido'],
      rut: json['rut'],
      email: json['email'],
      carreraNombre:
          json['carrera'] != null ? json['carrera']['nombre'] : 'Sin carrera',
      celular: json['celular'] ?? '',
      contactoEmergencia: json['contactoemergencia'] ?? '',
      ciudadActual: json['ciudadactual'] ?? '',
      fotoUrl: json['foto'],
      nivel: json['nivel'] ?? 'Sin nivel',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'rut': rut,
      'email': email,
      'carreraNombre': carreraNombre,
      'celular': celular,
      'contactoemergencia': contactoEmergencia,
      'ciudadactual': ciudadActual,
      'fotoUrl': fotoUrl,
      'nivel': nivel,
    };
  }
}

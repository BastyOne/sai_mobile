class AlumnoInfo {
  final String nombre;
  final String apellido;
  final String rut;
  final String email;
  final String carreraNombre;
  final String? fotoUrl;

  AlumnoInfo(
      {required this.nombre,
      required this.apellido,
      required this.rut,
      required this.email,
      required this.carreraNombre,
      this.fotoUrl});

  factory AlumnoInfo.fromJson(Map<String, dynamic> json) {
    return AlumnoInfo(
      nombre: json['nombre'],
      apellido: json['apellido'],
      rut: json['rut'],
      email: json['email'],
      carreraNombre: json['carrera']['nombre'],
      fotoUrl: json['foto'],
    );
  }
}

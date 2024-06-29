class PersonalInfo {
  final String nombre;
  final String rut;
  final String email;
  final String tipopersona;
  final String carreraNombre;
  final String? fotoUrl;

  PersonalInfo({
    required this.nombre,
    required this.rut,
    required this.email,
    required this.tipopersona,
    required this.carreraNombre,
    this.fotoUrl,
  });

  factory PersonalInfo.fromJson(Map<String, dynamic> json) {
    return PersonalInfo(
      nombre: json['nombre'] ?? '',
      rut: json['rut'],
      email: json['email'] ?? '',
      tipopersona: json['tipopersona']?['nombre'] ?? '',
      carreraNombre: json['carrera']?['nombre'] ?? '',
      fotoUrl: json['foto'],
    );
  }
}

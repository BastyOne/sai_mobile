class MensajeDiario {
  final int id;
  final String mensaje;
  final bool activo; // Agregar el campo activo
  final List<String> imagenes;

  MensajeDiario({
    required this.id,
    required this.mensaje,
    required this.activo,
    required this.imagenes,
  });

  factory MensajeDiario.fromJson(Map<String, dynamic> json) {
    return MensajeDiario(
      id: json['id'],
      mensaje: json['mensaje'],
      activo: json['activo'],
      imagenes: List<String>.from(json['imagenes']),
    );
  }
}

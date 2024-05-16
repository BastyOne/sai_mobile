class MensajeDiario {
  final String mensaje;
  final List<String> imagenes;

  MensajeDiario({
    required this.mensaje,
    required this.imagenes,
  });

  factory MensajeDiario.fromJson(Map<String, dynamic> json) {
    return MensajeDiario(
      mensaje: json['mensaje'],
      imagenes: List<String>.from(json['imagenes']),
    );
  }
}

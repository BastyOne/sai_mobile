class FAQ {
  final int id;
  final int categoriaFaqId;
  final String pregunta;
  final String respuesta;
  final bool activo;
  final String fechaCreacion;

  FAQ({
    required this.id,
    required this.categoriaFaqId,
    required this.pregunta,
    required this.respuesta,
    required this.activo,
    required this.fechaCreacion,
  });

  factory FAQ.fromJson(Map<String, dynamic> json) {
    return FAQ(
      id: json['id'],
      categoriaFaqId: json['categoriafaq_id'],
      pregunta: json['pregunta'],
      respuesta: json['respuesta'],
      activo: json['activo'],
      fechaCreacion: json['fechacreacion'],
    );
  }
}

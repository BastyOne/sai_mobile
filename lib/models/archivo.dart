class Archivo {
  final int id;
  final String entidadTipo;
  final int entidadId;
  final String archivoUrl;
  final String archivoNombre;
  final DateTime fechaSubida;

  Archivo({
    required this.id,
    required this.entidadTipo,
    required this.entidadId,
    required this.archivoUrl,
    required this.archivoNombre,
    required this.fechaSubida,
  });

  factory Archivo.fromJson(Map<String, dynamic> json) {
    return Archivo(
      id: json['id'],
      entidadTipo: json['entidad_tipo'],
      entidadId: json['entidad_id'],
      archivoUrl: json['archivo_url'],
      archivoNombre: json['archivo_nombre'],
      fechaSubida: DateTime.parse(json['fecha_subida']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'entidad_tipo': entidadTipo,
      'entidad_id': entidadId,
      'archivo_url': archivoUrl,
      'archivo_nombre': archivoNombre,
      'fecha_subida': fechaSubida.toIso8601String(),
    };
  }
}

class Incidencia {
  final int id;
  final int alumnoId;
  final int categoriaIncidenciaId;
  final String descripcion;
  final int personalId;
  final int carreraId; // Añadir este campo
  final String estado;
  final DateTime fechaHoraCreacion;
  final bool reabierta;
  final String prioridad;

  Incidencia({
    required this.id,
    required this.alumnoId,
    required this.categoriaIncidenciaId,
    required this.descripcion,
    required this.personalId,
    required this.carreraId, // Añadir este campo
    required this.estado,
    required this.fechaHoraCreacion,
    required this.reabierta,
    required this.prioridad,
  });

  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      id: json['id'],
      alumnoId: json['alumno_id'],
      categoriaIncidenciaId: json['categoriaIncidencia_id'],
      descripcion: json['descripcion'],
      personalId: json['personal_id'],
      carreraId: json['carrera_id'], // Añadir este campo
      estado: json['estado'],
      fechaHoraCreacion: DateTime.parse(json['fechaHoraCreacion']),
      reabierta: json['reabierta'],
      prioridad: json['prioridad'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumno_id': alumnoId,
      'categoriaIncidencia_id': categoriaIncidenciaId,
      'descripcion': descripcion,
      'personal_id': personalId,
      'carrera_id': carreraId, // Añadir este campo
      'estado': estado,
      'fechaHoraCreacion': fechaHoraCreacion.toIso8601String(),
      'reabierta': reabierta,
      'prioridad': prioridad,
    };
  }
}

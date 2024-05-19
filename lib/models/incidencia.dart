class Incidencia {
  final int id;
  final int alumnoId;
  final int categoriaIncidenciaId;
  final String descripcion;
  final int personalId;
  final int? carreraId; // Permitir null
  final String estado;
  final DateTime fechaHoraCreacion;
  final DateTime? fechaHoraCierre; // Permitir null
  final bool reabierta;
  final String? prioridad; // Permitir null
  final List<RespuestaIncidencia> respuestas;
  final List<Reunion> reuniones; // Añadir reuniones

  Incidencia({
    required this.id,
    required this.alumnoId,
    required this.categoriaIncidenciaId,
    required this.descripcion,
    required this.personalId,
    this.carreraId, // Permitir null
    required this.estado,
    required this.fechaHoraCreacion,
    this.fechaHoraCierre, // Permitir null
    required this.reabierta,
    this.prioridad, // Permitir null
    required this.respuestas,
    required this.reuniones, // Añadir reuniones
  });

  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      id: json['id'] as int,
      alumnoId: json['alumno_id'] as int,
      categoriaIncidenciaId: json['categoriaincidencia_id'] as int,
      descripcion: json['descripcion'] as String,
      personalId: json['personal_id'] as int,
      carreraId: json['carrera_id'] != null
          ? json['carrera_id'] as int
          : null, // Permitir null
      estado: json['estado'] as String,
      fechaHoraCreacion: DateTime.parse(json['fechahoracreacion'] as String),
      fechaHoraCierre: json['fechahoracierre'] != null
          ? DateTime.parse(json['fechahoracierre'] as String)
          : null, // Permitir null
      reabierta: json['reabierta'] as bool,
      prioridad: json['prioridad'] != null
          ? json['prioridad'] as String
          : null, // Permitir null
      respuestas: (json['respuestaincidencia'] as List)
          .map((i) => RespuestaIncidencia.fromJson(i as Map<String, dynamic>))
          .toList(),
      reuniones: (json['reunion'] as List)
          .map((i) => Reunion.fromJson(i as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumno_id': alumnoId,
      'categoriaincidencia_id': categoriaIncidenciaId,
      'descripcion': descripcion,
      'personal_id': personalId,
      'carrera_id': carreraId, // Permitir null
      'estado': estado,
      'fechahoracreacion': fechaHoraCreacion.toIso8601String(),
      'fechahoracierre': fechaHoraCierre?.toIso8601String(), // Permitir null
      'reabierta': reabierta,
      'prioridad': prioridad, // Permitir null
      'respuestaincidencia': respuestas.map((r) => r.toJson()).toList(),
      'reunion': reuniones.map((r) => r.toJson()).toList(), // Añadir reuniones
    };
  }
}

class RespuestaIncidencia {
  final int id;
  final int incidenciaId;
  final int? personalId; // Permitir valores nulos para personalId
  final String contenido;
  final DateTime fechaRespuesta;

  RespuestaIncidencia({
    required this.id,
    required this.incidenciaId,
    required this.personalId,
    required this.contenido,
    required this.fechaRespuesta,
  });

  factory RespuestaIncidencia.fromJson(Map<String, dynamic> json) {
    return RespuestaIncidencia(
      id: json['id'],
      incidenciaId: json['incidencia_id'],
      personalId: json['personal_id'],
      contenido: json['contenido'],
      fechaRespuesta: DateTime.parse(json['fecharespuesta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidencia_id': incidenciaId,
      'personal_id': personalId,
      'contenido': contenido,
      'fecharespuesta': fechaRespuesta.toIso8601String(),
    };
  }
}

class Reunion {
  final int id;
  final String hora;
  final String tema;
  final String fecha;
  final String lugar;
  final int incidenciaId;

  Reunion({
    required this.id,
    required this.hora,
    required this.tema,
    required this.fecha,
    required this.lugar,
    required this.incidenciaId,
  });

  factory Reunion.fromJson(Map<String, dynamic> json) {
    return Reunion(
      id: json['id'],
      hora: json['hora'],
      tema: json['tema'],
      fecha: json['fecha'],
      lugar: json['lugar'],
      incidenciaId: json['incidencia_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'hora': hora,
      'tema': tema,
      'fecha': fecha,
      'lugar': lugar,
      'incidencia_id': incidenciaId,
    };
  }
}

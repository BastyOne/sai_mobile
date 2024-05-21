import 'archivo.dart';

class Incidencia {
  final int id;
  final int alumnoId;
  final int categoriaIncidenciaId;
  final String descripcion;
  final int personalId;
  final int? carreraId;
  final String estado;
  final DateTime fechaHoraCreacion;
  final DateTime? fechaHoraCierre;
  final bool reabierta;
  final String? prioridad;
  final List<RespuestaIncidencia> respuestas;
  final List<Reunion> reuniones;
  final List<Archivo> archivos;

  Incidencia({
    required this.id,
    required this.alumnoId,
    required this.categoriaIncidenciaId,
    required this.descripcion,
    required this.personalId,
    this.carreraId,
    required this.estado,
    required this.fechaHoraCreacion,
    this.fechaHoraCierre,
    required this.reabierta,
    this.prioridad,
    required this.respuestas,
    required this.reuniones,
    required this.archivos,
  });

  factory Incidencia.fromJson(Map<String, dynamic> json) {
    return Incidencia(
      id: json['id'] as int,
      alumnoId: json['alumno_id'] as int,
      categoriaIncidenciaId: json['categoriaincidencia_id'] as int,
      descripcion: json['descripcion'] as String,
      personalId: json['personal_id'] as int,
      carreraId: json['carrera_id'] != null ? json['carrera_id'] as int : null,
      estado: json['estado'] as String,
      fechaHoraCreacion: DateTime.parse(json['fechahoracreacion'] as String),
      fechaHoraCierre: json['fechahoracierre'] != null
          ? DateTime.parse(json['fechahoracierre'] as String)
          : null,
      reabierta: json['reabierta'] as bool,
      prioridad: json['prioridad'] != null ? json['prioridad'] as String : null,
      respuestas: json['respuestaincidencia'] != null
          ? (json['respuestaincidencia'] as List)
              .map((i) => RespuestaIncidencia.fromJson(i))
              .toList()
          : [],
      reuniones: json['reunion'] != null
          ? (json['reunion'] as List).map((i) => Reunion.fromJson(i)).toList()
          : [],
      archivos: json['archivos'] != null
          ? (json['archivos'] as List).map((i) => Archivo.fromJson(i)).toList()
          : [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'alumno_id': alumnoId,
      'categoriaincidencia_id': categoriaIncidenciaId,
      'descripcion': descripcion,
      'personal_id': personalId,
      'carrera_id': carreraId,
      'estado': estado,
      'fechahoracreacion': fechaHoraCreacion.toIso8601String(),
      'fechahoracierre': fechaHoraCierre?.toIso8601String(),
      'reabierta': reabierta,
      'prioridad': prioridad,
      'respuestaincidencia': respuestas.map((r) => r.toJson()).toList(),
      'reunion': reuniones.map((r) => r.toJson()).toList(),
      'archivos': archivos.map((a) => a.toJson()).toList(),
    };
  }
}

class RespuestaIncidencia {
  final int id;
  final int incidenciaId;
  final int remitenteId;
  final String remitenteTipo; // 'alumno' o 'personal'
  final String contenido;
  final DateTime fechaRespuesta;

  RespuestaIncidencia({
    required this.id,
    required this.incidenciaId,
    required this.remitenteId,
    required this.remitenteTipo,
    required this.contenido,
    required this.fechaRespuesta,
  });

  factory RespuestaIncidencia.fromJson(Map<String, dynamic> json) {
    return RespuestaIncidencia(
      id: json['id'],
      incidenciaId: json['incidencia_id'],
      remitenteId: json['remitente_id'],
      remitenteTipo: json['remitente_tipo'],
      contenido: json['contenido'],
      fechaRespuesta: DateTime.parse(json['fecharespuesta']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'incidencia_id': incidenciaId,
      'remitente_id': remitenteId,
      'remitente_tipo': remitenteTipo,
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

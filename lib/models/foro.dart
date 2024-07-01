class Post {
  final int id;
  final int? autorId;
  final String? autorNombre;
  final String? autorApellido;
  final String? autorFoto; // URL de la foto del autor
  final String pregunta;
  final String contenido;
  final String? archivoUrl; // URL del archivo adjunto, si existe
  final DateTime fechaCreacion;
  final bool esAnonimo; // Añadir este campo

  Post({
    required this.id,
    this.autorId,
    this.autorNombre,
    this.autorApellido,
    this.autorFoto,
    required this.pregunta,
    required this.contenido,
    this.archivoUrl,
    required this.fechaCreacion,
    required this.esAnonimo,
  });

  factory Post.fromJson(Map<String, dynamic> json) {
    if (json['id'] == null) {
      throw Exception("El campo 'id' es null en el JSON proporcionado");
    }

    return Post(
      id: json['id'] as int,
      autorId: json['autor_id'] as int?,
      autorNombre: json['alumno']?['nombre'] as String?,
      autorApellido: json['alumno']?['apellido'] as String?,
      autorFoto: json['foto'] as String?,
      pregunta: json['pregunta'] as String,
      contenido: json['contenido'] as String,
      archivoUrl:
          json['archivos'] != null && (json['archivos'] as List).isNotEmpty
              ? (json['archivos'] as List).first['archivo_url'] as String?
              : null,
      fechaCreacion: DateTime.parse(json['fechacreacion'] as String),
      esAnonimo: json['es_anonimo'] as bool,
    );
  }
}

class Reply {
  final int id;
  final int postForoId;
  final int autorId;
  final String? autorNombre;
  final String? autorApellido;
  final String? autorFoto; // URL de la foto del autor
  final String contenido;
  final String? archivoUrl; // URL del archivo adjunto, si existe
  final DateTime fechaCreacion;

  Reply({
    required this.id,
    required this.postForoId,
    required this.autorId,
    this.autorNombre,
    this.autorApellido,
    this.autorFoto,
    required this.contenido,
    this.archivoUrl,
    required this.fechaCreacion,
  });

  factory Reply.fromJson(Map<String, dynamic> json) {
    Map<String, dynamic> replyJson =
        json.containsKey('reply') ? json['reply'] : json;

    if (replyJson['id'] == null) {
      throw Exception("El campo 'id' es null en el JSON proporcionado");
    }
    if (replyJson['postforo_id'] == null) {
      throw Exception(
          "El campo 'postforo_id' es null en el JSON proporcionado");
    }
    if (replyJson['autor_id'] == null) {
      throw Exception("El campo 'autor_id' es null en el JSON proporcionado");
    }

    return Reply(
      id: replyJson['id'] as int,
      postForoId: replyJson['postforo_id'] as int,
      autorId: replyJson['autor_id'] as int,
      autorNombre: replyJson['alumno']?['nombre'] as String?,
      autorApellido: replyJson['alumno']?['apellido'] as String?,
      autorFoto: replyJson['foto'] as String?,
      contenido: replyJson['contenido'] as String,
      archivoUrl: replyJson['archivos'] != null &&
              (replyJson['archivos'] as List).isNotEmpty
          ? (replyJson['archivos'] as List).first['archivo_url'] as String
          : null,
      fechaCreacion: DateTime.parse(replyJson['fechacreacion'] as String),
    );
  }
}

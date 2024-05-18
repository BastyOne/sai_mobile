class User {
  final String token;
  final int userId;
  final String userType;
  final int rol;
  final int? carreraId; // Puede ser null si no es un alumno

  User({
    required this.token,
    required this.userId,
    required this.userType,
    required this.rol,
    this.carreraId,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      userId: json['userId'],
      userType: json['userType'],
      rol: json['rol'],
      carreraId: json['carrera_id'],
    );
  }
}

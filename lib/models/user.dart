class User {
  final String token;
  final int
      userId; // Asegúrate de que esta propiedad esté presente en la clase User
  final String userType;
  final int rol;

  User(
      {required this.token,
      required this.userId,
      required this.userType,
      required this.rol});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      token: json['token'],
      userId: json[
          'userId'], // La clave debe coincidir con la respuesta del backend
      userType: json['userType'],
      rol: json['rol'],
    );
  }
}

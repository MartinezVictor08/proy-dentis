class Usuario {
  final String id;
  final String email;
  final String nombre;
  final String rol; // e.g., 'admin', 'doctor'

  Usuario({
    required this.id,
    required this.email,
    required this.nombre,
    required this.rol,
  });

  factory Usuario.fromMap(Map<String, dynamic> data, String id) {
    return Usuario(
      id: id,
      email: data['email'] ?? '',
      nombre: data['nombre'] ?? '',
      rol: data['rol'] ?? 'doctor',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'email': email,
      'nombre': nombre,
      'rol': rol,
    };
  }
}
class Paciente {
  final String id;
  final String nombre;
  final String apellido;
  final String telefono;
  final String email;
  final DateTime fechaNacimiento;
  final String direccion;
  final String historialMedico;

  Paciente({
    required this.id,
    required this.nombre,
    required this.apellido,
    required this.telefono,
    required this.email,
    required this.fechaNacimiento,
    required this.direccion,
    required this.historialMedico,
  });

  factory Paciente.fromMap(Map<String, dynamic> data, String id) {
    return Paciente(
      id: id,
      nombre: data['nombre'] ?? '',
      apellido: data['apellido'] ?? '',
      telefono: data['telefono'] ?? '',
      email: data['email'] ?? '',
      fechaNacimiento: DateTime.parse(data['fechaNacimiento'] ?? DateTime.now().toIso8601String()),
      direccion: data['direccion'] ?? '',
      historialMedico: data['historialMedico'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'nombre': nombre,
      'apellido': apellido,
      'telefono': telefono,
      'email': email,
      'fechaNacimiento': fechaNacimiento.toIso8601String(),
      'direccion': direccion,
      'historialMedico': historialMedico,
    };
  }
}
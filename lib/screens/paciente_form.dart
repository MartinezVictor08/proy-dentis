import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../services/firestore_service.dart';

class PacienteForm extends StatefulWidget {
  final Paciente? paciente;

  const PacienteForm({Key? key, this.paciente}) : super(key: key);

  @override
  State<PacienteForm> createState() => _PacienteFormState();
}

class _PacienteFormState extends State<PacienteForm> {
  final FirestoreService _firestore = FirestoreService();
  final TextEditingController _nombreController = TextEditingController();
  final TextEditingController _apellidoController = TextEditingController();
  final TextEditingController _telefonoController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _direccionController = TextEditingController();
  final TextEditingController _historialController = TextEditingController();
  DateTime _fechaNacimiento = DateTime.now();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    if (widget.paciente != null) {
      _nombreController.text = widget.paciente!.nombre;
      _apellidoController.text = widget.paciente!.apellido;
      _telefonoController.text = widget.paciente!.telefono;
      _emailController.text = widget.paciente!.email;
      _direccionController.text = widget.paciente!.direccion;
      _historialController.text = widget.paciente!.historialMedico;
      _fechaNacimiento = widget.paciente!.fechaNacimiento;
    }
  }

  // Función para ayudar a crear campos de texto con el mismo estilo del Login
  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    int maxLines = 1,
    TextInputType keyboardType = TextInputType.text,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16.0),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: Colors.blue[600]),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue[600]!, width: 2),
          ),
        ),
      ),
    );
  }

  Future<void> _savePaciente() async {
    if (_nombreController.text.isEmpty || _apellidoController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Nombre y Apellido son obligatorios')),
      );
      return;
    }

    setState(() => _isLoading = true);
    Paciente paciente = Paciente(
      id: widget.paciente?.id ?? DateTime.now().millisecondsSinceEpoch.toString(),
      nombre: _nombreController.text.trim(),
      apellido: _apellidoController.text.trim(),
      telefono: _telefonoController.text.trim(),
      email: _emailController.text.trim(),
      fechaNacimiento: _fechaNacimiento,
      direccion: _direccionController.text.trim(),
      historialMedico: _historialController.text.trim(),
    );

    try {
      if (widget.paciente == null) {
        await _firestore.addPaciente(paciente);
      } else {
        await _firestore.updatePaciente(paciente);
      }
      if (mounted) Navigator.pop(context);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text('Error: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.paciente == null ? 'Nuevo Paciente' : 'Editar Paciente'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[600],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Información Personal',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.blue[800],
                ),
              ),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nombreController,
                label: 'Nombre',
                icon: Icons.person,
              ),
              _buildTextField(
                controller: _apellidoController,
                label: 'Apellido',
                icon: Icons.person_outline,
              ),
              _buildTextField(
                controller: _telefonoController,
                label: 'Teléfono',
                icon: Icons.phone,
                keyboardType: TextInputType.phone,
              ),
              _buildTextField(
                controller: _emailController,
                label: 'Email',
                icon: Icons.email,
                keyboardType: TextInputType.emailAddress,
              ),
              _buildTextField(
                controller: _direccionController,
                label: 'Dirección',
                icon: Icons.location_on,
              ),
              _buildTextField(
                controller: _historialController,
                label: 'Historial Médico / Notas',
                icon: Icons.medical_services,
                maxLines: 3,
              ),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 55,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _savePaciente,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[600],
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    elevation: 2,
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          widget.paciente == null ? 'Guardar Paciente' : 'Actualizar Datos',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
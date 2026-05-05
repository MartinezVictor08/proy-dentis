import 'package:flutter/material.dart';
import '../models/paciente.dart';
import '../services/firestore_service.dart';
import '../screens/paciente_form.dart';

class PacienteListScreen extends StatefulWidget {
  const PacienteListScreen({Key? key}) : super(key: key);

  @override
  State<PacienteListScreen> createState() => _PacienteListScreenState();
}

class _PacienteListScreenState extends State<PacienteListScreen> {
  final FirestoreService _firestore = FirestoreService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[50], // Fondo ligeramente gris para que las tarjetas resalten
      appBar: AppBar(
        title: const Text('Gestión de Pacientes'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[600], // Azul consistente con Login y Home
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => Navigator.push(
          context, 
          MaterialPageRoute(builder: (_) => const PacienteForm())
        ),
        icon: const Icon(Icons.add),
        label: const Text('Nuevo Paciente'),
        backgroundColor: Colors.blue[600], // Mismo azul para el botón de acción
      ),
      body: StreamBuilder<List<Paciente>>(
        stream: _firestore.getPacientesStream(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}', style: const TextStyle(color: Colors.red)));
          }
          if (!snapshot.hasData) {
            return Center(child: CircularProgressIndicator(color: Colors.blue[600]));
          }
          
          List<Paciente> pacientes = snapshot.data!;
          
          if (pacientes.isEmpty) {
            return Padding(
              padding: const EdgeInsets.all(32.0),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.people_outline, size: 100, color: Colors.blue[200]),
                    const SizedBox(height: 20),
                    Text(
                      'No hay pacientes registrados',
                      style: TextStyle(
                        fontSize: 20, 
                        fontWeight: FontWeight.bold, 
                        color: Colors.blue[800]
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    const Text(
                      'Comienza agregando un paciente con el botón azul de abajo.',
                      textAlign: TextAlign.center,
                      style: TextStyle(color: Colors.grey),
                    ),
                  ],
                ),
              ),
            );
          }
          
          return ListView.builder(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80), // Padding extra abajo para el botón flotante
            itemCount: pacientes.length,
            itemBuilder: (context, index) {
              Paciente paciente = pacientes[index];
              return Card(
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                margin: const EdgeInsets.only(bottom: 12),
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                  leading: CircleAvatar(
                    radius: 25,
                    backgroundColor: Colors.blue[50],
                    child: Text(
                      paciente.nombre.isNotEmpty ? paciente.nombre[0].toUpperCase() : 'P',
                      style: TextStyle(
                        color: Colors.blue[600], 
                        fontWeight: FontWeight.bold,
                        fontSize: 20
                      ),
                    ),
                  ),
                  title: Text(
                    '${paciente.nombre} ${paciente.apellido}', 
                    style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)
                  ),
                  subtitle: Padding(
                    padding: const EdgeInsets.only(top: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Icon(Icons.phone, size: 14, color: Colors.blue[300]),
                            const SizedBox(width: 4),
                            Text(paciente.telefono),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Row(
                          children: [
                            Icon(Icons.email, size: 14, color: Colors.blue[300]),
                            const SizedBox(width: 4),
                            Text(paciente.email, style: const TextStyle(fontSize: 13)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: Icon(Icons.edit_outlined, color: Colors.blue[600]),
                        onPressed: () => Navigator.push(
                          context, 
                          MaterialPageRoute(builder: (_) => PacienteForm(paciente: paciente))
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete_outline, color: Colors.redAccent),
                        onPressed: () => _confirmarEliminacion(context, paciente),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }

  // Mejora: Diálogo de confirmación para no borrar por error
  void _confirmarEliminacion(BuildContext context, Paciente paciente) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('¿Eliminar paciente?'),
        content: Text('¿Estás seguro de que deseas eliminar a ${paciente.nombre}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancelar'),
          ),
          TextButton(
            onPressed: () async {
              await _firestore.deletePaciente(paciente.id);
              if (context.mounted) Navigator.pop(context);
            },
            child: const Text('Eliminar', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }
}
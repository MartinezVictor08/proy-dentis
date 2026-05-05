import 'package:flutter/material.dart';
import '../services/auth_service.dart';
import '../screens/paciente_list.dart';
import '../screens/login_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final AuthService _auth = AuthService();
    
    return Scaffold(
      appBar: AppBar(
        title: const Text('Smile Center - Home'),
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.blue[600], // Color consistente con el Login
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () async {
              await _auth.signOut();
              if (context.mounted) {
                Navigator.pushReplacement(
                  context, 
                  MaterialPageRoute(builder: (_) => const LoginScreen())
                );
              }
            },
          ),
        ],
      ),
      body: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(24.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icono central para mantener la identidad visual
            Icon(
              Icons.favorite,
              size: 100,
              color: Colors.blue[600],
            ),
            const SizedBox(height: 24),
            
            // Título estilizado
            Text(
              'Bienvenido a Smile Center',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Colors.blue[600],
                  ),
            ),
            const SizedBox(height: 10),
            const Text(
              'Sistema de Gestión Odontológica',
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const SizedBox(height: 60),
            
            // Botón principal con el mismo estilo que el Login
            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton.icon(
                onPressed: () => Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (_) => const PacienteListScreen())
                ),
                icon: const Icon(Icons.people),
                label: const Text(
                  'Gestionar Pacientes',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[600],
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  elevation: 4,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/paciente.dart';

class FirestoreService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // CRUD for Pacientes
  Future<void> addPaciente(Paciente paciente) async {
    await _db.collection('pacientes').doc(paciente.id).set(paciente.toMap());
  }

  Future<List<Paciente>> getPacientes() async {
    QuerySnapshot snapshot = await _db.collection('pacientes').get();
    return snapshot.docs.map((doc) => Paciente.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList();
  }

  Future<void> updatePaciente(Paciente paciente) async {
    await _db.collection('pacientes').doc(paciente.id).update(paciente.toMap());
  }

  Future<void> deletePaciente(String id) async {
    await _db.collection('pacientes').doc(id).delete();
  }

  Stream<List<Paciente>> getPacientesStream() {
    return _db.collection('pacientes').snapshots().map((snapshot) =>
        snapshot.docs.map((doc) => Paciente.fromMap(doc.data() as Map<String, dynamic>, doc.id)).toList());
  }
}
import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Resumen extends StatelessWidget {
  final ResumenService resumenService = ResumenService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Resumen'),
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _obtenerResumen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles.'));
          } else {
            final resumen = snapshot.data!;
            final nivelInversorEjercicio1 = _calcularNivelInversorEjercicio1(resumen['Ej1'] ?? 0);
            final nivelInversorEjercicio2 = _calcularNivelInversorEjercicio2(resumen['Ej2'] ?? 0);
            final nivelInversorEjercicio3 = _calcularNivelInversorEjercicio3(resumen['Ej3'] ?? 0);
            final nivelInversorTotal = _calcularNivelInversorTotal(
              nivelInversorEjercicio1,
              nivelInversorEjercicio2,
              nivelInversorEjercicio3,
            );
            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  _buildTituloEjercicio1('Ejercicio 1', resumen['Ej1'] ?? 0, nivelInversorEjercicio1),
                  _buildTituloEjercicio2('Ejercicio 2', resumen['Ej2'] ?? 0, nivelInversorEjercicio2),
                  _buildTituloEjercicio3('Ejercicio 3', resumen['Ej3'] ?? 0, nivelInversorEjercicio3),
                  const SizedBox(height: 20.0),
                  _buildTotalRow(nivelInversorTotal),
                  const SizedBox(height: 70.0),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => MenuPrincipal(onTap: () {})),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Colors.white,
                      backgroundColor: Colors.lightBlueAccent,
                      padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 75.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text(
                      'Continuar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  )
                ],
              ),
            );
          }
        },
      ),
    );
  }

  Widget _buildTituloEjercicio1(String ejercicio, int respiraciones, int nivelInversor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          ejercicio,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Column(
          children: [
            Text('Respiraciones por min: $respiraciones', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Nivel de inversor: $nivelInversor', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
  Widget _buildTituloEjercicio2(String ejercicio, int respiraciones, int nivelInversor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          ejercicio,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Column(
          children: [
            Text('Media de 3 respiraciones: $respiraciones', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Nivel de inversor: $nivelInversor', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }
  Widget _buildTituloEjercicio3(String ejercicio, int respiraciones, int nivelInversor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          ejercicio,
          style: const TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Column(
          children: [
            Text('Último número alcanzado: $respiraciones', style: const TextStyle(fontWeight: FontWeight.bold)),
            Text('Nivel de inversor: $nivelInversor', style: const TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        const SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildTotalRow(int nivelInversorTotal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        const Text(
          'Nivel de inversor total:',
          style: TextStyle(fontSize: 24.0, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8.0),
        Text(
          '$nivelInversorTotal',
          style: const TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  Future<Map<String, dynamic>> _obtenerResumen() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    String nombreUsuario = user.uid;

    return await resumenService.obtenerResumen(nombreUsuario);
  }

  int _calcularNivelInversorEjercicio1(int valor) {
    if (valor >= 14) return 0;
    if (valor >= 13) return 1;
    if (valor >= 12) return 2;
    if (valor >= 11) return 3;
    if (valor >= 10) return 4;
    if (valor >= 9) return 5;
    if (valor >= 8) return 6;
    if (valor >= 7) return 7;
    if (valor >= 6) return 8;
    if (valor >= 5) return 9;
    if (valor >= 4) return 10;
    if (valor >= 3) return 11;
    return 0;
  }

  int _calcularNivelInversorEjercicio2(int valor) {
    if (valor >= 301) return 11;
    if (valor >= 271) return 10;
    if (valor >= 241) return 9;
    if (valor >= 211) return 8;
    if (valor >= 181) return 7;
    if (valor >= 151) return 6;
    if (valor >= 121) return 5;
    if (valor >= 91) return 4;
    if (valor >= 61) return 3;
    if (valor >= 41) return 2;
    if (valor >= 21) return 1;
    return 0;
  }

  int _calcularNivelInversorEjercicio3(int valor) {
    if (valor >= 78) return 11;
    if (valor >= 71) return 10;
    if (valor >= 64) return 9;
    if (valor >= 57) return 8;
    if (valor >= 50) return 7;
    if (valor >= 43) return 6;
    if (valor >= 36) return 5;
    if (valor >= 29) return 4;
    if (valor >= 22) return 3;
    if (valor >= 15) return 2;
    if (valor >= 8) return 1;
    return 0;
  }

  int _calcularNivelInversorTotal(int nivelEjercicio1, int nivelEjercicio2, int nivelEjercicio3) {
    return (nivelEjercicio1 * 10 + nivelEjercicio2 * 30 + nivelEjercicio3 * 60) ~/ 100;
  }
}

class ResumenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> obtenerResumen(String nombreUsuario) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Inversiones')
          .doc(nombreUsuario)
          .collection('Inversión')
          .orderBy('fecha1', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot lastDocument = querySnapshot.docs.first;
        return lastDocument.data() as Map<String, dynamic>;
      } else {
        return {};
      }
    } catch (e) {
      print('Error al obtener el resumen: $e');
      return {};
    }
  }
}

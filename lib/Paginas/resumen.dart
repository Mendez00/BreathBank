import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class Resumen extends StatelessWidget {
  final ResumenService resumenService = ResumenService(); // Instancia de ResumenService para acceder a métodos de servicio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: const Text('Resumen'), // Título de la AppBar
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _obtenerResumen(), // Llamada asincrónica para obtener el resumen
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator()); // Muestra un indicador de carga mientras se espera la respuesta
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}')); // Muestra un mensaje de error si falla la obtención de datos
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No hay datos disponibles.')); // Muestra un mensaje si no hay datos disponibles
          } else {
            final resumen = snapshot.data!; // Datos obtenidos correctamente
            final nivelInversorEjercicio1 = _calcularNivelInversorEjercicio1(resumen['Ej1'] ?? 0); // Cálculo de niveles de inversor
            final nivelInversorEjercicio2 = _calcularNivelInversorEjercicio2(resumen['Ej2'] ?? 0);
            final nivelInversorEjercicio3 = _calcularNivelInversorEjercicio3(resumen['Ej3'] ?? 0);
            final nivelInversorTotal = _calcularNivelInversorTotal(
              nivelInversorEjercicio1,
              nivelInversorEjercicio2,
              nivelInversorEjercicio3,
            );

            _guardarNivelInversorTotal(resumen['documentId'], nivelInversorTotal); // Actualiza el nivel de inversor total

            return Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40.0),
                  _buildTituloEjercicio1('Ejercicio 1', resumen['Ej1'] ?? 0, nivelInversorEjercicio1), // Construye la sección para cada ejercicio
                  _buildTituloEjercicio2('Ejercicio 2', resumen['Ej2'] ?? 0, nivelInversorEjercicio2),
                  _buildTituloEjercicio3('Ejercicio 3', resumen['Ej3'] ?? 0, nivelInversorEjercicio3),
                  const SizedBox(height: 20.0),
                  _buildTotalRow(nivelInversorTotal), // Construye la fila para mostrar el nivel de inversor total
                  const SizedBox(height: 70.0),
                  ElevatedButton( // Botón para continuar al menú principal
                    onPressed: () {
                      Navigator.pushReplacement(
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

  // Widgets para construir la información de cada ejercicio
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

  // Método para guardar el nivel de inversor total en la base de datos
  Future<void> _guardarNivelInversorTotal(String? documentoId, int nivelInversorTotal) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null && documentoId != null) {
      await resumenService.actualizarNivelInversorTotal(user.uid, documentoId, nivelInversorTotal);
    }
  }

  // Método para obtener el resumen de la base de datos
  Future<Map<String, dynamic>> _obtenerResumen() async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user == null) {
      throw Exception('Usuario no autenticado');
    }

    String nombreUsuario = user.uid;

    final resumen = await resumenService.obtenerResumen(nombreUsuario);
    if (resumen.isNotEmpty) {
      resumen['documentId'] = resumen['documentId'];
    }
    return resumen;
  }

  // Métodos para calcular el nivel de inversor de cada ejercicio
  int _calcularNivelInversorEjercicio1(int valor) {
    if (valor >= 18) return 0;
    if (valor >= 16) return 1;
    if (valor >= 14) return 2;
    if (valor >= 12) return 3;
    if (valor >= 10) return 4;
    if (valor >= 9) return 5;
    if (valor >= 7) return 6;
    if (valor >= 6) return 7;
    if (valor >= 5) return 8;
    if (valor >= 4) return 9;
    return 0;
  }

  int _calcularNivelInversorEjercicio2(int valor) {
    if (valor >= 301) return 9;
    if (valor >= 271) return 8;
    if (valor >= 241) return 7;
    if (valor >= 211) return 6;
    if (valor >= 191) return 5;
    if (valor >= 151) return 4;
    if (valor >= 111) return 3;
    if (valor >= 71) return 2;
    if (valor >= 31) return 1;
    return 0;
  }

  int _calcularNivelInversorEjercicio3(int valor) {
    if (valor >= 90) return 9;
    if (valor >= 80) return 8;
    if (valor >= 70) return 7;
    if (valor >= 60) return 6;
    if (valor >= 50) return 5;
    if (valor >= 40) return 4;
    if (valor >= 30) return 3;
    if (valor >= 20) return 2;
    if (valor >= 10) return 1;
    return 0;
  }

  // Método para calcular el nivel de inversor total
  int _calcularNivelInversorTotal(int nivelEjercicio1, int nivelEjercicio2, int nivelEjercicio3) {
    return (nivelEjercicio1 * 10 + nivelEjercicio2 * 30 + nivelEjercicio3 * 60) ~/ 100;
  }
}

// Clase de servicio para manejar operaciones relacionadas con la base de datos
class ResumenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Método para obtener el resumen de un usuario específico
  Future<Map<String, dynamic>> obtenerResumen(String nombreUsuario) async {
    try {
      QuerySnapshot querySnapshot = await _firestore
          .collection('Prueba de nivel')
          .doc(nombreUsuario)
          .collection('Pruebas')
          .orderBy('fecha1', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentSnapshot lastDocument = querySnapshot.docs.first;
        final data = lastDocument.data() as Map<String, dynamic>;
        data['documentId'] = lastDocument.id;
        return data;
      } else {
        return {};
      }
    } catch (e) {
      print('Error al obtener el resumen: $e');
      return {};
    }
  }

  // Método para actualizar el nivel de inversor total en la base de datos
  Future<void> actualizarNivelInversorTotal(String nombreUsuario, String documentoId, int nivelInversorTotal) async {
    try {
      await _firestore
          .collection('Prueba de nivel')
          .doc(nombreUsuario)
          .collection('Pruebas')
          .doc(documentoId)
          .update({'Nivel Inversor': nivelInversorTotal});
    } catch (e) {
      print('Error al actualizar el nivel de inversor total: $e');
    }
  }
}

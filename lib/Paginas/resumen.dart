import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:cloud_firestore/cloud_firestore.dart'; // Importa el servicio

class Resumen extends StatelessWidget {
  final ResumenService _resumenService =
      ResumenService(); // Instancia del servicio

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:
            Colors.lightBlueAccent, // Cambiar color de fondo del AppBar
        title: Text('Resumen'), // Alinear título al centro del AppBar
        centerTitle: true,
      ),
      body: FutureBuilder<Map<String, dynamic>>(
        future: _obtenerResumen(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Muestra un indicador de carga mientras se obtienen los datos
            return Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            // Muestra un mensaje de error si ocurre algún error
            return Center(child: Text('Error: ${snapshot.error}'));
          } else {
            // Muestra los datos obtenidos en el resumen
            final resumen = snapshot.data!;
            return Center(
                child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(height: 40.0),
                _buildTituloEjercicio(
                    'Ejercicio 1',
                    resumen['respiracionesEjercicio1'],
                    resumen['nivelInversorEjercicio1']),
                _buildTituloEjercicio(
                    'Ejercicio 2',
                    resumen['respiracionesEjercicio2'],
                    resumen['nivelInversorEjercicio2']),
                _buildTituloEjercicio(
                    'Ejercicio 3',
                    resumen['respiracionesEjercicio3'],
                    resumen['nivelInversorEjercicio3']),
                SizedBox(height: 20.0),
                _buildTotalRow(resumen['nivelInversorTotal']),
                SizedBox(height: 70.0),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MenuPrincipal(onTap: () {  },)),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors
                        .lightBlueAccent, // Cambiar color de texto del botón
                    padding: const EdgeInsets.symmetric(
                        vertical: 35.0, horizontal: 75.0),
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
            ));
          }
        },
      ),
    );
  }

  Widget _buildTituloEjercicio(
      String ejercicio, int respiraciones, int nivelInversor) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          ejercicio, // Título del ejercicio
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold), // Estilo del título
        ),
        SizedBox(height: 8.0),
        Column(
          children: [
            Text('Nº respiraciones: $respiraciones' ,
                style: TextStyle(fontWeight: FontWeight.bold)),
            Text('Nivel de inversor: $nivelInversor',
                style: TextStyle(fontWeight: FontWeight.bold)),
          ],
        ),
        SizedBox(height: 20.0),
      ],
    );
  }

  Widget _buildTotalRow(int nivelInversorTotal) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text(
          'Nivel de inversor total:', // Título del nivel de inversor total
          style: TextStyle(
              fontSize: 24.0, fontWeight: FontWeight.bold), // Estilo del título
        ),
        SizedBox(height: 8.0),
        Text(
          '$nivelInversorTotal', // Valor del nivel de inversor total
          style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.bold),
        ),
      ],
    );
  }

  // Método para simular la obtención de datos del resumen (simplemente devuelve datos ficticios)
  Future<Map<String, dynamic>> _obtenerResumen() async {
    await Future.delayed(Duration(
        seconds: 2)); // Simula un retardo de 2 segundos para obtener los datos
    return {
      'respiracionesEjercicio1': 0,
      'nivelInversorEjercicio1': 0,
      'respiracionesEjercicio2': 0,
      'nivelInversorEjercicio2': 0,
      'respiracionesEjercicio3': 0,
      'nivelInversorEjercicio3': 0,
      'nivelInversorTotal': 0,
    };
  }
}

class ResumenService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<Map<String, dynamic>> obtenerResumen(String nombreUsuario) async {
    try {
      final DocumentSnapshot snapshot =
          await _firestore.collection('usuarios').doc(nombreUsuario).get();

      if (snapshot.exists) {
        return snapshot.data() as Map<String, dynamic>;
      } else {
        // En caso de que el documento no exista, retornar un mapa vacío
        return {};
      }
    } catch (e) {
      print('Error al obtener el resumen: $e');
      // En caso de error, retornar un mapa vacío o lanzar una excepción según lo desees
      return {};
    }
  }
}

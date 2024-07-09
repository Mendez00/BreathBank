import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

/// Widget para la pantalla del Ejercicio 1.
class Ejercicio1 extends StatefulWidget {
  final VoidCallback onEjercicioCompleto;

  const Ejercicio1({Key? key, required this.onEjercicioCompleto}) : super(key: key);

  @override
  State<Ejercicio1> createState() => EstadoEjercicio1();
}

class EstadoEjercicio1 extends State<Ejercicio1> {
  bool _completado = false; // Variable para verificar si se ha completado el ejercicio
  bool cronoActivado = false; // Variable para controlar el estado del cronómetro
  Timer? contador; // Timer para contar el tiempo
  int segunosRestantes = 60; // Tiempo inicial del cronómetro
  final TextEditingController subirDatos = TextEditingController(); // Controlador del campo de texto para ingresar datos

  @override
  void dispose() {
    subirDatos.dispose(); // Liberar recursos del controlador de texto
    contador?.cancel(); // Cancelar el temporizador si está activo
    super.dispose();
  }

  void _startTimer() {
    setState(() {
      cronoActivado = true; // Activar el cronómetro
      segunosRestantes = 60; // Reiniciar el contador de tiempo
    });

    contador = Timer.periodic(Duration(seconds: 1), (timer) {
      if (segunosRestantes > 0) {
        setState(() {
          segunosRestantes--; // Reducir el tiempo restante
        });
      } else {
        contador?.cancel(); // Cancelar el temporizador al llegar a cero
        setState(() {
          cronoActivado = false; // Desactivar el cronómetro
        });
      }
    });
  }

  void resetContador() {
    contador?.cancel(); // Cancelar el temporizador si está activo
    setState(() {
      segunosRestantes = 60; // Reiniciar el contador de tiempo
      cronoActivado = false; // Desactivar el cronómetro
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              const Padding(
                padding: EdgeInsets.symmetric(horizontal: 25.0),
                child: Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'Ejercicio 1\n',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text:
                        'Lee la ayuda y después utiliza el cronómetro para completar el ejercicio',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              IconButton(
                icon: Icon(Icons.help),
                iconSize: 60,
                color: Colors.lightBlueAccent,
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: Text('Ayuda'),
                        content: const Text(
                            'Estando en reposo (sin actividad física intensa previa) túmbate boca arriba, descansando durante 1 minuto y a continuación cuenta las respiraciones que haces durante el siguiente minuto.'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.pop(context);
                            },
                            child: const Text('Cerrar'),
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20),
              Text(
                '$segunosRestantes seg',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 50,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 20),
              if (!cronoActivado)
                ElevatedButton(
                  onPressed: _startTimer,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 25.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Iniciar cronómetro',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              if (cronoActivado)
                ElevatedButton(
                  onPressed: resetContador,
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(
                        vertical: 15.0, horizontal: 25.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Reiniciar',
                    style: TextStyle(fontSize: 18.0),
                  ),
                ),
              const SizedBox(height: 60),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: subirDatos,
                  decoration: const InputDecoration(
                    labelText: 'Introduzca el número de respiraciones',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  guardarDatos(context);
                },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white,
                  backgroundColor: Colors.lightBlueAccent,
                  padding: const EdgeInsets.symmetric(
                      vertical: 35.0, horizontal: 75.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Guardar datos',
                  style: TextStyle(fontSize: 18.0),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Método para guardar los datos del ejercicio en Firestore.
  void guardarDatos(BuildContext context) async {
    await Firebase.initializeApp(); // Inicializar Firebase si aún no se ha hecho

    FirebaseFirestore firestore = FirebaseFirestore.instance; // Instancia de Firestore

    final FirebaseAuth auth = FirebaseAuth.instance; // Instancia de FirebaseAuth
    User? user = auth.currentUser; // Usuario actual autenticado

    int respiraciones = int.tryParse(subirDatos.text) ?? 0; // Obtener el número de respiraciones desde el campo de texto

    try {
      String username = user!.uid; // Obtener el ID único del usuario
      DocumentReference userDocRef =
      firestore.collection('Prueba de nivel').doc(username); // Referencia al documento del usuario
      Timestamp fechaActual = Timestamp.now(); // Obtener la fecha y hora actual

      int numeroPrueba = 1; // Número inicial de la prueba
      QuerySnapshot querySnapshot =
      await userDocRef.collection('Pruebas').get(); // Obtener las pruebas existentes del usuario
      if (querySnapshot.docs.isNotEmpty) {
        numeroPrueba = querySnapshot.docs.length + 1; // Determinar el número de la siguiente prueba
      }

      // Verificar y borrar documentos que no contienen Ej1, Ej2 y Ej3
      for (var doc in querySnapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        if (!data.containsKey('Ej1') ||
            !data.containsKey('Ej2') ||
            !data.containsKey('Ej3')) {
          await doc.reference.delete(); // Eliminar documentos no válidos
        }
      }

      DocumentReference pruebaDocRef =
      userDocRef.collection('Pruebas').doc('Prueba $numeroPrueba'); // Referencia a la nueva prueba

      Map<String, dynamic> ejercicioData = {
        'fecha1': fechaActual, // Fecha y hora de la prueba
        'Ej1': respiraciones, // Número de respiraciones registrado
      };
      await pruebaDocRef.set(ejercicioData); // Guardar los datos de la prueba en Firestore
      setState(() {
        _completado = true; // Marcar el ejercicio como completado
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Datos guardados correctamente'), // Mensaje de éxito
        duration: Duration(seconds: 2), // Duración del SnackBar
      ));

      widget.onEjercicioCompleto(); // Llamar a la función proporcionada al completar el ejercicio
      Navigator.pop(context); // Cerrar la pantalla actual y volver a la anterior
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los datos: $error'), // Mensaje de error
        duration: Duration(seconds: 2), // Duración del SnackBar
      ));
    }
  }
}

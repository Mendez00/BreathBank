import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Ejercicio2 extends StatefulWidget {
  final VoidCallback onEjercicioCompleto;

  const Ejercicio2({Key? key, required this.onEjercicioCompleto}) : super(key: key);

  @override
  State<Ejercicio2> createState() => EstadoEjercicio2();
}

class EstadoEjercicio2 extends State<Ejercicio2> {
  bool _completado = true; // Variable para controlar si el ejercicio está completado

  final TextEditingController dato1 = TextEditingController(); // Controlador para el primer dato de tiempo
  final TextEditingController dato2 = TextEditingController(); // Controlador para el segundo dato de tiempo
  final TextEditingController dato3 = TextEditingController(); // Controlador para el tercer dato de tiempo
  int media = 0; // Variable para calcular y almacenar la media de los tiempos

  Timer? contador; // Timer para el cronómetro
  int tiempo = 0; // Variable para almacenar el tiempo del cronómetro
  bool cronoActivo = false; // Variable para controlar el estado del cronómetro

  @override
  void dispose() {
    dato1.dispose();
    dato2.dispose();
    dato3.dispose();
    contador?.cancel();
    super.dispose();
  }

  // Función para iniciar o reiniciar el cronómetro
  void iniciarContador() {
    if (cronoActivo) {
      resetContador();
    } else {
      setState(() {
        tiempo = 0;
        cronoActivo = true;
      });
      contador?.cancel();
      contador = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          tiempo++;
        });
      });
    }
  }

  // Función para detener o continuar el cronómetro
  void pararContador() {
    if (cronoActivo) {
      contador?.cancel();
      setState(() {
        cronoActivo = false;
      });
    } else {
      setState(() {
        cronoActivo = true;
      });
      contador = Timer.periodic(Duration(seconds: 1), (timer) {
        setState(() {
          tiempo++;
        });
      });
    }
  }

  // Función para reiniciar el cronómetro
  void resetContador() {
    contador?.cancel();
    setState(() {
      tiempo = 0;
      cronoActivo = false;
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
                        text: 'Ejercicio 2\n',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextSpan(
                        text: 'Lee la ayuda y después utiliza el cronómetro para completar el ejercicio',
                        style: TextStyle(
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 10),
              IconButton(
                icon: const Icon(Icons.help),
                iconSize: 50,
                color: Colors.lightBlueAccent,
                onPressed: () {
                  // Mostrar diálogo de ayuda
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('Ayuda'),
                        content: const Text(
                            'Continúa tumbado boca arriba y cronometra el tiempo empleado en realizar tres respiraciones de la forma más lenta posible, inspirando y espirando, cogiendo y soltando el aire por la nariz, sin pausas entre inspiración y espiración. La prueba debe ser tranquila y sin forzar la respiración. La prueba se realizará tres veces y se calculará la media entre ellas, anotándose el resultado obtenido en segundos.'),
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
              const SizedBox(height: 10),
              Text(
                '$tiempo seg',
                style: TextStyle(fontSize: 50, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: iniciarContador,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      primary: Colors.lightBlueAccent,
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      cronoActivo ? 'Reiniciar' : 'Iniciar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: pararContador,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      primary: cronoActivo ? Colors.red : Colors.green,
                      onPrimary: Colors.white,
                    ),
                    child: Text(
                      cronoActivo ? 'Parar' : 'Continuar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              // Campos para ingresar los tiempos de cada ronda
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: dato1,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo empleado 1ª ronda en s',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: dato2,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo empleado 2ª ronda en s',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: TextField(
                  controller: dato3,
                  decoration: const InputDecoration(
                    labelText: 'Tiempo empleado 3ª ronda en s',
                    border: OutlineInputBorder(),
                  ),
                  keyboardType: TextInputType.number,
                ),
              ),
              const SizedBox(height: 20),
              // Botón para guardar los datos en Firestore
              ElevatedButton(
                onPressed: () {
                  guardarDatos(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 30.0, horizontal: 75.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.lightBlueAccent,
                  onPrimary: Colors.white,
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

  // Función para guardar los datos en Firestore
  void guardarDatos(BuildContext context) async {
    await Firebase.initializeApp(); // Inicialización de Firebase

    FirebaseFirestore firestore = FirebaseFirestore.instance; // Instancia de Firestore

    final FirebaseAuth auth = FirebaseAuth.instance; // Instancia de FirebaseAuth para obtener el usuario actual
    User? user = auth.currentUser;

    // Obtención de los valores ingresados en los campos de texto
    int dato1Valor = int.tryParse(dato1.text) ?? 0;
    int dato2Valor = int.tryParse(dato2.text) ?? 0;
    int dato3Valor = int.tryParse(dato3.text) ?? 0;

    // Cálculo de la media de los tiempos
    media = (dato1Valor + dato2Valor + dato3Valor) ~/ 3;

    try {
      String username = user!.uid; // Obtención del UID del usuario actual
      DocumentReference userDocRef =
      firestore.collection('Prueba de nivel').doc(username); // Referencia al documento del usuario

      Timestamp fechaActual = Timestamp.now(); // Timestamp de la fecha actual

      // Consulta para obtener la última prueba y actualizar sus datos
      QuerySnapshot querySnapshot = await userDocRef
          .collection('Pruebas')
          .orderBy('fecha1', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference pruebaDocRef =
        userDocRef.collection('Pruebas').doc(querySnapshot.docs.last.id);

        // Datos a actualizar en Firestore
        Map<String, dynamic> mediaData = {
          'Ej2 Intento 1': dato1Valor,
          'Ej2 Intento 2': dato2Valor,
          'Ej2 Intento 3': dato3Valor,
          'Ej2': media,
          'fecha2': fechaActual,
        };

        // Actualización de los datos en Firestore
        await pruebaDocRef.update(mediaData);

        setState(() {
          _completado = true;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Datos guardados correctamente'),
          duration: Duration(seconds: 2),
        ));

        widget.onEjercicioCompleto();
        Navigator.pop(context);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('No se encontró el documento para actualizar.'),
          duration: Duration(seconds: 2),
        ));
      }
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los datos: $error'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}

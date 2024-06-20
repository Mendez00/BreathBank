import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:async';

class Ejercicio2 extends StatefulWidget {
  final VoidCallback onEjercicioCompleto;

  const Ejercicio2({Key? key, required this.onEjercicioCompleto})
      : super(key: key);

  @override
  State<Ejercicio2> createState() => EstadoEjercicio2();
}

class EstadoEjercicio2 extends State<Ejercicio2> {
  bool _completado = true;

  final TextEditingController dato1 = TextEditingController();
  final TextEditingController dato2 = TextEditingController();
  final TextEditingController dato3 = TextEditingController();
  int media = 0;

  Timer? contador;
  int tiempo = 0;
  bool cronoActivo = false;

  @override
  void dispose() {
    dato1.dispose();
    dato2.dispose();
    dato3.dispose();
    contador?.cancel();
    super.dispose();
  }

  void iniciarContador() {
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

  void pararContador() {
    contador?.cancel();
    setState(() {
      cronoActivo = false;
    });
  }

  void continuarContador() {
    setState(() {
      cronoActivo = true;
    });
    contador?.cancel();
    contador = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        tiempo++;
      });
    });
  }

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
                        text:
                            'Lea la ayuda y después utiliza el cronómetro para completar el ejercicio',
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
                    child: const Text(
                      'Iniciar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: cronoActivo ? pararContador : continuarContador,
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
                  const SizedBox(width: 10),
                  ElevatedButton(
                    onPressed: resetContador,
                    style: ElevatedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15.0, horizontal: 25.0),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      primary: Colors.orange,
                      onPrimary: Colors.white,
                    ),
                    child: const Text(
                      'Reiniciar',
                      style: TextStyle(fontSize: 18.0),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
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

  void guardarDatos(BuildContext context) async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    int dato1Valor = int.tryParse(dato1.text) ?? 0;
    int dato2Valor = int.tryParse(dato2.text) ?? 0;
    int dato3Valor = int.tryParse(dato3.text) ?? 0;

    media = (dato1Valor + dato2Valor + dato3Valor) ~/ 3;
    try {
      String username = user!.uid;
      DocumentReference userDocRef =
          firestore.collection('Prueba de nivel').doc(username);
      Timestamp fechaActual = Timestamp.now();

      QuerySnapshot querySnapshot = await userDocRef
          .collection('Pruebas')
          .orderBy('fecha1', descending: true)
          .limit(1)
          .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference pruebaDocRef =
            userDocRef.collection('Pruebas').doc(querySnapshot.docs.last.id);

        Map<String, dynamic> mediaData = {
          'Ej2 Intento 1': dato1Valor,
          'Ej2 Intento 2': dato2Valor,
          'Ej2 Intento 3': dato3Valor,
          'Ej2': media,
          'fecha2': fechaActual,
        };

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

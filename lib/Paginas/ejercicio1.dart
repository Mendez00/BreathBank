import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_timer_countdown/flutter_timer_countdown.dart';

class Ejercicio1 extends StatefulWidget {
  final VoidCallback onEjercicioCompleto;

  const Ejercicio1({Key? key, required this.onEjercicioCompleto})
      : super(key: key);

  @override
  State<Ejercicio1> createState() => EstadoEjercicio1();
}

class EstadoEjercicio1 extends State<Ejercicio1> {
  bool _completado = false;
  bool cronoActivado = false;
  final TextEditingController subirDatos = TextEditingController();

  @override
  void dispose() {
    subirDatos.dispose();
    super.dispose();
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
                const SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    IconButton(
                      icon: Icon(Icons.help),
                      iconSize: 50,
                      color: Colors.lightBlueAccent,
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Ayuda'),
                              content: const Text(
                                  'El participante en reposo (sin haber hecho ninguna actividad física intensa en los últimos 30 minutos) se tumba boca arriba, descansando durante 1 minuto y a continuación cuenta las respiraciones que hace durante el siguiente minuto.'),
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
                    const SizedBox(width: 20),
                    if (!cronoActivado)
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            cronoActivado = true;
                          });
                        },
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
                      TimerCountdown(
                        format: CountDownTimerFormat.minutesSeconds,
                        endTime: DateTime.now().add(
                          Duration(minutes: 1),
                        ),
                        onEnd: () {
                          setState(() {
                            cronoActivado = false;
                          });
                        },
                        timeTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        colonsTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                        descriptionTextStyle: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                        ),
                      ),
                  ],
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
                const SizedBox(height: 60),
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
        ));
  }
  void guardarDatos(BuildContext context) async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    int respiraciones = int.tryParse(subirDatos.text) ?? 0;

    try {
      String username = user!.uid;
      DocumentReference userDocRef =
          firestore.collection('Inversiones').doc(username);
      Timestamp fechaActual = Timestamp.now();

      int numeroPrueba = 1;
      QuerySnapshot querySnapshot =
          await userDocRef.collection('Inversión').get();
      if (querySnapshot.docs.isNotEmpty) {
        numeroPrueba = querySnapshot.docs.length + 1;
      }

      DocumentReference pruebaDocRef =
          userDocRef.collection('Inversión').doc('Inversión $numeroPrueba');

      Map<String, dynamic> ejercicioData = {
        'fecha1': fechaActual,
        'Ej1': respiraciones,
      };
      await pruebaDocRef.set(ejercicioData);
      setState(() {
        _completado = true;
      });
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Datos guardados correctamente'),
        duration: Duration(seconds: 2),
      ));

      widget.onEjercicioCompleto();
      Navigator.pop(context);
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los datos: $error'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}

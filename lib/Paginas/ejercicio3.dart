import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/Paginas/inversion.dart';

class Ejercicio3 extends StatefulWidget {
  @override
  State<Ejercicio3> createState() => EstadoEjercicio3();
}

class EstadoEjercicio3 extends State<Ejercicio3> {
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
                          text: 'Ejercicio 3\n',
                          style: TextStyle(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                          'Varias respiraciones progresivamente más largas guiadas por audio',
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
                              'El participante sigue tumbado cómodamente boca arriba y aproximadamente un minuto después de finalizar la prueba anterior reproducirá un audio que le guiará en la realización de respiraciones lentas conscientes donde los tiempos de inspiración y espiración son cada vez mayores, evaluando su resistencia ante respiraciones cada vez más largas. Sonará un pitido que indica el inicio de la inspiración y a los cuatro segundos dos pitidos que indica el inicio de la espiración. Estos intervalos irán incrementando su duración progresivamente. Cada aviso sonoro de uno o dos pitidos va acompañado de un número que indica las inspiraciones/espiraciones realizadas. Se anotará como resultado de la prueba el último número oído antes que el participante “necesite” inspirar antes del pitido único o “necesite” espirar antes de los dos pitidos.'),
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
                IconButton(
                  icon: const Icon(Icons.play_circle),
                  iconSize: 50,
                  color: Colors.lightBlueAccent,
                  onPressed: () {},
                ),
                const SizedBox(height: 40),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: subirDatos,
                    decoration: const InputDecoration(
                      labelText: 'Introduzca el número alcanzado',
                      border: OutlineInputBorder(),
                    ),
                    keyboardType: TextInputType.number,
                  ),
                ),
                const SizedBox(height: 40),
                ElevatedButton(
                  onPressed: () {
                    guardarDatos();
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Inversion(
                            onTap: () {},
                          )),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 75.0),
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

  void guardarDatos() async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    int nivelAlcanzado = int.tryParse(subirDatos.text) ?? 0;

    Map<String, dynamic> Ej3 = {
      'Nivel alcanzado': nivelAlcanzado,
      'fecha': Timestamp.now(),
    };

    try {
      await firestore.collection('Ejercicios').add(Ej3);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Datos guardados correctamente'),
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los datos: $error'),
        duration: Duration(seconds: 10),
      ));
    }
  }
}

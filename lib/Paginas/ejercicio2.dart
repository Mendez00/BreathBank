import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/Paginas/inversion.dart';

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

  @override
  void dispose() {
    dato1.dispose();
    dato2.dispose();
    dato3.dispose();
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
                          'El participante tras realizar la prueba anterior, sigue tumbado boca arriba y cronometra el tiempo empleado en realizar tres respiraciones de la forma más lenta posible, inspirando y espirando muy lentamente, cogiendo y soltando el aire por la nariz suavemente, sin pausas entre ambas fases respiratorias, es decir cuando acabo de inspirar, espiro y cuando acabo de espirar empiezo a inspirar de nuevo. Esta prueba no es una competición, la prueba debe ser tranquila, cómoda, sin forzar la respiración, de manera que no debe aparecer sensación de fatiga, tensión, mareo ni falta de aire. La prueba se realizará tres veces y se calculará la media entre ellas, anotándose el resultado obtenido en segundos.'),
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
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25.0),
              child: TextField(
                controller: dato1,
                decoration: const InputDecoration(
                  labelText: 'tiempo empleado 1ª ronda en s',
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
                  labelText: 'tiempo empleado 2ª ronda en s',
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
                  labelText: 'tiempo empleado 3ª ronda en s',
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
                padding: const EdgeInsets.symmetric(
                    vertical: 35.0, horizontal: 75.0),
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
    ));
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
          firestore.collection('Inversiones').doc(username);
      Timestamp fechaActual = Timestamp.now();

      QuerySnapshot querySnapshot =
          await userDocRef.collection('Inversión')
              .orderBy('fecha1', descending: true)
              .limit(1)
              .get();

      if (querySnapshot.docs.isNotEmpty) {
        DocumentReference pruebaDocRef = userDocRef.collection('Inversión').doc(querySnapshot.docs.last.id);

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

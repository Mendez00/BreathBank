import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/Paginas/inversion.dart';

class Ejercicio2 extends StatefulWidget {
  @override
  State<Ejercicio2> createState() => EstadoEjercicio2();
}

class EstadoEjercicio2 extends State<Ejercicio2> {
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
                          'Registro del tiempo empleado en realizar tres respiraciones lentas conscientes',
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
    ));
  }

  hallarMedia(dato1, dato2, dato3) {
    media = (dato1 + dato2 + dato3) / 3;
    return media;
  }

  void guardarDatos() async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;
    int respiraciones = int.tryParse(media.toString()) ?? 0;

    Map<String, dynamic> Ej2 = {
      'Media de los 3': respiraciones,
      'fecha': Timestamp.now(),
    };

    try {
      await firestore.collection('Ejercicios').add(Ej2);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Datos guardados correctamente'),
        duration: Duration(seconds: 2),
      ));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los datos: $error'),
        duration: Duration(seconds: 2),
      ));
    }
  }
}

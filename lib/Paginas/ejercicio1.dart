import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/Paginas/inversion.dart';

class Ejercicio1 extends StatefulWidget {
  @override
  State<Ejercicio1> createState() => EstadoEjercicio1();
}

class EstadoEjercicio1 extends State<Ejercicio1> {
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
                          'Registro de las respiraciones por minuto en reposo',
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
            const SizedBox(height: 40),
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

  void guardarDatos() async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    int respiraciones = int.tryParse(subirDatos.text) ?? 0;

    Map<String, dynamic> Ej1 = {
      'respiraciones': respiraciones,
      'fecha': Timestamp.now(),
    };
    try {
      await firestore.collection('Ejercicios').add(Ej1);
      //(widget as EstadoInversion).marcarEjercicioCompletado(1);

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

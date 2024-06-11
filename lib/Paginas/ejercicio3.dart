import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:breath_bank/Paginas/resumen.dart';
import 'package:just_audio/just_audio.dart';

class Ejercicio3 extends StatefulWidget {
  final VoidCallback onEjercicioCompleto;

  const Ejercicio3({Key? key, required this.onEjercicioCompleto}) : super(key: key);

  @override
  State<Ejercicio3> createState() => _EstadoEjercicio3();
}

class _EstadoEjercicio3 extends State<Ejercicio3> {
  final TextEditingController subirDatos = TextEditingController();
  bool _completado = true;
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  void _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop();
      setState(() {
        _isPlaying = false;
      });
    } else {
      try {
        await _audioPlayer.setAsset('assets/audio/guia.mp3');
        await _audioPlayer.play();
        setState(() {
          _isPlaying = true;
        });
      } catch (error) {
        print('Error al reproducir audio: $error');
      }
    }
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
                        text: 'Lea la ayuda y después utiliza el audio-guía para completar el ejercicio',
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
                          'Tumbado boca arriba y un minuto después de finalizar la prueba anterior, reproduce el audio que te guiará en la realización de respiraciones lentas conscientes donde los tiempos de inspiración y espiración son cada vez mayores, evaluando tu resistencia ante respiraciones cada vez más largas. Sonará un pitido que indica el inicio de la inspiración y a los cuatro segundos dos pitidos que indica el inicio de la espiración. Estos intervalos irán incrementando su duración progresivamente. Cada aviso sonoro de uno o dos pitidos va acompañado de un número que indica las inspiraciones/espiraciones realizadas. Se anotará como resultado de la prueba el último número oído antes que el participante “necesite” inspirar antes del pitido único o “necesite” espirar antes de los dos pitidos.',
                        ),
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
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle),
                iconSize: 50,
                color: Colors.lightBlueAccent,
                onPressed: _playAudio,
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

  void guardarDatos(BuildContext context) async {
    await Firebase.initializeApp();

    FirebaseFirestore firestore = FirebaseFirestore.instance;

    final FirebaseAuth auth = FirebaseAuth.instance;
    User? user = auth.currentUser;

    int nivelAlcanzado = int.tryParse(subirDatos.text) ?? 0;

    try {
      String username = user!.uid;
      DocumentReference userDocRef =
      firestore.collection('Inversiones').doc(username);
      Timestamp fechaActual = Timestamp.now();

      QuerySnapshot querySnapshot = await userDocRef
          .collection('Inversión')
          .orderBy('fecha1', descending: true)
          .limit(1)
          .get();

      DocumentReference pruebaDocRef =
      userDocRef.collection('Inversión').doc(querySnapshot.docs.last.id);

      Map<String, dynamic> mediaData = {
        'Ej3': nivelAlcanzado,
        'fecha3': fechaActual,
      };

      await pruebaDocRef.update(mediaData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Datos guardados correctamente'),
        duration: Duration(seconds: 2),
      ));

      setState(() {
        _completado = true;
      });
      widget.onEjercicioCompleto();

      Navigator.push(
          context, MaterialPageRoute(builder: (context) => Resumen()));
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los datos: $error'),
        duration: Duration(seconds: 10),
      ));
    }
  }
}

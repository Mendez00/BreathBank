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
  final TextEditingController subirDatos = TextEditingController(); // Controlador para el campo de texto
  bool _completado = true; // Variable para controlar si el ejercicio está completado
  late AudioPlayer _audioPlayer; // Reproductor de audio
  bool _isPlaying = false; // Estado de reproducción del audio

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer(); // Inicialización del reproductor de audio
  }

  @override
  void dispose() {
    _audioPlayer.dispose(); // Liberación de recursos del reproductor de audio
    super.dispose();
  }

  // Función para reproducir o pausar el audio
  void _playAudio() async {
    if (_isPlaying) {
      await _audioPlayer.stop(); // Detener la reproducción si está reproduciendo
      setState(() {
        _isPlaying = false; // Actualizar el estado de reproducción
      });
    } else {
      try {
        await _audioPlayer.setAsset('assets/audio/guia.mp3'); // Cargar el audio desde los assets
        await _audioPlayer.play(); // Reproducir el audio
        setState(() {
          _isPlaying = true; // Actualizar el estado de reproducción
        });
      } catch (error) {
        print('Error al reproducir audio: $error'); // Manejo de errores de reproducción
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
                        text: 'Lee la ayuda y después utiliza el audio-guía para completar el ejercicio',
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
                  // Mostrar diálogo de ayuda
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
                icon: Icon(_isPlaying ? Icons.pause_circle : Icons.play_circle), // Icono de reproducción o pausa dependiendo del estado
                iconSize: 50,
                color: Colors.lightBlueAccent,
                onPressed: _playAudio, // Función para manejar la reproducción del audio
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
                  guardarDatos(context); // Función para guardar los datos en Firestore
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

  // Función para guardar los datos en Firestore
  void guardarDatos(BuildContext context) async {
    await Firebase.initializeApp(); // Inicialización de Firebase

    FirebaseFirestore firestore = FirebaseFirestore.instance; // Instancia de Firestore

    final FirebaseAuth auth = FirebaseAuth.instance; // Instancia de FirebaseAuth para obtener el usuario actual
    User? user = auth.currentUser;

    int nivelAlcanzado = int.tryParse(subirDatos.text) ?? 0; // Obtención del nivel alcanzado desde el campo de texto

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

      DocumentReference pruebaDocRef =
      userDocRef.collection('Pruebas').doc(querySnapshot.docs.last.id); // Referencia al documento de la última prueba

      // Datos a actualizar en Firestore
      Map<String, dynamic> mediaData = {
        'Ej3': nivelAlcanzado,
        'fecha3': fechaActual,
      };

      // Actualización de los datos en Firestore
      await pruebaDocRef.update(mediaData);

      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Datos guardados correctamente'), // Mensaje de confirmación
        duration: Duration(seconds: 2),
      ));

      setState(() {
        _completado = true; // Actualizar el estado de completado
      });
      widget.onEjercicioCompleto(); // Llamar al callback cuando se completa el ejercicio

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => Resumen())); // Navegar a la página de resumen
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('Error al guardar los datos: $error'), // Mensaje de error en caso de falla
        duration: Duration(seconds: 10),
      ));
    }
  }
}

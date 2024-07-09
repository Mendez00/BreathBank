import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';

// Widget de estado para la pantalla de Listones
class Listones extends StatefulWidget {
  final Function()? onTap; // Función de retorno al tocar opcional

  const Listones({Key? key, this.onTap}) : super(key: key);

  @override
  _ListonesState createState() => _ListonesState();
}

// Estado de la pantalla de Listones
class _ListonesState extends State<Listones> {
  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de autenticación de Firebase
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instancia de Firestore

  int _nivelInversor = 0; // Nivel del inversor obtenido de Firestore
  String _fechaInversion = ''; // Fecha de la última inversión
  String displayName = ''; // Nombre del usuario actual
  bool _isLoading = true; // Estado de carga inicial
  String errorMessage = ''; // Mensaje de error, si hay algún problema
  int _numeroInversiones = 0; // Número total de inversiones realizadas por el usuario
  AudioPlayer? _currentPlayer; // Reproductor de audio actual

  @override
  void initState() {
    super.initState();
    _getUserInfo(); // Método para obtener la información del usuario al inicializar el estado
  }

  // Método asincrónico para obtener la información del usuario desde Firestore
  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser; // Obtener el usuario actualmente autenticado
    if (user != null) {
      setState(() {
        displayName = user.displayName ?? ''; // Establecer el nombre de usuario
      });

      String userId = user.uid; // ID único del usuario

      try {
        // Consulta para obtener el resumen de la última prueba de nivel del usuario
        DocumentSnapshot resumenSnapshot = await _firestore
            .collection('Prueba de nivel')
            .doc(userId)
            .collection('Pruebas')
            .orderBy('fecha1', descending: true)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.last);

        // Si existe un documento de resumen válido, actualizar el estado con los datos obtenidos
        if (resumenSnapshot.exists) {
          Map<String, dynamic> data = resumenSnapshot.data() as Map<String, dynamic>;

          setState(() {
            _nivelInversor = data['Nivel Inversor'] ?? 0;
            Timestamp fecha = data['fecha1'] ?? Timestamp.now();
            _fechaInversion = DateFormat('dd-MM-yyyy – kk:mm').format(fecha.toDate());
          });
        } else {
          print("No existe documento de resumen para el usuario");
        }

        // Obtener el número total de inversiones realizadas por el usuario
        QuerySnapshot querySnapshot = await _firestore
            .collection('Inversion')
            .doc(userId)
            .collection('Inversiones')
            .get();

        setState(() {
          _numeroInversiones = querySnapshot.docs.length;
        });

      } catch (e) {
        print("Error al obtener datos del usuario: $e");
        setState(() {
          errorMessage = 'Error al obtener datos del usuario';
        });
      }
    } else {
      print("Usuario no está autenticado");
    }

    setState(() {
      _isLoading = false; // Finalizar el estado de carga
    });
  }

  @override
  Widget build(BuildContext context) {
    // Construcción de la interfaz de usuario según el estado de carga y los posibles errores
    if (_isLoading) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Listones'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (errorMessage.isNotEmpty) {
      return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.lightBlueAccent,
          title: Text('Listones'),
          centerTitle: true,
          elevation: 0,
        ),
        body: Center(child: Text(errorMessage)),
      );
    }

    // Construcción de la pantalla principal de Listones
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Realizar inversión'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back), // Botón de retroceso
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPrincipal(onTap: () {}),
              ),
            );
          },
        ),
      ),
      body: Column(
        children: [
          // Información estática sobre el usuario y las instrucciones
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nivel de inversor: $_nivelInversor',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Para accionar el audio, pulsa el play. Al acabar, pulsa el mismo botón para guardar los datos.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Nº de inversiones: $_numeroInversiones',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Realizar las respiraciones de acuerdo a los pitidos. \nUn pitido inspirar. \nDos pitidos espirar. \nVarios pitidos graves parar.',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Expanded(
            // Lista desplegable de niveles y sus listones correspondientes
            child: ListView.builder(
              itemCount: 6, // Niveles 0 a 5
              itemBuilder: (context, levelIndex) {
                int listonCount = (levelIndex == 0) ? 2 : 5; // Nivel 0 tiene 2 listones, otros niveles tienen 5
                bool isLocked = levelIndex > _nivelInversor;

                return ExpansionTile(
                  title: Text(
                    'Nivel $levelIndex',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  children: isLocked
                      ? [ListTile(title: Text('Nivel bloqueado'))]
                      : List.generate(listonCount, (listonIndex) {
                    String listonNumber = getAudioFileNumber(levelIndex, listonIndex + 1);
                    String audioFileName = '1 SERIE LISTON $listonNumber.mp3';
                    String audioFilePath = 'assets/audio/$audioFileName';

                    return ListonTile(
                      audioFileName: audioFileName,
                      audioFilePath: audioFilePath,
                      listonName: 'Listón $listonNumber',
                      levelIndex: levelIndex,
                      listonIndex: listonIndex + 1,
                      onPlay: (player) {
                        // Si ya hay un audio reproduciéndose, pausarlo
                        if (_currentPlayer != null && _currentPlayer != player) {
                          _currentPlayer!.pause();
                        }
                        _currentPlayer = player;
                      },
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  // Método para obtener el número del archivo de audio basado en el nivel y el índice del listón
  String getAudioFileNumber(int levelIndex, int listonIndex) {
    switch (levelIndex) {
      case 0:
        return listonIndex == 1 ? '6' : '8';
      case 1:
        return '${10 + (listonIndex - 1) * 2}';
      case 2:
        return '${20 + (listonIndex - 1) * 2}';
      case 3:
        return '${30 + (listonIndex - 1) * 2}';
      case 4:
        return '${40 + (listonIndex - 1) * 2}';
      case 5:
        return '${50 + (listonIndex - 1) * 2}';
      default:
        return '6';
    }
  }
}

// Widget de estado para cada listón dentro de un nivel
class ListonTile extends StatefulWidget {
  final String audioFileName; // Nombre del archivo de audio
  final String audioFilePath; // Ruta del archivo de audio
  final String listonName; // Nombre del listón
  final int levelIndex; // Índice del nivel
  final int listonIndex; // Índice del listón dentro del nivel
  final Function(AudioPlayer) onPlay; // Callback para manejar la reproducción de audio

  const ListonTile({
    required this.audioFileName,
    required this.audioFilePath,
    required this.listonName,
    required this.levelIndex,
    required this.listonIndex,
    required this.onPlay,
    Key? key,
  }) : super(key: key);

  @override
  _ListonTileState createState() => _ListonTileState();
}

// Estado para cada listón que maneja la reproducción de audio y el estado de guardado
class _ListonTileState extends State<ListonTile> {
  late AudioPlayer _player; // Reproductor de audio
  bool _isPlaying = false; // Estado de reproducción del audio
  bool _hasSavedProgress = false; // Estado de guardado para evitar múltiples guardados

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer(); // Inicialización del reproductor de audio
    _player.playerStateStream.listen((state) {
      // Escuchar cambios en el estado del reproductor
      if (state.processingState == ProcessingState.completed) {
        _onAudioComplete(); // Manejar la finalización del audio
      } else if (state.playing) {
        setState(() {
          _isPlaying = true;
        });
      } else {
        setState(() {
          _isPlaying = false;
        });
      }
    });
  }

  @override
  void dispose() {
    _player.dispose(); // Liberar recursos del reproductor al cerrar el estado
    super.dispose();
  }

  // Alternar entre reproducción y pausa del audio
  void _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause(); // Pausar reproducción si está reproduciéndose
      setState(() {
        _isPlaying = false;
      });
    } else {
      try {
        if (_player.playing) {
          await _player.pause();
        }
        await _player.setAsset(widget.audioFilePath); // Establecer archivo de audio a reproducir
        await _player.play(); // Iniciar reproducción
        widget.onPlay(_player); // Notificar al widget padre sobre la reproducción
        setState(() {
          _isPlaying = true; // Actualizar estado de reproducción
          _hasSavedProgress = false; // Reiniciar estado de guardado
        });
      } catch (e) {
        print('Error al reproducir el audio: $e');
      }
    }
  }

  // Manejar la finalización del audio
  void _onAudioComplete() async {
    setState(() {
      _isPlaying = false;
    });

    if (!_hasSavedProgress) {
      await _saveProgress(); // Guardar el progreso una vez finalizada la reproducción
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Datos guardados.'), // Mostrar mensaje de éxito al guardar datos
        ),
      );
      setState(() {
        _hasSavedProgress = true;
      });
    }
  }

  // Función para guardar el progreso en Firestore
  Future<void> _saveProgress() async {
    await addInvestment(widget.levelIndex, widget.listonIndex);
  }

  @override
  Widget build(BuildContext context) {
    // Construir el widget del listón dentro de la lista
    return ListTile(
      title: Text(widget.listonName), // Mostrar nombre del listón
      trailing: IconButton(
        icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow), // Icono de reproducción o pausa
        onPressed: _togglePlayPause, // Alternar reproducción o pausa al hacer clic en el botón
      ),
    );
  }
}

// Función asincrónica para agregar una nueva inversión en Firestore
Future<void> addInvestment(int level, int liston) async {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user'; // Obtener ID del usuario actual
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('Inversion').doc(userId); // Referencia al documento del usuario en Firestore

  Timestamp fechaActual = Timestamp.now(); // Fecha y hora actuales

  int numeroInversion = 1; // Número de la inversión inicializado en 1
  QuerySnapshot querySnapshot = await userDocRef.collection('Inversiones').get(); // Consulta para obtener las inversiones existentes
  if (querySnapshot.docs.isNotEmpty) {
    numeroInversion = querySnapshot.docs.length + 1; // Actualizar número de inversión basado en las inversiones existentes
  }

  DocumentReference pruebaDocRef =
  userDocRef.collection('Inversiones').doc('Inversion $numeroInversion'); // Referencia al documento de la nueva inversión

  Map<String, dynamic> ejercicioData = {
    'fecha1': fechaActual, // Fecha de la inversión
    'nivel': level, // Nivel de la inversión
    'Liston': liston, // Número de listón
  };
  await pruebaDocRef.set(ejercicioData); // Guardar los datos de la nueva inversión en Firestore
}

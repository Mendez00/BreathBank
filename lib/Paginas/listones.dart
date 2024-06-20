import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';

class Listones extends StatefulWidget {
  final Function()? onTap;

  const Listones({Key? key, this.onTap}) : super(key: key);

  @override
  _ListonesState createState() => _ListonesState();
}

class _ListonesState extends State<Listones> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  int _nivelInversor = 0;
  String _fechaInversion = '';
  String displayName = '';
  bool _isLoading = true;
  String errorMessage = '';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        displayName = user.displayName ?? '';
      });

      String userId = user.uid;

      try {
        DocumentSnapshot resumenSnapshot = await _firestore
            .collection('Prueba de nivel')
            .doc(userId)
            .collection('Pruebas')
            .orderBy('fecha1', descending: true)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.last);

        if (resumenSnapshot.exists) {
          Map<String, dynamic> data = resumenSnapshot.data() as Map<String, dynamic>;

          print("Data from Firestore: $data");

          setState(() {
            _nivelInversor = data['Nivel Inversor'] ?? 0;
            Timestamp fecha = data['fecha1'] ?? Timestamp.now();
            _fechaInversion = DateFormat('dd-MM-yyyy – kk:mm').format(fecha.toDate());

            print("Nivel Inversor: $_nivelInversor");
            print("Fecha Inversión: $_fechaInversion");
          });
        } else {
          print("No existe documento de resumen para el usuario");
        }
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
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
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

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Listones'),
        centerTitle: true,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                  builder: (context) => MenuPrincipal(onTap: () {})),
            );
          },
        ),
      ),
      body: ListView.builder(
        itemCount: 6, // Niveles 0 a 5
        itemBuilder: (context, levelIndex) {
          int listonCount = (levelIndex == 0) ? 2 : 5; // Nivel 0 tiene 2 listones, otros niveles tienen 5
          bool isLocked = levelIndex > _nivelInversor;

          return ExpansionTile(
            title: Text(
              'Nivel ${levelIndex}',
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
              );
            }),
          );
        },
      ),
    );
  }

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

class ListonTile extends StatefulWidget {
  final String audioFileName;
  final String audioFilePath;
  final String listonName;
  final int levelIndex;
  final int listonIndex;

  const ListonTile({
    required this.audioFileName,
    required this.audioFilePath,
    required this.listonName,
    required this.levelIndex,
    required this.listonIndex,
    Key? key,
  }) : super(key: key);

  @override
  _ListonTileState createState() => _ListonTileState();
}

class _ListonTileState extends State<ListonTile> {
  late AudioPlayer _player;
  bool _isPlaying = false;

  @override
  void initState() {
    super.initState();
    _player = AudioPlayer();
    _player.playerStateStream.listen((state) {
      if (state.processingState == ProcessingState.completed) {
        setState(() {
          _isPlaying = false;
        });

        // Registro de inversión en Firestore cuando se completa la reproducción
        addInvestment(widget.levelIndex, widget.listonIndex);
      }
    });
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  void _togglePlayPause() async {
    if (_isPlaying) {
      await _player.pause();
    } else {
      try {
        await _player.setAsset(widget.audioFilePath);
        await _player.play();
      } catch (e) {
        print('Error al reproducir el audio: $e');
      }
    }

    setState(() {
      _isPlaying = !_isPlaying;
    });
  }

  Future<void> _saveProgress() async {
    await addInvestment(widget.levelIndex, widget.listonIndex);
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(widget.listonName),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
            onPressed: _togglePlayPause,
          ),
          IconButton(
            icon: Icon(Icons.save),
            onPressed: _saveProgress,
          ),
        ],
      ),
    );
  }
}

Future<void> addInvestment(int level, int liston) async {
  String userId = FirebaseAuth.instance.currentUser?.uid ?? 'unknown_user';
  DocumentReference userDocRef = FirebaseFirestore.instance.collection('inversion').doc(userId);

  Timestamp fechaActual = Timestamp.now();

  int numeroInversion = 1;
  QuerySnapshot querySnapshot = await userDocRef.collection('Inversiones').get();
  if (querySnapshot.docs.isNotEmpty) {
    numeroInversion = querySnapshot.docs.length + 1;
  }

  DocumentReference pruebaDocRef =
  userDocRef.collection('Inversiones').doc('Inversion $numeroInversion');

  Map<String, dynamic> ejercicioData = {
    'fecha1': fechaActual,
    'nivel': level,
    'Liston': liston,
  };
  await pruebaDocRef.set(ejercicioData);
}

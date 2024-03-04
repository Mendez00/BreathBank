import 'package:breath_bank/Paginas/perfil.dart';
import 'package:breath_bank/Paginas/estadisticas.dart';
import 'package:breath_bank/Paginas/ajustes.dart';
import 'package:breath_bank/Paginas/amigos.dart';
import 'package:flutter/material.dart';

class menuPrincipal extends StatefulWidget {
  menuPrincipal({super.key});

  @override
  State<menuPrincipal> createState() => estadoMenuPrincipal();
}

class estadoMenuPrincipal extends State<menuPrincipal> {

  int indiceActual = 0;

  void barraNavegacion(int indice) {
    setState(() {
      indiceActual = indice;
    });
  }

  final List paginas = [
    //estadisticas
    Estadisticas(),
    //perfil
    Perfil(),
    //ajustes
    Ajustes(),
    //amigos
    Amigos(),
  ];

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "BreathBank",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 30,
          ),
        ),
        backgroundColor: Colors.lightBlueAccent,
      ),
      body: paginas[indiceActual],
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.lightBlueAccent,
        currentIndex: indiceActual,
        onTap: barraNavegacion,
        items: const [
          //estadisticas
          BottomNavigationBarItem(
            icon: Icon(Icons.analytics),
            label: 'Estadisticas',
          ),

          //perfil
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Perfil',
          ),

          //Ajustes
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Ajustes',
          ),

          //Amigos
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: 'Amigos',
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';

class EjerciciosIniciales extends StatefulWidget {
  final Function()? onTap;
  const EjerciciosIniciales({super.key, required this.onTap});

  @override
  State<EjerciciosIniciales> createState() => EstadoEjerciciosIniciales();
}

class EstadoEjerciciosIniciales extends State<EjerciciosIniciales> {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: Container(
            margin: EdgeInsets.all(40.0),
            width: 280,
            decoration: BoxDecoration(
              color: Colors.grey.shade200,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              children: [
                Image.asset('insertar foto ejercicio'),
                Text(
                  'Descripción ejercicio',
                  style: TextStyle(color: Colors.white),
                ),
              ],
            ),
            ),
          ),
        ),
      );
  }
}

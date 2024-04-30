import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/inversion.dart';


class Resumen extends StatelessWidget  {
  const Resumen({super.key});

  Widget build(BuildContext context){
    return Scaffold(

      body: Center(
        child: ElevatedButton(
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => MenuPrincipal(onTap: () {  },)),
            );
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
            'Continuar',
            style: TextStyle(fontSize: 25.0),
          ),
        ),
      ),
    );
  }

}
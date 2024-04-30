import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/drawer.dart';


class Ajustes extends StatelessWidget {
  final Function()? onTap;
  const Ajustes({super.key, required this.onTap});

  Widget build(BuildContext context){
    return Scaffold(
      drawer: MyDrawer( ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Center(
        child: Text("Ajustes"),
      ),

    );
  }
}
import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/drawer.dart';


class Estadisticas extends StatelessWidget  {
  const Estadisticas({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      drawer: MyDrawer( ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),

      body: Center(
        child: Text("Estadisticas"),
      ),
    );
  }

}
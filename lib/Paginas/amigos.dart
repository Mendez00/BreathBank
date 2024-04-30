import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/drawer.dart';


class Amigos extends StatelessWidget {
  const Amigos({super.key});

  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      drawer: MyDrawer( ),
      body: Center(
        child: Text("Amigos"),
      ),

    );
  }
}
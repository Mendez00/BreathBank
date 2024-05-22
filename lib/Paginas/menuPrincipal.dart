import 'package:breath_bank/Paginas/inversion.dart';
import 'package:breath_bank/Paginas/inicioSesion.dart';
import 'package:breath_bank/Paginas/drawer.dart';
import 'package:breath_bank/Paginas/perfil.dart';
import 'package:breath_bank/Paginas/estadisticas.dart';
import 'package:breath_bank/Paginas/ajustes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MenuPrincipal extends StatefulWidget {
  final Function()? onTap;
  const MenuPrincipal({Key? key, required this.onTap}) : super(key: key);

  @override
  State<MenuPrincipal> createState() => EstadoMenuPrincipal();
}

class EstadoMenuPrincipal extends State<MenuPrincipal> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        drawer: MyDrawer(),
        appBar: AppBar(
            backgroundColor:
                Colors.lightBlueAccent,
            title: Text('Inicio'),
            centerTitle: true,
            elevation: 0,
            leading: Builder(
              builder: (context) => IconButton(
                icon: const Icon(
                  Icons.menu,
                  color: Colors.black,
                ),
                onPressed: () {
                  Scaffold.of(context).openDrawer();
                },
              ),
            )),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 50),
                Image.asset(
                  'lib/images/logo.png',
                  width: 175,
                  height: 175,
                  fit: BoxFit.contain,
                ),
                const SizedBox(height: 75),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                  child: Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: 'MEJORA TU VIDA\n',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        TextSpan(
                          text:
                              'Realizar ejercicios diarios para mejorar tu capacidad pulmonar, tu estrés y tu concentración en solo 10 minutos',
                          style: TextStyle(
                            fontSize: 16,
                          ),
                        ),
                      ],
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
                const SizedBox(height: 50),
                Container(
                  margin: EdgeInsets.only(bottom: 200),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => Inversion(onTap: () {})),
                      );
                    },
                    child: Container(
                      width: 250,
                      height: 100,
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                          color: Colors.lightBlueAccent,
                          borderRadius: BorderRadius.circular(8)),
                      child: const Center(
                        child: Text(
                          "Realizar Inversión",
                          style: TextStyle(color: Colors.white, fontSize: 25.0),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ));
  }
}

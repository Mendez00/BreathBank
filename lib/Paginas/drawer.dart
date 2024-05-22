import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/ajustes.dart';
import 'package:breath_bank/Paginas/inicioSesion.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:breath_bank/Paginas/estadisticas.dart';
import 'package:breath_bank/Paginas/perfil.dart';
import 'package:firebase_auth/firebase_auth.dart';

class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    void IrAlInicioSesion(BuildContext context) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => InicioSesion()),
      );
    }

    void cerrarSesion(BuildContext context) async {
      FirebaseAuth.instance.signOut();
      IrAlInicioSesion(context);
    }

    return Drawer(
        child: ListView(
      padding: EdgeInsets.zero,
      children: [
        DrawerHeader(
          child: Image.asset('lib/images/logo.png'),
        ),
        ListTile(
          leading: Icon(
            Icons.home,
            color: Colors.lightBlueAccent,
          ),
          title: Text(
            'Inicio',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => MenuPrincipal(onTap: () {}),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.analytics,
            color: Colors.lightBlueAccent,
          ),
          title: Text(
            'Estadisticas',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Estadisticas(),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.person,
            color: Colors.lightBlueAccent,
          ),
          title: Text(
            'Perfil',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Perfil(onTap: () {}),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.settings,
            color: Colors.lightBlueAccent,
          ),
          title: Text(
            'Ajustes',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Ajustes(onTap: () {}),
              ),
            );
          },
        ),
        ListTile(
          leading: Icon(
            Icons.logout,
            color: Colors.lightBlueAccent,
          ),
          title: Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.lightBlueAccent),
          ),
          onTap: () {
            cerrarSesion(context);
          },
        ),
      ],
    ));
  }
}

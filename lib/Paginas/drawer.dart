import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/ajustes.dart';
import 'package:breath_bank/Paginas/inicioSesion.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:breath_bank/Paginas/estadisticas.dart';
import 'package:breath_bank/Paginas/perfil.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Clase del Drawer lateral que muestra las opciones de navegación y cierre de sesión.
class MyDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    /// Navega a la pantalla de inicio de sesión.
    void IrAlInicioSesion(BuildContext context) {
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => InicioSesion()),
      );
    }

    /// Cierra la sesión actual y redirige a la pantalla de inicio de sesión.
    void cerrarSesion(BuildContext context) async {
      await FirebaseAuth.instance.signOut();

      // Borrar el estado de inicio de sesión guardado en SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.remove('isLoggedIn');

      IrAlInicioSesion(context);
    }

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            child: Image.asset('lib/imagenes/logo.png'),
          ),
          ListTile(
            leading: Icon(
              Icons.home,
              color: Colors.lightBlueAccent,
            ),
            title: Text(
              'Inicio',
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
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
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
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
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
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
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              Navigator.pushReplacement(
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
              style: TextStyle(color: Colors.black),
            ),
            onTap: () {
              cerrarSesion(context);
            },
          ),
        ],
      ),
    );
  }
}

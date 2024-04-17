import 'package:breath_bank/Paginas/ejerciciosIniciales.dart';
import 'package:breath_bank/Paginas/inicioSesion.dart';
import 'package:breath_bank/Paginas/perfil.dart';
import 'package:breath_bank/Paginas/estadisticas.dart';
import 'package:breath_bank/Paginas/ajustes.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';

class MenuPrincipal extends StatefulWidget {
  final Function()? onTap;
  const MenuPrincipal({Key? key, required this.onTap}) : super(key: key);

  @override
  State<MenuPrincipal> createState() => EstadoMenuPrincipal();
}

class EstadoMenuPrincipal extends State<MenuPrincipal> {
  void IrAlInicioSesion(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => InicioSesion()),
    );
  }

  void cerrarSesion() async {
    FirebaseAuth.instance.signOut();
    IrAlInicioSesion(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(height: 20),
            Image.asset(
              'lib/images/logo.png',
              width: 200,
              height: 200,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 30),
            Container(
              margin: EdgeInsets.only(bottom: 200),
              child: GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            EjerciciosIniciales(onTap: () {})),
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
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      appBar: AppBar(
          backgroundColor: Colors.transparent,
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
      drawer: Drawer(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              children: [
                DrawerHeader(child: Image.asset('lib/images/logo.png')),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 25.0),
                ),
                ListTile(
                  leading: const Icon(
                    Icons.home,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    'Home',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MenuPrincipal(
                                onTap: () {},
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.analytics,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    'Estadisticas',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Estadisticas()),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.person,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    'Perfil',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Perfil(
                                onTap: () {},
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.settings,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    'Ajustes',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => Ajustes(
                                onTap: () {},
                              )),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(
                    Icons.logout,
                    color: Colors.lightBlueAccent,
                  ),
                  title: const Text(
                    'Cerrar sesión',
                    style: TextStyle(color: Colors.lightBlueAccent),
                  ),
                  onTap: () {
                    cerrarSesion();
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

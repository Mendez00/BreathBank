import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/inversion.dart';
import 'package:breath_bank/Paginas/drawer.dart';
import 'package:breath_bank/Paginas/listones.dart';

// Clase MenuPrincipal que es un StatefulWidget
class MenuPrincipal extends StatefulWidget {
  final Function()? onTap; // Función onTap opcional

  const MenuPrincipal({Key? key, required this.onTap}) : super(key: key);

  @override
  State<MenuPrincipal> createState() => _MenuPrincipalState(); // Creación del estado _MenuPrincipalState
}

// Estado de MenuPrincipal
class _MenuPrincipalState extends State<MenuPrincipal> {
  @override
  void initState() {
    super.initState();
    // Estado inicial, no realiza ninguna acción especial
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
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
              Scaffold.of(context).openDrawer(); // Abrir el Drawer al presionar el botón de menú
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const SizedBox(height: 50),
              Image.asset(
                'lib/imagenes/logo.png',
                width: 175,
                height: 175,
                fit: BoxFit.contain,
              ),
              const SizedBox(height: 50),
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
                        'Realiza ejercicios diarios para mejorar tu capacidad pulmonar, tu estrés y tu concentración en solo 10 minutos', // Texto normal
                        style: TextStyle(
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 40),
              GestureDetector(
                onTap: () async {
                  await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Inversion(onTap: () {}),
                    ),
                  );
                },
                child: Container(
                  width: 250,
                  height: 100,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Center(
                    child: Text(
                      "Prueba de Nivel",
                      style: TextStyle(color: Colors.white, fontSize: 25.0),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
              Container(
                margin: EdgeInsets.only(bottom: 50),
                child: GestureDetector(
                  onTap: () {
                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Listones(onTap: () {}),
                      ),
                    );
                  },
                  child: Container(
                    width: 250,
                    height: 100,
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.lightBlueAccent,
                      borderRadius: BorderRadius.circular(8),
                    ),
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
      ),
    );
  }
}

import 'package:breath_bank/Paginas/inicioSesion.dart';
import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:flutter/material.dart';

class CrearCuenta extends StatefulWidget {
  const CrearCuenta({super.key});
  @override
  State<CrearCuenta> createState() => EstadoCrearCuenta();
}

class EstadoCrearCuenta extends State<CrearCuenta> {
  TextEditingController textoNombre = TextEditingController();
  TextEditingController textoEmail = TextEditingController();
  TextEditingController textoContrasena = TextEditingController();
  TextEditingController textoRepiteContrasena = TextEditingController();

  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            children: [
              //logo
              SizedBox(height: 50),
              Image.asset(
                'lib/images/logo.png',
                width: 200,
                height: 200,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 30),
              //Escribir nombre usuario
              TextField(
                controller: textoNombre,
                decoration: InputDecoration(
                  hintText: "Nombre",
                ),
              ),
              SizedBox(height: 30),
              //Escribir email
              TextField(
                controller: textoEmail,
                decoration: InputDecoration(
                  hintText: "Email",
                ),
              ),
              SizedBox(height: 30),
              //Escribir contraseña
              TextField(
                controller: textoContrasena,
                decoration: InputDecoration(
                  hintText: "Contraseña",
                ),
              ),
              SizedBox(height: 30),
              //Escribir contraseña
              TextField(
                controller: textoRepiteContrasena,
                decoration: InputDecoration(
                  hintText: "Repite Contraseña",
                ),
              ),
              SizedBox(height: 30),
              //boton crear cuenta
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => menuPrincipal()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: const Center(
                    child: Text(
                      'Crear cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 30),
              //boton si ya tienes cuenta
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InicioSesion()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
                  child: const Center(
                    child: Text(
                      'Si ya tienes cuenta',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
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

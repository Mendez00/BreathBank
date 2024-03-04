import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:flutter/material.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({super.key});

  @override
  State<InicioSesion> createState() => EstadoInicioSesion();
}
class EstadoInicioSesion extends State<InicioSesion>{

  TextEditingController textoEmail = TextEditingController();
  TextEditingController textoContrasena = TextEditingController();

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
                width: 300,
                height: 300,
                fit: BoxFit.contain,
              ),
              SizedBox(height: 40),
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
              //boton iniciar sesion
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
                      'Inicio sesión',
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
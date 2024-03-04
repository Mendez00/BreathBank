import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/crearCuenta.dart';
import 'package:breath_bank/Paginas/inicioSesion.dart';

class Inicio extends StatelessWidget {
  const Inicio({super.key});

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
              //boton crear cuenta
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => CrearCuenta()),
                ),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  padding: const EdgeInsets.all(25),
                  child: const Center(
                    child: Text(
                      'Crear Cuenta',
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
              //boton iniciar sesion
              GestureDetector(
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => InicioSesion()),
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

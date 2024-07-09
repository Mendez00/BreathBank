import 'package:breath_bank/Paginas/menuPrincipal.dart';
import 'package:breath_bank/Paginas/crearCuenta.dart';
import 'package:breath_bank/Paginas/menuPrincipalInicial.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class InicioSesion extends StatefulWidget {
  const InicioSesion({
    Key? key,
  }) : super(key: key);

  @override
  State<InicioSesion> createState() => EstadoInicioSesion();
}

class EstadoInicioSesion extends State<InicioSesion> {
  final email = TextEditingController(); // Controlador para el campo de email
  final contrasena = TextEditingController(); // Controlador para el campo de contraseña

  // Función para navegar al menú principal basado en la existencia de documentos específicos en Firestore
  void IrAlMenuPrincipal(BuildContext context) async {
    try {
      User? user = FirebaseAuth.instance.currentUser; // Obtener usuario actualmente autenticado
      if (user != null) {
        String userId = user.uid;

        // Consultar documentos que contengan Ej1
        QuerySnapshot ej1Snapshot = await FirebaseFirestore.instance
            .collection('Prueba de nivel')
            .doc(userId)
            .collection('Pruebas')
            .where('Ej1', isNull: false)
            .limit(1)
            .get();

        // Consultar documentos que contengan Ej2
        QuerySnapshot ej2Snapshot = await FirebaseFirestore.instance
            .collection('Prueba de nivel')
            .doc(userId)
            .collection('Pruebas')
            .where('Ej2', isNull: false)
            .limit(1)
            .get();

        // Consultar documentos que contengan Ej3
        QuerySnapshot ej3Snapshot = await FirebaseFirestore.instance
            .collection('Prueba de nivel')
            .doc(userId)
            .collection('Pruebas')
            .where('Ej3', isNull: false)
            .limit(1)
            .get();

        // Verificar si alguna consulta tiene resultados
        if (ej1Snapshot.docs.isNotEmpty &&
            ej2Snapshot.docs.isNotEmpty &&
            ej3Snapshot.docs.isNotEmpty) {
          // Si existen documentos para Ej1, Ej2 y Ej3, ir al menú principal
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuPrincipal(onTap: () {})),
          );
        } else {
          // Si no existen documentos para Ej1, Ej2 o Ej3, ir al menú principal inicial
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MenuPrincipalInicial()),
          );
        }
      }
    } catch (e) {
      // Manejo de errores durante la verificación de documentos en Firestore
      print("Error al verificar documentos: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al verificar documentos.'),
        ),
      );
    }
  }

  // Función para iniciar sesión usando Firebase Authentication
  void iniciarSesion() async {
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: email.text,
        password: contrasena.text,
      );

      // Guardar el estado de inicio de sesión utilizando SharedPreferences
      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setBool('isLoggedIn', true);

      // Mostrar mensaje de inicio de sesión exitoso
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Inicio de sesión exitoso.'),
        ),
      );

      // Navegar al menú principal después de iniciar sesión
      IrAlMenuPrincipal(context);
    } on FirebaseAuthException catch (e) {
      // Manejo de errores específicos de FirebaseAuth durante el inicio de sesión
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error al iniciar sesión. Por favor, inténtalo de nuevo.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Color de fondo blanco para la pantalla
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                // Logo de la aplicación
                Image.asset(
                  'lib/imagenes/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 80),

                // Campo de texto para introducir el email
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: email,
                    obscureText: false,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),

                const SizedBox(height: 10),

                // Campo de texto para introducir la contraseña
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: contrasena,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.grey.shade400)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),

                const SizedBox(height: 10),

                // Enlace para recuperar contraseña
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Text(
                        '¿Olvidaste tu contraseña?',
                        style: TextStyle(color: Colors.white /*grey[600]*/),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 30),

                // Botón para iniciar sesión
                GestureDetector(
                  onTap: () {
                    iniciarSesion();
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        "Inicio Sesión",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 50),

                // Enlace para registrarse si no se tiene cuenta
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿No tienes cuenta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => CrearCuenta(onTap: () {})),
                      ),
                      child: const Text(
                        'Regístrate',
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

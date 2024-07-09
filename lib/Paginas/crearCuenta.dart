import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breath_bank/Paginas/menuPrincipalInicial.dart'; // Importación del menú principal inicial
import 'package:breath_bank/Paginas/inicioSesion.dart'; // Importación de la pantalla de inicio de sesión

/// Widget para la pantalla de creación de cuenta de usuario.
class CrearCuenta extends StatefulWidget {
  final Function()? onTap;

  /// Constructor para la clase CrearCuenta.
  ///
  /// [onTap]: Función para manejar eventos de tap.
  CrearCuenta({Key? key, required this.onTap}) : super(key: key);

  @override
  State<CrearCuenta> createState() => EstadoCrearCuenta();
}

class EstadoCrearCuenta extends State<CrearCuenta> {
  final emailController = TextEditingController();
  final nombreController = TextEditingController();
  final contrasenaController = TextEditingController();
  final RepiteContrasenaController = TextEditingController();

  /// Navega a la pantalla menú principal inicial después de crear la cuenta.
  ///
  /// [context]: Contexto actual de la aplicación.
  void IrAInversion(BuildContext context) {
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
          builder: (context) => MenuPrincipalInicial()), // Navegación al menú principal inicial
    );
  }

  /// Intenta crear una nueva cuenta de usuario utilizando los datos ingresados.
  ///
  /// Maneja la creación de cuenta, validación de contraseña y muestra mensajes de error.
  void CreacionCuenta() async {
    try {
      if (contrasenaController.text == RepiteContrasenaController.text) {
        UserCredential userCredential = await FirebaseAuth.instance.createUserWithEmailAndPassword(
          email: emailController.text,
          password: contrasenaController.text,
        );
        await userCredential.user!.sendEmailVerification();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Cuenta creada correctamente. Por favor, verifica tu correo electrónico.'),
          ),
        );
        IrAInversion(context); // Llama a la función para navegar al menú principal inicial
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Las contraseñas no coinciden')),
        );
      }
    } on FirebaseAuthException catch (e) {
      if (e.code == 'weak-password') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('La contraseña es débil')),
        );
      } else if (e.code == 'email-already-in-use') {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('El correo electrónico ya está en uso')),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Error al crear la cuenta')),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 20),

                Image.asset(
                  'lib/imagenes/logo.png',
                  width: 200,
                  height: 200,
                  fit: BoxFit.contain,
                ),

                const SizedBox(height: 60),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: emailController,
                    obscureText: false,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade400)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Email',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: contrasenaController,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade400)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Contraseña',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),

                const SizedBox(height: 10),

                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 25.0),
                  child: TextField(
                    controller: RepiteContrasenaController,
                    obscureText: true,
                    decoration: InputDecoration(
                        enabledBorder: const OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.white)),
                        focusedBorder: OutlineInputBorder(
                            borderSide:
                            BorderSide(color: Colors.grey.shade400)),
                        fillColor: Colors.grey.shade200,
                        filled: true,
                        hintText: 'Repite la contraseña',
                        hintStyle: TextStyle(color: Colors.grey[500])),
                  ),
                ),

                const SizedBox(height: 25),

                GestureDetector(
                  onTap: () {
                    CreacionCuenta(); // Llama al método para crear la cuenta al hacer tap
                  },
                  child: Container(
                    padding: const EdgeInsets.all(25),
                    margin: const EdgeInsets.symmetric(horizontal: 25),
                    decoration: BoxDecoration(
                        color: Colors.black,
                        borderRadius: BorderRadius.circular(8)),
                    child: const Center(
                      child: Text(
                        "Crear Cuenta",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ),
                ),

                const SizedBox(height: 20),

                const SizedBox(height: 50),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '¿Ya tienes cuenta?',
                      style: TextStyle(color: Colors.grey[700]),
                    ),
                    const SizedBox(width: 4),
                    GestureDetector(
                      onTap: () => Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => InicioSesion()), // Navegación a la pantalla de inicio de sesión
                      ),
                      child: const Text(
                        'Inicia sesión',
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

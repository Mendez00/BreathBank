import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/Paginas/drawer.dart';

/// Widget de la pantalla de ajustes, que permite al usuario cambiar su nombre y contraseña.
class Ajustes extends StatefulWidget {
  final Function()? onTap;

  const Ajustes({Key? key, this.onTap}) : super(key: key);

  @override
  EstadoAjustes createState() => EstadoAjustes();
}

class EstadoAjustes extends State<Ajustes> {
  // Controladores para los campos de texto
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController contrasenaAntiguaController =
      TextEditingController();
  final TextEditingController contrasenaNuevaController =
      TextEditingController();
  final TextEditingController contrasenaRepetirController =
      TextEditingController();

  final FirebaseAuth _auth = FirebaseAuth.instance; // Instancia de FirebaseAuth
  final FirebaseFirestore _firestore =
      FirebaseFirestore.instance; // Instancia de FirebaseFirestore

  bool _isPasswordVisible =
      false; // Estado para controlar la visibilidad de la contraseña

  /// Método para cambiar el nombre del usuario en Firebase Auth y Firestore.
  Future<void> cambiarNombre(String nuevoNombre) async {
    User? user =
        _auth.currentUser; // Obtiene el usuario actualmente autenticado

    if (user != null) {
      try {
        // Actualiza el nombre en Firebase Auth
        await user.updateDisplayName(nuevoNombre);
        await user.reload(); // Recarga los datos del usuario
        user = _auth
            .currentUser; // Actualiza la referencia al usuario después de la recarga

        // Actualiza el nombre en Firestore
        DocumentReference userDocRef =
            _firestore.collection('usuarios').doc(user?.uid);
        DocumentSnapshot userDoc = await userDocRef.get();

        if (userDoc.exists) {
          await userDocRef.update({
            'nombre': nuevoNombre
          }); // Actualiza el nombre en el documento de usuario
        } else {
          await userDocRef.set({
            'nombre': nuevoNombre
          }); // Crea un nuevo documento con el nombre si no existe
        }

        // Actualiza el texto en el controlador del campo de nombre
        setState(() {
          nombreController.text = nuevoNombre;
        });

        // Muestra un mensaje de éxito al usuario
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nombre actualizado'),
        ));
      } catch (e) {
        // Muestra un mensaje de error si falla la actualización
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cambiar el nombre: $e'),
        ));
      }
    }
  }

  /// Método para cambiar la contraseña del usuario en Firebase Auth.
  Future<void> cambiarContrasena(
      String contrasenaAntigua, String nuevaContrasena) async {
    User? user =
        _auth.currentUser; // Obtiene el usuario actualmente autenticado

    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!, // Obtiene el email del usuario
        password:
            contrasenaAntigua, // Contraseña antigua proporcionada por el usuario
      );

      try {
        // Reautentica al usuario con la credencial proporcionada
        await user.reauthenticateWithCredential(credential);
        // Actualiza la contraseña del usuario en Firebase Auth
        await user.updatePassword(nuevaContrasena);

        // Muestra un mensaje de éxito al usuario
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contraseña actualizada'),
        ));
      } catch (e) {
        // Muestra un mensaje de error si falla la actualización
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cambiar la contraseña: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user =
        _auth.currentUser; // Obtiene el usuario actualmente autenticado
    String? email = user?.email; // Obtiene el email del usuario
    String? displayName =
        user?.displayName; // Obtiene el nombre para mostrar del usuario

    return Scaffold(
      drawer: MyDrawer(), // Widget del drawer para la navegación
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Ajustes'),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context)
                  .openDrawer(); // Abre el drawer al presionar el ícono de menú
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            // Sección para mostrar el saludo y el email del usuario
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¡Hola $displayName!',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                RichText(
                  text: TextSpan(
                    text: email,
                    style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blueAccent),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            // Sección para cambiar el nombre del usuario
            ExpansionTile(
              title: Text(
                'Cambiar nombre',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                // Campo de texto para introducir el nuevo nombre
                TextField(
                  controller: nombreController,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: 'Introduce nombre',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón para guardar el nuevo nombre
                ElevatedButton(
                  onPressed: () async {
                    String nuevoNombre = nombreController.text;
                    if (nuevoNombre.isNotEmpty) {
                      await cambiarNombre(nuevoNombre);
                    }
                  },
                  child: Text(
                    'Guardar nombre',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
            // Sección para cambiar la contraseña del usuario
            ExpansionTile(
              title: Text(
                'Cambiar contraseña',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              children: [
                // Campo de texto para introducir la contraseña antigua
                TextField(
                  controller: contrasenaAntiguaController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: 'Introduce contraseña antigua',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    // Ícono para alternar la visibilidad de la contraseña
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de texto para introducir la nueva contraseña
                TextField(
                  controller: contrasenaNuevaController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: 'Introduce nueva contraseña',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    // Ícono para alternar la visibilidad de la contraseña
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Campo de texto para repetir la nueva contraseña
                TextField(
                  controller: contrasenaRepetirController,
                  obscureText: !_isPasswordVisible,
                  decoration: InputDecoration(
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.white),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.shade400),
                    ),
                    fillColor: Colors.grey.shade200,
                    filled: true,
                    hintText: 'Repite nueva contraseña',
                    hintStyle: TextStyle(color: Colors.grey[500]),
                    // Ícono para alternar la visibilidad de la contraseña
                    suffixIcon: IconButton(
                      icon: Icon(
                        _isPasswordVisible
                            ? Icons.visibility
                            : Icons.visibility_off,
                      ),
                      onPressed: () {
                        setState(() {
                          _isPasswordVisible = !_isPasswordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                // Botón para guardar la nueva contraseña
                ElevatedButton(
                  onPressed: () async {
                    String contrasenaAntigua = contrasenaAntiguaController.text;
                    String nuevaContrasena = contrasenaNuevaController.text;
                    String repetirContrasena = contrasenaRepetirController.text;

                    if (contrasenaAntigua.isNotEmpty &&
                        nuevaContrasena.isNotEmpty &&
                        repetirContrasena.isNotEmpty) {
                      if (nuevaContrasena == repetirContrasena) {
                        await cambiarContrasena(
                            contrasenaAntigua, nuevaContrasena);
                      } else {
                        // Muestra un mensaje si las contraseñas no coinciden
                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text('Las nuevas contraseñas no coinciden'),
                        ));
                      }
                    }
                  },
                  child: Text(
                    'Guardar contraseña',
                    style: TextStyle(fontSize: 18.0),
                  ),
                  style: ElevatedButton.styleFrom(
                    foregroundColor: Colors.white,
                    backgroundColor: Colors.lightBlueAccent,
                    padding: const EdgeInsets.symmetric(
                        vertical: 20.0, horizontal: 50.0),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

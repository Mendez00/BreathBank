import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:breath_bank/Paginas/drawer.dart';

class Ajustes extends StatefulWidget {
  final Function()? onTap;

  const Ajustes({Key? key, this.onTap}) : super(key: key);

  @override
  EstadoAjustes createState() => EstadoAjustes();
}

class EstadoAjustes extends State<Ajustes> {
  final TextEditingController nombreController = TextEditingController();
  final TextEditingController contrasenaAntiguaController = TextEditingController();
  final TextEditingController contrasenaNuevaController = TextEditingController();
  final TextEditingController contrasenaRepetirController = TextEditingController();
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  bool _showChangeName = false;
  bool _showChangePassword = false;
  bool _isPasswordVisible = false;

  Future<void> cambiarNombre(String nuevoNombre) async {
    User? user = _auth.currentUser;
    if (user != null) {
      try {

        await user.updateDisplayName(nuevoNombre);
        await user.reload();
        user = _auth.currentUser;

        DocumentReference userDocRef = _firestore.collection('usuarios').doc(user?.uid);
        DocumentSnapshot userDoc = await userDocRef.get();

        if (userDoc.exists) {

          await userDocRef.update({'nombre': nuevoNombre});
        } else {

          await userDocRef.set({'nombre': nuevoNombre});
        }

        setState(() {
          nombreController.text = nuevoNombre;
        });

        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Nombre actualizado'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cambiar el nombre: $e'),
        ));
      }
    }
  }

  Future<void> cambiarContrasena(String contrasenaAntigua, String nuevaContrasena) async {
    User? user = _auth.currentUser;
    if (user != null) {
      AuthCredential credential = EmailAuthProvider.credential(
        email: user.email!,
        password: contrasenaAntigua,
      );

      try {
        await user.reauthenticateWithCredential(credential);
        await user.updatePassword(nuevaContrasena);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Contraseña actualizada'),
        ));
      } catch (e) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Error al cambiar la contraseña: $e'),
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String? email = user?.email;
    String? displayName = user?.displayName;

    return Scaffold(
      drawer: MyDrawer(),
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
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Center(
              child: Column(
                children: [
                  if (user?.photoURL != null)
                    CircleAvatar(
                      backgroundImage: NetworkImage(user!.photoURL!),
                      radius: 50,
                    ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: email,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
            const SizedBox(height: 20),
            ExpansionTile(
              title: Text('Cambiar nombre'),
              children: [
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
            ExpansionTile(
              title: Text('Cambiar contraseña'),
              children: [
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
                ElevatedButton(
                  onPressed: () async {
                    String contrasenaAntigua = contrasenaAntiguaController.text;
                    String nuevaContrasena = contrasenaNuevaController.text;
                    String repetirContrasena = contrasenaRepetirController.text;

                    if (contrasenaAntigua.isNotEmpty &&
                        nuevaContrasena.isNotEmpty &&
                        repetirContrasena.isNotEmpty) {
                      if (nuevaContrasena == repetirContrasena) {
                        await cambiarContrasena(contrasenaAntigua, nuevaContrasena);
                      } else {
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

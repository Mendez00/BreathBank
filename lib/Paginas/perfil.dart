import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'package:breath_bank/Paginas/drawer.dart';

class Perfil extends StatefulWidget {
  final Function()? onTap;

  const Perfil({Key? key, this.onTap}) : super(key: key);

  @override
  EstadoPerfil createState() => EstadoPerfil();
}

class EstadoPerfil extends State<Perfil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String displayName = '';
  int _nivelInversor = 0;
  String _fechaInversion = '';
  String _selectedCountry = 'Seleccione su país';
  String _selectedProvince = 'Seleccione su provincia';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
    _loadOriginData();
  }

  // Método para obtener información del usuario desde Firebase Authentication y Firestore
  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        displayName = user.displayName ?? ''; // Nombre de usuario
      });

      String userId = user.uid;

      try {
        DocumentSnapshot resumenSnapshot = await _firestore
            .collection('Prueba de nivel')
            .doc(userId)
            .collection('Pruebas')
            .orderBy('fecha1', descending: true)
            .limit(1)
            .get()
            .then((snapshot) => snapshot.docs.last);

        if (resumenSnapshot.exists) {
          Map<String, dynamic> data = resumenSnapshot.data() as Map<String, dynamic>;

          setState(() {
            _nivelInversor = data['Nivel Inversor'] ?? 0; // Nivel de inversor del usuario
            Timestamp fecha = data['fecha1'] ?? Timestamp.now(); // Fecha de la última inversión
            _fechaInversion = DateFormat('dd-MM-yyyy – kk:mm').format(fecha.toDate()); // Formateo de fecha
          });
        } else {
          print("No existe documento de resumen para el usuario");
        }
      } catch (e) {
        print("Error al obtener datos del usuario: $e");
      }
    } else {
      print("Usuario no está autenticado");
    }
  }

  // Método para cargar información de origen (país y provincia) del usuario desde Firestore
  Future<void> _loadOriginData() async {
    User? user = _auth.currentUser;
    if (user != null) {
      DocumentSnapshot snapshot = await _firestore.collection('Lugar del usuario').doc(user.uid).get();
      if (snapshot.exists) {
        Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;

        setState(() {
          _selectedCountry = data['pais'] ?? 'Seleccione su país'; // País seleccionado
          _selectedProvince = data['provincia'] ?? 'Seleccione su provincia'; // Provincia seleccionada
        });
      }
    }
  }

  // Método para mostrar el selector de país
  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country.name == "Spain" ? "España" : country.name; // Actualiza el país seleccionado
        });
      },
    );
  }

  // Método para mostrar el selector de provincia
  void _showProvincePicker() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Seleccione su provincia'),
          content: Container(
            width: double.minPositive,
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: provinciasEspana.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(provinciasEspana[index]),
                  onTap: () {
                    setState(() {
                      _selectedProvince = provinciasEspana[index]; // Actualiza la provincia seleccionada
                    });
                    Navigator.pop(context);
                  },
                );
              },
            ),
          ),
        );
      },
    );
  }

  // Método para guardar la selección de país y provincia en Firestore
  Future<void> _saveOrigin() async {
    User? user = _auth.currentUser;
    if (user != null) {
      await _firestore.collection('Lugar del usuario').doc(user.uid).set({
        'pais': _selectedCountry,
        'provincia': _selectedProvince,
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    User? user = _auth.currentUser;
    String? email = user?.email;

    return Scaffold(
      drawer: MyDrawer(), // Drawer personalizado
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Perfil'), // Título de la AppBar
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(
              Icons.menu,
              color: Colors.black,
            ),
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Abre el drawer al presionar el ícono del menú
            },
          ),
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: ListView(
          children: [
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '¡Hola $displayName!', // Saludo al usuario
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 5),
                RichText(
                  text: TextSpan(
                    text: email, // Correo electrónico del usuario
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.blueAccent,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 40),
            Text(
              'Nivel de inversor: $_nivelInversor', // Muestra el nivel de inversor del usuario
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              'Fecha de inversión: $_fechaInversion', // Muestra la última fecha de inversión del usuario
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              '¿Desde dónde realizas las inversiones?', // Título para la selección de país y provincia
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              textAlign: TextAlign.left,
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showCountryPicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedCountry, // Muestra el país seleccionado
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down), // Icono de despliegue para seleccionar país
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            GestureDetector(
              onTap: _showProvincePicker,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  vertical: 12.0,
                  horizontal: 16.0,
                ),
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _selectedProvince, // Muestra la provincia seleccionada
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down), // Icono de despliegue para seleccionar provincia
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrigin, // Guarda la selección de país y provincia
              child: Text(
                'Guardar Origen',
                style: TextStyle(fontSize: 18.0),
              ),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(
                  vertical: 20.0,
                  horizontal: 50.0,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// Lista de provincias de España para el selector de provincias
const List<String> provinciasEspana = [
  'Álava',
  'Albacete',
  'Alicante',
  'Almería',
  'Asturias',
  'Ávila',
  'Badajoz',
  'Baleares',
  'Barcelona',
  'Burgos',
  'Cáceres',
  'Cádiz',
  'Cantabria',
  'Castellón',
  'Ciudad Real',
  'Córdoba',
  'Cuenca',
  'Gerona',
  'Granada',
  'Guadalajara',
  'Guipúzcoa',
  'Huelva',
  'Huesca',
  'Jaén',
  'La Coruña',
  'La Rioja',
  'Las Palmas',
  'León',
  'Lérida',
  'Lugo',
  'Madrid',
  'Málaga',
  'Murcia',
  'Navarra',
  'Orense',
  'Palencia',
  'Pontevedra',
  'Salamanca',
  'Santa Cruz de Tenerife',
  'Segovia',
  'Sevilla',
  'Soria',
  'Tarragona',
  'Teruel',
  'Toledo',
  'Valencia',
  'Valladolid',
  'Vizcaya',
  'Zamora',
  'Zaragoza'
];

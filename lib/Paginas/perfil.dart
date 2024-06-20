import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:country_picker/country_picker.dart';
import 'drawer.dart';

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
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        displayName = user.displayName ?? '';
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

          print("Data from Firestore: $data");

          setState(() {
            _nivelInversor = data['Nivel Inversor'] ?? 0;
            Timestamp fecha = data['fecha1'] ?? Timestamp.now();
            _fechaInversion = DateFormat('dd-MM-yyyy – kk:mm').format(fecha.toDate());

            print("Nivel Inversor: $_nivelInversor");
            print("Fecha Inversión: $_fechaInversion");
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

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country.name == "Spain" ? "España" : country.name;
        });
      },
    );
  }

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
                      _selectedProvince = provinciasEspana[index];
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
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Perfil'),
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
            const SizedBox(height: 40),
            Text(
              'Nivel de inversor: $_nivelInversor',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              'Fecha de inversión: $_fechaInversion',
              style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            Text(
              '¿Desde dónde realizas las inversiones?',
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
                      _selectedCountry,
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down),
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
                      _selectedProvince,
                      style: TextStyle(fontSize: 16),
                    ),
                    Icon(Icons.arrow_drop_down),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveOrigin,
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

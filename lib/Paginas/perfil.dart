import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';
import 'package:breath_bank/Paginas/drawer.dart';
import 'package:country_picker/country_picker.dart';

class Perfil extends StatefulWidget {
  final Function()? onTap;

  const Perfil({Key? key, this.onTap}) : super(key: key);

  @override
  EstadoPerfil createState() => EstadoPerfil();
}

class EstadoPerfil extends State<Perfil> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  String _displayName = '';
  int _totalEjercicios = 0;
  String _ultimaInversion = '';
  String _primeraInversion = '';
  String _selectedCountry = 'Seleccione su país';

  @override
  void initState() {
    super.initState();
    _getUserInfo();
  }

  Future<void> _getUserInfo() async {
    User? user = _auth.currentUser;
    if (user != null) {
      setState(() {
        _displayName = user.displayName ?? 'Por favor, actualiza tu nombre en la pantalla de ajustes';
      });

      String userId = user.uid;

      QuerySnapshot inversionesSnapshot = await _firestore
          .collection('Inversiones')
          .where('usuario_id', isEqualTo: userId)
          .orderBy('fecha1')
          .get();

      if (inversionesSnapshot.docs.isNotEmpty) {
        setState(() {
          List<DateTime> dates = inversionesSnapshot.docs.map((doc) {
            Timestamp fecha = doc['fecha1'];
            return fecha.toDate();
          }).toList();

          _totalEjercicios = inversionesSnapshot.docs.length;
          dates.sort((a, b) => a.compareTo(b));
          _primeraInversion = DateFormat('dd-MM-yyyy – kk:mm').format(dates.first);
          _ultimaInversion = DateFormat('dd-MM-yyyy – kk:mm').format(dates.last);
        });
      }
    }
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      showPhoneCode: false,
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country.name;
        });
      },
    );
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
            Center(
              child: Column(
                children: [
                  const SizedBox(height: 20),
                  Text(
                    'Usuario: $_displayName',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Colors.black,
                    ),
                  ),
                  const SizedBox(height: 20),
                  RichText(
                    text: TextSpan(
                      text: email,
                      style: TextStyle(fontSize: 20, color: Colors.black),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    'Total de inversiones: $_totalEjercicios',
                    style: TextStyle(fontSize: 16),
                  ),
                  const SizedBox(height: 20),
                  if (_ultimaInversion.isNotEmpty)
                    Text(
                      'Última inversión: $_ultimaInversion',
                      style: TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  if (_primeraInversion.isNotEmpty)
                    Text(
                      'Primera inversión: $_primeraInversion',
                      style: TextStyle(fontSize: 16),
                    ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: _showCountryPicker,
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12.0, horizontal: 16.0),
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
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

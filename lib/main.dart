import 'package:breath_bank/Paginas/menuPrincipalInicial.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'package:breath_bank/Paginas/inicioSesion.dart';
import 'package:breath_bank/Paginas/inversion.dart';
import 'package:flutter/material.dart';



void main() async{
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
    home: InicioSesion(),
      );
  }
}

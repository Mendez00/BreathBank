import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/resumen.dart';
import 'package:breath_bank/Paginas/ejercicio1.dart';
import 'package:breath_bank/Paginas/ejercicio2.dart';
import 'package:breath_bank/Paginas/ejercicio3.dart';

enum EstadoEjercicio { Pendiente, Completado, Bloqueado }

class Inversion extends StatefulWidget {
  final VoidCallback onTap;
  const Inversion({required this.onTap});

  @override
  State<Inversion> createState() => EstadoInversion();
}

class EstadoInversion extends State<Inversion> {
  final PageController _pageController = PageController();
  bool flechaBloqueada = true;
  int paginaActual = 0;
  var estadoEjercicio1;
  var estadoEjercicio2;
  var estadoEjercicio3;

  @override
  void initState() {
    super.initState();
    estadoEjercicio1 = EstadoEjercicio.Pendiente;
    estadoEjercicio2 = EstadoEjercicio.Bloqueado;
    estadoEjercicio3 = EstadoEjercicio.Bloqueado;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: PageView(
              controller: _pageController,
              onPageChanged: (int page) {
                setState(() {
                  paginaActual = page;
                });
              },
              children: [
                buildEjercicio1Container(),
                buildEjercicio2Container(),
                buildEjercicio3Container(),
              ],
            ),
          ),
          const SizedBox(height: 20),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i <= 2; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor:
                      i == paginaActual ? Colors.lightBlueAccent : Colors.grey,
                      radius: 10,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget buildEjercicio1Container() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'lib/imagenes/E1.png',
              width: 200,
              height: 100,
              fit: BoxFit.contain,
            ),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Ejercicio 1\n',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Tumbado boca arriba, realiza un minuto de respiraciones relajadas, y después cuenta las respiraciones que realices en el siguiente minuto.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            buildBotton(
              'Ejercicio 1',
              estadoEjercicio1,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ejercicio1(
                      onEjercicioCompleto: () {
                        setState(() {
                          estadoEjercicio1 = EstadoEjercicio.Completado;
                          estadoEjercicio2 = EstadoEjercicio.Pendiente;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEjercicio2Container() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'lib/imagenes/E1.png',
              width: 200,
              height: 100,
              fit: BoxFit.contain,
            ),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Ejercicio 2\n',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Tumbado boca arriba, cuenta cuanto tardas en realizar tres respiraciones lentas. Hazlo 3 veces y halla la media de las 3',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            buildBotton(
              'Ejercicio 2',
              estadoEjercicio2,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ejercicio2(
                      onEjercicioCompleto: () {
                        setState(() {
                          estadoEjercicio2 = EstadoEjercicio.Completado;
                          estadoEjercicio3 = EstadoEjercicio.Pendiente;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildEjercicio3Container() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'lib/imagenes/E1.png',
              width: 200,
              height: 100,
              fit: BoxFit.contain,
            ),
            const Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: 'Ejercicio 3\n',
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  TextSpan(
                    text:
                        'Tumbado boca arriba, y con la ayuda del audio, sigue las ordenes de inspiración y espiración que marca el pitido, hasta el último número que llegues sin perder el orden de las respiraciones.',
                    style: TextStyle(
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
            buildBotton(
              'Ejercicio 3',
              estadoEjercicio3,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ejercicio3(
                      onEjercicioCompleto: () {
                        setState(() {
                          estadoEjercicio3 = EstadoEjercicio.Completado;
                        });
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

Widget buildBotton(
    String texto, EstadoEjercicio estado, VoidCallback onPressed) {
  Color backgroundColor;
  String buttonText;
  bool isEnabled;

  switch (estado) {
    case EstadoEjercicio.Pendiente:
      backgroundColor = Colors.lightBlueAccent;
      buttonText = '¡Vamos!';
      isEnabled = true;
      break;
    case EstadoEjercicio.Completado:
      backgroundColor = Colors.green;
      buttonText = '¡Hecho!';
      isEnabled = false;
      break;
    case EstadoEjercicio.Bloqueado:
      backgroundColor = Colors.grey;
      buttonText = '¡Vamos!';
      isEnabled = false;
      break;
  }

  return ElevatedButton(
    onPressed: isEnabled ? onPressed : null,
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: backgroundColor,
      padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 75.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
    ),
    child: Text(
      buttonText,
      style: const TextStyle(fontSize: 25.0),
    ),
  );
}

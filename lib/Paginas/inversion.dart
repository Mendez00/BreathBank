import 'package:breath_bank/Paginas/resumen.dart';
import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/ejercicio1.dart';
import 'package:breath_bank/Paginas/ejercicio2.dart';
import 'package:breath_bank/Paginas/ejercicio3.dart';

class Inversion extends StatefulWidget {
  final Function()? onTap;
  const Inversion({super.key, required this.onTap});

  @override
  State<Inversion> createState() => EstadoInversion();
}

class EstadoInversion extends State<Inversion> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final List<bool> _ejerciciosCompletados = [false, false, false];

  @override
  Widget build(BuildContext context) {
    final List<Widget> _ejercicios = [
      Container(
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
                'lib/images/E1.png',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ejercicio1()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 35.0, horizontal: 75.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.lightBlueAccent,
                  onPrimary: Colors.white,
                ),
                child: const Text(
                  '¡Vamos!',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
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
                'lib/images/E1.png',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ejercicio2()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 35.0, horizontal: 75.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.lightBlueAccent,
                  onPrimary: Colors.white,
                ),
                child: const Text(
                  '¡Vamos!',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ],
          ),
        ),
      ),
      Container(
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
                'lib/images/E1.png',
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
              ElevatedButton(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => Ejercicio3()),
                  );
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(
                      vertical: 35.0, horizontal: 75.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  primary: Colors.lightBlueAccent,
                  onPrimary: Colors.white,
                ),
                child: const Text(
                  '¡Vamos!',
                  style: TextStyle(fontSize: 25.0),
                ),
              ),
            ],
          ),
        ),
      ),
    ];
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100),
          Expanded(
            child: PageView.builder(
              controller: _pageController,
              itemCount: _ejercicios.length,
              onPageChanged: (int page) {
                setState(() {
                  _currentPage = page;
                });
              },
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: _ejercicios[index],
                );
              },
            ),
          ),
          const SizedBox(height: 100),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              _ejercicios.length,
              (index) => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Icon(
                  _ejerciciosCompletados[index] ? Icons.check : Icons.circle,
                  color: _ejerciciosCompletados[index]
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if(_ejerciciosCompletados.length == 3){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Resumen()),
            );
          }

          setState(() {
            if (_currentPage < _ejerciciosCompletados.length - 1 &&
                _ejerciciosCompletados[_currentPage]) {
              _currentPage++;
            }
          });
        },
        child: Icon(Icons.arrow_forward, color: Colors.lightBlueAccent),
      ),
    );
  }

  void marcarEjercicioCompletado(int index) {
    setState(() {
      _ejerciciosCompletados[index] = true;
    });
  }
}

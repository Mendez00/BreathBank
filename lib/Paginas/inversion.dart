import 'package:flutter/material.dart';
import 'package:breath_bank/Paginas/ejercicio1.dart';
import 'package:breath_bank/Paginas/ejercicio2.dart';
import 'package:breath_bank/Paginas/ejercicio3.dart';

// Enumeración para representar los estados de los ejercicios
enum EstadoEjercicio { Pendiente, Completado, Bloqueado }

// Widget principal que representa la pantalla de Inversión
class Inversion extends StatefulWidget {
  final VoidCallback onTap; // Función de retorno al tocar
  const Inversion({required this.onTap});

  @override
  State<Inversion> createState() => EstadoInversion();
}

// Estado de la pantalla de Inversión
class EstadoInversion extends State<Inversion> {
  final PageController _pageController = PageController(); // Controlador de la página
  bool flechaBloqueada = true; // Estado de bloqueo de flecha (no utilizado en el código proporcionado)
  int paginaActual = 0; // Índice de la página actual
  var estadoEjercicio1; // Estado del ejercicio 1
  var estadoEjercicio2; // Estado del ejercicio 2
  var estadoEjercicio3; // Estado del ejercicio 3

  @override
  void initState() {
    super.initState();
    estadoEjercicio1 = EstadoEjercicio.Pendiente; // Inicialización del estado del ejercicio 1 como Pendiente
    estadoEjercicio2 = EstadoEjercicio.Bloqueado; // Inicialización del estado del ejercicio 2 como Bloqueado
    estadoEjercicio3 = EstadoEjercicio.Bloqueado; // Inicialización del estado del ejercicio 3 como Bloqueado
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          const SizedBox(height: 100), // Espacio en blanco
          Expanded(
            child: PageView(
              controller: _pageController, // Controlador de la página para el PageView
              onPageChanged: (int page) {
                setState(() {
                  paginaActual = page; // Actualizar la página actual cuando se cambia de página
                });
              },
              children: [
                buildEjercicio1Container(), // Contenedor del ejercicio 1
                buildEjercicio2Container(), // Contenedor del ejercicio 2
                buildEjercicio3Container(), // Contenedor del ejercicio 3
              ],
            ),
          ),
          const SizedBox(height: 20), // Espacio en blanco
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                for (int i = 0; i <= 2; i++)
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: CircleAvatar(
                      backgroundColor: i == paginaActual ? Colors.lightBlueAccent : Colors.grey, // Color del indicador de página actual
                      radius: 10,
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(height: 20), // Espacio en blanco
        ],
      ),
    );
  }

  // Constructor del contenedor del ejercicio 1
  Widget buildEjercicio1Container() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(12), // Borde redondeado del contenedor
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'lib/imagenes/Ej1.png', // Imagen del ejercicio 1
              width: 250,
              height: 150,
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
            buildBotton( // Botón del ejercicio 1
              'Ejercicio 1', // Texto del botón
              estadoEjercicio1, // Estado del botón
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ejercicio1(
                      onEjercicioCompleto: () {
                        setState(() {
                          estadoEjercicio1 = EstadoEjercicio.Completado; // Actualización del estado del ejercicio 1 a Completado
                          estadoEjercicio2 = EstadoEjercicio.Pendiente; // Actualización del estado del ejercicio 2 a Pendiente
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

  // Constructor del contenedor del ejercicio 2
  Widget buildEjercicio2Container() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(12), // Borde redondeado del contenedor
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'lib/imagenes/Ej2.png', // Imagen del ejercicio 2
              width: 250,
              height: 150,
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
            buildBotton( // Botón del ejercicio 2
              'Ejercicio 2', // Texto del botón
              estadoEjercicio2, // Estado del botón
                  () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ejercicio2(
                      onEjercicioCompleto: () {
                        setState(() {
                          estadoEjercicio2 = EstadoEjercicio.Completado; // Actualización del estado del ejercicio 2 a Completado
                          estadoEjercicio3 = EstadoEjercicio.Pendiente; // Actualización del estado del ejercicio 3 a Pendiente
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

  // Constructor del contenedor del ejercicio 3
  Widget buildEjercicio3Container() {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color: Colors.grey[200], // Color de fondo del contenedor
        borderRadius: BorderRadius.circular(12), // Borde redondeado del contenedor
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Image.asset(
              'lib/imagenes/Ej3.png', // Imagen del ejercicio 3
              width: 250,
              height: 150,
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
            buildBotton( // Botón del ejercicio 3
              'Ejercicio 3', // Texto del botón
              estadoEjercicio3, // Estado del botón
                  () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Ejercicio3(
                      onEjercicioCompleto: () {
                        setState(() {
                          estadoEjercicio3 = EstadoEjercicio.Completado; // Actualización del estado del ejercicio 3 a Completado
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

// Función para construir el botón del ejercicio
Widget buildBotton(
    String texto, EstadoEjercicio estado, VoidCallback onPressed) {
  Color backgroundColor; // Color de fondo del botón
  String buttonText; // Texto del botón
  bool isEnabled; // Estado de habilitación del botón

  // Switch para determinar el color, texto y habilitación del botón basado en el estado del ejercicio
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

  // Retorna un ElevatedButton con estilo definido
  return ElevatedButton(
    onPressed: isEnabled ? onPressed : null, // Habilita el botón solo si está permitido
    style: ElevatedButton.styleFrom(
      foregroundColor: Colors.white,
      backgroundColor: backgroundColor, // Aplica el color de fondo determinado
      padding: const EdgeInsets.symmetric(vertical: 35.0, horizontal: 75.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12), // Borde redondeado del botón
      ),
    ),
    child: Text(
      buttonText, // Texto del botón definido por el estado
      style: const TextStyle(fontSize: 25.0),
    ),
  );
}

import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:breath_bank/Paginas/drawer.dart';

class Estadisticas extends StatefulWidget {
  @override
  EstadoEstadisticas createState() => EstadoEstadisticas();
}

class EstadoEstadisticas extends State<Estadisticas> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance; // Instancia de Firestore
  List<_ChartData> dataEj1 = []; // Lista para almacenar datos del Ejercicio 1
  List<_ChartData> dataEj2 = []; // Lista para almacenar datos del Ejercicio 2
  List<_ChartData> dataEj3 = []; // Lista para almacenar datos del Ejercicio 3
  DateTimeRange? FechaSeleccionada; // Rango de fecha seleccionado
  String selectedChart = 'Ejercicio 1'; // Gráfico seleccionado inicialmente

  @override
  void initState() {
    super.initState();
    buscarData(); // Llamar a la función para buscar datos al inicializar
  }

  // Función asincrónica para buscar datos en Firestore
  Future<void> buscarData() async {
    User? user = FirebaseAuth.instance.currentUser; // Obtener usuario actualmente autenticado
    if (user != null) {
      String userId = user.uid;
      final snapshot = await _firestore
          .collection('Prueba de nivel')
          .doc(userId)
          .collection('Pruebas')
          .get(); // Consulta para obtener documentos de pruebas del usuario

      // Listas temporales para almacenar datos de cada ejercicio
      List<_ChartData> tempDataEj1 = [];
      List<_ChartData> tempDataEj2 = [];
      List<_ChartData> tempDataEj3 = [];

      // Iterar sobre los documentos obtenidos
      for (var doc in snapshot.docs) {
        DateTime date = doc['fecha1'].toDate(); // Convertir fecha de Firestore a DateTime
        // Añadir datos a las listas temporales, con manejo de si existen o no los campos específicos en Firestore
        tempDataEj1.add(
            _ChartData(date, doc.data().containsKey('Ej1') ? doc['Ej1'] : 0));
        tempDataEj2.add(
            _ChartData(date, doc.data().containsKey('Ej2') ? doc['Ej2'] : 0));
        tempDataEj3.add(
            _ChartData(date, doc.data().containsKey('Ej3') ? doc['Ej3'] : 0));
      }

      // Actualizar el estado con los datos recuperados
      setState(() {
        dataEj1 = tempDataEj1;
        dataEj2 = tempDataEj2;
        dataEj3 = tempDataEj3;
      });

      // Imprimir datos recuperados para fines de depuración
      print("Fetched dataEj1: $dataEj1");
      print("Fetched dataEj2: $dataEj2");
      print("Fetched dataEj3: $dataEj3");
    }
  }

  // Función para seleccionar un rango de fecha
  void SelFecha(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: FechaSeleccionada,
    );
    if (picked != null && picked != FechaSeleccionada) {
      setState(() {
        FechaSeleccionada = picked; // Actualizar el estado con el rango de fecha seleccionado
      });
    }
  }

  // Función para filtrar los datos por el rango de fecha seleccionado
  List<_ChartData> filterDataByDateRange(List<_ChartData> data) {
    if (FechaSeleccionada == null) {
      return data; // Si no se ha seleccionado ningún rango de fecha, devolver los datos sin filtrar
    }

    // Filtrar y devolver los datos dentro del rango de fecha seleccionado
    return data.where((chartData) {
      return chartData.date.isAfter(FechaSeleccionada!.start) &&
          chartData.date.isBefore(FechaSeleccionada!.end);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser; // Obtener usuario actualmente autenticado
    String userId = user?.uid ?? ''; // Obtener el UID del usuario actual o cadena vacía si no está autenticado

    // Filtrar datos según el rango de fecha seleccionado
    List<_ChartData> filteredDataEj1 = filterDataByDateRange(dataEj1);
    List<_ChartData> filteredDataEj2 = filterDataByDateRange(dataEj2);
    List<_ChartData> filteredDataEj3 = filterDataByDateRange(dataEj3);

    // Imprimir datos filtrados para fines de depuración
    print("Filtered dataEj1: $filteredDataEj1");
    print("Filtered dataEj2: $filteredDataEj2");
    print("Filtered dataEj3: $filteredDataEj3");

    // Función para obtener los datos de gráfico actualmente seleccionados
    List<_ChartData> getCurrentChartData() {
      switch (selectedChart) {
        case 'Ejercicio 1':
          return filteredDataEj1;
        case 'Ejercicio 2':
          return filteredDataEj2;
        case 'Ejercicio 3':
          return filteredDataEj3;
        default:
          return [];
      }
    }

    return Scaffold(
      backgroundColor: Colors.white, // Fondo blanco para la pantalla
      drawer: MyDrawer(), // Widget del drawer personalizado
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent, // Color de fondo de la barra de aplicación
        title: Text('Estadísticas'), // Título de la barra de aplicación
        centerTitle: true, // Centrar el título en la barra de aplicación
        elevation: 0, // Sin elevación en la barra de aplicación
        leading: Builder(
          // Widget para el botón del drawer
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black), // Icono del botón del drawer
            onPressed: () {
              Scaffold.of(context).openDrawer(); // Abrir el drawer al presionar el botón
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20), // Espacio vertical
            ElevatedButton(
              onPressed: () => SelFecha(context), // Función para seleccionar fecha
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white, // Texto en color blanco
                backgroundColor: Colors.lightBlueAccent, // Color de fondo del botón
                padding: const EdgeInsets.symmetric(
                    vertical: 20.0, horizontal: 50.0), // Padding del botón
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12), // Borde redondeado
                ),
              ),
              child: const Text(
                'Seleccionar Fecha', // Texto del botón para seleccionar fecha
                style: TextStyle(fontSize: 18.0), // Estilo del texto
              ),
            ),
            SizedBox(height: 20), // Espacio vertical
            DropdownButton<String>(
              value: selectedChart, // Valor seleccionado del DropdownButton
              onChanged: (String? newValue) {
                setState(() {
                  selectedChart = newValue!; // Actualizar el gráfico seleccionado
                });
              },
              items: <String>['Ejercicio 1', 'Ejercicio 2', 'Ejercicio 3']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value), // Texto del item del DropdownButton
                );
              }).toList(),
            ),
            SizedBox(height: 20), // Espacio vertical
            SfCartesianChart(
              // Gráfico de Syncfusion para visualizar datos
              legend: Legend(isVisible: false), // Leyenda no visible
              primaryXAxis: DateTimeAxis(
                title: AxisTitle(text: 'Fecha'), // Título del eje X (fecha)
              ),
              primaryYAxis: NumericAxis(
                title: AxisTitle(text: 'Valor alcanzado'), // Título del eje Y (valor alcanzado)
              ),
              series: <CartesianSeries<dynamic, DateTime>>[
                LineSeries<_ChartData, DateTime>(
                  dataSource: getCurrentChartData(), // Datos del gráfico según el ejercicio seleccionado
                  xValueMapper: (_ChartData data, _) => data.date, // Mapeo del valor X (fecha)
                  yValueMapper: (_ChartData data, _) => data.value, // Mapeo del valor Y (valor alcanzado)
                  name: selectedChart, // Nombre del gráfico según el ejercicio seleccionado
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// Clase privada para estructurar los datos del gráfico (_ChartData)
class _ChartData {
  _ChartData(this.date, this.value); // Constructor de la clase _ChartData

  final DateTime date; // Fecha del dato
  final int value; // Valor asociado a la fecha

  @override
  String toString() => '$_ChartData(date: $date, value: $value)'; // Representación de cadena para depuración
}

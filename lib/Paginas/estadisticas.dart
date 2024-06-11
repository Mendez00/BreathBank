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
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  List<_ChartData> dataEj1 = [];
  List<_ChartData> dataEj2 = [];
  List<_ChartData> dataEj3 = [];
  DateTimeRange? FechaSeleccionada;

  @override
  void initState() {
    super.initState();
    buscarData();
  }

  Future<void> buscarData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      String userId = user.uid;
      final snapshot = await _firestore
          .collection('Inversiones')
          .doc(userId)
          .collection('Inversión')
          .get();
      List<_ChartData> tempDataEj1 = [];
      List<_ChartData> tempDataEj2 = [];
      List<_ChartData> tempDataEj3 = [];

      for (var doc in snapshot.docs) {
        DateTime date = doc['fecha1'].toDate();
        tempDataEj1.add(
            _ChartData(date, doc.data().containsKey('Ej1') ? doc['Ej1'] : 0));
        tempDataEj2.add(
            _ChartData(date, doc.data().containsKey('Ej2') ? doc['Ej2'] : 0));
        tempDataEj3.add(
            _ChartData(date, doc.data().containsKey('Ej3') ? doc['Ej3'] : 0));
      }

      setState(() {
        dataEj1 = tempDataEj1;
        dataEj2 = tempDataEj2;
        dataEj3 = tempDataEj3;
      });

      print("Fetched dataEj1: $dataEj1");
      print("Fetched dataEj2: $dataEj2");
      print("Fetched dataEj3: $dataEj3");
    }
  }

  void SelFecha(BuildContext context) async {
    DateTimeRange? picked = await showDateRangePicker(
      context: context,
      firstDate: DateTime(2000),
      lastDate: DateTime(2101),
      initialDateRange: FechaSeleccionada,
    );
    if (picked != null && picked != FechaSeleccionada) {
      setState(() {
        FechaSeleccionada = picked;
      });
    }
  }

  List<_ChartData> filterDataByDateRange(List<_ChartData> data) {
    if (FechaSeleccionada == null) {
      return data;
    }

    return data.where((chartData) {
      return chartData.date.isAfter(FechaSeleccionada!.start) &&
          chartData.date.isBefore(FechaSeleccionada!.end);
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String userId = user?.uid ?? '';

    List<_ChartData> filteredDataEj1 = filterDataByDateRange(dataEj1);
    List<_ChartData> filteredDataEj2 = filterDataByDateRange(dataEj2);
    List<_ChartData> filteredDataEj3 = filterDataByDateRange(dataEj3);

    print("Filtered dataEj1: $filteredDataEj1");
    print("Filtered dataEj2: $filteredDataEj2");
    print("Filtered dataEj3: $filteredDataEj3");

    return Scaffold(
      backgroundColor: Colors.white,
      drawer: MyDrawer(),
      appBar: AppBar(
        backgroundColor: Colors.lightBlueAccent,
        title: Text('Estadísticas'),
        centerTitle: true,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => SelFecha(context),
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.white,
                backgroundColor: Colors.lightBlueAccent,
                padding: const EdgeInsets.symmetric(
                    vertical: 35.0, horizontal: 75.0),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: const Text(
                'Seleccionar Fecha',
                style: TextStyle(fontSize: 18.0),
              ),
            ),
            SizedBox(height: 20),
            SfCartesianChart(
              title: ChartTitle(text: 'Ejercicio 1'),
              legend: Legend(isVisible: false),
              primaryXAxis: DateTimeAxis(),
              series: <CartesianSeries<dynamic, DateTime>>[
                LineSeries<_ChartData, DateTime>(
                  dataSource: filteredDataEj1,
                  xValueMapper: (_ChartData data, _) => data.date,
                  yValueMapper: (_ChartData data, _) => data.value,
                  name: 'Ejercicio 1',
                ),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Ejercicio 2'),
              legend: Legend(isVisible: false),
              primaryXAxis: DateTimeAxis(),
              series: <CartesianSeries<dynamic, DateTime>>[
                LineSeries<_ChartData, DateTime>(
                  dataSource: filteredDataEj2,
                  xValueMapper: (_ChartData data, _) => data.date,
                  yValueMapper: (_ChartData data, _) => data.value,
                  name: 'Ejercicio 2',
                ),
              ],
            ),
            SfCartesianChart(
              title: ChartTitle(text: 'Ejercicio 3'),
              legend: Legend(isVisible: false),
              primaryXAxis: DateTimeAxis(),
              series: <CartesianSeries<dynamic, DateTime>>[
                LineSeries<_ChartData, DateTime>(
                  dataSource: filteredDataEj3,
                  xValueMapper: (_ChartData data, _) => data.date,
                  yValueMapper: (_ChartData data, _) => data.value,
                  name: 'Ejercicio 3',
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _ChartData {
  _ChartData(this.date, this.value);

  final DateTime date;
  final int value;

  @override
  String toString() => '$_ChartData(date: $date, value: $value)';
}

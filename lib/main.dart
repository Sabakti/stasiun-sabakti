import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Data Stasiun KAI',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Data Stasiun Kereta Api di Indonesia'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key? key, required this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late Future<List<dynamic>> _stations;

  Future<List<dynamic>> fetchStations() async {
    final response =
        await http.get(Uri.parse('https://booking.kai.id/api/stations2'));
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load data');
    }
  }

  @override
  void initState() {
    super.initState();
    _stations = fetchStations();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Container(
        color: Color.fromARGB(
            255, 240, 255, 72), // Memberikan warna merah pada latar belakang
        child: Center(
          child: FutureBuilder<List<dynamic>>(
            future: _stations,
            builder: (context, snapshot) {
              if (snapshot.hasData) {
                List<dynamic> data = snapshot.data!;
                return SingleChildScrollView(
                  child: DataTable(
                    columns: [
                      DataColumn(
                        label: Text(
                          'Kode',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0,
                                  0)), // Memberikan warna putih pada teks
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Nama',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0,
                                  0)), // Memberikan warna putih pada teks
                        ),
                      ),
                      DataColumn(
                        label: Text(
                          'Nama Kota',
                          style: TextStyle(
                              color: Color.fromARGB(255, 0, 0,
                                  0)), // Memberikan warna putih pada teks
                        ),
                      ),
                    ],
                    rows: data
                        .map(
                          (item) => DataRow(
                            cells: [
                              DataCell(
                                Text(
                                  item['code'].toString(),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0,
                                          0)), // Memberikan warna hitam pada teks
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['name'].toString(),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0,
                                          0)), // Memberikan warna biru pada teks
                                ),
                              ),
                              DataCell(
                                Text(
                                  item['cityname'].toString(),
                                  style: TextStyle(
                                      color: Color.fromARGB(255, 0, 0,
                                          0)), // Memberikan warna hijau pada teks
                                ),
                              ),
                            ],
                          ),
                        )
                        .toList(),
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("${snapshot.error}");
              }
              return CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}

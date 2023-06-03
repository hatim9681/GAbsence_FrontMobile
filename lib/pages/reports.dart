// ignore_for_file: library_private_types_in_public_api, prefer_const_constructors, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_null_comparison

import 'dart:convert';
import 'package:exams_absentes/Entities/Etudiant.dart';
import 'package:exams_absentes/pages/profil.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:flutter/services.dart';

import '../Entities/Pv.dart';

class Reports extends StatefulWidget {
  final int id_ex;
  const Reports({Key? key, required this.id_ex}) : super(key: key);
  @override
  _ReportsState createState() => _ReportsState();
}

class _ReportsState extends State<Reports> {
  TextEditingController numapp = TextEditingController();

  //////////////////////////////////
  late String getResult;
  bool az = false;
  void scanQRCode() async {
    try {
      final qrCode = await FlutterBarcodeScanner.scanBarcode(
        '#ff6666',
        'Cancel',
        false,
        ScanMode.QR,
      );
      if (qrCode.compareTo('-1') != 0) {
        az = true;
      }
      if (az) {
        getResult = qrCode;
        print(getResult);
        // ignore: use_build_context_synchronously
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProfilWidget(
              qrCodeResult: getResult,
              examId: widget.id_ex,
            ),
          ),
        );
        az = false;
      }
    } on PlatformException {
      setState(() {
        getResult = 'Failed to scan QR Code.';
      });
    }
  }

  late Future<List<Pv>> exam;

  late Future<List<Pv>> etuds;

  List<Etudiant> etud = [];
  late Future<List<Etudiant>> etudse;

  Future<List<Etudiant>> fetchEtudiant() async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:8030/etudiant/all'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Etudiant.fromJson(data)).toList();
    } else {
      throw Exception('Fail');
    }
  }

  Future<List<Pv>> fetchPv(int id) async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:8030/pv/exa/$id'));
    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      if (jsonResponse != null && jsonResponse is List<dynamic>) {
        List<Pv> pvList = [];

        for (dynamic json in jsonResponse) {
          Pv pv = Pv.fromJson(json);
          pvList.add(pv);
        }

        return pvList;
      } else {
        throw Exception('Invalid JSON response format.');
      }
    } else {
      throw Exception(
          'Failed to fetch Pv data. Status code: ${response.statusCode}');
    }
  }

  Etudiant? testDispo(String num) {
    for (Etudiant element in etud) {
      print(element.num_appo);
      print("num entre" + num);
      if (element.num_appo == num) {
        return element;
      }
    }
    return null;
  }

  @override
  void initState() {
    super.initState();

    exam = fetchPv(widget.id_ex);
    etudse = fetchEtudiant();
    loadData();
  }

  void loadData() async {
    etud = await etudse;
  }

  @override
  Widget build(BuildContext context) {
    Etudiant? et;
    return Scaffold(
      appBar: AppBar(
        title: const Text("Reports"),
        backgroundColor: const Color.fromARGB(255, 10, 54, 105),
        actions: [
          InkWell(
            onTap: () => {
              setState(() {
                exam = fetchPv(widget.id_ex);
                etudse = fetchEtudiant();
              })
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.refresh_rounded,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
          FutureBuilder(
            future: exam,
            builder: ((context, snapshot) {
              if (snapshot.hasData) {
                List<Pv>? examen = snapshot.data;

                return Container(
                  margin: const EdgeInsets.all(15),
                  child: Column(
                    children: [
                      Row(children: [
                        Text(
                          'Subject : ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          examen![0].examen.matiere,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ]),
                      SizedBox(height: 8),
                      Row(children: [
                        Text(
                          'Room N°: ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          examen[0].examen.salle,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ]),
                      SizedBox(height: 8),
                      Row(children: [
                        Text(
                          'Date : ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          examen[0].examen.dateExamen,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ]),
                      SizedBox(height: 8),
                      Row(children: [
                        Text(
                          'Time : ',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        Text(
                          examen[0].examen.heureD,
                          style: TextStyle(
                            fontSize: 20,
                          ),
                        ),
                      ]),
                      SizedBox(height: 8),
                    ],
                  ),
                );
              } else if (snapshot.hasError) {
                return Text("Failed to fetch Surveillant data");
              }
              return Center(
                child: CircularProgressIndicator(),
              );
            }),
          ),
          Text(
            'List Of Student  ',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 100, left: 20, right: 20),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15),
                border: Border.all(
                  color: Colors.black,
                  width: 2.0,
                ),
              ),
              width: double.infinity,
              child: SingleChildScrollView(
                child: FutureBuilder<List<Pv>>(
                  future: exam,
                  builder: (context, snapshot) {
                    List<Pv>? pvList = snapshot.data;
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return Center(child: CircularProgressIndicator());
                    } else if (snapshot.hasError) {
                      return Text('Failed to fetch data');
                    } else if (pvList == null || pvList.isEmpty) {
                      return Text('No data available');
                    } else {
                      return DataTable(
                        columns: const [
                          DataColumn(
                            label: Text('Name'),
                          ),
                          DataColumn(label: Text('Present')),
                        ],
                        rows: pvList.map((pv) {
                          return DataRow(cells: [
                            DataCell(Text(
                                '${pv.etudiant.prenom} ${pv.etudiant.nom}')),
                            DataCell(
                                Icon(pv.presence ? Icons.done : Icons.clear)),
                          ]);
                        }).toList(),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.only(left: 30),
            child: Align(
              alignment: Alignment.bottomLeft,
              child: Container(
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 10, 54, 105),
                  borderRadius: BorderRadius.circular(50),
                ),
                height: 80,
                width: 80,
                margin: EdgeInsets.only(top: 20),
                child: FloatingActionButton(
                  heroTag: "btn2",
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      builder: (BuildContext context) {
                        return SingleChildScrollView(
                          child: Container(
                            padding: EdgeInsets.only(
                              bottom: MediaQuery.of(context).viewInsets.bottom,
                            ),
                            child: SizedBox(
                              height: MediaQuery.of(context).size.height *
                                  0.4, // Adjust the fraction as desired
                              child: ListView(
                                padding: EdgeInsets.all(20),
                                children: [
                                  Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    children: [
                                      Text(
                                        "SEARCH A STUDENT",
                                        style: TextStyle(
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold,
                                          color:
                                              Color.fromARGB(255, 10, 54, 105),
                                        ),
                                      ),
                                      Divider(
                                        color: Color.fromARGB(255, 10, 54, 105),
                                        thickness: 4,
                                        indent: 30,
                                        endIndent: 30,
                                      ),
                                      Container(
                                        alignment: Alignment.center,
                                        margin: const EdgeInsets.all(20),
                                        child: TextField(
                                          decoration: InputDecoration(
                                            labelText: "Enter N°Apoge ",
                                          ),
                                          controller: numapp,
                                        ),
                                      ),
                                      Divider(
                                        color: Color.fromARGB(255, 10, 54, 105),
                                        thickness: 4,
                                        indent: 30,
                                        endIndent: 30,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          et = testDispo(numapp.text);
                                          if (et != null) {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProfilWidget(
                                                  qrCodeResult:
                                                      et!.id.toString(),
                                                  examId: widget.id_ex,
                                                ),
                                              ),
                                            );
                                          } else {
                                            showDialog(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  title:
                                                      Text("No Student Found"),
                                                  content: Text(
                                                    "There is no student with this number ",
                                                  ),
                                                  actions: [
                                                    TextButton(
                                                      child: Text("OK"),
                                                      onPressed: () {
                                                        Navigator.pop(context);
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            );
                                          }
                                        },
                                        child: Container(
                                          height: 70,
                                          margin: const EdgeInsets.all(10),
                                          alignment: Alignment.center,
                                          decoration: BoxDecoration(
                                            color: const Color.fromARGB(
                                                255, 10, 54, 105),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.search,
                                                color: Colors.white,
                                                size: 50,
                                              ),
                                              Text(
                                                "SEARCH",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 25,
                                                  fontWeight: FontWeight.bold,
                                                  fontFamily: 'PT_Serif',
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  },
                  backgroundColor: Color.fromARGB(255, 10, 54, 105),
                  child: Icon(
                    Icons.search,
                    size: 40,
                  ),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomRight,
            child: Container(
              height: 80,
              width: 80,
              margin: EdgeInsets.only(top: 20),
              child: FloatingActionButton(
                heroTag: "btn1",
                onPressed: () {
                  scanQRCode();
                },
                backgroundColor: Color.fromARGB(255, 10, 54, 105),
                child: Icon(Icons.camera, size: 40),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, use_build_context_synchronously, prefer_typing_uninitialized_variables, prefer_interpolation_to_compose_strings, unnecessary_import, non_constant_identifier_names, unused_local_variable

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:exams_absentes/Entities/Etudiant.dart';

class ProfilWidget extends StatefulWidget {
  final String qrCodeResult;
  final int examId;

  const ProfilWidget(
      {Key? key, required this.qrCodeResult, required this.examId})
      : super(key: key);

  @override
  State<ProfilWidget> createState() => Profil();
}

class Profil extends State<ProfilWidget> {
  late String getResult;
  bool az = false;

  @override
  void initState() {
    super.initState();
    etudiants = fetchEtudiant(widget.qrCodeResult);
    exams = EtudbyExam(widget.examId);
    loadData();
  }

  late Future<List<Etudiant>> exams;
  Future<List<Etudiant>> EtudbyExam(int id) async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:8030/examen/etud/$id'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Etudiant.fromJson(data)).toList();
    } else {
      throw Exception('Fail');
    }
  }

  void validate(String exam, String etud) async {
    var response = await http.put(
        Uri.parse('http://192.168.137.1:8030/pv/update/exa/$exam/etu/$etud'));
    if (response.statusCode == 200) {
      print('we won');
    } else {
      print('not working');
    }
  }

  late Future<Etudiant> etudiants;
  Future<Etudiant> fetchEtudiant(String id) async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:8030/etudiant/$id'));
    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);
      if (jsonResponse != null) {
        return Etudiant.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to parse JSON response.');
      }
    } else {
      throw Exception(
          'Failed to fetch etudiant data. Status code: ${response.statusCode}');
    }
  }

  List<Etudiant> etudList = [];
  void loadData() async {
    etudList = await exams;
  }

  bool testDispo(int id) {
    for (var element in etudList) {
      if (element.id == id) return true;
    }
    return false;
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 10, 54, 105),
      appBar: AppBar(
        title: const Text("STUDENT INFO"),
        backgroundColor: const Color.fromARGB(255, 10, 54, 105),
        actions: [
          InkWell(
            onTap: () => {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.home,
              ),
            ),
          ),
        ],
      ),
      body: Container(
        margin: const EdgeInsets.all(10),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: height * 0.43,
              child: LayoutBuilder(
                builder: (context, constraints) {
                  double innerHeight = constraints.maxHeight;
                  double innerWidth = constraints.maxWidth;
                  return FutureBuilder(
                    future: etudiants,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        Etudiant? etu = snapshot.data;
                        return Stack(
                          children: [
                            Positioned(
                              bottom: 0,
                              left: 0,
                              right: 0,
                              child: Container(
                                height: innerHeight * 0.72,
                                width: innerWidth,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(30),
                                  color: Colors.white,
                                ),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: 21),
                                    Text(
                                      etu!.nom + ' ' + etu.prenom,
                                      style: TextStyle(
                                        color: Color.fromARGB(255, 10, 54, 105),
                                        fontWeight: FontWeight.bold,
                                        fontSize: 30,
                                      ),
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 20),
                                        Icon(Icons.perm_identity),
                                        SizedBox(width: 10),
                                        Text(
                                          etu.num_appo,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 20),
                                        Icon(Icons.phone_android),
                                        SizedBox(width: 10),
                                        Text(
                                          etu.telephone,
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        SizedBox(width: 20),
                                        Icon(Icons.mail),
                                        SizedBox(width: 10),
                                        Text(
                                          etu.email,
                                          style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              top: 0,
                              left: 0,
                              right: 0,
                              child: Center(
                                child: Image.asset(
                                  'images/profil.jpg',
                                  width: innerWidth * 0.4,
                                ),
                              ),
                            ),
                          ],
                        );
                      } else if (snapshot.hasError) {
                        return Container();
                      }

                      return Center(child: CircularProgressIndicator());
                    },
                  );
                },
              ),
            ),
            SizedBox(
              height: 30,
            ),
            FutureBuilder(
              future: etudiants,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  Etudiant etu = snapshot.data!;
                  return Container(
                    height: height * 0.3,
                    width: width,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                      color: Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 15),
                      child: Column(
                        children: [
                          SizedBox(
                            height: 20,
                          ),
                          Text(
                            'RESULTS',
                            style: TextStyle(
                              color: Color.fromARGB(255, 10, 54, 105),
                              fontWeight: FontWeight.bold,
                              fontSize: 27,
                            ),
                          ),
                          Divider(
                            thickness: 2.5,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Container(
                            height: height * 0.15,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 206, 206, 206),
                              borderRadius: BorderRadius.circular(30),
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                testDispo(etu.id)
                                    ? Text(
                                        'APPROUVED',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.green),
                                      )
                                    : Text(
                                        'DECLINED',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.red),
                                      ),
                                testDispo(etu.id)
                                    ? Row(
                                        children: [
                                          FloatingActionButton(
                                            heroTag: "btn2",
                                            onPressed: () {
                                              validate(widget.examId.toString(),
                                                  widget.qrCodeResult);
                                              Navigator.pop(
                                                context,
                                              );
                                            },
                                            backgroundColor: Color.fromARGB(
                                                255, 21, 105, 10),
                                            child: Icon(Icons.done_outline,
                                                size: 20),
                                          ),
                                          SizedBox(width: 5),
                                        ],
                                      )
                                    : Row(
                                        children: [
                                          FloatingActionButton(
                                            heroTag: "btn2",
                                            onPressed: () {
                                              Navigator.pop(
                                                context,
                                              );
                                            },
                                            backgroundColor: Color.fromARGB(
                                                255, 141, 15, 15),
                                            child: Icon(Icons.clear, size: 20),
                                          ),
                                        ],
                                      )
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                } else if (snapshot.hasError) {}

                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

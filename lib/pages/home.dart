// ignore_for_file: prefer_const_constructors, prefer_interpolation_to_compose_strings, use_build_context_synchronously, prefer_const_literals_to_create_immutables, non_constant_identifier_names, unnecessary_import

import 'dart:convert';

import 'package:exams_absentes/Entities/Examen.dart';
import 'package:exams_absentes/Entities/Surveillant.dart';
import 'package:exams_absentes/pages/login.dart';
import 'package:exams_absentes/pages/reports.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;

class HomeWidget extends StatefulWidget {
  final int id_surv;

  const HomeWidget({Key? key, required this.id_surv}) : super(key: key);

  @override
  State<HomeWidget> createState() => Home();
}

class Home extends State<HomeWidget> {
  late int surv_id = widget.id_surv;
  late String getResult;
  bool az = false;

  @override
  void initState() {
    super.initState();
    surv = fetchSurveillant(surv_id);
    exams = fetchExamen(surv_id);
  }

  late Future<List<Examen>>? exams;
  Future<List<Examen>> fetchExamen(int id) async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:8030/examen/surv/$id'));

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);

      return jsonResponse.map((data) => Examen.fromJson(data)).toList();
    } else {
      throw Exception('Fail');
    }
  }

  late Future<Surveillant> surv;
  Future<Surveillant> fetchSurveillant(int id) async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:8030/surveillant/$id'));
    if (response.statusCode == 200) {
      final dynamic jsonResponse = jsonDecode(response.body);

      if (jsonResponse != null) {
        return Surveillant.fromJson(jsonResponse);
      } else {
        throw Exception('Failed to parse JSON response.');
      }
    } else {
      throw Exception(
          'Failed to fetch etudiant data. Status code: ${response.statusCode}');
    }
  }

  @override
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: Text("Welcome"),
        backgroundColor: Color.fromARGB(255, 10, 54, 105),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () => {
              Navigator.push(
                  context, MaterialPageRoute(builder: (context) => Login()))
            },
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.logout,
                size: 35,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: double.infinity,
            margin: const EdgeInsets.all(15),
            child: Card(
              elevation: 5,
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: FutureBuilder(
                  future: surv,
                  builder: ((context, snapshot) {
                    if (snapshot.hasData) {
                      Surveillant? surveillant = snapshot.data;
                      return Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          CircleAvatar(
                            radius: 50,
                            backgroundImage:
                                NetworkImage(surveillant!.imageUrl),
                          ),
                          SizedBox(width: 15),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                surveillant.nom +
                                    ' ' +
                                    surveillant
                                        .prenom, // Display the name of the Surveillant
                                style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              SizedBox(height: 8),
                              // Display other information of the Surveillant using Text widgets
                              Row(
                                children: [
                                  Icon(Icons.perm_identity),
                                  SizedBox(width: 10),
                                  Text(
                                    'N° :  ${surveillant.id}',
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.phone_android),
                                  SizedBox(width: 10),
                                  Text(
                                    surveillant.telephone,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                              SizedBox(height: 8),
                              Row(
                                children: [
                                  Icon(Icons.mail),
                                  SizedBox(width: 10),
                                  Text(
                                    surveillant.email,
                                    style: TextStyle(fontSize: 16),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      );
                    } else if (snapshot.hasError) {
                      return Text("Failed to fetch Surveillant data");
                    }
                    return Center(
                      child: CircularProgressIndicator(),
                    );
                  }),
                ),
              ),
            ),
          ),
          /* Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 50),
              child: Image.asset("images/main.png")),*/
          Text(
            "YOUR EXAMS CALENDAR",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 10, 54, 105),
            ),
          ),
          Expanded(
            child: FutureBuilder(
              future: exams,
              builder: (context, snapshot) {
                List<Examen>? exas;
                if (snapshot.hasData) {
                  exas = snapshot.data;

                  return GridView.count(
                    crossAxisCount: 2,
                    childAspectRatio: 1,
                    children: exas!.map((ex) {
                      return RedCard(
                        i: ex.id,
                        n: ex.salle,
                        d: ex.dateExamen,
                        h: ex.heureD,
                        m: ex.matiere,
                      );
                    }).toList(),
                  );
                } else if (snapshot.hasError) {
                  return Text('${snapshot.error}');
                }
                return Center(
                  child: CircularProgressIndicator(),
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class RedCard extends StatefulWidget {
  final int i;
  final String n;
  final String h;
  final String m;
  final String d;

  RedCard({
    required this.i,
    required this.n,
    required this.h,
    required this.m,
    required this.d,
  });

  @override
  _RedCardState createState() => _RedCardState();
}

class _RedCardState extends State<RedCard> {
  late int id;
  late String nom;
  late String heure;
  late String module;
  late String date;
  @override
  void initState() {
    id = widget.i;
    nom = widget.n;
    heure = widget.h;
    module = widget.m;
    date = widget.d;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        setState(() {
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => Reports(id_ex: id)));
        });
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.room),
                SizedBox(width: 10),
                Text(
                  nom,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.access_time_filled),
                SizedBox(width: 10),
                Text(
                  heure,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.note_alt),
                SizedBox(width: 10),
                Text(
                  module,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.calendar_month),
                SizedBox(width: 10),
                Text(
                  date,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

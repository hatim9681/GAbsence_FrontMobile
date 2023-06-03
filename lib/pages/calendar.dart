// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, must_be_immutable, prefer_const_constructors_in_immutables, library_private_types_in_public_api, camel_case_types, use_key_in_widget_constructors, no_logic_in_create_state, non_constant_identifier_names

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:exams_absentes/Entities/Examen.dart';
import 'package:http/http.dart' as http;

class Calendar extends StatefulWidget {
  final int id_surv;
  const Calendar({Key? key, required this.id_surv}) : super(key: key);
  @override
  _calendarState createState() => _calendarState();
}

class _calendarState extends State<Calendar> {
  @override
  void initState() {
    super.initState();
    print(widget.id_surv);
    exams = fetchExamen(widget.id_surv);
  }

  late Future<List<Examen>> exams;
  Future<List<Examen>> fetchExamen(int id) async {
    final response =
        await http.get(Uri.parse('http://192.168.56.1:8030/examen/surv/$id'));
    print(widget.id_surv);

    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Examen.fromJson(data)).toList();
    } else {
      throw Exception('Fail');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("CALENDAR"),
        backgroundColor: Color.fromARGB(255, 10, 54, 105),
        automaticallyImplyLeading: false,
        actions: [
          InkWell(
            onTap: () => {},
            child: Container(
              margin: EdgeInsets.symmetric(horizontal: 20),
              child: Icon(
                Icons.home,
                size: 40,
              ),
            ),
          ),
        ],
      ),
      body: Column(
        children: [
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
                        a: false,
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
  final bool a;
  final String n;
  final String h;
  final String m;
  final String d;

  RedCard({
    required this.a,
    required this.n,
    required this.h,
    required this.m,
    required this.d,
  });

  @override
  _RedCardState createState() => _RedCardState();
}

class _RedCardState extends State<RedCard> {
  bool _isTapped = false;
  late String nom;
  late String heure;
  late String module;
  late String date;
  @override
  void initState() {
    _isTapped = widget.a;
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
          _isTapped = true;
        });
      },
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        color: _isTapped ? Colors.red : null,
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

// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables, library_private_types_in_public_api

import 'dart:convert';

import 'package:exams_absentes/Entities/Etudiant.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class Search extends StatefulWidget {
  final String? qrCodeResult;

  const Search({Key? key, this.qrCodeResult}) : super(key: key);

  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  TextEditingController numappo = TextEditingController();
  late List<Etudiant>? etud;
  Future<List<Etudiant>>? etuds;

  void loadData() async {
    etud = await etuds;
  }

  Future<List<Etudiant>> fetchEtudiant() async {
    final response =
        await http.get(Uri.parse('http://192.168.176.62:8030/etudiant/all'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Etudiant.fromJson(data)).toList();
    } else {
      throw Exception('Fail');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    etuds = fetchEtudiant();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("SEARCH"),
        backgroundColor: const Color.fromARGB(255, 10, 54, 105),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(
            "SEARCH A STUDENT",
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.bold,
              color: Color.fromARGB(255, 10, 54, 105),
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
                decoration: InputDecoration(labelText: "Enter N°Apoge or CIN"),
                controller: numappo,
                onChanged: (newValue) {
                  setState(() {
                    // etud = FetchEtudiant(newValue) as Etudiant;
                  });
                }),
          ),
          Divider(
            color: Color.fromARGB(255, 10, 54, 105),
            thickness: 4,
            indent: 30,
            endIndent: 30,
          ),
          InkWell(
            onTap: () => {
              /* etud = testDispo(username.text, password1.text),
              if (surv != null)
                {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) =>
                              HomeWidget(id_surv: surv!.id))).then((value) {
                    Navigator.pop(
                        context); // Close the current page after navigating back
                  }),
                }
              else
                {
                  Text("There is no user with these infos",
                      style: TextStyle(
                        color: Colors.red,
                      ))
                }*/
            },
            child: Container(
              height: 70,
              margin: const EdgeInsets.all(10),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 10, 54, 105),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.search, color: Colors.white, size: 50),
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
    );
  }
}

// ignore_for_file: prefer_const_constructors, sort_child_properties_last, prefer_const_literals_to_create_immutables, unnecessary_new

import 'dart:convert';

import 'package:exams_absentes/Entities/Surveillant.dart';
import 'package:exams_absentes/pages/home.dart';
import 'package:flutter/material.dart';
import 'package:exams_absentes/pages/background.dart';
import 'package:http/http.dart' as http;

class Login extends StatefulWidget {
  const Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController username = TextEditingController();
  TextEditingController password1 = TextEditingController();
  List<Surveillant> survList = [];

  void loadData() async {
    survList = await exams;
  }

  @override
  void initState() {
    super.initState();
    exams = fetchSurveillant();
    loadData();
  }

  Surveillant? testDispo(String nom, String password) {
    for (Surveillant element in survList) {
      print(element.email);
      if (element.email == nom && element.password == password) {
        return element;
      }
    }
    return null;
  }

  late Future<List<Surveillant>> exams;
  Future<List<Surveillant>> fetchSurveillant() async {
    final response =
        await http.get(Uri.parse('http://192.168.137.1:8030/surveillant/all'));
    if (response.statusCode == 200) {
      final List<dynamic> jsonResponse = jsonDecode(response.body);
      return jsonResponse.map((data) => Surveillant.fromJson(data)).toList();
    } else {
      throw Exception('Fail');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    Surveillant? surv;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Background(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 80),
                child: Image.asset("images/main.png")),
            Container(
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: 40),
              child: Text(
                "LOGIN",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 10, 54, 105),
                    fontSize: 36),
                textAlign: TextAlign.left,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(labelText: "Username"),
                controller: username,
              ),
            ),
            SizedBox(height: size.height * 0.03),
            Container(
              alignment: Alignment.center,
              margin: EdgeInsets.symmetric(horizontal: 40),
              child: TextField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                controller: password1,
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "Forgot your password?",
                style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: Color.fromARGB(255, 29, 29, 29)),
              ),
            ),
            InkWell(
              onTap: () => {
                surv = testDispo(username.text, password1.text),
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
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text("No Supervisor Found"),
                          content: Text(
                            "Email or Password Incorrect ",
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
                    ),
                  }
              },
              child: Container(
                width: 300,
                height: 50,
                margin: const EdgeInsets.all(10),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                        color: Colors.black.withOpacity(0.2),
                        spreadRadius: 2,
                        blurRadius: 2,
                        offset: const Offset(2, -2)),
                  ],
                  color: const Color.fromARGB(255, 10, 54, 105),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  "LOGIN",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 25,
                    fontWeight: FontWeight.bold,
                    fontFamily: 'PT_Serif',
                    shadows: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.2),
                          spreadRadius: 2,
                          blurRadius: 2,
                          offset: const Offset(2, -2)),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              alignment: Alignment.centerRight,
              margin: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
              child: Text(
                "Don't Have an Account? Sign up",
                style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 15, 15, 15)),
              ),
            )
          ],
        ),
      ),
    );
  }
}

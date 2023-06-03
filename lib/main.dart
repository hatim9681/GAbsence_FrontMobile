// ignore_for_file: prefer_const_constructors, missing_required_param

import 'package:exams_absentes/pages/calendar.dart';
import 'package:exams_absentes/pages/home.dart';
import 'package:exams_absentes/pages/login.dart';
import 'package:exams_absentes/pages/profil.dart';
import 'package:exams_absentes/pages/search.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: "/",
      routes: {
        '/': (context) => const Login(),
        "/calendar": (context) => Calendar(
              id_surv: 0,
            ),
        "/profil": (context) => ProfilWidget(
              qrCodeResult: '',
              examId: 0,
            ),
        "/search": (context) => const Search(),
        "/home": (context) => HomeWidget(
              id_surv: 1,
            ),
      },
    );
  }
}

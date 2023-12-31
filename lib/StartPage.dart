// ignore_for_file: prefer_const_constructors, file_names

import 'dart:async';

import 'package:arabicspeaker/controller/var.dart';
import 'package:arabicspeaker/view/Auth/login.dart';
import 'package:flutter/material.dart';

class Start extends StatefulWidget {
  const Start({Key? key}) : super(key: key);

  @override
  State<Start> createState() => _StartState();
}

class _StartState extends State<Start> {
  @override
  void initState() {
    super.initState();
    Timer(
        Duration(seconds: 4),
        () => Navigator.pushReplacement(
            context, MaterialPageRoute(builder: (context) => Login())));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: maincolor,
      body: Container(
        decoration: BoxDecoration(
            color: const Color(0xff339870),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: const [
                  Color.fromARGB(255, 24, 117, 80),
                  Color.fromARGB(255, 3, 107, 138),
                ])),
        alignment: Alignment.center,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              "assets/logo.png",
              height: 200,
              width: 200,
            ),
            Text(
              "المتحدث العربي",
              style: TextStyle(
                  fontSize: 25, color: Color.fromARGB(255, 255, 255, 255)),
            )
          ],
        ),
      ),
    );
  }
}

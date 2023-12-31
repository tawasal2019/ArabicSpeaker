import '/controller/var.dart';
import 'package:flutter/material.dart';

Widget contentText(String text) {
  String ftext = text.length <= 40 ? text : "${text.substring(0, 41)}...";
  return SizedBox(
    height: 70,
    child: Align(
      alignment: Alignment.center,
      child: Text(
        ftext,
        textAlign: TextAlign.center,
        style: TextStyle(
            fontSize: size == 0 ? 26 : 21, fontWeight: FontWeight.bold),
      ),
    ),
  );
}

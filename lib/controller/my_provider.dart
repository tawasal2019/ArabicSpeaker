import 'package:flutter/material.dart';

class MyProvider with ChangeNotifier {
  String lastimagepath = "";
  void setPath(String path) {
    lastimagepath = path;
    notifyListeners();
  }
}

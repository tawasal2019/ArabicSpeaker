import 'dart:convert';

import 'package:arabicspeaker/controller/libtostring.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/content.dart';
import '../model/library.dart';

Future setDataOnLogin(data) async {
  SharedPreferences pref = await SharedPreferences.getInstance();
  pref.setBool("firsttime", false);
  List tem = data?["library list"] ?? [];
  List tem2 = data?["favlist"] ?? [];

  List<String> librarylist = [];
  List<String> favoritelist = [];
  for (var element in tem) {
    librarylist.add(element.toString());
  }
  for (var element in tem2) {
    favoritelist.add(element.toString());
  }
  ////////////////////////
  List<String> lastLibrarylist = [];
  List<String> lastFavoritelist = [];
  for (String element in librarylist) {
    lib onelib;
    List e = json.decode(element);
    List<Content> contentlist = [];
    for (List l in e[3] as List) {
      contentlist.add(Content(l[0], l[1], l[2], l[3], "", l[5]));
    }
    onelib = lib(e[0], e[1], e[2], contentlist);
    String newLib = convertLibString(onelib);
    lastLibrarylist.add(newLib);
  }
  for (String element in favoritelist) {
    List e = json.decode(element);
    lastFavoritelist.add("""
["${e[0]}",
"${e[1]}",
"${e[2]}",
"${e[3]}",
"",
"${e[5]}"]
""");
  }

  pref.setStringList("liblist", lastLibrarylist);
  pref.setStringList("favlist", lastFavoritelist);
}

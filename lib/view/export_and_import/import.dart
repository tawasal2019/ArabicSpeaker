// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import 'package:animated_search_bar/animated_search_bar.dart';

import '/controller/erroralert.dart';
import '/controller/var.dart';
import '/model/library.dart';
import '/view/export_and_import/exportlibrary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/content.dart';

class Import extends StatefulWidget {
  const Import({Key? key}) : super(key: key);

  @override
  State<Import> createState() => _ImportState();
}

class _ImportState extends State<Import> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> data = [];
  List<QueryDocumentSnapshot<Map<String, dynamic>>> allData = [];
  bool loading = true;
  String searchText = "";
  final TextEditingController _controller = TextEditingController(text: "");

  @override
  void initState() {
    getdata().then((value) {
      setState(() {
        loading = false;
      });
    });

    super.initState();
  }

  Future getdata() async {
    await FirebaseFirestore.instance.collection("Shared").get().then((value) {
      for (var element in value.docs) {
        if (element.data()["approval"].toString() == "true") {
          data.add(element);
        }
      }
      allData = data;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: AnimatedSearchBar(
            label: "ابحث",
            labelStyle: const TextStyle(),
            controller: _controller,
            searchStyle: const TextStyle(color: Colors.white),
            cursorColor: Colors.white,
            searchDecoration: const InputDecoration(
              hintText: "ابحث هنا",
              alignLabelWithHint: true,
              focusColor: Colors.white,
              hintStyle:
                  TextStyle(color: Colors.white70, fontWeight: FontWeight.bold),
              border: InputBorder.none,
            ),
            onChanged: (value) {
              setState(() {
                searchText = value.trim();

                data = dataAfterSearch(value);
              });
            },
          ),
          backgroundColor: maincolor,
        ),
        body: loading
            ? Center(
                child: CircularProgressIndicator(
                  color: maincolor,
                ),
              )
            : Padding(
                padding: const EdgeInsets.only(top: 25, bottom: 25),
                child: GridView.builder(
                    itemCount: data.length,
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 1
                            : 2,
                        childAspectRatio: 2 / .85),
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: FittedBox(
                          child: Container(
                            width: 330,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(20),
                                border: Border.all(color: maincolor, width: 2)),
                            child: Directionality(
                              textDirection: TextDirection.rtl,
                              child: Column(
                                children: [
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                        "اسم التصدير : ${data[index]["name"]}",
                                        style: const TextStyle(
                                            fontSize: 15,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(right: 8),
                                      child: Text(
                                          "اسم الناشر : ${data[index]["publisherName"]}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Padding(
                                      padding: const EdgeInsets.only(
                                          right: 8, bottom: 7),
                                      child: Text(
                                          "شرح عن التصدير : ${data[index]["explaination"]}",
                                          style: const TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.bold)),
                                    ),
                                  ),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      InkWell(
                                        onTap: () async {
                                          SharedPreferences liblist =
                                              await SharedPreferences
                                                  .getInstance();
                                          List<String> past = liblist
                                                  .getStringList("liblist") ??
                                              [];
                                          for (var element in data[index]
                                              ["data"]) {
                                            past.add(element.toString());
                                          }
                                          liblist.setStringList(
                                              "liblist", past);
                                          acceptalert(
                                              context, "تم التنزيل بنجاح");
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.cloud_download,
                                                color: maincolor,
                                                size: 25,
                                              ),
                                              Text(
                                                "  تنزيل ",
                                                style: TextStyle(
                                                    color: maincolor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              )
                                            ],
                                          ),
                                        ),
                                      ),
                                      TextButton(
                                          onPressed: () {
                                            List<lib> library = [];
                                            for (var element in data[index]
                                                ["data"]) {
                                              List e = json.decode(element);
                                              List<Content> contentlist = [];
                                              for (List l in e[3]) {
                                                contentlist.add(Content(
                                                    l[0],
                                                    l[1],
                                                    l[2],
                                                    l[3],
                                                    l[4],
                                                    l[5]));
                                              }
                                              library.add(lib(e[0], e[1], e[2],
                                                  contentlist));
                                            }
                                            Navigator.push(
                                                context,
                                                MaterialPageRoute(
                                                    builder: (context) =>
                                                        ExportLibrary(
                                                            data: library)));
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.folder,
                                                color: maincolor,
                                              ),
                                              Text(
                                                "محتوى المكتبة",
                                                style: TextStyle(
                                                    color: maincolor,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 15),
                                              ),
                                            ],
                                          )),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    }),
              ),
      ),
    );
  }

  List<QueryDocumentSnapshot<Map<String, dynamic>>> dataAfterSearch(value) {
    List<QueryDocumentSnapshot<Map<String, dynamic>>> returnList = [];

    for (var element in allData) {
      if (element["name"].contains(value) ||
          element["publisherName"].contains(value) ||
          element["explaination"].contains(value)) {
        returnList.add(element);
      }
    }
    return returnList;
  }
}

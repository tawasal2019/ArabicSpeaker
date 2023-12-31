// ignore_for_file: use_build_context_synchronously

import '/controller/images.dart';
import '/model/content.dart';
import '/view/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/libtostring.dart';
import '../../controller/var.dart';
import '../../model/library.dart';

class MoveLibrary extends StatelessWidget {
  final int pastLibIndex;
  final List<int> selectedindexcontent;
  const MoveLibrary(
      {Key? key,
      required this.pastLibIndex,
      required this.selectedindexcontent})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: maincolor,
        ),
        body: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: SizedBox(
                width: double.infinity,
                height: MediaQuery.of(context).size.height -
                    AppBar().preferredSize.height -
                    130,
                child: GridView.builder(
                    itemCount: libraryList.length,
                    gridDelegate:
                        const SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      childAspectRatio: 1,
                      mainAxisSpacing: 20,
                      crossAxisSpacing: 20,
                    ),
                    itemBuilder: ((context, index) {
                      return InkWell(
                          onTap: () async {
                            for (int element in selectedindexcontent) {
                              Content temporary =
                                  libraryList[pastLibIndex].contenlist[element];
                              libraryList[pastLibIndex]
                                  .contenlist
                                  .removeAt(element);
                              libraryList[index].contenlist.add(temporary);
                            }
                            SharedPreferences liblist =
                                await SharedPreferences.getInstance();
                            List<String> v = [];
                            for (lib l in libraryList) {
                              String s = convertLibString(l);
                              v.add(s);
                            }
                            liblist.setStringList("liblist", v);
                            Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const MainScreen(navindex: 1)),
                                (route) => false);
                          },
                          child: Stack(
                            children: [
                              Container(
                                  width: double.infinity,
                                  decoration: BoxDecoration(
                                      border: Border.all(
                                          color: maincolor, width: 1.5),
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20)),
                                  child: Column(children: [
                                    const SizedBox(
                                      height: 7,
                                    ),
                                    Expanded(
                                        child: getImage(
                                            libraryList[index].imgurl)),
                                    Text(
                                      libraryList[index].name,
                                      style: const TextStyle(
                                          fontSize: 21,
                                          fontWeight: FontWeight.bold),
                                    )
                                  ])),
                            ],
                          ));
                    })),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

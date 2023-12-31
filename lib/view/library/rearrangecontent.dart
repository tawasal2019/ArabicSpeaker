import 'dart:convert';
import 'package:arabicspeaker/view/library/contentlibrary.dart';

import '/controller/erroralert.dart';
import '/controller/images.dart';
import '/view/drawer/drawer.dart';
import 'package:flutter/material.dart';
import 'package:flutter_draggable_gridview/flutter_draggable_gridview.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/libtostring.dart';
import '../../controller/var.dart';
import '../../model/content.dart';
import '../../model/library.dart';

class ReArrangeContent extends StatefulWidget {
  final int contentIndex;
  const ReArrangeContent({Key? key, required this.contentIndex})
      : super(key: key);

  @override
  State<ReArrangeContent> createState() => _ReArrangeContentState();
}

class _ReArrangeContentState extends State<ReArrangeContent> {
  String appTitle = "";
  final List<DraggableGridItem> _draggList = [];
  getDraggbleItems() {
    for (int i = 0;
        i < libraryList[widget.contentIndex].contenlist.length;
        i++) {
      _draggList.add(DraggableGridItem(
        isDraggable: true,
        child: Container(
            width: double.infinity,
            decoration: BoxDecoration(
                border: Border.all(color: maincolor, width: 1.5),
                color: Colors.white,
                borderRadius: BorderRadius.circular(20)),
            child: Column(children: [
              const SizedBox(
                height: 7,
              ),
              Expanded(
                  child: getImage(
                      libraryList[widget.contentIndex].contenlist[i].imgurl)),
              Align(
                alignment: Alignment.center,
                child: Text(
                  libraryList[widget.contentIndex].contenlist[i].name,
                  overflow: TextOverflow.clip,
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  style: const TextStyle(
                      fontSize: 21,
                      fontWeight: FontWeight.bold,
                      decoration: TextDecoration.none),
                ),
              )
            ])),
      ));
    }
  }

  bool isloading = true;
  @override
  void initState() {
    getdata().then((v) {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  getdata() async {
    libraryList = [];
    SharedPreferences liblist = await SharedPreferences.getInstance();
    List<String>? library = liblist.getStringList("liblist");
    if (library != null) {
      for (String element in library) {
        List e = json.decode(element);
        List<Content> contentlist = [];
        for (List l in e[3]) {
          contentlist.add(Content(l[0], l[1], l[2], l[3], l[4], l[5]));
        }
        libraryList.add(lib(e[0], e[1], e[2], contentlist));
      }
    }
    await getDraggbleItems();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: const Drawerc(),
        appBar: AppBar(
          title: Center(child: Text(appTitle)),
          actions: [
            Padding(
              padding: const EdgeInsets.all(10),
              child: Center(
                  child: InkWell(
                      onTap: () {
                        updateSharedPreferences().then((v) {
                          getdata();
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContentLibrary(
                                        contentIndex: widget.contentIndex,
                                      )),
                              (route) => false);
                          acceptalert(context, "تم الحفظ بنجاح");
                        });
                      },
                      child: const Text(
                        "حفظ",
                        style: TextStyle(
                            fontSize: 25, fontWeight: FontWeight.bold),
                      ))),
            )
          ],
          backgroundColor: maincolor,
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.only(right: 20, top: 20),
                  ),
                  const SizedBox(
                    height: 27,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SafeArea(
                      child: SizedBox(
                          width: double.infinity,
                          height: MediaQuery.of(context).size.height -
                              AppBar().preferredSize.height -
                              200,
                          child: DraggableGridViewBuilder(
                            dragFeedback:
                                (List<DraggableGridItem> list, int index) {
                              return SizedBox(
                                width: 120,
                                height: 130,
                                child: list[index].child,
                              );
                            },
                            isOnlyLongPress: false,
                            dragPlaceHolder:
                                (List<DraggableGridItem> list, index) {
                              return PlaceHolderWidget(
                                child: Container(
                                  color: Colors.white,
                                ),
                              );
                            },
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? 3
                                      : 4,
                              childAspectRatio: 1,
                              mainAxisSpacing: 20,
                              crossAxisSpacing: 20,
                            ),
                            dragCompletion: (List<DraggableGridItem> list,
                                int beforeIndex, int afterIndex) {
                              setState(() {
                                final elementLibrary =
                                    libraryList[widget.contentIndex]
                                        .contenlist
                                        .elementAt(beforeIndex);
                                libraryList[widget.contentIndex]
                                    .contenlist
                                    .removeAt(beforeIndex);
                                libraryList[widget.contentIndex]
                                    .contenlist
                                    .insert(afterIndex, elementLibrary);
                                final elementDraggable =
                                    _draggList.elementAt(beforeIndex);
                                _draggList.removeAt(beforeIndex);
                                _draggList.insert(afterIndex, elementDraggable);
                              });
                            },
                            children: _draggList,
                          )),
                    ),
                  )
                ],
              ),
      ),
    );
  }

  Future updateSharedPreferences() async {
    SharedPreferences liblist = await SharedPreferences.getInstance();
    List<String> v = [];
    for (lib l in libraryList) {
      String s = convertLibString(l);
      v.add(s);
    }
    liblist.setStringList("liblist", v);
  }
}

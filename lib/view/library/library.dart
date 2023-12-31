// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'package:arabicspeaker/controller/librarybutton.dart';

import '/controller/checkinternet.dart';
import '/controller/erroralert.dart';
import '/controller/exportnote.dart';
import '/controller/images.dart';
import '/controller/uploaddata.dart';
import '/view/drawer/drawer.dart';
import '/view/library/addlibrary.dart';
import '/view/library/editlibrary.dart';
import '/view/library/rearrangelibrary.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/allUploadedDone.dart';
import '../../controller/libtostring.dart';
import '../../controller/var.dart';
import '../../model/content.dart';
import '../../model/library.dart';
import '../mainscreen.dart';
import 'contentlibrary.dart';

class Library extends StatefulWidget {
  const Library({Key? key}) : super(key: key);

  @override
  State<Library> createState() => _LibraryState();
}

class _LibraryState extends State<Library> {
  bool isloading = true;
  final controller = DragSelectGridViewController();
  @override
  void initState() {
    controller.addListener(() {
      setState(() {});
    });
    getdata().then((v) {
      setState(() {
        isloading = false;
      });
      internetConnection().then((value) async {
        SharedPreferences notOpenInternetFiveTime =
            await SharedPreferences.getInstance();
        if (value == true) {
          notOpenInternetFiveTime.setInt("notOpenInternetFiveTime", 0);
          tryUploadData();
        } else {
          int numb =
              notOpenInternetFiveTime.getInt("notOpenInternetFiveTime") ?? 0;
          if (numb >= 5) {
            notOpenInternetFiveTime.setInt("notOpenInternetFiveTime", 0);
            noteAlert(context,
                "لقد لاحظنا استخدامك للتطبيق لفترة دون الاتصال بالانترنت \nنود تنبيهك لضرورة الاتصال بالانترنت ليتم حفظ بياناتك في حال حذف التطبيق");
          } else {
            notOpenInternetFiveTime.setInt("notOpenInternetFiveTime", numb + 1);
          }
        }
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
  }

  @override
  void dispose() {
    controller.addListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isSelectedAnyItem = controller.value.isSelecting;
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        drawer: const Drawerc(),
        appBar: AppBar(
          title: isSelectedAnyItem
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text("${controller.value.amount} ",
                            style: const TextStyle(
                                color: Colors.white, fontSize: 20)),
                        const Text(" من المكتبات",
                            style:
                                TextStyle(color: Colors.white, fontSize: 18)),
                      ],
                    ),
                    InkWell(
                      onTap: () {
                        Set<int> indexes = {};
                        for (int i = 0; i < libraryList.length; i++) {
                          indexes.add(i);
                        }
                        controller.value = Selection(indexes);
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.checklist,
                            color: Colors.white,
                          ),
                          Text("تحديد الكل",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 16))
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Column(
                        children: [
                          Icon(
                            Icons.close,
                            color: Colors.white,
                          ),
                          Text("إلغاء",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18))
                        ],
                      ),
                    ),
                  ],
                )
              : Container(),
          backgroundColor: maincolor,
        ),
        body: isloading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ListView(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: FittedBox(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            "                               ",
                            style: TextStyle(
                                fontSize: 21, fontWeight: FontWeight.bold),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 55
                                : 35,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: isSelectedAnyItem
                                    ? buttonlib(
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.delete,
                                              color: Colors.white,
                                              size: 25,
                                            ),
                                            Text(
                                              " حذف",
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                  fontSize: 20),
                                            )
                                          ],
                                        ), () async {
                                        showAlertDialog(context);
                                      })
                                    : buttonlib(
                                        const Text(
                                          ' انشاء مكتبة ',
                                          style: TextStyle(
                                              fontSize: 22,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const AddLibrary()));
                                      })),
                          ),
                          SizedBox(
                            height: MediaQuery.of(context).orientation ==
                                    Orientation.portrait
                                ? 55
                                : 35,
                            child: Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: isSelectedAnyItem
                                    ? buttonlib(
                                        const Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Icon(
                                              Icons.cloud_upload,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: EdgeInsets.all(3.0),
                                              child: Text(
                                                "رفع",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20),
                                              ),
                                            )
                                          ],
                                        ), () {
                                        List<int> theSelectedItem = controller
                                            .value.selectedIndexes
                                            .toList();
                                        List<String> dataToExport = [];
                                        for (int i in theSelectedItem) {
                                          String s =
                                              convertLibString(libraryList[i]);
                                          dataToExport.add(s);
                                        }
                                        showDialog(
                                            context: context,
                                            builder: (context) {
                                              bool isloading = false;
                                              TextEditingController name =
                                                  TextEditingController();

                                              TextEditingController
                                                  publisherName =
                                                  TextEditingController();

                                              TextEditingController
                                                  explaination =
                                                  TextEditingController();
                                              return Container(
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            30)),
                                                child: Center(
                                                  child: SingleChildScrollView(
                                                    child: AlertDialog(
                                                      title: Directionality(
                                                        textDirection:
                                                            TextDirection.rtl,
                                                        child: Column(
                                                          children: [
                                                            const Padding(
                                                              padding:
                                                                  EdgeInsets
                                                                      .all(8.0),
                                                              child: FittedBox(
                                                                child: Text(
                                                                  "معلومات المكتبات المرغوب مشاركتها",
                                                                  style: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          25),
                                                                ),
                                                              ),
                                                            ),
                                                            const SizedBox(
                                                              height: 35,
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                      .only(
                                                                left: 20,
                                                                right: 20,
                                                                //bottom: 11,
                                                              ),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    name,
                                                                maxLength: 25,
                                                                maxLines: 1,
                                                                decoration:
                                                                    InputDecoration(
                                                                  // hintText: "اسم التصدير",
                                                                  labelText:
                                                                      "اسم النسخة",
                                                                  hintStyle: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  labelStyle: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          22,
                                                                      color:
                                                                          maincolor),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                maincolor),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          13.0),
                                                                    ),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                maincolor),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          13.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            const Text(
                                                              "* هذا الاسم سيظهر للمستخدمين عند تنزيل المكتبة",
                                                              // textAlign: TextAlign.right,
                                                              // ignore: prefer_const_constructors
                                                              style: TextStyle(
                                                                  fontSize: 14,
                                                                  color: Colors
                                                                      .red,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .bold),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      top: 40,
                                                                      bottom:
                                                                          20,
                                                                      right: 20,
                                                                      left: 20),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    publisherName,
                                                                maxLength: 25,
                                                                maxLines: 1,
                                                                decoration:
                                                                    InputDecoration(
                                                                  //   hintText: "اسم الناشر",
                                                                  labelText:
                                                                      "اسم الناشر",
                                                                  hintStyle: const TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  labelStyle: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          22,
                                                                      color:
                                                                          maincolor),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                maincolor),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          13.0),
                                                                    ),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                maincolor),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          13.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Padding(
                                                              padding:
                                                                  const EdgeInsets
                                                                          .only(
                                                                      left: 20,
                                                                      right:
                                                                          20),
                                                              child:
                                                                  TextFormField(
                                                                controller:
                                                                    explaination,
                                                                maxLength: 120,
                                                                minLines: 4,
                                                                maxLines: 4,
                                                                decoration:
                                                                    InputDecoration(
                                                                  labelText:
                                                                      "شرح توضيحي عن المكتبات ",
                                                                  hintStyle: const TextStyle(
                                                                      fontSize:
                                                                          15,
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold),
                                                                  labelStyle: TextStyle(
                                                                      fontWeight:
                                                                          FontWeight
                                                                              .bold,
                                                                      fontSize:
                                                                          22,
                                                                      color:
                                                                          maincolor),
                                                                  focusedBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                maincolor),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          13.0),
                                                                    ),
                                                                  ),
                                                                  enabledBorder:
                                                                      OutlineInputBorder(
                                                                    borderSide:
                                                                        BorderSide(
                                                                            color:
                                                                                maincolor),
                                                                    borderRadius:
                                                                        const BorderRadius
                                                                            .all(
                                                                      Radius.circular(
                                                                          13.0),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ),
                                                            ),
                                                            Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .spaceBetween,
                                                              children: [
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      top: 20),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: () {
                                                                      if (name.text.isEmpty ||
                                                                          publisherName
                                                                              .text
                                                                              .isEmpty ||
                                                                          explaination
                                                                              .text
                                                                              .isEmpty) {
                                                                        erroralert(
                                                                            context,
                                                                            "يجب ملىء جميع الحقول");
                                                                      } else {
                                                                        internetConnection()
                                                                            .then((value) {
                                                                          if (value ==
                                                                              true) {
                                                                            setState(() {
                                                                              isloading = true;
                                                                            });
                                                                            tryUploadData().then((v) {
                                                                              allUploadedDone().then((value2) {
                                                                                if (value2 == true) {
                                                                                  FirebaseFirestore.instance.collection("Shared").doc().set({
                                                                                    "data": dataToExport,
                                                                                    "name": name.text,
                                                                                    "publisherName": publisherName.text,
                                                                                    "explaination": explaination.text,
                                                                                    "approval": "no"
                                                                                  }).then((value) {
                                                                                    Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(navindex: 1)), (route) => false);
                                                                                    acceptalert(
                                                                                      context,
                                                                                      "سيتم نشر مكتبتك بعد مراجعتها يمكنك الوصول للمكتبات من خلال اعدادات -> تنزيل المكتبات",
                                                                                    );
                                                                                  });
                                                                                } else {
                                                                                  Navigator.pushAndRemoveUntil(context, MaterialPageRoute(builder: (context) => const MainScreen(navindex: 1)), (route) => false);
                                                                                  erroralert(context, "حاول مرة اخرى");
                                                                                }
                                                                              });
                                                                            });
                                                                          } else {
                                                                            erroralert(context,
                                                                                "يرجى الاتصال بالانترنت");
                                                                          }
                                                                        });
                                                                      }
                                                                    },
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width:
                                                                          100,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          color:
                                                                              maincolor),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            FittedBox(
                                                                          child: isloading
                                                                              ? const Center(
                                                                                  child: CircularProgressIndicator(),
                                                                                )
                                                                              : const Text(
                                                                                  "رفع",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),

                                                                ////////////////////////////////// الغاء
                                                                Padding(
                                                                  padding: const EdgeInsets
                                                                          .only(
                                                                      // left: 65,
                                                                      // right: 65,
                                                                      top: 20),
                                                                  child:
                                                                      InkWell(
                                                                    onTap: (() {
                                                                      Navigator.pop(
                                                                          context);
                                                                    }),
                                                                    child:
                                                                        Container(
                                                                      height:
                                                                          50,
                                                                      width:
                                                                          100,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              15),
                                                                          color:
                                                                              maincolor),
                                                                      child:
                                                                          Center(
                                                                        child:
                                                                            FittedBox(
                                                                          child: isloading
                                                                              ? const Center(
                                                                                  child: CircularProgressIndicator(),
                                                                                )
                                                                              : const Text(
                                                                                  "إلغاء",
                                                                                  style: TextStyle(color: Colors.white, fontSize: 25),
                                                                                ),
                                                                        ),
                                                                      ),
                                                                    ),
                                                                  ),
                                                                ),
                                                              ],
                                                            ),
                                                            const SizedBox(
                                                              height: 35,
                                                            ),
                                                          ],
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                              );
                                            });

                                        exportNote(context);
                                      })
                                    : buttonlib(
                                        const Text(
                                          ' إعادة الترتيب ',
                                          style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                              color: Colors.white),
                                        ), () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const ReArrangeLibrary()));
                                        //const ReArrangeLibrary()
                                      })),
                          ),
                        ],
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(10),
                    child: SafeArea(
                      child: SizedBox(
                        width: double.infinity,
                        height: MediaQuery.of(context).size.height -
                            AppBar().preferredSize.height -
                            230,
                        child: DragSelectGridView(
                            gridController: controller,
                            itemCount: libraryList.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount:
                                  MediaQuery.of(context).orientation ==
                                          Orientation.portrait
                                      ? size == 0
                                          ? 2
                                          : 3
                                      : 4,
                              childAspectRatio: 1,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                            ),
                            itemBuilder: ((context, index, isSelected) {
                              return InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            ContentLibrary(contentIndex: index),
                                      ),
                                    );
                                  },
                                  child: Stack(
                                    children: [
                                      Container(
                                          width: double.infinity,
                                          decoration: BoxDecoration(
                                              border: Border.all(
                                                  color: maincolor, width: 1.5),
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(20)),
                                          child: Column(children: [
                                            const SizedBox(
                                              height: 7,
                                            ),
                                            Expanded(
                                                child: getImage(
                                                    libraryList[index].imgurl)),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  bottom: 4),
                                              child: Text(
                                                libraryList[index].name,
                                                style: TextStyle(
                                                    fontSize:
                                                        size == 0 ? 30 : 24,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            )
                                          ])),
                                      isSelected
                                          ? Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Container(
                                                height: 23,
                                                width: 23,
                                                decoration: BoxDecoration(
                                                    color: const Color.fromARGB(
                                                        255, 224, 223, 223),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40),
                                                    border: Border.all(
                                                        color: Colors.red,
                                                        width: 3)),
                                                child: const Icon(
                                                  Icons.done,
                                                  color: Colors.red,
                                                  size: 17,
                                                ),
                                              ),
                                            )
                                          : isSelectedAnyItem
                                              ? Container()
                                              : InkWell(
                                                  onTap: () {
                                                    Navigator.push(
                                                        context,
                                                        MaterialPageRoute(
                                                            builder: (context) => EditLibrary(
                                                                librarayName:
                                                                    libraryList[
                                                                            index]
                                                                        .name,
                                                                imgpath:
                                                                    libraryList[
                                                                            index]
                                                                        .imgurl,
                                                                libIndex:
                                                                    index)));
                                                  },
                                                  child: Padding(
                                                    padding:
                                                        const EdgeInsets.all(7),
                                                    child: Icon(
                                                      Icons.edit,
                                                      color: maincolor,
                                                    ),
                                                  ),
                                                )
                                    ],
                                  ));
                            })),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  showAlertDialog(BuildContext context) {
    // set up the buttons

    const SizedBox(
      width: 50,
    );

    Widget cancelButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(maincolor),
      ),
      child: const Text(
        "إلغاء",
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () {
        Navigator.pop(context);
      },
    );
    Widget continueButton = ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all(maincolor),
      ),
      child: const Text(
        "نعم، متأكد",
        style: TextStyle(fontSize: 18),
      ),
      onPressed: () async {
        List theSelectedItem = controller.value.selectedIndexes.toList();
        theSelectedItem.sort();
        theSelectedItem = theSelectedItem.reversed.toList();

        for (var element in theSelectedItem) {
          libraryList.removeAt(element);
        }
        controller.clear();
        setState(() {});
        SharedPreferences liblist = await SharedPreferences.getInstance();
        List<String> v = [];
        for (lib l in libraryList) {
          String s = convertLibString(l);
          v.add(s);
        }
        liblist.setStringList("liblist", v);
        Navigator.pop(context);
      },
    );
    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      actionsAlignment: MainAxisAlignment.center,
      title: const Icon(
        Icons.warning,
        size: 60,
        color: Colors.red,
      ),
      content: const Text(
        "هل أنت متأكد أنك تريد حذف هذه المكتبات؟ ",
        textDirection: TextDirection.rtl,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
      ),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}

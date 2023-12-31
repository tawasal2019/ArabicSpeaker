// ignore_for_file: non_constant_identifier_names, empty_catches, use_build_context_synchronously

import 'dart:convert';

import 'package:arabicspeaker/controller/librarybutton.dart';

import '/controller/contenttext.dart';
import '/controller/images.dart';
import '/controller/speak.dart';
import '/controller/var.dart';
import '/view/drawer/drawer.dart';
import '/view/library/editcontent.dart';
import '/view/library/movelib.dart';
import '/view/library/rearrangecontent.dart';
import '/view/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/libtostring.dart';
import '../../model/library.dart';
import 'addcontent.dart';

class ContentLibrary extends StatefulWidget {
  final int contentIndex;
  const ContentLibrary({Key? key, required this.contentIndex})
      : super(key: key);

  @override
  State<ContentLibrary> createState() => _ContentLibraryState();
}

class _ContentLibraryState extends State<ContentLibrary> {
  int pageindex = 1;
  bool cantPressed = false;
  int cantpressIndex = 0;
  bool isLoading = true;
  List<String> fav = [];
  @override
  void initState() {
    contentlib_controller.addListener(() {
      setState(() {});
    });
    getFavData().then((v) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  getFavData() async {
    SharedPreferences favlist = await SharedPreferences.getInstance();
    var tem = favlist.getStringList("favlist");
    if (tem != null) {
      for (var element in tem) {
        List test = json.decode(element);
        fav.add(test[0]);
      }
    }
  }

  @override
  void dispose() {
    contentlib_controller.addListener(() {
      setState(() {});
    });
    super.dispose();
  }

  playaudio() async {
    final player = AudioPlayer();
    await player.setAsset(noteVoices[notevoiceindex]);
    player.play();
  }

  final contentlib_controller = DragSelectGridViewController();

  @override
  Widget build(BuildContext context) {
    final isSelectedAnyItem = contentlib_controller.value.isSelecting;

    return Directionality(
        textDirection: TextDirection.rtl,
        child: Scaffold(
          drawer: const Drawerc(),
          appBar: AppBar(
            backgroundColor: maincolor,
            title: isSelectedAnyItem
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Column(
                        children: [
                          Text("${contentlib_controller.value.amount} ",
                              style: const TextStyle(
                                color: Colors.white,
                              )),
                          const Text(" من العناصر",
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
                          contentlib_controller.value = Selection(indexes);
                        },
                        child: const Column(
                          children: [
                            Icon(
                              Icons.checklist,
                              color: Colors.white,
                            ),
                            Text("تحديد الكل",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))
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
                                style: TextStyle(
                                    color: Colors.white, fontSize: 18))
                          ],
                        ),
                      ),
                    ],
                  )
                : Text(
                    libraryList[widget.contentIndex].name,
                    style: const TextStyle(
                        fontSize: 25,
                        fontWeight: FontWeight.bold,
                        color: Colors.white),
                  ),
            leading: IconButton(
              icon: const Icon(
                Icons.arrow_back_ios,
                textDirection: TextDirection.rtl,
              ),
              onPressed: () {
                // Navigator.pop(context);
                Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => const MainScreen(navindex: 1)));
              },
            ),
            //IconButton,
          ),
          body: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              ListView(children: [
                FittedBox(
                  child: Padding(
                    padding: const EdgeInsets.all(10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        const Padding(
                          padding: EdgeInsets.only(right: 20),
                          child: Text(
                              "                                               "),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? 55
                                  : 35,
                              child: isSelectedAnyItem
                                  ? buttonlib(
                                      const Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.move_up,
                                            color: Colors.white,
                                            size: 30,
                                          ),
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(" نقل",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 20)),
                                          )
                                        ],
                                      ), () {
                                      List<int> theSelectedItem =
                                          contentlib_controller
                                              .value.selectedIndexes
                                              .toList();

                                      theSelectedItem.sort();
                                      theSelectedItem =
                                          theSelectedItem.reversed.toList();
                                      contentlib_controller.clear();
                                      Navigator.pushReplacement(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => MoveLibrary(
                                                  pastLibIndex:
                                                      widget.contentIndex,
                                                  selectedindexcontent:
                                                      theSelectedItem)));
                                    })
                                  : buttonlib(
                                      const Text(
                                        'إضافة جملة',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ), () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => AddContent(
                                                  libraryindex:
                                                      widget.contentIndex)));
                                    })),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(left: 10),
                          child: SizedBox(
                              height: MediaQuery.of(context).orientation ==
                                      Orientation.portrait
                                  ? 55
                                  : 35,
                              child: isSelectedAnyItem
                                  ? buttonlib(
                                      const Row(
                                        children: [
                                          Icon(
                                            Icons.delete,
                                            color: Colors.white,
                                            size: 35,
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
                                        'إعادة الترتيب',
                                        style: TextStyle(
                                            fontSize: 20,
                                            fontWeight: FontWeight.bold,
                                            color: Colors.white),
                                      ), () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) =>
                                                  ReArrangeContent(
                                                    contentIndex:
                                                        widget.contentIndex,
                                                  )));
                                    })),
                        ),
                      ],
                    ),
                  ),
                ),
                SafeArea(
                  child: SizedBox(
                    height: MediaQuery.of(context).size.height * .66,
                    width: double.infinity,
                    child: Padding(
                      padding: const EdgeInsets.all(10),
                      child: DragSelectGridView(
                          gridController: contentlib_controller,
                          itemCount: libraryList[widget.contentIndex]
                              .contenlist
                              .length,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            childAspectRatio: size == 0 ? 2 / 1 : 1,
                            crossAxisCount:
                                MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? size == 0
                                        ? 1
                                        : 2
                                    : 3,
                            mainAxisSpacing: 15,
                            crossAxisSpacing: 15,
                          ),
                          itemBuilder: ((context, index, isSelected) {
                            bool pressed = fav.contains(
                                libraryList[widget.contentIndex]
                                    .contenlist[index]
                                    .name);
                            return InkWell(
                              onTap: () async {
                                if (!cantPressed) {
                                  setState(() {
                                    cantPressed = true;
                                    cantpressIndex = index;
                                  });
                                  String path = libraryList[widget.contentIndex]
                                      .contenlist[index]
                                      .opvoice;
                                  String pathCache =
                                      libraryList[widget.contentIndex]
                                          .contenlist[index]
                                          .cacheVoicePath;

                                  if (path.isNotEmpty || pathCache.isNotEmpty) {
                                    final player = AudioPlayer();
                                    if (pathCache.isNotEmpty) {
                                      await player.setFilePath(pathCache);
                                    } else {
                                      path.contains(
                                              "https://firebasestorage.googleapis.com")
                                          ? await player.setUrl(// Load a URL
                                              path)
                                          : await player.setFilePath(
                                              // Load a URL
                                              path);
                                    }
                                    player.play().then((value) {
                                      setState(() {
                                        cantPressed = false;
                                      });
                                    });
                                  } else {
                                    howtospeak(libraryList[widget.contentIndex]
                                        .contenlist[index]
                                        .name);

                                    Future.delayed(
                                            const Duration(milliseconds: 1500))
                                        .then((value) {
                                      setState(() {
                                        cantPressed = false;
                                      });
                                    });
                                  }
                                }
                              },
                              child: Stack(
                                children: [
                                  Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                              color: maincolor, width: 1.5),
                                          color: cantPressed &&
                                                  cantpressIndex == index
                                              ? Colors.orange
                                              : Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(20)),
                                      child: Column(children: [
                                        const SizedBox(
                                          height: 7,
                                        ),
                                        Expanded(
                                            child: getImage(
                                                libraryList[widget.contentIndex]
                                                    .contenlist[index]
                                                    .imgurl)),
                                        contentText(
                                            libraryList[widget.contentIndex]
                                                .contenlist[index]
                                                .name),
                                        InkWell(
                                          child: Column(
                                            children: [
                                              Icon(
                                                Icons.star_rounded,
                                                color: pressed
                                                    ? maincolor
                                                    : Colors.grey,
                                                size: 35,
                                              ),
                                            ],
                                          ),
                                          onTap: () async {
                                            if (pressed) {
                                              setState(() {
                                                fav.remove(libraryList[
                                                        widget.contentIndex]
                                                    .contenlist[index]
                                                    .name);
                                                pressed = false;
                                              });
                                              String text = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .name;
                                              String imgurl = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .imgurl;
                                              String isImgeUpload = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .isImageUpload;
                                              String opvoice = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .opvoice;
                                              String cacheVoicePath =
                                                  libraryList[
                                                          widget.contentIndex]
                                                      .contenlist[index]
                                                      .cacheVoicePath;
                                              String isVoiceUpload =
                                                  libraryList[
                                                          widget.contentIndex]
                                                      .contenlist[index]
                                                      .isVoiceUpload;
                                              SharedPreferences favlist =
                                                  await SharedPreferences
                                                      .getInstance();
                                              var tem = favlist
                                                  .getStringList("favlist");
                                              if (tem != null) {
                                                List<String> f = tem;
                                                f.remove(
                                                    """["$text","$imgurl","$isImgeUpload","$opvoice","$cacheVoicePath","$isVoiceUpload"]""");
                                                favlist.setStringList(
                                                    "favlist", f);
                                              }
                                            } else {
                                              setState(() {
                                                fav.add(libraryList[
                                                        widget.contentIndex]
                                                    .contenlist[index]
                                                    .name);
                                                pressed = true;
                                              });
                                              List<String> favl = [];
                                              SharedPreferences favlist =
                                                  await SharedPreferences
                                                      .getInstance();
                                              var tem = favlist
                                                  .getStringList("favlist");
                                              String text = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .name;
                                              String imgurl = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .imgurl;
                                              String isImgeUpload = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .isImageUpload;
                                              String opvoice = libraryList[
                                                      widget.contentIndex]
                                                  .contenlist[index]
                                                  .opvoice;
                                              String cacheVoicePath =
                                                  libraryList[
                                                          widget.contentIndex]
                                                      .contenlist[index]
                                                      .cacheVoicePath;
                                              String isVoiceUpload =
                                                  libraryList[
                                                          widget.contentIndex]
                                                      .contenlist[index]
                                                      .isVoiceUpload;

                                              if (tem == null) {
                                                favl = [
                                                  """["$text","$imgurl","$isImgeUpload","$opvoice","$cacheVoicePath","$isVoiceUpload"]"""
                                                ];
                                              } else {
                                                favl = tem;
                                                favl.add(
                                                    """["$text","$imgurl","$isImgeUpload","$opvoice","$cacheVoicePath","$isVoiceUpload"]""");
                                              }
                                              favlist.setStringList(
                                                  "favlist", favl);
                                            }
                                          },
                                        ),
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
                                                    BorderRadius.circular(40),
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
                                                        builder: (context) => EditContent(
                                                            libraryindex: widget
                                                                .contentIndex,
                                                            contentIndex: index,
                                                            contentName:
                                                                libraryList[widget.contentIndex]
                                                                    .contenlist[
                                                                        index]
                                                                    .name,
                                                            imUrl: libraryList[
                                                                    widget
                                                                        .contentIndex]
                                                                .contenlist[
                                                                    index]
                                                                .imgurl,
                                                            opvoice:
                                                                libraryList[widget.contentIndex]
                                                                    .contenlist[
                                                                        index]
                                                                    .opvoice,
                                                            cacheVoicePath: libraryList[
                                                                    widget
                                                                        .contentIndex]
                                                                .contenlist[index]
                                                                .cacheVoicePath)));
                                              },
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Icon(
                                                  Icons.edit,
                                                  color: maincolor,
                                                ),
                                              ),
                                            )
                                ],
                              ),
                            );
                          })),
                    ),
                  ),
                ),
              ]),
              Container(
                height: MediaQuery.of(context).size.height * .1,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: maincolor, spreadRadius: 1, blurRadius: 3)
                    ],
                    border: Border.all(color: maincolor, width: 1),
                    borderRadius: const BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10))),
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreen(navindex: 0)),
                              (route) => false);
                        },
                        child: FittedBox(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      pageindex == 0 ? maincolor : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.wechat,
                                    color: pageindex == 0
                                        ? Colors.white
                                        : Colors.black,
                                    size: pageindex == 0 ? 40 : 35,
                                  ),
                                ),
                              ),
                              Text(
                                "التحدث",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: pageindex == 0 ? 25 : 20,
                                    color: pageindex == 0
                                        ? maincolor
                                        : Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreen(navindex: 1)),
                              (route) => false);
                        },
                        child: FittedBox(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      pageindex == 1 ? maincolor : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.my_library_books,
                                    color: pageindex == 1
                                        ? Colors.white
                                        : Colors.black,
                                    size: pageindex == 1 ? 40 : 35,
                                  ),
                                ),
                              ),
                              Text(
                                "المكتبة",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: pageindex == 1 ? 25 : 20,
                                    color: pageindex == 1
                                        ? maincolor
                                        : Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreen(navindex: 2)),
                              (route) => false);
                        },
                        child: FittedBox(
                          child: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  color:
                                      pageindex == 2 ? maincolor : Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.star,
                                    color: pageindex == 2
                                        ? Colors.white
                                        : Colors.black,
                                    size: pageindex == 2 ? 40 : 35,
                                  ),
                                ),
                              ),
                              Text(
                                "المفضلة",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: pageindex == 2 ? 25 : 20,
                                    color: pageindex == 2
                                        ? maincolor
                                        : Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          playaudio();
                        },
                        child: FittedBox(
                          child: Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.circle,
                                ),
                                child: const Padding(
                                  padding: EdgeInsets.all(5.0),
                                  child: Icon(
                                    Icons.notifications,
                                    color: Colors.black,
                                    size: 35,
                                  ),
                                ),
                              ),
                              const Text(
                                "تنبيه",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 20,
                                    color: Colors.black),
                              )
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ));
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
        List theSelectedItem =
            contentlib_controller.value.selectedIndexes.toList();
        theSelectedItem.sort();
        theSelectedItem = theSelectedItem.reversed.toList();
        for (var element in theSelectedItem) {
          libraryList[widget.contentIndex].contenlist.removeAt(element);
        }
        contentlib_controller.clear();
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

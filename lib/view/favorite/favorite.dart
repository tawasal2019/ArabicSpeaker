// ignore_for_file: use_build_context_synchronously

import 'dart:convert';

import '/controller/contenttext.dart';
import '/controller/images.dart';
import '/controller/speak.dart';
import '/controller/var.dart';
import '/view/drawer/drawer.dart';
import 'package:drag_select_grid_view/drag_select_grid_view.dart';
import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../model/content.dart';

class Favorite extends StatefulWidget {
  const Favorite({Key? key}) : super(key: key);

  @override
  State<Favorite> createState() => _FavoriteState();
}

class _FavoriteState extends State<Favorite> {
  final favcontroller = DragSelectGridViewController();
  List<Content> favorite = [];
  bool isloading = true;
  bool isempty = false;
  bool cantPressed = false;
  int cantpressIndex = 0;
  @override
  void initState() {
    favcontroller.addListener(() {
      setState(() {});
    });

    getdata().then((v) {
      setState(() {
        isloading = false;
      });
    });
    super.initState();
  }

  Future getdata() async {
    SharedPreferences favlist = await SharedPreferences.getInstance();
    List temoprary = favlist.getStringList("favlist") ?? [];
    if (temoprary.isEmpty) {
      isempty = true;
    } else {
      for (var element in temoprary) {
        List test = json.decode(element);
        favorite
            .add(Content(test[0], test[1], test[2], test[3], test[4], test[5]));
      }
    }
  }

  @override
  void dispose() {
    favcontroller.addListener(() {
      setState(() {});
    });
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isSelectedAnyItem = favcontroller.value.isSelecting;
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
                          Text("${favcontroller.value.amount} ",
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
                          for (int i = 0; i < favorite.length; i++) {
                            indexes.add(i);
                          }
                          favcontroller.value = Selection(indexes);
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
                : const Text("  "),
            backgroundColor: maincolor,
          ),
          body: isloading
              ? const Center(child: CircularProgressIndicator())
              : isempty
                  ? const Align(
                      alignment: Alignment.center,
                      child: Text("لا يوجد عناصر في المفضلة بعد"))
                  : ListView(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const SizedBox(
                              height: 73,
                              child: Padding(
                                padding: EdgeInsets.all(8.0),
                                child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Text(
                                      "المفضلة",
                                      style: TextStyle(
                                          fontSize: 31,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            isSelectedAnyItem
                                ? Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(11)),
                                            backgroundColor: maincolor,
                                            side: const BorderSide(
                                                width: 1.7,
                                                color: Colors.white),
                                            minimumSize: const Size(77, 31),
                                            textStyle: const TextStyle(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.bold)),
                                        onPressed: () async {
                                          showAlertDialog(context);
                                        },
                                        child: const Padding(
                                          padding: EdgeInsets.all(5.0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.delete,
                                                size: 35,
                                                color: Colors.white,
                                              ),
                                              Text("حذف",
                                                  style: TextStyle(
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 20))
                                            ],
                                          ),
                                        )),
                                  )
                                : const SizedBox()
                          ],
                        ),
                        Padding(
                          padding: const EdgeInsets.all(10),
                          child: SafeArea(
                            child: SizedBox(
                              width: double.infinity,
                              height: MediaQuery.of(context).size.height -
                                  AppBar().preferredSize.height -
                                  200,
                              child: DragSelectGridView(
                                  gridController: favcontroller,
                                  itemCount: favorite.length,
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? size == 0
                                                ? 1
                                                : 2
                                            : 3,
                                    childAspectRatio: size == 0 ? 2 / 1 : 1,
                                    mainAxisSpacing: 20,
                                    crossAxisSpacing: 20,
                                  ),
                                  itemBuilder: ((context, index, isSelected) {
                                    return InkWell(
                                      onTap: () async {
                                        if (!cantPressed) {
                                          setState(() {
                                            cantPressed = true;
                                            cantpressIndex = index;
                                          });
                                          String path = favorite[index].opvoice;

                                          String pathCache =
                                              favorite[index].cacheVoicePath;
                                          if (path.isNotEmpty ||
                                              pathCache.isNotEmpty) {
                                            final player = AudioPlayer();
                                            if (pathCache.isNotEmpty) {
                                              await player
                                                  .setFilePath(pathCache);
                                            } else {
                                              path.contains(
                                                      "https://firebasestorage.googleapis.com")
                                                  ? await player
                                                      .setUrl(// Load a URL
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
                                            howtospeak(favorite[index].name);

                                            Future.delayed(
                                                    const Duration(seconds: 2))
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
                                                      color: maincolor,
                                                      width: 1.5),
                                                  color: cantPressed &&
                                                          cantpressIndex ==
                                                              index
                                                      ? Colors.orange
                                                      : Colors.white,
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              child: Column(children: [
                                                const SizedBox(
                                                  height: 7,
                                                ),
                                                favorite[index].imgurl.isEmpty
                                                    ? Expanded(
                                                        child: FittedBox(
                                                          child: Column(
                                                            children: [
                                                              const SizedBox(
                                                                height: 30,
                                                              ),
                                                              Icon(
                                                                Icons
                                                                    .volume_up_outlined,
                                                                color:
                                                                    maincolor,
                                                                size: 80,
                                                              ),
                                                              const SizedBox(
                                                                height: 25,
                                                              ),
                                                            ],
                                                          ),
                                                        ),
                                                      )
                                                    : Expanded(
                                                        child: getImage(
                                                            favorite[index]
                                                                .imgurl)),
                                                contentText(
                                                    favorite[index].name)
                                              ])),
                                          isSelected
                                              ? Padding(
                                                  padding:
                                                      const EdgeInsets.all(5.0),
                                                  child: Container(
                                                    height: 23,
                                                    width: 23,
                                                    decoration: BoxDecoration(
                                                        color: Colors.white,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(40),
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
                                              : Container(),
                                        ],
                                      ),
                                    );
                                  })),
                            ),
                          ),
                        ),
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
        List theSelectedItem = favcontroller.value.selectedIndexes.toList();
        theSelectedItem.sort();
        theSelectedItem = theSelectedItem.reversed.toList();
        for (var element in theSelectedItem) {
          favorite.removeAt(element);
          favcontroller.clear();
          setState(() {});
        }

        SharedPreferences favlist = await SharedPreferences.getInstance();
        List<String> v = [];
        for (Content element in favorite) {
          String n = element.name;
          String i = element.imgurl;
          String imageUpload = element.isImageUpload;
          String o = element.opvoice;
          String co = element.opvoice;
          String voiceUpload = element.isVoiceUpload;
          v.add("""[
                              "$n",
                              "$i",
                              "$imageUpload",
                              "$o",
                              "$co",
                              "$voiceUpload"
                            ]""");
        }
        favlist.setStringList('favlist', v);
        if (v.isEmpty) {
          setState(() {
            isempty = true;
          });
        }
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

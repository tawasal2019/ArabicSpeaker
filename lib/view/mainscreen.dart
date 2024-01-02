// ignore_for_file: use_build_context_synchronously

import 'dart:convert';
import 'dart:io';

import 'package:arabicspeaker/controller/erroralert.dart';
import 'package:arabicspeaker/main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../controller/Rating_view.dart';
import '../controller/checkinternet.dart';
import '/view/favorite/favorite.dart';
import '/view/library/library.dart';
import '/view/speaking/speaking.dart';

import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/data_one_time.dart';
import '../controller/var.dart';
import 'block_user.dart';

int pageindex = 0;
List<Widget> screen = [const Speaking(), const Library(), const Favorite()];

class MainScreen extends StatefulWidget {
  final int navindex;
  const MainScreen({Key? key, required this.navindex}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  bool isLoading = true;

  playaudio() async {
    final player = AudioPlayer(); // Create a player
    await player.setAsset(// Load a URL
        noteVoices[notevoiceindex]); // Schemes: (https: | file: | asset: )
    player.play();
  }

  @override
  void initState() {
    pageindex = widget.navindex;
    getRatingDialog();
    getSize();
    getColor();
    getVoice();
    checkIfNeedUpdate();

    setDataOneTime().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    getfemail();
    checkIfBlockedUser();
    super.initState();
  }

  getRatingDialog() async {
    SharedPreferences numOfOpenApp = await SharedPreferences.getInstance();
    int countNum = numOfOpenApp.getInt("numOpenApp") ?? 0;
    if (countNum == 5) {
      internetConnection().then((value) async {
        if (value) {
          SharedPreferences IsRating = await SharedPreferences.getInstance();
          String IsR = IsRating.getString("israting") ?? "false";
          // print(IsR);

          if (IsR == "true") {
            numOfOpenApp.setInt("numOpenApp", -1);
          } else {
            numOfOpenApp.setInt("numOpenApp", 0);
            openDilogRating(context);
          }
        }
      });
    } else if (countNum == -1) {
    } else {
      int tmp = countNum + 1;
      numOfOpenApp.setInt("numOpenApp", tmp);
      //print(countNum);
    }
  }

  getVoice() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      notevoiceindex = pref.getInt("noteVoiceIndex") ?? 0;
    });
  }

  getSize() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      size = pref.getInt("size") ?? 1;
      isWordByWord = pref.getBool("switchValue") ?? true;
    });
  }

  getColor() async {
    SharedPreferences color = await SharedPreferences.getInstance();
    int colorind = color.getInt("color") ?? 0;
    setState(() {
      maincolor = colorList[colorind];
    });
  }

  getfemail() async {
    SharedPreferences female = await SharedPreferences.getInstance();
    var f = female.getBool("female");
    if (f == null) {
      setState(() {
        isFemale = false;
      });
    } else {
      setState(() {
        isFemale = f;
      });
    }
  }

  checkIfNeedUpdate() async {
    try {
      var lastAppVersion = await FirebaseFirestore.instance
          .collection("LastAppVersion")
          .doc("sD99s9XRXDDTW49hJJtJ")
          .get();
      Map<String, dynamic> data = lastAppVersion.data() ?? {};
      PackageInfo packageInfo = await PackageInfo.fromPlatform();

      int lastiosversion = Platform.isIOS
          ? data["iosVersionArabicSpeaker"]
          : data["androidVersionArabicSpeaker"];
      int version = int.parse(packageInfo.version);
      //print(lastiosversion);
     // print(version)
;

      if (lastiosversion > version) {
        updateVersionAlert(context);
      }
    } catch (e) {
      print(e);
    }
  }

  checkIfBlockedUser() async {
    try {
      var blockedEmails = await FirebaseFirestore.instance
          .collection("blockedEmails")
          .doc("CFpjKa35zNa83PaQDtRU")
          .get();

      Map<String, dynamic> data = blockedEmails.data() ?? {};
      List userDatablocked =
          json.decode(data[FirebaseAuth.instance.currentUser!.email]) ?? [];
      if (userDatablocked.isNotEmpty) {
        if (userDatablocked[0] == "1" && userDatablocked[1] == "false") {
          data[FirebaseAuth.instance.currentUser!.email.toString()] =
              """["1","true"]""";
          await FirebaseFirestore.instance
              .collection("blockedEmails")
              .doc("CFpjKa35zNa83PaQDtRU")
              .set(data);
          blockAlert(context, 1);
        } else if (userDatablocked[0] == "2" && userDatablocked[1] == "false") {
          data[FirebaseAuth.instance.currentUser!.email.toString()] =
              """["2","true"]""";
          await FirebaseFirestore.instance
              .collection("blockedEmails")
              .doc("CFpjKa35zNa83PaQDtRU")
              .set(data);
          blockAlert(context, 2);
        } else if (userDatablocked[0] == "3") {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => blockedUser(context)),
              (route) => false);
        }
      }
    } catch (_) {}
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
        textDirection: TextDirection.rtl,
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Scaffold(
                bottomNavigationBar: Container(
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
                    padding: EdgeInsets.all(
                        MediaQuery.of(context).orientation ==
                                Orientation.portrait
                            ? 12
                            : 0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        InkWell(
                          onTap: () {
                            setState(() {
                              pageindex = 0;
                            });
                          },
                          child: FittedBox(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: pageindex == 0
                                        ? maincolor
                                        : Colors.white,
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
                            setState(() {
                              pageindex = 1;
                            });
                          },
                          child: FittedBox(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: pageindex == 1
                                        ? maincolor
                                        : Colors.white,
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
                            setState(() {
                              pageindex = 2;
                            });
                          },
                          child: FittedBox(
                            child: Column(
                              children: [
                                Container(
                                  decoration: BoxDecoration(
                                    color: pageindex == 2
                                        ? maincolor
                                        : Colors.white,
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
                ),
                extendBody: true,
                body: screen[pageindex],
              ));
  }

  openDilogRating(BuildContext context) {
    showDialog(
        context: context,
        builder: (context) {
          return const Dialog(
            child: RatingView(),
          );
        });
  }
}

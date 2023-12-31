// ignore_for_file: use_build_context_synchronously

import 'package:arabicspeaker/main.dart';
import 'package:arabicspeaker/view/drawer/HowToUse.dart';
import 'package:arabicspeaker/view/drawer/block_user.dart';
import 'package:arabicspeaker/view/drawer/libraryUplodedSettings.dart';

import '../../controller/istablet.dart';
import '/controller/button.dart';
import '/controller/checkinternet.dart';
import '/view/Auth/login.dart';
import '/view/drawer/aboutapp.dart';
import '/view/drawer/contactus.dart';
import '/view/drawer/deleteaccount.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:volume_controller/volume_controller.dart';

import '../../controller/erroralert.dart';
import '../../controller/removeallshared.dart';
import '../../controller/var.dart';
import '../export_and_import/export.dart';
import '../export_and_import/import.dart';
import '../mainscreen.dart';
import 'QuestionnairResult.dart';

class Drawerc extends StatefulWidget {
  const Drawerc({Key? key}) : super(key: key);

  @override
  State<Drawerc> createState() => _DrawercState();
}

class _DrawercState extends State<Drawerc> {
  final user = FirebaseAuth.instance.currentUser;
  int radiovalue1 = isFemale ? 1 : 0;
  int radiovalue2 = 0;
  int radiovalue3 = size;
  int radiovalue4 = notevoiceindex;
  bool isExpanded = false;
  bool isExpanded1 = false;
  bool isLoading = true;
  ///////////////////

  @override
  void initState() {
    getdata().then((value) {
      setState(() {
        isLoading = false;
      });
    });
    super.initState();
  }

  Future getdata() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    radiovalue2 = pref.getInt("volume") ?? 0;
  }

  double fontSize = size == 0 ? 24 : 20;
  @override
  Widget build(BuildContext context) {
    return isLoading
        ? Center(
      child: CircularProgressIndicator(
        color: maincolor,
      ),
    )
        : Drawer(
        child: Column(
          children: [
            SizedBox(
              height: DeviceUtil.isTablet ?240:180,
              width: double.infinity,
              child: ClipRRect(
                child: DrawerHeader(
                  decoration: BoxDecoration(
                    color: maincolor,
                    borderRadius:  BorderRadius.only(
                        bottomRight: Radius.circular(DeviceUtil.isTablet ?50:30),
                        bottomLeft: Radius.circular(DeviceUtil.isTablet ?50:30)),
                  ),
                  child: Column(
                    children: [
                      Image.asset(
                        "assets/logo.png",
                        height: DeviceUtil.isTablet ?100:86,
                      ),
                      Padding(
                        padding: DeviceUtil.isTablet
                            ? const EdgeInsets.only(
                            left: 8.0, right: 8.0, bottom: 8.0, top: 10)
                            : EdgeInsets.only(
                            left: 4.0, right: 4.0, bottom: 4.0),
                        child: Center(
                            child: FittedBox(
                              child: Text(
                                " ${user!.email ?? 'Anonymous'}",
                                style:  TextStyle(
                                  color: Colors.white,
                                  fontSize: DeviceUtil.isTablet ?20:15,
                                ),
                              ),
                            )),
                      ),
                    ],
                  ),
                ),
              ),
            ),

                Expanded(
                  child: ListView(
                   // padding: EdgeInsets.zero,
                    children: [
                      ExpansionTile(
                        title: Row(children: [
                          Icon(
                            Icons.settings,
                            color: maincolor,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text(
                              "الإعدادات",
                              style: TextStyle(
                                fontSize: fontSize,
                                color: isExpanded
                                    ? maincolor
                                    : const Color.fromARGB(255, 0, 0, 0),
                              ),
                            ),
                          ),
                        ]),
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 16.0),
                            child: Align(
                              alignment: Alignment.topLeft,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                mainAxisSize: MainAxisSize.min,
                                children: <Widget>[
                                  Column(
                                    children: <Widget>[
                                      ExpansionTile(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.record_voice_over,
                                              color: maincolor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "صوت المتحدث",
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: isExpanded1
                                                      ? maincolor
                                                      : const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      "رجل",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                      value: 0,
                                                      groupValue: radiovalue1,
                                                      onChanged: (v) async {
                                                        SharedPreferences female =
                                                        await SharedPreferences
                                                            .getInstance();
                                                        female.setBool(
                                                            "female", false);
                                                        setState(() {
                                                          isFemale = false;
                                                          radiovalue1 = v as int;
                                                        });
                                                      },
                                                      activeColor: maincolor,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      "امرأة",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                        value: 1,
                                                        groupValue: radiovalue1,
                                                        onChanged: (v) async {
                                                          SharedPreferences
                                                          female =
                                                          await SharedPreferences
                                                              .getInstance();
                                                          female.setBool(
                                                              "female", true);
                                                          setState(() {
                                                            isFemale = true;
                                                            radiovalue1 =
                                                            v as int;
                                                          });
                                                        },
                                                        activeColor: maincolor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        onExpansionChanged: (bool expanding) =>
                                            setState(
                                                    () => isExpanded1 = expanding),
                                      ),
                                      ExpansionTile(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.notification_important,
                                              color: maincolor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "صوت التنبيه",
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: isExpanded1
                                                      ? maincolor
                                                      : const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      "تنبيه ١",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                      value: 0,
                                                      groupValue: radiovalue4,
                                                      onChanged: (v) async {
                                                        SharedPreferences pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                        pref.setInt(
                                                            "noteVoiceIndex",
                                                            v as int);
                                                        final player =
                                                        AudioPlayer();
                                                        await player.setAsset(
                                                            noteVoices[0]);
                                                        player.play();
                                                        setState(() {
                                                          radiovalue4 = v;
                                                          notevoiceindex =
                                                              radiovalue4;
                                                        });
                                                      },
                                                      activeColor: maincolor,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      "تنبيه ٢",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                        value: 1,
                                                        groupValue: radiovalue4,
                                                        onChanged: (v) async {
                                                          SharedPreferences pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                          pref.setInt(
                                                              "noteVoiceIndex",
                                                              v as int);
                                                          final player =
                                                          AudioPlayer();
                                                          await player.setAsset(
                                                            // Load a URL
                                                              noteVoices[
                                                              v]); // Schemes: (https: | file: | asset: )
                                                          player.play();
                                                          setState(() {
                                                            radiovalue4 = v;
                                                            notevoiceindex =
                                                                radiovalue4;
                                                          });
                                                        },
                                                        activeColor: maincolor),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      "تنبيه ٣",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                        value: 2,
                                                        groupValue: radiovalue4,
                                                        onChanged: (v) async {
                                                          SharedPreferences pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                          pref.setInt(
                                                              "noteVoiceIndex",
                                                              v as int);
                                                          final player =
                                                          AudioPlayer();
                                                          await player.setAsset(
                                                            // Load a URL
                                                              noteVoices[
                                                              v]); // Schemes: (https: | file: | asset: )
                                                          player.play();
                                                          setState(() {
                                                            radiovalue4 = v;
                                                            notevoiceindex =
                                                                radiovalue4;
                                                          });
                                                        },
                                                        activeColor: maincolor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        onExpansionChanged: (bool expanding) =>
                                            setState(
                                                    () => isExpanded1 = expanding),
                                      ),
                                      ExpansionTile(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.volume_up,
                                              color: maincolor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "مستوى الصوت",
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: isExpanded1
                                                      ? maincolor
                                                      : const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          /////////////////////////////////////////
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      "مرتفع",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                      value: 0,
                                                      groupValue: radiovalue2,
                                                      onChanged: (v) async {
                                                        SharedPreferences volume =
                                                        await SharedPreferences
                                                            .getInstance();
                                                        volume.setInt(
                                                            "volume", 0);
                                                        VolumeController()
                                                            .setVolume(1);
                                                        setState(() {
                                                          radiovalue2 = v as int;
                                                        });
                                                      },
                                                      activeColor: maincolor,
                                                    ),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      "متوسط",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                        value: 1,
                                                        groupValue: radiovalue2,
                                                        onChanged: (v) async {
                                                          SharedPreferences
                                                          volume =
                                                          await SharedPreferences
                                                              .getInstance();
                                                          volume.setInt(
                                                              "volume", 1);
                                                          VolumeController()
                                                              .setVolume(.65);
                                                          setState(() {
                                                            radiovalue2 =
                                                            v as int;
                                                          });
                                                        },
                                                        activeColor: maincolor),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      "منخفض",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                        value: 2,
                                                        groupValue: radiovalue2,
                                                        onChanged: (v) async {
                                                          SharedPreferences
                                                          volume =
                                                          await SharedPreferences
                                                              .getInstance();
                                                          volume.setInt(
                                                              "volume", 2);
                                                          VolumeController()
                                                              .setVolume(.4);
                                                          setState(() {
                                                            radiovalue2 =
                                                            v as int;
                                                          });
                                                        },
                                                        activeColor: maincolor),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        onExpansionChanged: (bool expanding) =>
                                            setState(
                                                    () => isExpanded1 = expanding),
                                      ),
                                      ExpansionTile(
                                        title: Row(
                                          children: [
                                            Icon(
                                              Icons.format_size,
                                              color: maincolor,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.all(8.0),
                                              child: Text(
                                                "حجم الواجهة",
                                                style: TextStyle(
                                                  fontSize: fontSize,
                                                  color: isExpanded1
                                                      ? maincolor
                                                      : const Color.fromARGB(
                                                      255, 0, 0, 0),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        children: <Widget>[
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                                horizontal: 16.0),
                                            child: Align(
                                              alignment: Alignment.topLeft,
                                              child: Column(
                                                mainAxisAlignment:
                                                MainAxisAlignment.start,
                                                mainAxisSize: MainAxisSize.min,
                                                children: <Widget>[
                                                  ListTile(
                                                    title: Text(
                                                      "افتراضي",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                        value: 1,
                                                        groupValue: radiovalue3,
                                                        onChanged: (v) async {
                                                          SharedPreferences pref =
                                                          await SharedPreferences
                                                              .getInstance();
                                                          pref.setInt("size", 1);
                                                          setState(() {
                                                            radiovalue3 =
                                                            v as int;
                                                            size = radiovalue3;
                                                          });

                                                          Navigator.pushAndRemoveUntil(
                                                              context,
                                                              MaterialPageRoute(
                                                                  builder: (context) =>
                                                                  const MainScreen(
                                                                      navindex:
                                                                      0)),
                                                                  (route) => false);
                                                        },
                                                        activeColor: maincolor),
                                                  ),
                                                  ListTile(
                                                    title: Text(
                                                      "كبير",
                                                      style: TextStyle(
                                                        fontSize: fontSize,
                                                      ),
                                                    ),
                                                    leading: Radio(
                                                      value: 0,
                                                      groupValue: radiovalue3,
                                                      onChanged: (v) async {
                                                        SharedPreferences pref =
                                                        await SharedPreferences
                                                            .getInstance();
                                                        pref.setInt("size", 0);

                                                        setState(() {
                                                          radiovalue3 = v as int;
                                                          size = radiovalue3;
                                                        });

                                                        Navigator.pushAndRemoveUntil(
                                                            context,
                                                            MaterialPageRoute(
                                                                builder: (context) =>
                                                                const MainScreen(
                                                                    navindex:
                                                                    0)),
                                                                (route) => false);
                                                      },
                                                      activeColor: maincolor,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ],
                                        onExpansionChanged: (bool expanding) =>
                                            setState(
                                                    () => isExpanded1 = expanding),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.only(
                                            right: 16, bottom: 16),
                                        child: Row(
                                          mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                          children: [
                                            Row(
                                              children: [
                                                Image.asset(
                                                  "assets/comment-text.png",
                                                  height: 30,
                                                  color: maincolor,
                                                ),
                                                Container(
                                                  width: 10,
                                                ),
                                                FittedBox(
                                                  child: Text(
                                                    "النطق أثناء الكتابة",
                                                    style: TextStyle(
                                                      fontSize: 22,
                                                      color: isExpanded1
                                                          ? maincolor
                                                          : const Color.fromARGB(
                                                          255, 0, 0, 0),
                                                    ),
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Switch(
                                                value: isWordByWord,
                                                activeColor: maincolor,
                                                onChanged: ((value) async {
                                                  setState(() {
                                                    isWordByWord = value;
                                                  });
                                                  SharedPreferences switchV =
                                                  await SharedPreferences
                                                      .getInstance();
                                                  switchV.setBool(
                                                      "switchValue", value);
                                                })),
                                          ],
                                        ),
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              builder: (context) {
                                                return FittedBox(
                                                  child: AlertDialog(
                                                    title: const Align(
                                                        alignment:
                                                        Alignment.centerRight,
                                                        child: Text("لون الواجهة",
                                                            style: TextStyle(
                                                                fontSize: 24,
                                                                fontWeight:
                                                                FontWeight
                                                                    .bold,
                                                                color: Colors
                                                                    .black))),
                                                    content: Column(
                                                      children: [
                                                        BlockPicker(
                                                            pickerColor:
                                                            maincolor,
                                                            availableColors:
                                                            colorList,
                                                            onColorChanged:
                                                                (c) async {
                                                              maincolor = c;
                                                              SharedPreferences
                                                              color =
                                                              await SharedPreferences
                                                                  .getInstance();
                                                              int ind = 0;
                                                              for (var element
                                                              in colorList) {
                                                                if (maincolor ==
                                                                    element) {
                                                                  break;
                                                                } else {
                                                                  ind++;
                                                                }
                                                              }
                                                              color.setInt(
                                                                  "color", ind);

                                                              Navigator.pushAndRemoveUntil(
                                                                  context,
                                                                  MaterialPageRoute(
                                                                      builder: (context) =>
                                                                      const MainScreen(
                                                                          navindex:
                                                                          0)),
                                                                      (route) =>
                                                                  false);
                                                            }),
                                                      ],
                                                    ),
                                                  ),
                                                );
                                              });
                                        },
                                        child: Padding(
                                          padding:
                                          const EdgeInsets.only(right: 20),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.palette,
                                                color: maincolor,
                                              ),
                                              Padding(
                                                padding:
                                                const EdgeInsets.all(8.0),
                                                child: Text(
                                                  "لون الواجهة",
                                                  style: TextStyle(
                                                    fontSize: fontSize,
                                                    color: const Color.fromARGB(
                                                        255, 0, 0, 0),
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                ],
                              ),
                            ),
                          ),
                        ],
                        onExpansionChanged: (bool expanding) =>
                            setState(() => isExpanded = expanding),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Icon(
                                  Icons.cloud_upload,
                                  color: maincolor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "رفع مكتبات",
                                    style: TextStyle(
                                      fontSize: fontSize,
                                    ),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          onTap: () async {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const Export()));

                            // exportNote(context);
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Icon(
                                  Icons.cloud_download,
                                  color: maincolor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("تنزيل مكتبات",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )),
                                ),
                              ]),
                            ),
                          ),
                          onTap: () async {
                            internetConnection().then((value) {
                              if (value == true) {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Import()));
                              } else {
                                erroralert(context, "يرجى الاتصال بالانترنت");
                              }
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Icon(
                                  Icons.description,
                                  color: maincolor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("شرح التطبيق",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )),
                                ),
                              ]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const HowToUse()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Icon(
                                  Icons.app_shortcut,
                                  color: maincolor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("عن التطبيق",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )),
                                ),
                              ]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => const AboutApp()));
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Icon(
                                  Icons.forum,
                                  color: maincolor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("تواصل معنا",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )),
                                ),
                              ]),
                            ),
                          ),
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => const Contactus(),
                                ));
                          },
                        ),
                      ),
                      FirebaseAuth.instance.currentUser!.uid ==
                          "J9OjdpMs5dMSnTVwzQS3ecoTUnE2"
                          ? Padding(
                        padding:
                        const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.control_camera,
                                    color: maincolor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("متابعة التنزيلات",
                                        style: TextStyle(
                                          fontSize: fontSize,
                                        )),
                                  ),
                                ]),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const LibraryUploadedSettings()));
                            }),
                      )
                          : Container(),
                      FirebaseAuth.instance.currentUser!.uid ==
                          "J9OjdpMs5dMSnTVwzQS3ecoTUnE2"
                          ? Padding(
                        padding:
                        const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.block,
                                    color: maincolor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("حظر المستخدمين",
                                        style: TextStyle(
                                          fontSize: fontSize,
                                        )),
                                  ),
                                ]),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                      const BlockUser()));
                            }),
                      )
                          : Container(),

                      FirebaseAuth.instance.currentUser!.uid ==
                          "J9OjdpMs5dMSnTVwzQS3ecoTUnE2"
                          ? Padding(
                        padding:
                        const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                            child: SizedBox(
                              height: 60,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Icon(
                                    Icons.add_chart_outlined,
                                    color: maincolor,
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: Text("نتائج الإستبيانات",
                                        style: TextStyle(
                                          fontSize: fontSize,
                                        )),
                                  ),
                                ]),
                              ),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          QuestionnairResult()
                                  )
                              );
                            }),
                      )
                          : Container(),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                Icon(
                                  Icons.exit_to_app_rounded,
                                  color: maincolor,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text("تسجيل الخروج",
                                      style: TextStyle(
                                        fontSize: fontSize,
                                      )),
                                ),
                              ]),
                            ),
                          ),
                          onTap: () async {
                            if (await internetConnection()) {
                              await FirebaseAuth.instance.signOut();
                              SharedPreferences myLoginInfo =
                              await SharedPreferences.getInstance();
                              List<String> myInfo =
                                  myLoginInfo.getStringList("myLoginInfo") ?? [];

                              removeAllSharedPrefrences().then((value) {
                                if (myInfo.isNotEmpty) {
                                  myLoginInfo.setStringList(
                                      "myLoginInfo", myInfo);
                                }
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => const Login()),
                                        (route) => false);
                              });
                            } else {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(" فضلا تأكد من اتصالك بالإنترنت",
                                      textAlign: TextAlign.right),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            }
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0, left: 8.0),
                        child: InkWell(
                          child: SizedBox(
                            height: 60,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Row(children: [
                                const Icon(
                                  Icons.delete,
                                  color: Colors.red,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    "حذف الحساب",
                                    style: TextStyle(
                                        color: Colors.red, fontSize: fontSize),
                                  ),
                                ),
                              ]),
                            ),
                          ),
                          onTap: () {
                            internetConnection().then((value) {
                              if (value == true) {
                                showDialog(
                                    context: context,
                                    builder: (context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                        ),
                                        title: const Text(
                                          'حذف الحساب',
                                          textDirection: TextDirection.rtl,
                                        ),
                                        content: const Text(
                                          "هل أنت متأكد من حذف حسابك؟",
                                          textDirection: TextDirection.rtl,
                                        ),
                                        actions: <Widget>[
                                          button(() {
                                            Navigator.of(context).pop();
                                          }, 'لا، تراجع'),
                                          button(() {
                                            Navigator.of(context).pop();
                                            deleteAccount();
                                          }, 'نعم، أنا متأكد')
                                        ],
                                      );
                                    });
                              } else {
                                erroralert(context, "تحقق من اتصالك بالانترنت");
                              }
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ),

          ],
        ));
  }
}

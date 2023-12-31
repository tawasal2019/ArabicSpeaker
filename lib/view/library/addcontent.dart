// ignore_for_file: prefer_typing_uninitialized_variables, prefer_const_literals_to_create_immutables, use_build_context_synchronously

import 'dart:async';

import 'dart:io' as io;
import 'package:arabicspeaker/controller/my_provider.dart';
import 'package:provider/provider.dart';

import '../../controller/erroralert.dart';
import '../../controller/images.dart';
import '/controller/uploaddata.dart';
import '/controller/var.dart';
import '/model/content.dart';
import '/view/library/contentlibrary.dart';
import '/view/library/iconsgroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_audio_recorder2/flutter_audio_recorder2.dart';
import 'package:image_picker/image_picker.dart';
import 'package:just_audio/just_audio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/button.dart';
import '../../controller/libtostring.dart';
import '../../model/library.dart';

class AddContent extends StatefulWidget {
  final int libraryindex;
  const AddContent({Key? key, required this.libraryindex}) : super(key: key);

  @override
  State<AddContent> createState() => _AddContentState();
}

class _AddContentState extends State<AddContent> {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool isRecording = false;
  late var im;
  TextEditingController controller = TextEditingController();
  bool isReady = false;
  String optionalvoice = "";
  bool isrecodeNow = false;
  bool deleteColor = false;
  bool errorsen = false;
  String message = "سيتم نطق الجملة بواسطة المتحدث العربي    ";
  bool hint = true;

  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyProvider>(context, listen: false).setPath("");
    });
    initrecorder();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: maincolor,
          title: const Text(
            "إضافة جملة",
            style: TextStyle(
                fontSize: 31, fontWeight: FontWeight.w500, color: Colors.white),
          ),
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 40,
                  ),
                  Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      left: 23,
                      right: 13,
                    ),
                    child: Text(
                      "اكتب جملة لا تتجاوز ست كلمات",
                      style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 80, 80, 80)),
                    ),
                  ),
                ],
              ),
            ),
            Stack(alignment: Alignment.bottomLeft, children: [
              Padding(
                padding: const EdgeInsets.only(
                    top: 5, left: 23, right: 23, bottom: 23),
                child: Container(
                  height: 155,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    onChanged: (value) {
                      if (controller.text.isNotEmpty) {
                        setState(() {
                          errorsen = false;
                        });
                      }
                    },
                    controller: controller,
                    maxLines: 3,
                    cursorColor: maincolor,
                    decoration: InputDecoration(
                      enabledBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          borderSide: BorderSide(width: 2, color: maincolor)),
                      focusedBorder: OutlineInputBorder(
                          borderRadius: const BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20)),
                          borderSide: BorderSide(width: 2, color: maincolor)),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(23),
                child: Container(
                  height: 60,
                  decoration: BoxDecoration(
                    color: maincolor,
                    borderRadius: const BorderRadius.only(
                        bottomLeft: Radius.circular(20),
                        bottomRight: Radius.circular(20)),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      optionalvoice.isEmpty
                          ? InkWell(
                              onTap: () async {
                                setState(() {
                                  message =
                                      "سيتم نطق الجملة بواسطة الصوت الخاص بك";
                                });
                                if (_currentStatus ==
                                    RecordingStatus.Initialized) {
                                  _start();
                                } else if (_currentStatus ==
                                        RecordingStatus.Recording &&
                                    _currentStatus != RecordingStatus.Unset) {
                                  _stop();
                                }
                              },
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  if (_currentStatus ==
                                      RecordingStatus.Recording)
                                    const Icon(
                                      Icons.stop,
                                      color: Colors.red,
                                    )
                                  else
                                    const Icon(Icons.mic, color: Colors.white),
                                  _currentStatus == RecordingStatus.Recording
                                      ? const Text(
                                          "يتم التسجيل...",
                                          style: TextStyle(color: Colors.red),
                                        )
                                      : const Text(
                                          "تسجيل صوتي",
                                          style: TextStyle(color: Colors.white),
                                        )
                                ],
                              ))
                          : InkWell(
                              onTap: () {
                                setState(() {
                                  message =
                                      "سيتم نطق الجملة بواسطة المتحدث العربي    ";
                                  optionalvoice = "";
                                });
                              },
                              child: const Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.restart_alt, color: Colors.white),
                                  Text(
                                    "إلغاء التسجيل",
                                    style: TextStyle(color: Colors.white),
                                  )
                                ],
                              ),
                            ),
                      Provider.of<MyProvider>(context)
                              .lastimagepath
                              .toString()
                              .isNotEmpty
                          ? InkWell(
                              onTap: () => diag(),
                              child: Padding(
                                padding: const EdgeInsets.only(right: 31),
                                child: SizedBox(
                                  height: 45,
                                  width: 45,
                                  child: getImage(
                                      Provider.of<MyProvider>(context)
                                          .lastimagepath
                                          .toString()),
                                ),
                              ),
                            )
                          : Container(),
                      Provider.of<MyProvider>(context)
                              .lastimagepath
                              .toString()
                              .isEmpty
                          ? InkWell(
                              onTap: () => diag(),
                              child: const SizedBox(
                                height: 71,
                                width: 71,
                                child: Padding(
                                  padding: EdgeInsets.only(left: 41),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(Icons.camera, color: Colors.white),
                                      Text(
                                        "صورة",
                                        style: TextStyle(color: Colors.white),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            )
                          : Container(),
                      InkWell(
                          onTap: () {
                            setState(() {
                              deleteColor = true;
                            });
                            Future.delayed(const Duration(seconds: 1))
                                .then((value) {
                              setState(() {
                                deleteColor = false;
                              });
                            });
                            controller.clear();
                          },
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.delete_outline,
                                color: deleteColor ? Colors.red : Colors.white,
                              ),
                              Text(
                                "مسح",
                                style: TextStyle(
                                    color: deleteColor
                                        ? Colors.red
                                        : Colors.white),
                              )
                            ],
                          )),
                    ],
                  ),
                ),
              )
            ]),
            hint
                ? Padding(
                    padding: const EdgeInsets.only(
                        top: 10, right: 20, left: 20, bottom: 10),
                    child: Container(
                      height: 60,
                      width: 20,
                      decoration: const BoxDecoration(
                        color: Color.fromARGB(255, 238, 237, 237),
                        shape: BoxShape
                            .rectangle, //border: BorderRadius.circular(30)
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                              InkWell(
                                onTap: () {
                                  setState(() {
                                    hint = false;
                                  });
                                },
                                child: const Icon(Icons.close),
                              ),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(
                                Icons.circle,
                                color: maincolor,
                                size: 16,
                              ),
                              Text(
                                message,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  )
                : const SizedBox(),
            errorsen
                ? const Padding(
                    padding: EdgeInsets.only(top: 3, right: 33, bottom: 10),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.error,
                          color: Colors.red,
                        ),
                        Text(
                          " يجب ادخال جملة  ",
                          style: TextStyle(
                              color: Colors.red,
                              fontSize: 20,
                              fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  )
                : const SizedBox(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                //crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(),
                  SizedBox(
                    height: 65,
                    width: 110,
                    child: button(() async {
                      if (controller.text.trim().isEmpty) {
                        setState(() {
                          errorsen = true;
                        });

                        //erroralert(context, "يجب ادخال جملة");
                      } else {
                        String imgUpload = "no";
                        String voiceUpload = "no";
                        if (Provider.of<MyProvider>(context, listen: false)
                                .lastimagepath
                                .toString()
                                .isEmpty ||
                            Provider.of<MyProvider>(context, listen: false)
                                .lastimagepath
                                .toString()
                                .contains("assets/")) {
                          imgUpload = "yes";
                        }
                        if (optionalvoice.isEmpty) voiceUpload = "yes";

                        libraryList[widget.libraryindex].contenlist.add(Content(
                            controller.text,
                            Provider.of<MyProvider>(context, listen: false)
                                .lastimagepath
                                .toString(),
                            imgUpload,
                            optionalvoice,
                            optionalvoice,
                            voiceUpload));
                        SharedPreferences liblist =
                            await SharedPreferences.getInstance();
                        List<String> v = [];
                        for (lib l in libraryList) {
                          String s = convertLibString(l);
                          v.add(s);
                        }
                        liblist.setStringList("liblist", v);
                        tryUploadData();
                        Navigator.pushAndRemoveUntil(
                            context,
                            MaterialPageRoute(
                                builder: (context) => ContentLibrary(
                                    contentIndex: widget.libraryindex)),
                            (route) => false);

                        Provider.of<MyProvider>(context, listen: false)
                            .setPath("");
                        acceptalert(context, "تم إضافة المحتوى بنجاح");
                      }
                    }, 'حفظ'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  initrecorder() async {
    final status = await Permission.microphone.request();
    if (status != PermissionStatus.granted) {
    } else {
      _init();
    }
  }

  _init() async {
    try {
      bool hasPermission = await FlutterAudioRecorder2.hasPermissions ?? false;

      if (hasPermission) {
        String customPath = '/flutter_audio_recorder_';
        io.Directory appDocDirectory;
        if (io.Platform.isIOS) {
          appDocDirectory = await getApplicationDocumentsDirectory();
        } else {
          appDocDirectory = (await getExternalStorageDirectory())!;
        }

        // can add extension like ".mp4" ".wav" ".m4a" ".aac"
        customPath = appDocDirectory.path +
            customPath +
            DateTime.now().millisecondsSinceEpoch.toString();

        // .wav <---> AudioFormat.WAV
        // .mp4 .m4a .aac <---> AudioFormat.AAC
        // AudioFormat is optional, if given value, will overwrite path extension when there is conflicts.
        _recorder =
            FlutterAudioRecorder2(customPath, audioFormat: AudioFormat.WAV);

        await _recorder!.initialized;
        // after initialization
        var current = await _recorder!.current(channel: 0);
        setState(() {
          _current = current;
          _currentStatus = current!.status!;
        });
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text("You must accept permissions")));
      }
    } catch (_) {}
  }

  _start() async {
    try {
      await _recorder!.start();
      var recording = await _recorder!.current(channel: 0);
      setState(() {
        _current = recording;
      });

      const tick = Duration(milliseconds: 50);
      Timer.periodic(tick, (Timer t) async {
        if (_currentStatus == RecordingStatus.Stopped) {
          t.cancel();
        }

        var current = await _recorder!.current(channel: 0);
        if (mounted) {
          setState(() {
            _current = current;
            _currentStatus = _current!.status!;
          });
        }
      });
    } catch (_) {}
  }

  _stop() async {
    var result = await _recorder!.stop();
    final player = AudioPlayer();

    if (result?.path != null) {
      optionalvoice = result?.path ?? "";
      await player.setFilePath(result?.path ?? "");
      player.play();
    }
    _init();
    setState(() {
      _current = result;
      _currentStatus = _current!.status!;
    });
  }

  Future pickimage(ImageSource source) async {
    try {
      final im = await ImagePicker().pickImage(source: source);
      if (im == null) {
        return;
      } else {
        Provider.of<MyProvider>(context, listen: false).setPath(im.path);
      }
    } on PlatformException {
      ///////////edit heeeeeeeeeeeeeeeeeeeeeeeeere
      return;
    }
  }

  diag() {
    return showCupertinoDialog(
        context: context,
        builder: (context) {
          return CupertinoAlertDialog(
            actions: [
              CupertinoDialogAction(
                  child: const Text(
                    "الكاميرا",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    pickimage(ImageSource.camera);
                  }),
              CupertinoDialogAction(
                child: const Text(" الاستديو",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  pickimage(ImageSource.gallery);
                },
              ),
              CupertinoDialogAction(
                child: const Text("مكتبة الايقونات",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 22,
                        fontWeight: FontWeight.bold)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Icongroups()));
                },
              ),
              CupertinoDialogAction(
                  isDefaultAction: true,
                  onPressed: () {
                    Navigator.pop(context, 'Cancel');
                  },
                  child: const Text('إلغاء',
                      style: TextStyle(
                          fontSize: 22, fontWeight: FontWeight.bold))),
            ],
          );
        });
  }
}

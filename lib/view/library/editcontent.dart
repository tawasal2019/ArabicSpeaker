// ignore_for_file: prefer_typing_uninitialized_variables, use_build_context_synchronously

import 'dart:async';
import 'dart:convert';
import 'dart:io' as io;

import 'package:arabicspeaker/controller/images.dart';
import 'package:arabicspeaker/view/library/contentlibrary.dart';
import 'package:provider/provider.dart';

import '../../controller/my_provider.dart';
import '/controller/var.dart';
import '/model/content.dart';
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
import '../../controller/erroralert.dart';
import '../../controller/libtostring.dart';
import '../../model/library.dart';

class EditContent extends StatefulWidget {
  final int libraryindex;
  final int contentIndex;
  final String contentName;
  final String imUrl;
  final String opvoice;
  final String cacheVoicePath;
  const EditContent(
      {Key? key,
      required this.libraryindex,
      required this.contentIndex,
      required this.contentName,
      required this.imUrl,
      required this.opvoice,
      required this.cacheVoicePath})
      : super(key: key);

  @override
  State<EditContent> createState() => _EditContentState();
}

class _EditContentState extends State<EditContent> {
  FlutterAudioRecorder2? _recorder;
  Recording? _current;
  RecordingStatus _currentStatus = RecordingStatus.Unset;
  bool isRecording = false;
  late var im;
  TextEditingController controller = TextEditingController();
  bool isReady = false;
  String optionalvoice = "";
  String cacheoptionalvoice = "";
  bool isrecodeNow = false;
  bool deleteColor = false;
  bool errorsen = false;

  @override
  void initState() {
    controller.text = widget.contentName;
    optionalvoice = widget.opvoice;
    cacheoptionalvoice = widget.cacheVoicePath;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyProvider>(context, listen: false).setPath(widget.imUrl);
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
        ),
        body: ListView(
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 23),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "تعديل الجملة",
                    style: TextStyle(fontSize: 31, fontWeight: FontWeight.w500),
                  ),
                  Text("اكتب جملة لا تتجاوز ست كلمات"),
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
                                if (_currentStatus ==
                                    RecordingStatus.Initialized) {
                                  _start();
                                } else if (_currentStatus ==
                                        RecordingStatus.Recording &&
                                    _currentStatus != RecordingStatus.Unset) {
                                  _stop();
                                }
                              }, ////////////////////////////////////

                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  _currentStatus == RecordingStatus.Recording
                                      ? const Icon(
                                          Icons.stop, //Icons.stop,

                                          color: Colors.red,
                                        )
                                      : const Icon(Icons.mic, //Icons.mic,
                                          color: Colors.white),
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
                                  optionalvoice = "";
                                  cacheoptionalvoice = "";
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

                      /////////////////////////////////اظهار الصورة بعد فتح الجمله للتعديل

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
                              child: SizedBox(
                                height: 71,
                                width: 71,
                                child: Padding(
                                    padding: const EdgeInsets.only(left: 41),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const Icon(Icons.camera,
                                            color: Colors.white),
                                        Provider.of<MyProvider>(context)
                                                .lastimagepath
                                                .toString()
                                                .isEmpty
                                            ? const Text(
                                                "صورة",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                            : const Text(
                                                "تغيير الصورة",
                                                style: TextStyle(
                                                    color: Colors.white),
                                              )
                                      ],
                                    )),
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
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SizedBox(
                    height: 65,
                    width: 110,
                    child: button(() async {
                      if (controller.text.isNotEmpty) {
                        SharedPreferences liblist =
                            await SharedPreferences.getInstance();
                        List<String> lb =
                            liblist.getStringList("liblist") ?? [];
                        List e = json.decode(lb[widget.libraryindex]);
                        List<Content> contentlist = [];
                        for (List l in e[3]) {
                          contentlist
                              .add(Content(l[0], l[1], l[2], l[3], l[4], l[5]));
                        }

                        if (Provider.of<MyProvider>(context, listen: false)
                                    .lastimagepath
                                    .toString() ==
                                widget.imUrl &&
                            optionalvoice == widget.opvoice) {
                          Content lastcon = contentlist[widget.contentIndex];
                          contentlist[widget.contentIndex] = Content(
                              controller.text,
                              lastcon.imgurl,
                              lastcon.isImageUpload,
                              lastcon.opvoice,
                              lastcon.cacheVoicePath,
                              lastcon.isVoiceUpload);
                        } else if (Provider.of<MyProvider>(context,
                                        listen: false)
                                    .lastimagepath
                                    .toString() !=
                                widget.imUrl &&
                            optionalvoice == widget.opvoice) {
                          Content lastcon = contentlist[widget.contentIndex];
                          if (Provider.of<MyProvider>(context, listen: false)
                                  .lastimagepath
                                  .toString()
                                  .isEmpty ||
                              Provider.of<MyProvider>(context, listen: false)
                                  .lastimagepath
                                  .toString()
                                  .contains("assets/")) {
                            contentlist[widget.contentIndex] = Content(
                                controller.text,
                                Provider.of<MyProvider>(context, listen: false)
                                    .lastimagepath
                                    .toString(),
                                "yes",
                                lastcon.opvoice,
                                lastcon.cacheVoicePath,
                                lastcon.isVoiceUpload);
                          } else {
                            contentlist[widget.contentIndex] = Content(
                                controller.text,
                                Provider.of<MyProvider>(context, listen: false)
                                    .lastimagepath
                                    .toString(),
                                "no",
                                lastcon.opvoice,
                                lastcon.cacheVoicePath,
                                lastcon.isVoiceUpload);
                          }
                        } else if (Provider.of<MyProvider>(context,
                                        listen: false)
                                    .lastimagepath
                                    .toString() ==
                                widget.imUrl &&
                            optionalvoice != widget.opvoice) {
                          Content lastcon = contentlist[widget.contentIndex];
                          if (optionalvoice.isEmpty) {
                            contentlist[widget.contentIndex] = Content(
                                controller.text,
                                lastcon.imgurl,
                                lastcon.isImageUpload,
                                "",
                                "",
                                "yes");
                          } else {
                            contentlist[widget.contentIndex] = Content(
                                controller.text,
                                lastcon.imgurl,
                                lastcon.isImageUpload,
                                optionalvoice,
                                cacheoptionalvoice,
                                "no");
                          }
                        } else {
                          if (Provider.of<MyProvider>(context, listen: false)
                                  .lastimagepath
                                  .toString()
                                  .isEmpty ||
                              Provider.of<MyProvider>(context, listen: false)
                                  .lastimagepath
                                  .toString()
                                  .contains("assets/")) {
                            if (optionalvoice.isEmpty) {
                              contentlist[widget.contentIndex] = Content(
                                  controller.text,
                                  Provider.of<MyProvider>(context,
                                          listen: false)
                                      .lastimagepath
                                      .toString(),
                                  "yes",
                                  optionalvoice,
                                  cacheoptionalvoice,
                                  "yes");
                            } else {
                              contentlist[widget.contentIndex] = Content(
                                  controller.text,
                                  Provider.of<MyProvider>(context,
                                          listen: false)
                                      .lastimagepath
                                      .toString(),
                                  "yes",
                                  optionalvoice,
                                  cacheoptionalvoice,
                                  "no");
                            }
                          } else {
                            if (optionalvoice.isEmpty) {
                              contentlist[widget.contentIndex] = Content(
                                  controller.text,
                                  Provider.of<MyProvider>(context,
                                          listen: false)
                                      .lastimagepath
                                      .toString(),
                                  "no",
                                  optionalvoice,
                                  cacheoptionalvoice,
                                  "yes");
                            } else {
                              contentlist[widget.contentIndex] = Content(
                                  controller.text,
                                  Provider.of<MyProvider>(context,
                                          listen: false)
                                      .lastimagepath
                                      .toString(),
                                  "no",
                                  optionalvoice,
                                  cacheoptionalvoice,
                                  "no");
                            }
                          }
                        }
                        lb[widget.libraryindex] = convertLibString(
                            lib(e[0], e[1], e[2], contentlist));
                        getdata();
                        liblist.setStringList("liblist", lb).then((value) {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ContentLibrary(
                                      contentIndex: widget.libraryindex)));
                          Provider.of<MyProvider>(context, listen: false)
                              .setPath("");
                          acceptalert(context, "تم تعديل المحتوى بنجاح");
                        });
                      } else {
                        setState(() {
                          errorsen = true;
                        });

                        // erroralert(context, "عليك وضع اسم للمحتوى");
                      }
                    }, 'حفظ'),
                  ),
                  SizedBox(
                    height: 65,
                    width: 110,
                    child: button(() {
                      Navigator.pop(context);
                    }, 'الغاء'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
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
      cacheoptionalvoice = result?.path ?? "";
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
                    style: TextStyle(color: Colors.black),
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                    pickimage(ImageSource.camera);
                  }),
              CupertinoDialogAction(
                child: const Text(" الاستديو",
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  pickimage(ImageSource.gallery);
                },
              ),
              CupertinoDialogAction(
                child: const Text("مكتبة الايقونات",
                    style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Icongroups()));
                },
              ),
              ///////////////////// خاصية الالغاء
              CupertinoDialogAction(
                child:
                    const Text(" الغاء", style: TextStyle(color: Colors.black)),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              ///////////////////// خاصية الالغاء
            ],
          );
        });
  }
}

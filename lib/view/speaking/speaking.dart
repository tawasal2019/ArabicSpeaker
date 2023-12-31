// ignore_for_file: non_constant_identifier_names, unused_local_variable, iterable_contains_unrelated_type
import 'dart:convert';
import 'package:arabicspeaker/main.dart';
import 'package:arabicspeaker/view/drawer/drawer.dart';

import '../../controller/istablet.dart';
import '../../controller/realtime.dart';
import '/controller/erroralert.dart';
import '/controller/var.dart';
import 'package:flutter/material.dart';
import 'package:keyboard_dismisser/keyboard_dismisser.dart';
import 'package:share_plus/share_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/speak.dart';
import 'package:flutter/services.dart' show rootBundle;

class Speaking extends StatefulWidget {
  const Speaking({Key? key}) : super(key: key);
  @override
  State<Speaking> createState() => _SpeakingState();
}

class _SpeakingState extends State<Speaking> {
  bool autoComp = false;
  String text = '';
  String path = "";
  bool speakColor = false;
  bool shareColor = false;
  bool deleteColor = false;
  bool deleteWordColor = false;
  List<String> fav = [];
  List<String> LocalDB = [];
  List<String> displayedWords = [
    "هل",
    "متى",
    "اين",
    "كيف",
    "بكم",
    "افتح",
    "ممكن",
    "طيب",
    "السلام",
    "اعطني",
    "انا",
    "لماذا",
  ];
  List<String> enteredWords = []; // so we don't display the entered words
  final TextEditingController _fieldcontroller = TextEditingController();
  bool isLoading = true;
  bool pressed = false;
  bool notextyet = true;

  @override
  void initState() {
    getLocalDB();
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
        fav.add(test[0].toString().trim());
      }
    }
  }

  getLocalDB() async {
    SharedPreferences Local = await SharedPreferences.getInstance();
    var list = Local.getStringList("Local");
    if (list != null) {
      for (var element in list) {
        List Sentence = json.decode(element);
        LocalDB.add(Sentence[0].toString());
      }
    }
  }

  store_In_local(String Text) async {
    Text = Text.trim();
    Text = Text.replaceAll("  ", " ");
    SharedPreferences Local = await SharedPreferences.getInstance();
    List<String> temp = Local.getStringList("Local") ?? [];
    if (!LocalDB.contains(Text)) {
      LocalDB.add(Text);
      temp.add("""["$Text","","yes","","yes"]""");
    }
    Local.setStringList("Local", temp);
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xffeae9ef),
        extendBody: true,
        appBar: AppBar(
          backgroundColor: maincolor,
        ),
        drawer: const Drawerc(),
        body: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : KeyboardDismisser(
                gestures: const [
                  GestureType.onTap,
                  GestureType.onPanUpdateDownDirection,
                ],
                child: ListView(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(
                          top: 10,
                          left: DeviceUtil.isTablet ? 25 : 10,
                          right: 20),
                      child: Stack(
                        children: [
                          Column(
                            children: [
                              Container(
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      topLeft: Radius.circular(13),
                                      topRight: Radius.circular(13)),
                                  color: Colors.white,
                                ),
                                width: MediaQuery.of(context).size.width * .95,
                                height: MediaQuery.of(context).orientation ==
                                        Orientation.portrait
                                    ? DeviceUtil.isTablet
                                        ? 230
                                        : size == 0
                                            ? 160
                                            : 150 //150
                                    : DeviceUtil.isTablet
                                        ? 140
                                        : 97,
                                child: GestureDetector(
                                  onTap: () {
                                    FocusScope.of(context).unfocus();
                                  },
                                  child: TextField(
                                    controller: _fieldcontroller,
                                    maxLength: 500,
                                    maxLines:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? 4
                                            : 2,
                                    cursorColor:
                                        const Color.fromARGB(255, 29, 19, 19),
                                    style: TextStyle(
                                      fontSize: DeviceUtil.isTablet
                                          ? 33
                                          : size == 0
                                              ? 26
                                              : 24,
                                      color: Colors.grey.shade700,
                                      fontWeight: FontWeight.w600,
                                    ),
                                    onTap: () {
                                      _fieldcontroller.selection =
                                          TextSelection.fromPosition(
                                              TextPosition(
                                                  offset: _fieldcontroller
                                                      .text.length));
                                    },
                                    onChanged: (text) {
                                      if (_fieldcontroller.text.length >= 500) {
                                        noteAlert(context,
                                            "لا يمكنك نطق جملة تحتوي أكثر من 500 حرف");
                                      }
                                      if (text.isEmpty) {
                                        setState(() {
                                          notextyet = true;
                                        });
                                      } else {
                                        setState(() {
                                          notextyet = false;
                                        });
                                      }
                                      List<String> word =
                                          text.trim().split(" ");
                                      /*  if (text.isNotEmpty) {
                                        setState(() {
                                          if (text.endsWith(" ") &&
                                              word.length != 1) {
                                            store_In_local(text);
                                          }
                                        });
                                      }*/

                                      if (text.trim().isEmpty) {
                                        autoComp = false;
                                        displayedWords = [
                                          "هل",
                                          "متى",
                                          "اين",
                                          "كيف",
                                          "بكم",
                                          "افتح",
                                          "ممكن",
                                          "طيب",
                                          "السلام",
                                          "اعطني",
                                          "انا",
                                          "لماذا",
                                        ];
                                        setState(() {});
                                      } else if (!text.endsWith(" ")) {
                                        displayedWords.clear();
                                        auto_complete(word[word.length - 1]);
                                        autoComp = true;
                                        setState(() {});
                                      } else {
                                        autoComp = false;
                                        setState(() {});

                                        for (String aword in word) {
                                          if (!enteredWords.contains(aword)) {
                                            enteredWords.add(aword);
                                          }
                                        }
                                        //here
                                        if (isWordByWord) {
                                          setState(() {
                                            speakColor = true;
                                          });

                                          howtospeak(
                                              word[word.length - 1].toString());
                                          Future.delayed(
                                                  const Duration(seconds: 2))
                                              .then((value) {
                                            setState(() {
                                              speakColor = false;
                                            });
                                          });
                                        }

                                        predict(word);
                                      }
                                      if (fav.contains(text.trim())) {
                                        setState(() {
                                          pressed = true;
                                        });
                                      } else {
                                        setState(() {
                                          pressed = false;
                                        });
                                      }
                                    },
                                    decoration: InputDecoration(
                                      hintText: ' أكتب هنا',
                                      hintStyle: TextStyle(
                                          fontSize: DeviceUtil.isTablet
                                              ? 40
                                              : size == 0
                                                  ? 24
                                                  : 22,
                                          fontWeight: FontWeight.w300),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                          )),
                                      focusedBorder: OutlineInputBorder(
                                          borderRadius:
                                              BorderRadius.circular(20),
                                          borderSide: const BorderSide(
                                            color: Colors.white,
                                          )),
                                    ),
                                  ),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width *
                                    .95, //.8
                                height: DeviceUtil.isTablet
                                    ? 85
                                    : size == 0
                                        ? 70
                                        : 65,
                                decoration: const BoxDecoration(
                                  borderRadius: BorderRadius.only(
                                      bottomLeft: Radius.circular(13),
                                      bottomRight: Radius.circular(13)),
                                  color: Color(0xffdbdbdb),
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceAround,
                                  children: [
                                    InkWell(
                                      onTap: () {
                                        if (_fieldcontroller.text.isNotEmpty) {
                                          if (_fieldcontroller.text.length >
                                              500) {
                                            noteAlert(context,
                                                "لا يمكنك نطق جملة تحتوي أكثر من 500 حرف");
                                          } else {
                                            store_In_local(
                                                _fieldcontroller.text);
                                            setState(() {
                                              speakColor = true;
                                            });

                                            howtospeak(_fieldcontroller.text);
                                            Future.delayed(
                                                    const Duration(seconds: 2))
                                                .then((value) {
                                              setState(() {
                                                speakColor = false;
                                              });
                                            });
                                            tryUploadToRealTime(
                                                _fieldcontroller.text);
                                          }
                                        }
                                      },
                                      child: Container(
                                        width: DeviceUtil.isTablet
                                            ? 130
                                            : size == 0
                                                ? 95
                                                : 90,
                                        height: DeviceUtil.isTablet
                                            ? 66
                                            : size == 0
                                                ? 50
                                                : 46,
                                        decoration: BoxDecoration(
                                            boxShadow: const [
                                              BoxShadow(
                                                color: Colors.grey,
                                                blurRadius: 9,
                                                spreadRadius: 3,
                                                offset: Offset(
                                                  2,
                                                  5,
                                                ),
                                              )
                                            ],
                                            border: Border.all(
                                                color: Colors.white,
                                                width: 1.6),
                                            borderRadius:
                                                BorderRadius.circular(12),
                                            color: notextyet
                                                ? maincolor.withOpacity(.3)
                                                : speakColor
                                                    ? Colors.red
                                                    : maincolor),
                                        child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Text(
                                                "نطق",
                                                style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize:
                                                        DeviceUtil.isTablet
                                                            ? 35
                                                            : size == 0
                                                                ? 22
                                                                : 20),
                                              ),
                                              Icon(
                                                Icons.volume_up_outlined,
                                                color: Colors.white,
                                                size: DeviceUtil.isTablet
                                                    ? 40
                                                    : 30,
                                                //here
                                              )
                                            ]),
                                      ),
                                    ),
                                    //.................................
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          deleteWordColor = true;
                                        });
                                        List<String> words = _fieldcontroller
                                            .text
                                            .trim()
                                            .split(" ");
                                        words.removeAt(words.length - 1);
                                        _fieldcontroller.text =
                                            "${words.join(" ")} ";
                                        text = _fieldcontroller.text;
                                        _fieldcontroller.selection =
                                            TextSelection.fromPosition(
                                                TextPosition(
                                                    offset: _fieldcontroller
                                                        .text.length));
                                        predict(words);
                                        if (_fieldcontroller.text
                                            .trim()
                                            .isEmpty) {
                                          setState(() {
                                            displayedWords = [
                                              //words displayed in the boxes
                                              "هل",
                                              "متى",
                                              "اين",
                                              "كيف",
                                              "بكم",
                                              "افتح",
                                              "ممكن",
                                              "طيب",
                                              "السلام",
                                              "اعطني",
                                              "انا",
                                              "لماذا",
                                            ];
                                            notextyet = true;
                                          });
                                        }
                                        Future.delayed(
                                                const Duration(seconds: 1))
                                            .then((value) {
                                          setState(() {
                                            deleteWordColor = false;
                                          });
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.arrow_back,
                                            color: deleteWordColor
                                                ? Colors.red
                                                : Colors.black,
                                            size: size == 0 ? 35 : 32,
                                          ),
                                          Text(
                                            "حذف كلمة",
                                            style: TextStyle(
                                                fontSize: DeviceUtil.isTablet
                                                    ? 22
                                                    : size == 0
                                                        ? 19
                                                        : 17),
                                          )
                                        ],
                                      ),
                                    ),
                                    //................................
                                    InkWell(
                                      onTap: () {
                                        _fieldcontroller.clear();
                                        autoComp = false;

                                        setState(() {
                                          notextyet = true;
                                          enteredWords.clear();
                                          displayedWords = [
                                            "هل",
                                            "متى",
                                            "اين",
                                            "كيف",
                                            "بكم",
                                            "افتح",
                                            "ممكن",
                                            "طيب",
                                            "السلام",
                                            "اعطني",
                                            "انا",
                                            "لماذا",
                                          ];
                                          deleteColor = true;
                                        });
                                        Future.delayed(
                                                const Duration(seconds: 1))
                                            .then((value) {
                                          setState(() {
                                            deleteColor = false;
                                          });
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.delete_outline,
                                            color: deleteColor
                                                ? Colors.red
                                                : Colors.black,
                                            size: size == 0 ? 40 : 35,
                                          ),
                                          Text(
                                            "مسح",
                                            style: TextStyle(
                                                fontSize: DeviceUtil.isTablet
                                                    ? 22
                                                    : size == 0
                                                        ? 19
                                                        : 17),
                                          )
                                        ],
                                      ),
                                    ),
                                    //.................................
                                    InkWell(
                                      onTap: () {
                                        setState(() {
                                          shareColor = true;
                                        });
                                        if (_fieldcontroller.text.isNotEmpty) {
                                          if (DeviceUtil.isTablet) {
                                            final Rect sharePositionOrigin =
                                                const Offset(0, 0) &
                                                    const Size(165, 720);

                                            Share.share(_fieldcontroller.text,
                                                sharePositionOrigin:
                                                    sharePositionOrigin);
                                          } else {
                                            Share.share(_fieldcontroller.text);
                                          }
                                        } else {
                                          erroralert(context,
                                              "لا يمكن مشاركة حقل فارغ");
                                        }
                                        Future.delayed(
                                                const Duration(seconds: 1))
                                            .then((value) {
                                          setState(() {
                                            shareColor = false;
                                          });
                                        });
                                      },
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.ios_share_rounded,
                                            color: shareColor
                                                ? Colors.red
                                                : Colors.black,
                                            size: size == 0 ? 38 : 35,
                                          ),
                                          Text(
                                            "مشاركة",
                                            style: TextStyle(
                                                fontSize: DeviceUtil.isTablet
                                                    ? 22
                                                    : size == 0
                                                        ? 19
                                                        : 17),
                                          )
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          Align(
                            alignment: Alignment.topLeft,
                            child: Padding(
                              padding: const EdgeInsets.only(left: 15, top: 10),
                              child: InkWell(
                                //Fav button
                                onTap: () async {
                                  if (_fieldcontroller.text.trim().isNotEmpty) {
                                    SharedPreferences favlist =
                                        await SharedPreferences.getInstance();
                                    if (!fav.contains(
                                        _fieldcontroller.text.trim())) {
                                      setState(() {
                                        fav.add(_fieldcontroller.text.trim());
                                        pressed = true;
                                      });
                                      List<String> favl = [];
                                      String input =
                                          _fieldcontroller.text.trim();
                                      var temp =
                                          favlist.getStringList("favlist");
                                      if (temp == null) {
                                        favl = [
                                          """["$input","","yes","","","yes"]"""
                                        ];
                                      } else {
                                        favl = temp;
                                        favl.add(
                                            """["$input","","yes","","","yes"]""");
                                      }
                                      favlist.setStringList("favlist", favl);
                                    } else {
                                      fav.remove(_fieldcontroller.text.trim());
                                      setState(() {
                                        pressed = false;
                                      });
                                      List<String> v = [];
                                      for (String element in fav) {
                                        String n = element.trim();
                                        String y = "yes";
                                        String i = "";
                                        v.add("""[
                                                      "$n",
                                                      "$i",
                                                      "$y",
                                                      "$i",
                                                      "$i",
                                                      "$y"
                                                    ]""");
                                      }
                                      favlist.setStringList('favlist', v);
                                    }
                                  } else {
                                    erroralert(context,
                                        "يرجى ملئ الحقل للاضافة الى المفضلة");
                                  }
                                },

                                child: pressed
                                    ? Icon(
                                        Icons.star,
                                        color: maincolor,
                                        size: DeviceUtil.isTablet
                                            ? 45
                                            : size == 0
                                                ? 40
                                                : 33,
                                      )
                                    : Icon(
                                        Icons.star_outline_rounded,
                                        size: DeviceUtil.isTablet
                                            ? 45
                                            : size == 0
                                                ? 44
                                                : 37,
                                      ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    MediaQuery.of(context).orientation == Orientation.portrait
                        ? SizedBox(
                            height: size == 0 ? 10 : 20,
                          )
                        : Container(),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: size == 0 ? 30 : 40, vertical: 10),
                      child: SizedBox(
                        height: MediaQuery.of(context).size.height * .5,
                        width: double.infinity,
                        child: GridView.builder(
                            itemCount: displayedWords.length > 12
                                ? 12
                                : displayedWords.length,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                                    crossAxisCount:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? DeviceUtil.isTablet
                                                ? size == 0
                                                    ? 4
                                                    : 5
                                                : 3
                                            : DeviceUtil.isTablet && size == 1
                                                ? 7
                                                : 6,
                                    crossAxisSpacing:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? size == 0
                                                ? 5
                                                : 10
                                            : 10,
                                    mainAxisSpacing:
                                        MediaQuery.of(context).orientation ==
                                                Orientation.portrait
                                            ? 15
                                            : 10,
                                    childAspectRatio:
                                        size == 0 ? 2 / 1.2 : 2 / 1.1),
                            itemBuilder: ((context, index) {
                              return InkWell(
                                onTap: () {
                                  int numOfChar = _fieldcontroller.text.length +
                                      displayedWords[index].length;
                                  if (numOfChar > 500) {
                                    noteAlert(context,
                                        "لا يمكنك نطق جملة تحتوي أكثر من 500 حرف");
                                  } else {
                                    if (isWordByWord) {
                                      setState(() {
                                        speakColor = true;
                                      });

                                      howtospeak(displayedWords[index]);
                                      Future.delayed(const Duration(seconds: 2))
                                          .then((value) {
                                        setState(() {
                                          speakColor = false;
                                        });
                                      });
                                    }
                                    List<String> words =
                                        _fieldcontroller.text.split(" ");

                                    if (autoComp) {
                                      words[words.length - 1] =
                                          displayedWords[index];
                                      _fieldcontroller.text =
                                          "${words.join(" ")} ";
                                      autoComp = false;
                                      setState(() {});
                                    } else {
                                      enteredWords.add(displayedWords[index]);
                                      _fieldcontroller.text =
                                          '${_fieldcontroller.text.trim()} ${displayedWords[index]} ';
                                    }
                                    _fieldcontroller.selection =
                                        TextSelection.fromPosition(TextPosition(
                                            offset:
                                                _fieldcontroller.text.length));
                                    List<String> word =
                                        _fieldcontroller.text.trim().split(" ");

                                    predict(word);
                                    if (fav.contains(
                                        _fieldcontroller.text.trim())) {
                                      setState(() {
                                        pressed = true;
                                        notextyet = false;
                                      });
                                    } else {
                                      setState(() {
                                        pressed = false;
                                        notextyet = false;
                                      });
                                    }
                                  }
                                },
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      borderRadius: BorderRadius.circular(20),
                                      border: Border.all(
                                          color: maincolor, width: 1.5)),
                                  child: FittedBox(
                                    child: Center(
                                        child: Text(
                                      " ${displayedWords[index]} ",
                                      style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20),
                                    )),
                                  ),
                                ),
                              );
                            })),
                      ),
                    ),
                  ],
                ),
              ),
      ),
    );
  }

  auto_complete(String text) async {
    int counter = 0;
    path = await rootBundle.loadString("assets/predictionFiles/oneWord.txt");
    List<String> Local_result = LocalDB;
    for (String s in Local_result) {
      List<String> word = s.trim().split(" ");
      for (int i = 0; i < word.length; i++) {
        if (text.isNotEmpty && word[i].length >= text.length && counter < 4) {
          if (word[i].length >= text.length) {
            if ((word[i].substring(0, text.length)).compareTo(text) == 0 &&
                !displayedWords.contains(word[i])) {
              displayedWords.add(word[i]);
              counter++;
              setState(() {});
            }
          }
        }
      }
    }
    List<String> result = path.split('\n');

    for (String r in result) {
      if (text.isNotEmpty && r.length >= text.length && counter < 12) {
        if ((r.substring(0, text.length)).compareTo(text) == 0 &&
            !displayedWords.contains(r)) {
          displayedWords.add(r);
          counter++;
          setState(() {});
        }
      }
    }
  }

  predict(List<String> sentence) {
    String s = sentence.join(" ");
    s = s.replaceAll("أ", "ا").replaceAll("إ", "ا").replaceAll("ة", "ه");
    sentence = s.split(" ");
    if (sentence.length == 1) {
      displayedWords.clear();
      second_word_Local(sentence[0], 0);
    } else if (sentence.length == 2) {
      displayedWords.clear();
      third_word_Local(sentence, 0);
    } else {
      displayedWords.clear();
      List sent = sentence.sublist(sentence.length - 3, sentence.length);

      fourth_word_Local(sent, 0);
    }
    if (fav.contains(_fieldcontroller.text.trim())) {
      setState(() {
        pressed = true;
      });
    } else {
      setState(() {
        pressed = false;
      });
    }
  }

  fourth_word_Local(List text, int counter) async {
    List<String> result = LocalDB;
    for (String r in result) {
      if (counter < 12) {
        List<String> s = r
            .replaceAll("أ", "ا")
            .replaceAll("إ", "ا")
            .replaceAll("ة", "ه")
            .split(" ");

        List<String> sf = r.split(" ");
        for (int i = 0; i < s.length; i++) {
          if (s[i] == text[1]) {
            if (s.length - i >= 3 &&
                s[i + 1].trim() == text[2] &&
                enteredWords[enteredWords.length - 1] != s[i + 2] &&
                !search_in_predictionWords(s[i + 2])) {
              counter++;

              enteredWords.add(sf[i + 2]);
              displayedWords.add(sf[i + 2]);
            }
          }
        }
      } else {
        break;
      }
    }
    setState(() {});
    if (counter < 12) {
      fourth_word_child(text, counter);
    } else {
      return counter;
    }
  }

  fourth_word_child(List text, int counter) async {
    String path =
        await rootBundle.loadString("assets/predictionFiles/4gram.txt");
    List<String> result = path.split('\n');
    for (String r in result) {
      if (counter < 12) {
        List<String> s = r
            .replaceAll("أ", "ا")
            .replaceAll("إ", "ا")
            .replaceAll("ة", "ه")
            .split(" ");
        List<String> sf = r.split(" ");
        if (s[1].compareTo(text[1]) == 0 &&
            s[2].compareTo(text[2]) == 0 &&
            s[3] != enteredWords[enteredWords.length - 1] &&
            !search_in_predictionWords(s[3])) {
          counter++;
          displayedWords.add(sf[3]);
        }
      } else {
        break;
      }
    }
    setState(() {});

    if (counter < 12) {
      third_word_Local(text.sublist(1, text.length), counter);
    } else {
      return counter;
    }
  }

  third_word_Local(List text, int counter) async {
    for (String r in LocalDB) {
      if (counter < 12) {
        List<String> s = r
            .replaceAll("أ", "ا")
            .replaceAll("إ", "ا")
            .replaceAll("ة", "ه")
            .split(" ");
        List<String> sf = r.split(" ");
        for (int i = 0; i < s.length; i++) {
          if (s[i] == text[0]) {
            if (s.length - i >= 3 &&
                s[i + 1].trim() == text[1].trim() &&
                s[i + 2].trim() != enteredWords[enteredWords.length - 1] &&
                !search_in_predictionWords(s[i + 2])) {
              counter++;
              displayedWords.add(sf[i + 2]);
            }
          }
        }
      } else {
        break;
      }
    }
    setState(() {});
    if (counter < 12) {
      return third_word_child(text, counter);
    }
    return counter;
  }

  third_word_child(List text, int counter) async {
    String path =
        await rootBundle.loadString("assets/predictionFiles/trigramData.txt");
    List<String> result = path.split('\n');
    for (String r in result) {
      if (counter < 12) {
        List<String> s = r
            .replaceAll("أ", "ا")
            .replaceAll("إ", "ا")
            .replaceAll("ة", "ه")
            .split(" ");
        List<String> sf = r.split(" ");
        if (s[0] == text[0] &&
            s[1] == text[1] &&
            s[2] != enteredWords[enteredWords.length - 1] &&
            !search_in_predictionWords(s[2])) {
          counter++;
          displayedWords.add(sf[2]);
        }
      } else {
        break;
      }
    }
    setState(() {});

    if (counter < 12) {
      second_word_Local(text[1], counter);
    } else {
      return counter;
    }
  }

  second_word_Local(String text, int counter) async {
    List<String> result = LocalDB;
    for (String r in result) {
      if (counter < 12) {
        List<String> s = r
            .replaceAll("أ", "ا")
            .replaceAll("إ", "ا")
            .replaceAll("ة", "ه")
            .split(" ");
        List<String> sf = r.split(" ");

        for (int i = 0; i < s.length; i++) {
          if (s[i] == text) {
            if (s.length - i >= 2 &&
                !enteredWords.contains(sf[i + 1]) &&
                !search_in_predictionWords(s[1])) {
              counter++;
              enteredWords.add(text);
              displayedWords.add(sf[i + 1]);
            }
          }
        }
      } else {
        break;
      }
    }
    setState(() {});
    if (counter < 12) {
      return second_word_child(text, counter);
    }
  }

  second_word_child(String text, int counter) async {
    path = await rootBundle.loadString("assets/predictionFiles/bigramData.txt");
    List<String> result = path.split('\n');

    for (String r in result) {
      if (counter < 12) {
        List<String> s = r
            .replaceAll("أ", "ا")
            .replaceAll("إ", "ا")
            .replaceAll("ة", "ه")
            .split(" ");
        List<String> sf = r.split(" ");

        if (s[0] == text &&
            !enteredWords.contains(s[1]) &&
            !search_in_predictionWords(s[1])) {
          counter++;
          displayedWords.add(s[1]);
        }
      } else {
        break;
      }
    }
    setState(() {});
    if (counter < 12) {
      return one_word_child(counter);
    }
    return counter;
  }

  one_word_child(int counter) async {
    List wordsP = [
      "طيب",
      "تمام",
      "لا",
      "شكرا",
      "أنا",
      "هل",
      "كم",
      "هذا",
      "نعم",
      "أبغى",
      "كيف",
      "ممكن",
      "السلام",
      "اهلا",
      "مرحبا",
      "متى",
      "هذا",
      "مرحبا",
    ];
    for (int i = 0; i < wordsP.length; i++) {
      if (displayedWords.length < 12 && !search_in_predictionWords(wordsP[i])) {
        displayedWords.add(wordsP[i]);
      }
    }

    setState(() {});
  }

  search_in_predictionWords(String word) {
    for (int i = 0; i < displayedWords.length; i++) {
      if (displayedWords[i]
              .replaceAll("أ", "ا")
              .replaceAll("إ", "ا")
              .replaceAll("ة", "ه")
              .trim() ==
          word
              .replaceAll("أ", "ا")
              .replaceAll("إ", "ا")
              .replaceAll("ة", "ه")
              .trim()) {
        return true;
      }
    }
    return false;
  }
}

// ignore_for_file: empty_catches, use_build_context_synchronously

import 'dart:convert';
import 'dart:io';
import 'package:provider/provider.dart';

import '../../controller/my_provider.dart';
import '/controller/checkinternet.dart';
import '/controller/erroralert.dart';
import '/controller/var.dart';
import '/model/library.dart';
import '/view/library/iconsgroup.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../controller/button.dart';
import '../../controller/libtostring.dart';
import '../../model/content.dart';
import '../mainscreen.dart';

// ignore: must_be_immutable
class EditLibrary extends StatefulWidget {
  String librarayName;
  String imgpath;
  int libIndex;

  EditLibrary(
      {Key? key,
      required this.librarayName,
      required this.imgpath,
      required this.libIndex})
      : super(key: key);

  @override
  State<EditLibrary> createState() => _EditLibraryState();
}

class _EditLibraryState extends State<EditLibrary> {
  bool isLoading = true;
  bool hasInternet = false;
  bool errorsen = false;
  TextEditingController libraryname = TextEditingController();
  @override
  void initState() {
    super.initState();
    libraryname.text = widget.librarayName;
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyProvider>(context, listen: false).setPath(widget.imgpath);
    });

    internetConnection().then((value) {
      hasInternet = value;
      setState(() {
        isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: maincolor,
        ),
        body: isLoading
            ? Center(
                child: CircularProgressIndicator(color: maincolor),
              )
            : ListView(
                children: [
                  const Padding(
                    padding: EdgeInsets.all(20.0),
                    child: Text(
                      "انشاء مكتبة",
                      style: TextStyle(fontSize: 31),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 80.0,
                          child: Text(
                            "اسم المكتبة:",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Expanded(
                          child: TextFormField(
                            controller: libraryname,
                            maxLines: 1,
                            autofocus: true,
                            decoration: InputDecoration(
                              border: OutlineInputBorder(
                                borderSide: BorderSide(color: maincolor),
                                borderRadius: const BorderRadius.all(
                                  Radius.circular(13.0),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(17.0),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(
                          width: 80.0,
                          child: Text(
                            "ارفاق صورة:",
                            style: TextStyle(fontSize: 17),
                          ),
                        ),
                        Provider.of<MyProvider>(context)
                                    .lastimagepath
                                    .toString()
                                    .isNotEmpty &&
                                (hasInternet ||
                                    Provider.of<MyProvider>(context)
                                        .lastimagepath
                                        .toString()
                                        .contains("assets/"))
                            ? InkWell(
                                onTap: () => diag(),
                                child: Container(
                                    height: 120,
                                    width: 120,
                                    decoration: Provider.of<MyProvider>(context)
                                            .lastimagepath
                                            .toString()
                                            .contains("assets/")
                                        ? BoxDecoration(
                                            border: Border.all(
                                                color: maincolor, width: 1.5),
                                            borderRadius:
                                                BorderRadius.circular(15),
                                            image: DecorationImage(
                                                image: AssetImage(Provider.of<MyProvider>(context)
                                                    .lastimagepath
                                                    .toString()),
                                                fit: BoxFit.fill))
                                        : Provider.of<MyProvider>(context)
                                                .lastimagepath
                                                .toString()
                                                .contains(
                                                    "https://firebasestorage.googleapis.com")
                                            ? BoxDecoration(
                                                border: Border.all(
                                                    color: maincolor,
                                                    width: 1.5),
                                                borderRadius:
                                                    BorderRadius.circular(15),
                                                image: DecorationImage(
                                                    image: NetworkImage(Provider.of<MyProvider>(context).lastimagepath.toString()),
                                                    fit: BoxFit.fill))
                                            : BoxDecoration(border: Border.all(color: maincolor, width: 2), borderRadius: BorderRadius.circular(15), image: DecorationImage(image: FileImage(File(Provider.of<MyProvider>(context).lastimagepath.toString())), fit: BoxFit.fill))),
                              )
                            : Provider.of<MyProvider>(context)
                                        .lastimagepath
                                        .toString()
                                        .isEmpty ||
                                    !hasInternet
                                ? InkWell(
                                    onTap: () => diag(),
                                    child: Container(
                                      height: 120,
                                      width: 120,
                                      decoration: BoxDecoration(
                                          color: Colors.grey.withOpacity(.4)),
                                      child: const Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons.camera),
                                          Text(
                                            "ارفاق صورة:",
                                          ),
                                        ],
                                      ),
                                    ),
                                  )
                                : Container()
                      ],
                    ),
                  ),
                  errorsen
                      ? const Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text("يجب وضع اسم للمكتبة",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 20)),
                          ],
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
                            if (libraryname.text.isNotEmpty) {
                              SharedPreferences liblist =
                                  await SharedPreferences.getInstance();
                              List<String> lb =
                                  liblist.getStringList("liblist") ?? [];
                              List e = json.decode(lb[widget.libIndex]);
                              List<Content> contentlist = [];
                              for (List l in e[3]) {
                                contentlist.add(Content(
                                    l[0], l[1], l[2], l[3], l[4], l[5]));
                              }
                              if (Provider.of<MyProvider>(context,
                                          listen: false)
                                      .lastimagepath
                                      .toString() ==
                                  widget.imgpath) {
                                lb[widget.libIndex] = convertLibString(lib(
                                    libraryname.text, e[1], e[2], contentlist));
                              } else if (Provider.of<MyProvider>(context,
                                          listen: false)
                                      .lastimagepath
                                      .toString()
                                      .isEmpty ||
                                  Provider.of<MyProvider>(context,
                                          listen: false)
                                      .lastimagepath
                                      .toString()
                                      .contains("assets/")) {
                                lb[widget.libIndex] = convertLibString(lib(
                                    libraryname.text,
                                    Provider.of<MyProvider>(context,
                                            listen: false)
                                        .lastimagepath
                                        .toString(),
                                    "yes",
                                    contentlist));
                              } else {
                                lb[widget.libIndex] = convertLibString(lib(
                                    libraryname.text,
                                    Provider.of<MyProvider>(context,
                                            listen: false)
                                        .lastimagepath
                                        .toString(),
                                    "no",
                                    contentlist));
                              }

                              liblist
                                  .setStringList("liblist", lb)
                                  .then((value) {
                                Navigator.pushAndRemoveUntil(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            const MainScreen(navindex: 1)),
                                    (route) => false);
                                Provider.of<MyProvider>(context, listen: false)
                                    .setPath("");
                                acceptalert(context, "تم تعديل المكتبة بنجاح");
                              });
                            } else {
                              setState(() {
                                errorsen = true;
                              });

                              //erroralert(context, "عليك وضع اسم للمكتبة");
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
                  )
                ],
              ),
      ),
    );
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
            ],
          );
        });
  }
}

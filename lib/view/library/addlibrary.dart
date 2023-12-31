// ignore_for_file: empty_catches, use_build_context_synchronously

import 'dart:io';
import 'package:provider/provider.dart';

import '../../controller/my_provider.dart';
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
import '../mainscreen.dart';

class AddLibrary extends StatefulWidget {
  const AddLibrary({Key? key}) : super(key: key);

  @override
  State<AddLibrary> createState() => _AddLibraryState();
}

class _AddLibraryState extends State<AddLibrary> {
  TextEditingController libraryname = TextEditingController();
  bool errorsen = false;
  @override
  void initState() {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      Provider.of<MyProvider>(context, listen: false).setPath("");
    });
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
            "إنشاء مكتبة",
            style: TextStyle(fontSize: 31, color: Colors.white),
            textAlign: TextAlign.center,
          ),
        ),
        body: ListView(
          children: [
            // Padding(
            //   padding: const EdgeInsets.only(top: 10),
            //   child: Text(
            //     "إنشاء مكتبة",
            //     style: TextStyle(fontSize: 31),
            //     textAlign: TextAlign.center,
            //   ),
            // ),
            const SizedBox(
              height: 20,
            ),

            ///....................................
            const Padding(
              padding: EdgeInsets.only(right: 21),
              child: Row(
                children: [
                  Text(
                    "اسم المكتبة:",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),

            ///....................................

            Padding(
              padding: const EdgeInsets.all(17.0),
              child: Row(
                children: [
                  /* const SizedBox(
                    width: 80.0,
                    child: Text(
                      "اسم المكتبة:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )*/
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
            errorsen
                ? const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("يجب وضع اسم للمكتبة",
                          style: TextStyle(color: Colors.red, fontSize: 20)),
                    ],
                  )
                : const SizedBox(),

            Padding(
              padding: const EdgeInsets.only(right: 21, bottom: 36), //all(17.0)
              child: Row(
                children: <Widget>[
                  const SizedBox(
                    width: 111.0,
                    child: Text(
                      "إرفاق صورة:",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Provider.of<MyProvider>(context)
                          .lastimagepath
                          .toString()
                          .isNotEmpty
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
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image: AssetImage(
                                              Provider.of<MyProvider>(context)
                                                  .lastimagepath
                                                  .toString()),
                                          fit: BoxFit.fill))
                                  : BoxDecoration(
                                      border: Border.all(
                                          color: maincolor, width: 2),
                                      borderRadius: BorderRadius.circular(15),
                                      image: DecorationImage(
                                          image:
                                              FileImage(File(Provider.of<MyProvider>(context).lastimagepath.toString())),
                                          fit: BoxFit.fill))),
                        )
                      : Container(),
                  Provider.of<MyProvider>(context)
                          .lastimagepath
                          .toString()
                          .isEmpty
                      ? InkWell(
                          onTap: () => diag(),
                          child: Container(
                            height: 120,
                            width: 120,
                            decoration: BoxDecoration(
                                color: Colors
                                    .white // Color.fromARGB(255, 121, 161, 134)
                                    .withOpacity(.4)),
                            child: const Padding(
                              padding:
                                  EdgeInsets.only(right: 25), //only(right: 25),
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment
                                    .start, //crossAxisAlignment: CrossAxisAlignment.start
                                children: [
                                  Icon(
                                    Icons.camera,
                                    size: 33, //size: 33,
                                  ),
                                  //  Text( "إرفاق صورة:", ),
                                ],
                              ),
                            ),
                          ),
                        )
                      : Container()
                ],
              ),
            ),

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
                        if (Provider.of<MyProvider>(context, listen: false)
                                .lastimagepath
                                .toString()
                                .isEmpty ||
                            Provider.of<MyProvider>(context, listen: false)
                                .lastimagepath
                                .toString()
                                .contains("assets/")) {
                          lb.add(convertLibString(lib(
                              libraryname.text,
                              Provider.of<MyProvider>(context, listen: false)
                                  .lastimagepath
                                  .toString(),
                              "yes",
                              [])));
                        } else {
                          lb.add(convertLibString(lib(
                              libraryname.text,
                              Provider.of<MyProvider>(context, listen: false)
                                  .lastimagepath
                                  .toString(),
                              "no",
                              [])));
                        }
                        liblist.setStringList("liblist", lb).then((value) {
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const MainScreen(navindex: 1)),
                              (route) => false);
                          Provider.of<MyProvider>(context, listen: false)
                              .setPath("");
                          acceptalert(context, "تم إضافة المكتبة بنجاح");
                        });
                      } else {
                        setState(() {
                          errorsen = true;
                        });
                      }
                    }, 'حفظ'),
                  ),
                  /*   SizedBox(
                    height: 65,
                    width: 110,
                    child: button(() {
                      Navigator.pop(context);
                    }, 'الغاء'),
                  ),*/
                  ///....................................
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

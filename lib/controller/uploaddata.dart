import 'dart:io';

import '/controller/allUploadedDone.dart';
import '/controller/libtostring.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../model/content.dart';
import '../model/library.dart';

List<lib> libraryListUpload = [];

tryUploadData() async {
  libraryListUpload = libraryList;
  try {
    allUploadedDone().then((v) async {
      if (v == true) {
        List<String> finalFavToStore = [];
        SharedPreferences liblist = await SharedPreferences.getInstance();
        List<String> data = liblist.getStringList("liblist") ?? [];
        List<String> datafav = liblist.getStringList("favlist") ?? [];
        for (var element in datafav) {
          if (!element.contains(',"no"')) {
            finalFavToStore.add(element);
          }
        }
        FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .set({"library list": data, "favlist": finalFavToStore},
                SetOptions(merge: true));
      } else {
        uploadToStorage().then((v) async {
          SharedPreferences liblist = await SharedPreferences.getInstance();
          List<String> data = liblist.getStringList("liblist") ?? [];
          List<String> datafav = liblist.getStringList("favlist") ?? [];
          FirebaseFirestore.instance
              .collection("users")
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .set({"library list": data, "favlist": datafav},
                  SetOptions(merge: true));
        });
      }
    });
  } catch (_) {}
}

Future uploadToStorage() async {
  for (lib element in libraryListUpload) {
    if (element.isImageUpload == "no") {
      Reference reference =
          FirebaseStorage.instance.ref().child(element.imgurl);
      UploadTask uploadTask =
          reference.putData(File(element.imgurl).readAsBytesSync());
      await uploadTask.whenComplete(() {
        reference.getDownloadURL().then((value) {
          element.imgurl = value;
          element.isImageUpload = "yes";
          updateSharedPreferencesUpload();
        });
      });
    }
    for (Content content in element.contenlist) {
      if (content.isImageUpload == "no") {
        Reference reference =
            FirebaseStorage.instance.ref().child(content.imgurl);
        UploadTask uploadTask =
            reference.putData(File(content.imgurl).readAsBytesSync());
        await uploadTask.whenComplete(() {
          reference.getDownloadURL().then((value2) {
            content.isImageUpload = "yes";
            content.imgurl = value2;
            updateSharedPreferencesUpload();
          });
        });
      }
      if (content.isVoiceUpload == "no") {
        Reference reference =
            FirebaseStorage.instance.ref().child(content.opvoice);
        UploadTask uploadTask =
            reference.putData(File(content.opvoice).readAsBytesSync());
        await uploadTask.whenComplete(() {
          reference.getDownloadURL().then((value3) {
            content.opvoice = value3;
            content.isVoiceUpload = "yes";
            updateSharedPreferencesUpload();
          });
        });
      }
    }
  }
}

Future updateSharedPreferencesUpload() async {
  SharedPreferences liblist = await SharedPreferences.getInstance();
  List<String> v = [];
  for (lib l in libraryListUpload) {
    String s = convertLibString(l);
    v.add(s);
  }
  liblist.setStringList("liblist", v);
}

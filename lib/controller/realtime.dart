// ignore_for_file: avoid_function_literals_in_foreach_calls

import 'package:arabicspeaker/controller/checkinternet.dart';
import 'package:arabicspeaker/controller/specialid.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:shared_preferences/shared_preferences.dart';

tryUploadToRealTime(String text) {
  try {
    String d = getSpecialid();
    String uid = FirebaseAuth.instance.currentUser?.uid ?? "";
    internetConnection().then((value) async {
      if (value == true) {
        DatabaseReference ref = FirebaseDatabase.instance.ref("data/");
        SharedPreferences pref2 = await SharedPreferences.getInstance();
        List<String> dataCache = pref2.getStringList("realtime") ?? [];

        for (var element in dataCache) {
          String s = getSpecialid();

          await ref.update({"$uid::$s": element});
        }

        await ref.update({"$uid::$d": text});
        pref2.setStringList("realtime", []);
      } else {
        SharedPreferences pref = await SharedPreferences.getInstance();
        List<String> data = pref.getStringList("realtime") ?? [];
        data.add(text);
        pref.setStringList("realtime", data);
      }
    });
  } catch (_) {}
}

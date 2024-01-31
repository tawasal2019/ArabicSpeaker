// ignore_for_file: use_build_context_synchronously

import 'package:arabicspeaker/controller/my_provider.dart';
import 'package:arabicspeaker/view/Auth/login.dart';
import 'package:arabicspeaker/view/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'Services/NotificationIcon.dart';
import 'controller/sharedpref.dart';

bool isWordByWord = true;
late XFile f;
Future main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    const MyApp(),
  );
}

final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool loading = true;
  //bool isverifyEmail = true;
  late bool signOrLogIn;
  @override
  void initState() {
    getIsSignUpOrLogin().then((v) {
      signOrLogIn = v;
      /*    if (signOrLogIn) {
        isverifyEmail = FirebaseAuth.instance.currentUser!.emailVerified;
      }
    if (isverifyEmail == false && signOrLogIn) {
        notverifyEmailYet();
      }*/
      setState(() {
        loading = false;
      });
    });
    PushNotificationsManager().init();
    super.initState();
  }

/*
  notverifyEmailYet() async {
    final FirebaseAuth _auth = FirebaseAuth.instance;
    User? user = _auth.currentUser;
    if (user != null) {
      try {
        await user.delete();
      } catch (_) {}
    }
    _auth.signOut();

    SharedPreferences getSignUpOrLogin = await SharedPreferences.getInstance();

    getSignUpOrLogin.setBool("getSignUpOrLogin", false);
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const Signup()),
        (route) => false);
  }
*/
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => MyProvider(),
        child: MaterialApp(
          navigatorKey: navigatorKey,
          debugShowCheckedModeBanner: false,
          title: 'المتحدث العربي',
          theme: ThemeData(
            primarySwatch: Colors.grey,
          ),
          home:
          ( FirebaseAuth.instance.currentUser!=null)&&(FirebaseAuth.instance.currentUser!.emailVerified)
              ?  const MainScreen(navindex: 0)
              : const Login(),

          /* loading
              ? const Scaffold(
                  body: Center(child: CircularProgressIndicator()),
                )
              : signOrLogIn == false
                  ? const Login()
                  : const MainScreen(navindex: 0),*/

        )
    );
  }
}

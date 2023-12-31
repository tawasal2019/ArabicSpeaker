/*import 'dart:async';
//import 'package:email_auth/utils/constants/firebase_constants.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';*/
import 'dart:async';

import 'package:arabicspeaker/view/Auth/signup.dart';
import 'package:arabicspeaker/view/mainscreen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool isEmailVerified = false;
  bool  isSend = false;
  Timer? timer;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    FirebaseAuth.instance.currentUser?.sendEmailVerification();
    timer =
        Timer.periodic(const Duration(seconds: 3), (_) => checkEmailVerified());
  }

  checkEmailVerified() async {
    await FirebaseAuth.instance.currentUser?.reload();

    setState(() {
      isEmailVerified = FirebaseAuth.instance.currentUser!.emailVerified;
    });

    if (isEmailVerified) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
              builder: (context) => const MainScreen(navindex: 0)));

     /* ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("Email Successfully Verified")));*/

      timer?.cancel();
    }
  }

  @override
  void dispose() {
    // TODO: implement dispose
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        body:AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(child: Text('التحقق من الايميل')),
          content: Container(
            width: 300,
            height: 100,
            child: Column(

              children: [
                Text(
                  'لقد قمنا بارسال رابط للتحقق من بريدك الالكتروني على ',
                  textAlign: TextAlign.center,
                ),
                Text(
                  ' ${FirebaseAuth.instance.currentUser!.email} ',
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          actions: <Widget>[
            Column(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xff339870),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11)),
                  ),
                  onPressed: () async {
                    final FirebaseAuth auth = FirebaseAuth.instance;
                    User? user = auth.currentUser;
                    if (user != null) {
                      try {
                        await user.delete();
                      } catch (_) {}
                    }
                    auth.signOut();

                    SharedPreferences getSignUpOrLogin =
                    await SharedPreferences.getInstance();

                    getSignUpOrLogin.setBool("getSignUpOrLogin", false);
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const Signup()),
                            (route) => false);

                  },
                  child: Center(
                      child: const Text("موافق",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 25,
                          ))),),

                TextButton(
                  onPressed: () async {

                    FirebaseAuth.instance.currentUser
                        ?.sendEmailVerification();
                    setState(() {
                      isSend = true;
                    });
                    Future.delayed(const Duration(milliseconds: 3850))
                        .then((value) {
                      setState(() {
                        isSend = false;
                      });
                    });

                  },
                  child: const Text(
                    //'التسجيل بايميل اخر',
                    'إعادة الارسال',

                    style: TextStyle(color: Colors.black),
                  ),
                ),

              ],
            )
          ],
        ),
        /* SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 35),
              const SizedBox(height: 30),
              const Center(
                child: Text(
                  'التحقق من الايميل',
                  textAlign: TextAlign.center,
                ),
              ),
              const SizedBox(height: 8),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(

                    'لقد قمنا بارسال رابط للتحقق من بريدك الالكتروني على ${FirebaseAuth.instance.currentUser?.email}',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              const SizedBox(height: 8),
              const Padding(
                padding: EdgeInsets
                    .symmetric(horizontal: 32.0),
                child: Center(
                  child: Text(
                    'التحقق من الايميل ...',
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
              const SizedBox(height: 57),
              Column(
                children: [

                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 50,
                      width: 170,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff339870),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11)),
                        ),
                        onPressed: () async {
                          FirebaseAuth.instance.currentUser
                              ?.sendEmailVerification();
                          setState(() {
                            isSend = true;
                          });
                          Future.delayed(const Duration(milliseconds: 3850))
                              .then((value) {
                            setState(() {
                              isSend = false;
                            });
                          });

                        },
                        child: Center(
                            child: const Text("إعادة الارسال",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ))),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: SizedBox(
                      height: 50,
                      width: 170,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xff339870),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(11)),
                        ),
                        onPressed: () async {
                          final FirebaseAuth auth = FirebaseAuth.instance;
                          User? user = auth.currentUser;
                          if (user != null) {
                            try {
                              await user.delete();
                            } catch (_) {}
                          }
                          auth.signOut();

                          SharedPreferences getSignUpOrLogin =
                          await SharedPreferences.getInstance();

                          getSignUpOrLogin.setBool("getSignUpOrLogin", false);
                          Navigator.pushAndRemoveUntil(
                              context,
                              MaterialPageRoute(builder: (context) => const Signup()),
                                  (route) => false);

                        },
                        child: Center(
                            child: const Text("موافق",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                ))),
                      ),
                    ),
                  ),

                ],
              )
              /* Padding(
                      padding: const EdgeInsets
                          .symmetric(horizontal: 32.0),
                      child: ElevatedButton(
                        child: const Text('اعادة ارسال'),
                        onPressed: () {
                          try {
                            FirebaseAuth.instance.currentUser
                                ?.sendEmailVerification();
                          } catch (e) {
                            debugPrint('$e');
                          }
                        },
                      ),
                    ),*/

                /*  Padding(
                    padding: const EdgeInsets
                        .symmetric(horizontal: 32.0),
                    child: ElevatedButton(
                      child: const Text('الغاء'),
                      onPressed: () {
                        try {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()));
                        } catch (e) {
                          debugPrint('$e');
                        }
                      },
                    ),
                  ),*/


            ],
          ),
        ),*/
      ),
    );
  }
}
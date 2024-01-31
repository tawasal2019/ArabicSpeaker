// ignore_for_file: use_build_context_synchronously

import 'package:arabicspeaker/view/Auth/verify_email.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/checkinternet.dart';
import '../../controller/setdataonlogin.dart';
import '/controller/validation.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'login.dart';

class Signup extends StatefulWidget {
  const Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _LoginState();
}

class _LoginState extends State<Signup> {
  bool loadingicon = false;
  final _formKey = GlobalKey<FormState>();
  final passFieldKey = GlobalKey();
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final TextEditingController _repasswordcontroller = TextEditingController();

  bool showPassConditions = false;
  bool hasCapitalLetter = false;
  bool hasSmallLetter = false;
  bool hasNumber = false;
  bool greaterThan8 = false;
  IconData iconHasNum = Icons.circle;
  Color iconColorHasNum = Colors.red;
  IconData iconHasCapi = Icons.circle;
  Color iconColorHasCapi = Colors.red;
  IconData iconHasSmall = Icons.circle;
  Color iconColorHasSmall = Colors.red;
  IconData iconGre = Icons.circle;
  Color iconColorGre = Colors.red;
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        // backgroundColor: Colors.white,

        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xff339870),
                  // borderRadius: const BorderRadius.only(
                  //   bottomRight: Radius.circular(30),
                  //   bottomLeft: Radius.circular(30),
                  // ),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 24, 117, 80),
                        Color.fromARGB(255, 3, 107, 138)
                      ])),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topRight,
                    child: InkWell(
                      onTap: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (BuildContext context) => const Login(),
                            ));
                      },
                      child: const Padding(
                        padding: EdgeInsets.only(top: 20, right: 11),
                        child: Icon(
                          Icons.arrow_back_ios,
                          color: Color.fromARGB(255, 255, 255, 255),
                          size: 45,
                        ),
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.account_circle,
                    color: Color.fromARGB(255, 255, 255, 255),
                    size: 80,
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 12),
                    child: Text(
                      "مستخدم جديد\n",
                      style: TextStyle(
                        fontSize: 37,
                        fontWeight: FontWeight.bold,
                        color: Color.fromARGB(255, 255, 255, 255),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 30),
                child: Column(children: [
                  TextFormField(
                    controller: _emailcontroller,
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    validator: (value) {
                      return validate(value, 'البريد الإلكتروني');
                    },
                    decoration: InputDecoration(
                      errorStyle:
                          const TextStyle(fontSize: 18, color: Colors.red),
                      filled: true,
                      fillColor: const Color.fromARGB(61, 194, 194, 194),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      labelText: 'البريد الإلكتروني',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 24, 117, 80),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    key: passFieldKey,
                    onTap: () {
                      Scrollable.ensureVisible(passFieldKey.currentContext!);
                      setState(() {
                        showPassConditions = true;
                      });
                    },
                    onEditingComplete: () {
                      setState(() {
                        showPassConditions = false;
                      });
                    },
                    onChanged: (value) {
                      updateColors(value);
                    },
                    validator: (value) {
                      return validate(value, 'كلمة المرور');
                    },
                    controller: _passwordcontroller,
                    obscureText: true,
                    decoration: InputDecoration(
                      filled: true,
                      errorStyle:
                          const TextStyle(fontSize: 18, color: Colors.red),
                      fillColor: const Color.fromARGB(61, 194, 194, 194),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      // hintText: 'كلمة المرور',
                      labelText: 'كلمة المرور',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 24, 117, 80),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  TextFormField(
                    controller: _repasswordcontroller,
                    obscureText: true,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return 'أدخل كلمة المرور';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      errorStyle:
                          const TextStyle(fontSize: 18, color: Colors.red),
                      filled: true,
                      fillColor: const Color.fromARGB(61, 194, 194, 194),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                      //hintText: 'إعادة كلمة المرور',
                      labelText: 'إعادة كلمة المرور',
                      labelStyle: const TextStyle(
                          color: Color.fromARGB(255, 24, 117, 80),
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  showPassConditions
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text(
                                  ' كلمة المرور يجب أن تحتوي على الأقل على:',
                                  style: TextStyle(
                                      color: Color(0xff076d7f),
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                  textDirection: TextDirection.rtl,
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      iconHasNum,
                                      size: 16,
                                      color: iconColorHasNum,
                                    ),
                                    Text(
                                      ' رقم',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: hasNumber
                                              ? Colors.green
                                              : const Color(0xff076d7f)),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      iconGre,
                                      size: 16,
                                      color: iconColorGre,
                                    ),
                                    Text(
                                      ' 8 خانات',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: greaterThan8
                                              ? Colors.green
                                              : const Color(0xff076d7f)),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      iconHasSmall,
                                      size: 16,
                                      color: iconColorHasSmall,
                                    ),
                                    Text(
                                      ' حرف صغير',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: hasSmallLetter
                                              ? Colors.green
                                              : const Color(0xff076d7f)),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Icon(
                                      iconHasCapi,
                                      size: 16,
                                      color: iconColorHasCapi,
                                    ),
                                    Text(
                                      ' حرف كبير',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 16,
                                          color: hasCapitalLetter
                                              ? Colors.green
                                              : const Color(0xff076d7f)),
                                      textDirection: TextDirection.rtl,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        )
                      : const SizedBox(),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 8.0),
                        child: SizedBox(
                          height: 50,
                          width: loadingicon ? 65 : 170,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff339870),
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(11)),
                            ),
                            onPressed: () async {
                              if (_passwordcontroller.text ==
                                  _repasswordcontroller.text) {
                                if (_formKey.currentState!.validate()) {
                                  try {
                                    setState(() {
                                      loadingicon = true;
                                    });
                                    await FirebaseAuth.instance
                                        .createUserWithEmailAndPassword(
                                            email: _emailcontroller.text.trim(),
                                            password:
                                                _passwordcontroller.text.trim())
                                        .then((value) async {
                                      SharedPreferences getSignUpOrLogin =
                                          await SharedPreferences.getInstance();
                                      getSignUpOrLogin.setBool(
                                          "getSignUpOrLogin", true);
                                      final userDoc = FirebaseFirestore.instance
                                          .collection('users')
                                          .doc(FirebaseAuth
                                              .instance.currentUser!.uid);
                                      try {
                                        internetConnection()
                                            .then((value) async {
                                          if (value == true) {
                                            setState(() {
                                              loadingicon = true;
                                            });
                                            await userDoc
                                                .get()
                                                .then((value) async {
                                              if (value.exists) {
                                                if (value.data() == null ||
                                                    value.data()!.isEmpty ||
                                                    value.data() == {}) {
                                                  SharedPreferences
                                                      getSignUpOrLogin =
                                                      await SharedPreferences
                                                          .getInstance();
                                                  getSignUpOrLogin.setBool(
                                                      "getSignUpOrLogin", true);
                                                } else {
                                                  setDataOnLogin(value.data())
                                                      .then((value) async {
                                                    SharedPreferences
                                                        getSignUpOrLogin =
                                                        await SharedPreferences
                                                            .getInstance();
                                                    getSignUpOrLogin.setBool(
                                                        "getSignUpOrLogin",
                                                        true);
                                                  });
                                                }
                                              } else {
                                                SharedPreferences
                                                    getSignUpOrLogin =
                                                    await SharedPreferences
                                                        .getInstance();
                                                getSignUpOrLogin.setBool(
                                                    "getSignUpOrLogin", true);
                                              }
                                              FirebaseAuth.instance.currentUser?.sendEmailVerification();

                                              showDialog(
                                                context: context,
                                                barrierDismissible:
                                                    false, // Prevent dismissing by tapping outside
                                                builder:
                                                    (BuildContext context) {
                                                  return const EmailVerificationScreen();
                                                },
                                              );
                                            });
                                          }
                                          else {
                                            ScaffoldMessenger.of(context)
                                                .showSnackBar(
                                              const SnackBar(
                                                content: Text(
                                                    "لا يوجد اتصال بالانترنت",
                                                    textAlign: TextAlign.right),
                                                duration: Duration(seconds: 2),
                                              ),
                                            );
                                          }
                                        });
                                      } catch (e) {
                                        setState(() {
                                          loadingicon = true;
                                        });
                                        ScaffoldMessenger.of(context)
                                            .showSnackBar(
                                          const SnackBar(
                                            content: Text(
                                                "حدث خطأ أعد المحاولة",
                                                textAlign: TextAlign.right),
                                            duration: Duration(seconds: 2),
                                          ),
                                        );
                                      }
                                    });
                                  } on FirebaseAuthException catch (e) {
                                    setState(() {
                                      loadingicon = false;
                                    });
                                    String message = e.code;
                                    switch (e.code) {
                                      case 'ERROR_EMAIL_ALREADY_IN_USE':
                                      case 'email-already-in-use':
                                        message =
                                            'البريد الإلكتروني المدخل مستخدم بالفعل';
                                        break;
                                      default:
                                        message =
                                            'فضلا تأكد من صحة بياناتك واتصالك بالإنترنت';
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(
                                        content: Text(message,
                                            textAlign: TextAlign.right),
                                        duration: const Duration(seconds: 2),
                                      ),
                                    );
                                  }
                                }
                              } else {
                                ScaffoldMessenger.of(context)
                                    .showSnackBar(const SnackBar(
                                  content:
                                      Text("كلمة السر المدخلة غير متطابقة"),
                                  duration: Duration(seconds: 2),
                                ));
                              }
                            },
                            child: Center(
                                child: loadingicon
                                    ? const CircularProgressIndicator()
                                    : const Text("تسجيل",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                        ))),
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    const Text(
                      'هل لديك حساب؟',
                      textDirection: TextDirection.rtl,
                      style: TextStyle(
                          fontSize: 22,
                          color: Color(0xff339870),
                          fontWeight: FontWeight.bold),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const Login()));
                      },
                      child: const Text(
                        'تسجيل دخول',
                        style: TextStyle(
                          decoration: TextDecoration.underline,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                          color: Color.fromARGB(255, 24, 117, 80),
                        ),
                      ),
                    ),
                  ]),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }

  void updateColors(String value) {
    if (value.contains(RegExp(r'[0-9]'))) {
      setState(() {
        hasNumber = true;
        iconHasNum = Icons.check_circle;
        iconColorHasNum = Colors.green;
      });
    }
    if (!value.contains(RegExp(r'[0-9]'))) {
      setState(() {
        hasNumber = false;
        iconHasNum = Icons.circle_rounded;
        iconColorHasNum = const Color(0xff076d7f);
      });
    }
    if (value.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        hasCapitalLetter = true;
        iconHasCapi = Icons.check_circle;
        iconColorHasCapi = Colors.green;
      });
    }
    if (!value.contains(RegExp(r'[A-Z]'))) {
      setState(() {
        hasCapitalLetter = false;
        iconHasCapi = Icons.circle_rounded;
        iconColorHasCapi = const Color(0xff076d7f);
      });
    }
    if (value.contains(RegExp(r'[a-z]'))) {
      setState(() {
        hasSmallLetter = true;
        iconHasSmall = Icons.check_circle;
        iconColorHasSmall = Colors.green;
      });
    }
    if (!value.contains(RegExp(r'[a-z]'))) {
      setState(() {
        hasSmallLetter = false;
        iconHasSmall = Icons.circle_rounded;
        iconColorHasSmall = const Color(0xff076d7f);
      });
    }
    if (value.length >= 8) {
      setState(() {
        greaterThan8 = true;
        iconGre = Icons.check_circle;
        iconColorGre = Colors.green;
      });
    }
    if (value.length < 8) {
      setState(() {
        greaterThan8 = false;
        iconGre = Icons.circle_rounded;
        iconColorGre = const Color(0xff076d7f);
      });
    }
  }
}

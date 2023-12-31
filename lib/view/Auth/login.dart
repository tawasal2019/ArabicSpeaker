// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names

import 'package:arabicspeaker/controller/checkinternet.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../controller/setdataonlogin.dart';
import '../mainscreen.dart';
import '/controller/var.dart';
import '/view/Auth/forgetpass.dart';
import '/view/Auth/signup.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../controller/validation.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);
  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  bool checkBoxValue = true;
  bool loadingicon = false;
  final TextEditingController _emailcontroller = TextEditingController();
  final TextEditingController _passwordcontroller = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _passwordVisible = true;
  bool EmptyPass = true;

  @override
  void initState() {
    getInfo();
    super.initState();
  }

  getInfo() async {
    SharedPreferences myLoginInfo = await SharedPreferences.getInstance();
    List<String> myInfo = myLoginInfo.getStringList("myLoginInfo") ?? [];
    if (myInfo.isNotEmpty) {
      _emailcontroller.text = myInfo[0];
      _passwordcontroller.text = myInfo[1];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          child: Column(children: [
            Container(
              decoration: const BoxDecoration(
                  color: Color(0xff339870),
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color.fromARGB(255, 24, 117, 80),
                        Color.fromARGB(255, 3, 107, 138)
                      ])),
              child: Column(
                children: [
                  ClipRRect(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        DrawerHeader(
                          decoration: BoxDecoration(
                            color: maincolor,
                            borderRadius: const BorderRadius.only(
                                bottomRight: Radius.circular(50),
                                bottomLeft: Radius.circular(50)),
                          ),
                          child: Image.asset(
                            "assets/logo.png",
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(top: 8),
                    child: Align(
                      child: Text(
                        "مرحبًا بك\n",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            color: Color.fromARGB(255, 255, 255, 255),
                            fontSize: 35,
                            fontWeight: FontWeight.bold),
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
                    validator: (value) {
                      return validate(value, 'البريد الإلكتروني');
                    },
                    autovalidateMode: AutovalidateMode.onUserInteraction,
                    decoration: InputDecoration(
                        errorStyle:
                            const TextStyle(fontSize: 18, color: Colors.red),
                        filled: true,
                        fillColor: const Color.fromARGB(61, 194, 194, 194),
                        labelText: "البريد الإلكتروني",
                        labelStyle: const TextStyle(
                            color: Color.fromARGB(255, 24, 117, 80),
                            fontSize: 20,
                            fontWeight: FontWeight.bold),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        )),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  TextFormField(
                    onTap: () {
                      setState(() {
                        EmptyPass = false;
                      });
                    },
                    controller: _passwordcontroller,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return ' أدخل كلمة المرور';
                      }
                      return null;
                    },
                    obscureText: _passwordVisible,
                    decoration: InputDecoration(
                      errorStyle:
                          const TextStyle(fontSize: 18, color: Colors.red),
                      suffixIcon: EmptyPass
                          ? const SizedBox(
                              width: 10,
                            )
                          : IconButton(
                              icon: Icon(
                                _passwordVisible
                                    ? Icons.visibility
                                    : Icons.visibility_off,
                                color: Theme.of(context).primaryColorDark,
                              ),
                              onPressed: () {
                                setState(() {
                                  _passwordVisible = !_passwordVisible;
                                });
                              },
                            ),
                      filled: true,
                      fillColor: const Color.fromARGB(61, 194, 194, 194),
                      labelText: "كلمة المرور",
                      labelStyle: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Color.fromARGB(255, 24, 117, 80),
                          fontSize: 20),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                  ),
                  Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Row(
                          children: [
                            Checkbox(
                                checkColor:
                                    const Color.fromARGB(255, 255, 255, 255),
                                fillColor: MaterialStateProperty.all(
                                    const Color(0xff339870)),
                                value: checkBoxValue,
                                onChanged: (v) {
                                  setState(() {
                                    checkBoxValue = v!;
                                  });
                                }),
                            const Text(
                              "تذكرني",
                              style: TextStyle(
                                fontSize: 18,
                                color: Color(0xff339870),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        TextButton(
                          onPressed: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        const Forgetpassword()));
                          },
                          child: const Text(
                            'نسيت كلمة المرور؟',
                            style: TextStyle(
                              decoration: TextDecoration.underline,
                              fontSize: 18,
                              color: Color(0xff339870),
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ]),
                  Padding(
                    padding: const EdgeInsets.only(top: 6.0),
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
                          if (_formKey.currentState!.validate()) {
                            try {
                              setState(() {
                                loadingicon = true;
                              });

                              await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: _emailcontroller.text.trim(),
                                      password: _passwordcontroller.text.trim())
                                  .then((value) async {
                                /////////////////
                                if (checkBoxValue) {
                                  SharedPreferences myLoginInfo =
                                      await SharedPreferences.getInstance();
                                  myLoginInfo.setStringList("myLoginInfo", [
                                    _emailcontroller.text,
                                    _passwordcontroller.text
                                  ]);
                                }
                                ///////////////////////
                                final userDoc = FirebaseFirestore.instance
                                    .collection('users')
                                    .doc(
                                        FirebaseAuth.instance.currentUser!.uid);
                                try {
                                  internetConnection().then((value) async {
                                    if (value == true) {
                                      setState(() {
                                        loadingicon = true;
                                      });
                                      await userDoc.get().then((value) async {
                                        if (value.exists) {
                                          if (value.data() == null ||
                                              value.data()!.isEmpty ||
                                              value.data() == {}) {
                                            SharedPreferences getSignUpOrLogin =
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
                                                  "getSignUpOrLogin", true);
                                            });
                                          }
                                        } else {
                                          SharedPreferences getSignUpOrLogin =
                                              await SharedPreferences
                                                  .getInstance();
                                          getSignUpOrLogin.setBool(
                                              "getSignUpOrLogin", true);
                                        }
                                        Navigator.pushReplacement(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    const MainScreen(
                                                        navindex: 0)));
                                      });
                                    } else {
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
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    const SnackBar(
                                      content: Text("حدث خطأ أعد المحاولة",
                                          textAlign: TextAlign.right),
                                      duration: Duration(seconds: 2),
                                    ),
                                  );
                                }
                                //////////////////////
                              });
                            } on FirebaseAuthException catch (e) {
                              setState(() {
                                loadingicon = false;
                              });
                              String message = e.code;
                              switch (e.code) {
                                case 'user-not-found':
                                  message =
                                      "البريد الإلكتروني المدخل غير مسجل سابقًا";
                                  break;
                                case 'invalid-email':
                                case 'wrong-password':
                                  message = 'فضلًا تأكد من صحة كلمة المرور';
                                  break;
                                case 'Error 17011':
                                case 'Error 17009':
                                  message =
                                      'فضلًا تأكد من صحة البريد الإلكتروني وكلمة المرور';
                                  break;
                                default:
                                  message =
                                      'فضلا تأكد من صحة بياناتك واتصالك بالإنترنت';
                              }
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content:
                                      Text(message, textAlign: TextAlign.right),
                                  duration: const Duration(seconds: 2),
                                ),
                              );
                            }
                          }
                        },
                        child: Center(
                          child: loadingicon
                              ? const CircularProgressIndicator()
                              : const Text(
                                  "تسجيل ",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 25,
                                  ),
                                ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 30,
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "لا يوجد لديك حساب؟",
                        style: TextStyle(
                            color: Color(0xff339870),
                            fontSize: 22,
                            fontWeight: FontWeight.bold),
                      ),
                      TextButton(
                        onPressed: () {
                          Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const Signup()));
                        },
                        child: const Text(
                          'التسجيل',
                          style: TextStyle(
                            decoration: TextDecoration.underline,
                            fontSize: 22,
                            color: Color.fromARGB(255, 24, 117, 80),
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                    ],
                  ),
                ]),
              ),
            ),
          ]),
        ),
      ),
    );
  }
}

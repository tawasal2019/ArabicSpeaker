// ignore_for_file: use_build_context_synchronously

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/erroralert.dart';
import '../../controller/validation.dart';
import '../../controller/var.dart';

class Forgetpassword extends StatefulWidget {
  const Forgetpassword({Key? key}) : super(key: key);

  @override
  State<Forgetpassword> createState() => _ForgetpasswordState();
}

class _ForgetpasswordState extends State<Forgetpassword> {
  bool isloading = false;
  final TextEditingController _emailcontroller = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Form(
          key: _formKey,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Align(
                alignment: Alignment.topRight,
                child: Padding(
                  padding:
                      const EdgeInsets.only(bottom: 160, top: 25, right: 8),
                  child: IconButton(
                    icon: const Icon(
                      Icons.arrow_back_ios,
                      size: 40,
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),
                ),
              ),
              const Text(
                "إعادة تعيين كلمة المرور",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 30,
                    fontWeight: FontWeight.bold),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(15),
                child: TextFormField(
                  controller: _emailcontroller,
                  validator: (value) {
                    return validate(value, 'البريد الإلكتروني');
                  },
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  decoration: InputDecoration(
                    // hintText: 'البريد الإلكتروني',
                    labelText: "البريد الإلكتروني",
                    labelStyle:
                        const TextStyle(color: Colors.black, fontSize: 20),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                  height: 46,
                  width: 110,
                  child: ElevatedButton(
                      style:
                          ElevatedButton.styleFrom(backgroundColor: maincolor),
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          setState(() {
                            isloading = true;
                          });
                          try {
                            await FirebaseAuth.instance.sendPasswordResetEmail(
                                email: _emailcontroller.text.trim());
                            Navigator.pop(context);
                            acceptalert(context,
                                "لقد تم ارسال رابط لاعادة تعيين كلمة المرور راجع بريدك الالكتروني");
                          } on FirebaseAuthException catch (e) {
                            if (e.code == "user-not-found") {
                              snackbar(context,
                                  "هذا البريد الالكتروني غير مسجل مسبقا");
                            } else {
                              snackbar(
                                  context, "حدث خطأ تأكد من اتصالك بالانترنت");
                            }
                            setState(() {
                              isloading = false;
                            });
                          }
                        }
                      },
                      child: Center(
                        child: isloading
                            ? const CircularProgressIndicator(
                                color: Colors.black,
                              )
                            : const Text(
                                "إرسال",
                                style: TextStyle(
                                    fontSize: 25, color: Colors.black),
                              ),
                      )))
            ],
          ),
        ),
      ),
    );
  }
}

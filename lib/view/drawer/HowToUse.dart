// ignore_for_file: file_names

import 'package:arabicspeaker/controller/var.dart';
import 'package:arabicspeaker/view/mainscreen.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:steps_indicator/steps_indicator.dart';

List<String> images = [
  'assets/HowToUse/1.jpg',
  'assets/HowToUse/2.jpg',
  'assets/HowToUse/3.jpg',
  'assets/HowToUse/4.jpg',
  'assets/HowToUse/5.jpg',
];

class HowToUse extends StatefulWidget {
  const HowToUse({Key? key}) : super(key: key);

  @override
  State<HowToUse> createState() => _HowToUseState();
}

class _HowToUseState extends State<HowToUse> {
  late bool ischildApp;
  int currentStep = 0;
  @override
  void initState() {
    getisChild();
    super.initState();
  }

  getisChild() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    ischildApp = pref.getBool("isChildApp") ?? false;
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: maincolor,
          leading: InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(Icons.arrow_back_ios)),
          title: const Text(" شرح التطبيق",
              style: TextStyle(
                color: Colors.white,
                fontSize: 24,
                // fontWeight: FontWeight.bold
              )),
        ),
        body: Stack(
          children: [
            Column(children: [
              Expanded(
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                      image: DecorationImage(
                          image: AssetImage(images[currentStep]),
                          fit: BoxFit.fill)),
                ),
              ),
              Container(
                color: const Color.fromARGB(94, 0, 0, 0),
                width: double.infinity,
                child: FittedBox(
                  child: StepsIndicator(
                      doneStepSize: 25,
                      selectedStepSize: 25,
                      unselectedStepSize: 25,
                      selectedStepBorderSize: 2,
                      doneLineColor: maincolor,
                      doneStepColor: maincolor,
                      undoneLineColor: const Color.fromARGB(255, 255, 255, 255),
                      selectedStepColorOut: maincolor,
                      unselectedStepColorIn:
                          const Color.fromARGB(255, 255, 255, 255),
                      unselectedStepColorOut: maincolor,
                      selectedStep: currentStep,
                      doneStepWidget: Container(
                        height: 25,
                        width: 25,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(30),
                            color: maincolor),
                        child: const Icon(
                          Icons.done,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                      doneLineThickness: 3,
                      nbSteps: 5),
                ),
              ),
            ]),
            InkWell(
              onTap: () async {
                if (currentStep < 4) {
                  setState(() {
                    currentStep += 1;
                  });
                } else if (currentStep == 4) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const MainScreen(navindex: 0)),
                      (route) => false);
                }
              },
              child: Padding(
                padding: const EdgeInsets.only(bottom: 60, left: 20),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Container(
                    height: 75,
                    width: 75,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(100),
                        color: maincolor),
                    child: const Center(
                        child: Icon(
                      Icons.arrow_forward,
                      color: Colors.white,
                      size: 50,
                    )),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import '../../controller/istablet.dart';
import '../../controller/var.dart';

class QuestionnairResult extends StatefulWidget {
  QuestionnairResult({Key? key}) : super(key: key);

  final FirebaseFirestore fb = FirebaseFirestore.instance;


  @override
  State<QuestionnairResult> createState() => _QuestionnairResult();
}

/*getData(){

}*/


class _QuestionnairResult extends State<QuestionnairResult> {
  List<String> result = [];
  bool loading = true;

  List<String> resultTem = [];


  @override
  void initState() {
    super.initState();

    getdata().then((value) {
      setState(() {
        loading = false;
      });
    });
  }

  Future<void> getdata() async {
    List<String>temlist = [
      ' sRatingQ1AS',
      'sRatingQ2AS',
      'sRatingQ3AS',
      ' sRatingQLastAS'
    ];
    for (var i in temlist) {
      await FirebaseFirestore.instance.collection("rating")
          .doc(i)
          .get()
          .then((value) {
        String tem = value.data().toString();
        List<String>r = tem.split(',');
        for (var i in r) {
          resultTem.add(i.replaceAll( RegExp(r"\D"), ""));

        }

      });
    }
    setState(() {
      result = resultTem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(

      textDirection: TextDirection.rtl,
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
            backgroundColor: maincolor),
        body:loading? const Center(
          child: CircularProgressIndicator(),
        ):
        SafeArea(
          child: Center(
            child: ListView(
              //mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [

                Padding(

                  padding:  DeviceUtil.isTablet ? const EdgeInsets.only(top:  50.0):
                  const EdgeInsets.only(top:  15.0),
                  child: Text(" التطبيق سهل الاستخدام ",
                    style: TextStyle(fontSize:DeviceUtil.isTablet? 30:20),),
                ),
                SizedBox(height: DeviceUtil.isTablet?30:25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("عدد المستخدمين:", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet? 20:15, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: DeviceUtil.isTablet ? const EdgeInsets.only(right: 8.0):
                      const EdgeInsets.only(right: 3.0),
                      child: Text(
                        result.isNotEmpty ? result[1] : "empty",
                        style: TextStyle(
                            fontSize: DeviceUtil.isTablet?25:20, color: maincolor),
                      ),
                    ),
                    //Text(result[0]),

                  ],
                ),
                SizedBox(height: DeviceUtil.isTablet? 20:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("نعم:${result.isNotEmpty ? result[0] : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15,
                        fontWeight: FontWeight.bold),),

                    Text("محايد: ${result.isNotEmpty
                        ? result[2]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    Text("لا: ${result.isNotEmpty
                        ? result[3]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    //  Text(result[1]),


                  ],),





                //---------------------------------------------------------
                Padding(
                  padding:  EdgeInsets.only(top: DeviceUtil.isTablet? 60:50),
                  child:  Text(" مفيد للتواصل اليومي ",
                    style: TextStyle(fontSize: DeviceUtil.isTablet? 30:20),),
                ),
                SizedBox(height: DeviceUtil.isTablet?30:25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("عدد المستخدمين:", style: TextStyle(
                        fontSize: DeviceUtil.isTablet? 20:15, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        result.isNotEmpty ? result[5] : "empty",
                        style: TextStyle(
                            fontSize: 25, color: maincolor),),
                    ),
                    //Text(result[0]),

                  ],
                ),
                SizedBox(height: DeviceUtil.isTablet? 20:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("نعم:${result.isNotEmpty
                        ? result[4]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    Text("محايد: ${result.isNotEmpty
                        ? result[6]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    Text("لا: ${result.isNotEmpty
                        ? result[7]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    //  Text(result[1]),


                  ],),
                //---------------------------------------------------------

                Padding(
                  padding:  const EdgeInsets.only(top: 60.0),
                  child: Text(" بناء الجملة سهل وواضح ",
                    style:  TextStyle(fontSize: DeviceUtil.isTablet? 30:20),),
                ),
                SizedBox(height: DeviceUtil.isTablet?30:25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("عدد المستخدمين:", style: TextStyle(
                        fontSize: DeviceUtil.isTablet? 20:15, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        result.isNotEmpty ? result[9] : "empty",
                        style: TextStyle(
                            fontSize: 25, color: maincolor),),
                    ),
                    //Text(result[0]),

                  ],
                ),
                SizedBox(height: DeviceUtil.isTablet? 20:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("نعم:${result.isNotEmpty
                        ? result[8]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    Text("محايد: ${result.isNotEmpty
                        ? result[10]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    Text("لا: ${result.isNotEmpty
                        ? result[11]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    //  Text(result[1]),


                  ],),
                SizedBox(height: DeviceUtil.isTablet?30:20),
                // ----------------------------------------------

                Padding(
                  padding:  EdgeInsets.only(top: DeviceUtil.isTablet? 60:50),
                  child:  Text("هل أنت راضٍ عن الخدمات المقدمة في التطبيق ",
                    style: TextStyle(fontSize: DeviceUtil.isTablet? 30:20),),
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("عدد المستخدمين:", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet? 20:15, fontWeight: FontWeight.bold),),
                    Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: Text(
                        result.isNotEmpty ? result[13] : "empty",
                        style: TextStyle(
                            fontSize: 25, color: maincolor),),
                    ),
                    //Text(result[0]),

                  ],
                ),
                SizedBox(height: DeviceUtil.isTablet? 20:10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("نعم:${result.isNotEmpty
                        ? result[12]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    Text("محايد: ${result.isNotEmpty
                        ? result[14]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    Text("لا: ${result.isNotEmpty
                        ? result[15]
                        : "empty"}", style:  TextStyle(
                        fontSize: DeviceUtil.isTablet?20:15, fontWeight: FontWeight.bold),),

                    //  Text(result[1]),


                  ],),

              ],
            ),
          ),


        ),
      ),
    );
  }
}


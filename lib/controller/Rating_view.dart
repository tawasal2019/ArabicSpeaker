import 'dart:math';

import 'package:arabicspeaker/controller/checkinternet.dart';
import 'package:arabicspeaker/controller/var.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RatingView extends StatefulWidget {
  const RatingView({Key?key}): super(key: key);

  @override
  State<RatingView> createState() => _RatingViewState();
}

class _RatingViewState extends State<RatingView> {
  int loopCount=0;

  final _ratingPageController = PageController();
  var _rating = 0;
  var _rating2 = 0;
  var _rating3 = 0;
  var _rating4 = 0;
  bool isC=false;
  String isRaiting= "false";
  @override
  void initState() {
    //getRatingInfo();
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(24),

      ),
      clipBehavior: Clip.antiAlias,
      child: Stack(
          children: [
            //thank_you wedigit
            SizedBox(
                height: max(100, MediaQuery
                    .of(context)
                    .size
                    .height * 0.3),
                width: max(400, MediaQuery
                    .of(context)
                    .size
                    .height * 0.4),

                child: PageView(
                  controller: _ratingPageController,
                  physics: const NeverScrollableScrollPhysics(),
                  children: [
                    _buildThanksNote(),
                    _causeOfRating(),
                    _thirdrating(),
                    _forthRating(),
                    _thankYouPage(),
                  ],

                ),
              ),

            //Done button
            //Skip button
            Positioned(
                right: 0,
                child: MaterialButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Text('Skip',style:  TextStyle(fontSize: 18,fontWeight: FontWeight.bold),),
                )),

          ]
      ),
    );
  }

  _buildThanksNote() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding:  EdgeInsets.only(top: 5),
          child:  Text('التطبيق سهل الاستخدام',
            style:  TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),

        const SizedBox(height: 8,),
        //Star Rating

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index) =>
              IconButton(
                  onPressed: () {

                    setState(() {
                      //_starPosision=20.0;
                      _rating = index + 1;
                      isC=true;
                    });
                  },
                  color: maincolor,
                  icon: index < _rating ? const Icon(Icons.star, size: 40,) : const Icon(
                    Icons.star_border, size: 40,)
              )
          ),
        ),
        const SizedBox(height: 20,),

        SizedBox(
          width:100, //height of button
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,   // background color
              ),

              onPressed: (){
                isC==true?  _ratingPageController.nextPage(
                    duration: const Duration(microseconds: 300),
                    curve: Curves.easeIn)
                    :Container();
                isC=false;
              },
              child: const Text("التالي",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color: Colors.white),)
          ),
        ),



      ],
    );
  }

  _causeOfRating() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('مفيد للتواصل اليومي',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10,),

        //Star rating],

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index2) =>
              IconButton(
                  onPressed: () {

                    setState(() {
                      //_starPosision=20.0;
                      _rating2 = index2 + 1;
                      isC=true;
                    });
                  },
                  color: maincolor,

                  icon: index2 < _rating2 ? const Icon(Icons.star, size: 40,) : const Icon(
                    Icons.star_border, size: 40,)
              )
          ),
        ),
        const SizedBox(height: 20,),

        SizedBox(
          width:100, //height of button
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,   // background color
              ),

              onPressed: (){
                isC==true?  _ratingPageController.nextPage(
                    duration: const Duration(microseconds: 300),
                    curve: Curves.easeIn)
                    :Container();
                isC=false;
              },
              child: const Text("التالي",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color: Colors.white),)
          ),
        ),

      ],
    );
  }

  _thirdrating() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Text('بناء الجملة سهل وواضح',
          style: TextStyle(
            fontSize: 24,
            color: Colors.black,
            fontWeight: FontWeight.bold,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 10,),

        //Star rating],

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index3) =>
              IconButton(
                  onPressed: () {

                    setState(() {
                      //_starPosision=20.0;
                      _rating3 = index3 + 1;
                      isC=true;
                    });
                  },
                  color: maincolor,
                  icon: index3 < _rating3 ? const Icon(Icons.star, size: 40,) : const Icon(
                    Icons.star_border, size: 40,)
              )
          ),
        ),
        const SizedBox(height: 20,),

        SizedBox(
          width:100, //height of button
          child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: maincolor,   // background color
              ),

              onPressed: (){
                isC==true?  _ratingPageController.nextPage(
                    duration: const Duration(microseconds: 300),
                    curve: Curves.easeIn)
                    :Container();
                isC=false;
              },
              child: const Text("التالي",style: TextStyle(fontWeight:FontWeight.bold,fontSize:18,color: Colors.white),)
          ),
        ),

      ],
    );
  }

  _forthRating() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const Padding(
          padding:  EdgeInsets.only(top: 4),
          child:  Text(' أنت راضٍ عن الخدمات المقدمة في التطبيق',
            style: TextStyle(
              fontSize: 24,
              color: Colors.black,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(height: 10,),

        //Star rating],

        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(3, (index4) =>
              IconButton(
                  onPressed: () {
                    setState(() {
                      _rating4 = index4 + 1;
                      isC=true;
                    });
                  },
                  color: maincolor,
                  icon: index4 < _rating4 ? const Icon(Icons.star, size: 40,) : const Icon(
                    Icons.star_border, size: 40,)
              )
          ),
        ),
        const SizedBox(height: 20,),
        Container(
          width: 100,
          color: maincolor,
          child: MaterialButton(
            onPressed: () {
              if(isC==true) {
                isRaiting = "true";
               // print(isRaiting);
                switch (_rating) {
                  case 1:
                    ratingFirebase(0, 0);
                    break;
                  case 2:
                    ratingFirebase(0, 1);
                    break;
                  case 3:
                    ratingFirebase(1, 0);
                    break;
                }
                switch (_rating2) {
                  case 1:
                    ratingFirebase2(0, 0);
                    break;
                  case 2:
                    ratingFirebase2(0, 1);
                    break;
                  case 3:
                    ratingFirebase2(1, 0);
                    break;
                }
                switch (_rating3) {
                  case 1:
                    ratingFirebase3(0, 0);
                    break;
                  case 2:
                    ratingFirebase3(0, 1);
                    break;
                  case 3:
                    ratingFirebase3(1, 0);
                    break;
                }
                switch (_rating4) {
                  case 1:
                    ratingFirebase4(0, 0);
                    break;
                  case 2:
                    ratingFirebase4(0, 1);
                    break;
                  case 3:
                    ratingFirebase4(1, 0);
                    break;
                }
                _ratingPageController.nextPage(
                    duration: const Duration(microseconds: 300),
                    curve: Curves.easeIn);
              }
            },
            textColor: Colors.white,
            child: const Text('ارسال',style: TextStyle(fontWeight: FontWeight.bold,fontSize:18,color: Colors.white),
            ),

          ),

        )



      ],
    );
  }
  _thankYouPage(){
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text("شكرا لك",style: TextStyle(color: maincolor,fontWeight: FontWeight.bold,fontSize: 40),),
          const SizedBox(
            height: 30,
          ),
          SizedBox(
            width:100, //height of button

            child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: maincolor,   // background color
                ),

                onPressed: (){Navigator.pop(context);},
                child: const Text("موافق",
                    style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold,fontSize: 15))),
          )
        ],
      ),
    );
  }

  /*RatingFirebase(int r1, int r2,int r3,int r4) {
    List tmpR=[r1,r2,r3,r4];
    try {
      internetConnection().then((value) async {
        if (value == true) {

         DatabaseReference ref = FirebaseDatabase.instance.ref("rating/arabicSpeakerRating");
         // ref.update({"Nuser": FieldValue.increment(1)});
         DocumentReference<Map<String, dynamic>> refNumUser = await FirebaseFirestore
              .instance.collection('rating').doc(
              'arabicSpeakerRating/');
          refNumUser.update({"Nuser": FieldValue.increment(1)});





          for(int i in tmpR){
          /*  DocumentReference<Map<String, dynamic>> ref = await FirebaseFirestore
                .instance.collection('rating').doc(
                'arabicSpeakerRating/question${loopCount+1}');*/
            print(i);
            print(loopCount);

           switch(i){
              case 1:
              /*  await refNumUser.update({
                  "question${loopCount+1}": {
                    "oneStar": FieldValue.increment(1),
                  },
                });*/




                break;
             case 2:

              /* await refNumUser.update({
                "question${loopCount+1}": {
                   "twoStar": FieldValue.increment(1),
                 },
               });*/
               print( ref.child("question1/oneStar").onValue);
               break;
             case 3:
               /*await refNumUser.update({
                 "question1/threeStar": FieldValue.increment(1),
               });*/



               break;
            }
            loopCount++;

          }
          loopCount=0;

         /*await ref.update({
            "question1": {
              "oneStar": 1,
              "threeStar": 2,
              "twoStar": 3,
            },
            "question2": {
              "oneStar": 1,
              "threeStar": 2,
              "twoStar": 3,
            },
            "question3": {
              "oneStar": 1,
              "threeStar": 2,
              "twoStar": 3,
            },
            "question4": {
              "oneStar": 1,
              "threeStar": 2,
              "twoStar": 3,
            },
          });*/
         SharedPreferences Spref = await SharedPreferences.getInstance();
          Spref.setString("israting", isRaiting);
          print(isRaiting);


        }
      });
    } catch (_) {}
  }*/

  ratingFirebase(int y, int half) {
    try {
      internetConnection().then((value) async {
        if (value == true) {
          DocumentReference<Map<String, dynamic>> ref =  FirebaseFirestore
              .instance.collection('rating').doc(' sRatingQ1AS');
          SharedPreferences spref = await SharedPreferences.getInstance();
          spref.setString("israting", isRaiting);
          //print(isRaiting);

          ref.update({"Nuser": FieldValue.increment(1)});
          if (y == 1) {
            ref.update({"NumofYes": FieldValue.increment(1)});
          } else if (half == 1) {
            ref.update({"NumofNeural": FieldValue.increment(1)});
          } else {
            ref.update({"NumofNo": FieldValue.increment(1)});
          }
        }
      });
    } catch (_) {}
  }
  ratingFirebase2(int y, int half) {
    try {
      internetConnection().then((value) async {
        if (value == true) {
          DocumentReference<Map<String, dynamic>> ref =  FirebaseFirestore
              .instance.collection('rating').doc('sRatingQ2AS');
          //DatabaseReference ref = FirebaseDatabase.instance.ref("rating/");

          ref.update({"Nuser": FieldValue.increment(1)});
          if (y == 1) {
            ref.update({"NumofYes": FieldValue.increment(1)});
          } else if (half == 1) {
            ref.update({"NumofNeural": FieldValue.increment(1)});
          } else {
            ref.update({"NumofNo": FieldValue.increment(1)});
          }
        }
      });
    } catch (_) {}
  }
  ratingFirebase3(int y, int half) {
    try {
      internetConnection().then((value) async {
        if (value == true) {
          DocumentReference<Map<String, dynamic>> ref =  FirebaseFirestore
              .instance.collection('rating').doc(
              'sRatingQ3AS');
          //DatabaseReference ref = FirebaseDatabase.instance.ref("rating/");

          ref.update({"Nuser": FieldValue.increment(1)});
          if (y == 1) {
            ref.update({"NumofYes": FieldValue.increment(1)});
          } else if (half == 1) {
            ref.update({"NumofNeural": FieldValue.increment(1)});
          } else {
            ref.update({"NumofNo": FieldValue.increment(1)});
          }
        }
      });
    } catch (_) {}
  }
  ratingFirebase4(int y, int half) {
    try {
      internetConnection().then((value) async {
        if (value == true) {
          DocumentReference<Map<String, dynamic>> ref =  FirebaseFirestore
              .instance.collection('rating').doc(' sRatingQLastAS');
          //DatabaseReference ref = FirebaseDatabase.instance.ref("rating/");

          ref.update({"Nuser": FieldValue.increment(1)});
          if (y == 1) {
            ref.update({"NumofYes": FieldValue.increment(1)});
          } else if (half == 1) {
            ref.update({"NumofNeural": FieldValue.increment(1)});
          } else {
            ref.update({"NumofNo": FieldValue.increment(1)});
          }
        }
      });
    } catch (_) {}
  }

}
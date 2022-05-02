import 'dart:collection';
import 'package:doogo/screen/main_screen/register_screen.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doogo/screen/chat_screen.dart';
import 'package:doogo/screen/service_center_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/main.dart';


class LanguageScreen extends StatefulWidget {
  final VoidCallback onFinish;
  const LanguageScreen({Key? key, required this.onFinish}) : super(key: key);

  @override
  State<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends State<LanguageScreen> {

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  int selectNum = 3;
  Widget customSelect(String text,int num){

    return Material(
      child: InkWell(
        onTap: (){
          setState((){
            selectNum = num;
          });
        },
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: Padding(
                      padding: EdgeInsets.only(top: 3,bottom: 3),
                      child: Text(text,style: TextStyle(
                          fontSize: 15
                      ),),
                    ),
                  ),
                  if(num == selectNum)
                  Icon(
                      Icons.check,
                  )

                ],
              ),
            ),
            Container(
              height: 1,
              color: LIGHT_GRAY,
            )
          ],
        ),
      ),
    );
  }

  void floatingPressed() async{
    final codeList = ["ar","sq","en","es","fa","he","hi","ja","ko","tr"];
   await db.collection("users").doc(auth.currentUser!.email).update({"language" :codeList[selectNum-1]});

   widget.onFinish();



  }
  @override
  Widget build(BuildContext context) {
      return Column(
        children: [
          Container(
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: EdgeInsets.only(left: 8,right: 16,top: MediaQuery.of(context).padding.top+10),
              child: Container(
                child: Text("Select Language",style: TextStyle(
                  fontSize: 20
                ),)
              ),
            ),
          ),
          Expanded(
            child: ListView(
                children: [
                  customSelect("Arabic", 1),
                  customSelect("Albanian", 2),
                  customSelect("English", 3),
                  customSelect("Spanish", 4),
                  customSelect("Persian", 5),
                  customSelect("Hebrew", 6),
                  customSelect("Hidi", 7),
                  customSelect("Japanese", 8),
                  customSelect("Korean", 9),
                  customSelect("turkish", 10),
                ],
              ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(child: ElevatedButton(onPressed: floatingPressed, child: Text("Select"),
                style: ElevatedButton.styleFrom(
                  primary: MAIN_COLOR
                ),)),
              ],
            ),
          )
        ],
      );


  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/screen/main_screen/home_screen.dart';
import 'package:doogo/screen/main_screen/message_screen.dart';
import 'package:doogo/screen/main_screen/my_screen.dart';
import 'package:doogo/screen/main_screen/register_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Play extends StatefulWidget {
  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  bool isHome = true;
  bool isRegister = false;
  bool isMessage = false;
  bool isMy = false;

  @override
  void initState() {
    super.initState();
  }

  Widget bottomBar(bool isReceived) {
    return Container(
      color: Colors.white,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  isHome = true;
                  isMessage = false;
                  isMy = false;
                  isRegister = false;
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Image.asset("asset/img/home.png",
                      height: 25, color: isHome ? MAIN_COLOR : Colors.black),
                  SizedBox(
                    //fff
                    height: 5,
                  ),
                  Text(
                    "home",
                    style: TextStyle(
                        color: isHome ? MAIN_COLOR : Colors.black,
                        fontWeight: FontWeight.w400,
                        fontSize: 12),
                  ),
                  SizedBox(
                    height: 8,
                  )
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  isHome = false;
                  isMessage = false;
                  isMy = false;
                  isRegister = true;
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Image.asset(
                    "asset/img/register.png",
                    height: 25,
                    color: isRegister ? MAIN_COLOR : Colors.black,
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "register",
                    style: TextStyle(
                        fontSize: 12,
                        color: isRegister ? MAIN_COLOR : Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Align(
              alignment: Alignment.center,
              child: Stack(
                children: [
                  if (isReceived)
                    Positioned(
                        right: 5,
                        top: 8,
                        child: Image.asset(
                          "asset/img/dot.png",
                          width: 5,
                          color: Colors.red,
                        )),
                  GestureDetector(
                    behavior: HitTestBehavior.translucent,
                    onTap: () {
                      print("good");
                      setState(() {
                        isHome = false;
                        isMessage = true;
                        isMy = false;
                        isRegister = false;
                      });
                    },
                    child: Column(
                      children: [
                        SizedBox(
                          height: 8,
                        ),
                        Image.asset(
                          "asset/img/message.png",
                          height: 25,
                          color: isMessage ? MAIN_COLOR : Colors.black,
                        ),
                        SizedBox(
                          height: 5,
                        ),
                        Text(
                          "message",
                          style: TextStyle(
                              fontSize: 12,
                              color: isMessage ? MAIN_COLOR : Colors.black,
                              fontWeight: FontWeight.w400),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: () {
                setState(() {
                  isHome = false;
                  isMessage = false;
                  isMy = true;
                  isRegister = false;
                });
              },
              child: Column(
                children: [
                  SizedBox(
                    height: 8,
                  ),
                  Image.asset("asset/img/profile.png",
                      height: 25, color: isMy ? MAIN_COLOR : Colors.black),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    "my",
                    style: TextStyle(
                        fontSize: 12,
                        color: isMy ? MAIN_COLOR : Colors.black,
                        fontWeight: FontWeight.w400),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
                child: isHome
                    ? HomeScreen()
                    : isRegister
                        ? RegisterScreen(goHome: (){

                          setState((){
                            isHome = true;
                            isMessage = false;
                            isMy = false;
                            isRegister = false;
                          });
                },)
                        : isMy
                            ? MyScreen()
                            : MessageScreen()),
            StreamBuilder(
              stream: db
                  .collection("chat")
                  .where("receiver_id", isEqualTo: auth.currentUser!.email)
                  .where("check", isNull: true)
                  .snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Container();
                } else {
                  if (snapshot.data!.docs.length > 0) {
                    return bottomBar(true);
                  } else {
                    return bottomBar(false);
                  }
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

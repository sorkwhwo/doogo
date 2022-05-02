import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/screen/language_screen.dart';
import 'package:doogo/screen/main_screen/home_screen.dart';
import 'package:doogo/screen/main_screen/message_screen.dart';
import 'package:doogo/screen/main_screen/my_screen.dart';
import 'package:doogo/screen/main_screen/register_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';


class Play extends StatefulWidget {
  @override
  State<Play> createState() => _PlayState();
}

class _PlayState extends State<Play> {
  FirebaseFirestore db = FirebaseFirestore.instance;

  bool isHome = true;
  bool isRegister = false;
  bool isMessage = false;
  bool isMy = false;
  QuerySnapshot<Map<String, dynamic>>? data;
  FirebaseAuth auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();
    getData();
  }

  void getData() async {
    data = await db
        .collection("users")
        .where("id", isEqualTo: auth.currentUser!.email)
        .get();

    if (data!.docs.isNotEmpty) {
      await db
          .collection("users")
          .doc(auth.currentUser!.email)
          .update({"on": "on"});
    } else {
      await db
          .collection("users")
          .doc(auth.currentUser!.email)
          .set({"id": auth.currentUser!.email, "on": "on"});
    }

    data = await db
        .collection("users")
        .where("id", isEqualTo: auth.currentUser!.email)
        .get();

    setState(() {});
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

  // Widget getTranslate() {
  //   return Padding(
  //     padding: const EdgeInsets.all(30.0),
  //     child: GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
  //       translateFrom: Locale('ko'),
  //       translateTo: Locale('tr'),
  //       // automaticDetection: , In case you don't know the user language will want to traslate,
  //       // cacheDuration: Duration(days: 13), The duration of the cache translation.
  //       builder: () => Text(
  //         "만나서 반갑습니다.").translate()
  //     ),
  //   );
  // }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: data == null
            ? Center(
                child: circularProgressIndicator(),
              )
            : !data!.docs[0].data().containsKey("language")
                ? LanguageScreen(onFinish: () async {
                    data = await db
                        .collection("users")
                        .where("id", isEqualTo: auth.currentUser!.email)
                        .get();

                    setState(() {});
                  })
                : GoogleTranslatorInit(
                    "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
                    translateFrom: Locale('ko'),
                    translateTo: Locale("${data!.docs[0]["language"]}"),
                    builder: () {
                    return SafeArea(
                      top: isHome ? false : true,
                      child: Column(
                        children: [
                          Expanded(
                              child: isHome
                                  ? HomeScreen()
                                  : isRegister
                                      ? RegisterScreen(
                                          goHome: () {
                                            setState(() {
                                              isHome = true;
                                              isMessage = false;
                                              isMy = false;
                                              isRegister = false;
                                            });
                                          },
                                        )
                                      : isMy
                                          ? MyScreen()
                                          : MessageScreen()),
                          StreamBuilder(
                            stream: db
                                .collection("chat")
                                .where("receiver_id",
                                    isEqualTo: auth.currentUser!.email)
                                .where("check", isNull: true)
                                .snapshots(),
                            builder: (BuildContext context,
                                AsyncSnapshot<
                                        QuerySnapshot<Map<String, dynamic>>>
                                    snapshot) {
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
                    );
                  }));
  }
}

import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/admin_email.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/screen/main_screen/register_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

class AnswerScreen extends StatefulWidget {
  final String theme;
  final String id;
  final dateTime;
  final String inquire;
  final bool? admin;

  const AnswerScreen(
      {super.key,
      required this.theme,
      required this.id,
      required this.dateTime,
      required this.inquire,
      this.admin});

  @override
  State<AnswerScreen> createState() => _AnswerScreenState();
}

class _AnswerScreenState extends State<AnswerScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot<Map<String, dynamic>>? counterData;
  QuerySnapshot<Map<String, dynamic>>? myData;
  QuerySnapshot<Map<String, dynamic>>? data;
  QueryDocumentSnapshot<Map<String, dynamic>>? targetData;
  TextEditingController controller = TextEditingController();

  void getData() async {
    data = await db
        .collection("inquire")
        .where("id", isEqualTo: widget.id)
        .where("date", isEqualTo: widget.dateTime)
        .get();
    targetData = data!.docs[0];
    setState(() {});
  }

  @override
  void initState() {
    getData();
    getMyData();
    getCounterData();
  }

  getCounterData() async {
    counterData =
        await db.collection("users").where("id", isEqualTo: widget.id).get();
    setState(() {});
  }

  getMyData() async {
    myData = await db
        .collection("users")
        .where("id", isEqualTo: auth.currentUser!.email)
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_COLOR,
        title: Text("Q&A"),
      ),
      body: targetData == null || myData == null || counterData == null
          ? Center(
              child: circularProgressIndicator(),
            )
          : GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
              translateFrom: widget.id == auth.currentUser!.email
                  ? Locale('ko')
                  : Locale('${counterData!.docs[0]["language"]}'),
              translateTo: Locale('${myData!.docs[0]["language"]}'),
              builder: () {
              return SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                          padding: EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[200],
                          child: widget.id == auth.currentUser!.email
                              ? Text(
                                  "문의내용",
                                ).translate()
                              : Text(
                                  "문의내용",
                                )),
                      SizedBox(
                        height: 8,
                      ),
                      if (widget.id == auth.currentUser!.email)
                        Text("${widget.inquire}"),
                      if (widget.id != auth.currentUser!.email)
                        Text("${widget.inquire}").translate(),
                      SizedBox(
                        height: 16,
                      ),
                      Container(
                          padding: EdgeInsets.all(16),
                          width: MediaQuery.of(context).size.width,
                          color: Colors.grey[200],
                          child: widget.id == auth.currentUser!.email
                              ? Text(
                                  "답변내용",
                                ).translate()
                              : Text(
                                  "답변내용",
                                )),
                      SizedBox(
                        height: 8,
                      ),
                      if (targetData!["answer"] == "null")
                        widget.id == auth.currentUser!.email
                            ? Text(
                                "등록된 답변이 없습니다.",
                                style: TextStyle(color: Colors.grey[400]),
                              ).translate()
                            : Text(
                                "등록된 답변이 없습니다.",
                                style: TextStyle(color: Colors.grey[400]),
                              ),
                      if (targetData!["answer"] != "null")
                        Text(targetData!["answer"]).translate(),
                      SizedBox(
                        height: 16,
                      ),
                      if ((auth.currentUser!.email == ADMIN_1 ||
                              auth.currentUser!.email == ADMIN_2) &&
                          widget.admin == true)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Text(
                                "이름",
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(targetData!["name"]),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Text("휴대폰 번호"),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(targetData!["phone"]),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Text(
                                "가입 이메일",
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            Text(targetData!["id"]),
                            SizedBox(
                              height: 16,
                            ),
                            Container(
                              padding: EdgeInsets.all(16),
                              width: MediaQuery.of(context).size.width,
                              color: Colors.grey[200],
                              child: Text("답변입력"),
                            ),
                            TextFormField(
                              controller: controller,
                              cursorColor: Colors.black,
                              maxLines: 15,
                              decoration: InputDecoration(
                                  enabledBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: LIGHT_GRAY,
                                    width: 1,
                                  )),
                                  focusedBorder: OutlineInputBorder(
                                      borderSide: BorderSide(
                                    color: Colors.black,
                                    width: 1.5,
                                  ))),
                            ),
                            Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                onPressed: () async {
                                  if (controller.text.isEmpty) {
                                    return;
                                  }
                                  await db
                                      .collection("inquire")
                                      .doc(targetData!.id)
                                      .update({"answer": "${controller.text}"});
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      SnackBar(content: Text("답변을 완료하였습니다.")));
                                  Navigator.of(context).pop();
                                },
                                child: Text(
                                  "답변하기",
                                  style: TextStyle(color: Colors.indigo),
                                ),
                              ),
                            ),
                          ],
                        )
                    ],
                  ),
                ),
              );
            }),
    );
  }
}

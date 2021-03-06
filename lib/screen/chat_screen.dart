import 'dart:async';
import 'dart:collection';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/screen/service_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_chat_bubble/bubble_type.dart';
import 'package:flutter_chat_bubble/chat_bubble.dart';
import 'package:flutter_chat_bubble/clippers/chat_bubble_clipper_8.dart';
import 'package:google_translator/google_translator.dart';

class ChatScreen extends StatefulWidget {
  final String counterId;

  const ChatScreen({super.key, required this.counterId});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  getSenderView(CustomClipper clipper, BuildContext context, String message) =>
      ChatBubble(
        clipper: clipper,
        alignment: Alignment.topRight,
        margin: EdgeInsets.only(top: 9, bottom: 2),
        backGroundColor: MAIN_COLOR,
        child: Container(
          constraints: BoxConstraints(
            maxWidth: MediaQuery
                .of(context)
                .size
                .width * 0.5,
          ),
          child: Text(
            message,
            style: TextStyle(color: Colors.white),
          ),
        ),
      );

  getReceiverView(CustomClipper clipper, BuildContext context,
      String message) =>
      ChatBubble(
        clipper: clipper,
        backGroundColor: Color(0xffE7E7ED),
        margin: EdgeInsets.only(top: 9, bottom: 2),
        child: Row(
          children: [
            Container(
              constraints: BoxConstraints(
                maxWidth: MediaQuery
                    .of(context)
                    .size
                    .width * 0.5,
              ),
              child: GoogleTranslatorInit(
                  "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
                  translateFrom: Locale('${counterData!.docs[0]["language"]}'),
                  translateTo: Locale('${myData!.docs[0]["language"]}'),
                  builder: () {
                    return Text(
                      message,
                      style: TextStyle(color: Colors.black),
                    ).translate();
                  }),
            ),
          ],
        ),
      );
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  Timer? timer;

  QuerySnapshot<Map<String, dynamic>>? counterData;
  QuerySnapshot<Map<String, dynamic>>? myData;

  getCounterData() async {
    counterData = await db
        .collection("users")
        .where("id", isEqualTo: widget.counterId)
        .get();
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
  void initState() {
    super.initState();
    beForeTimer();
    getMyData();
    getCounterData();
    timer = Timer.periodic(Duration(seconds: 1), (timer) async {
      final targetChat = await db
          .collection("chat")
          .where("sender_id", isEqualTo: widget.counterId)
          .where("receiver_id", isEqualTo: auth.currentUser!.email)
          .where("check", isNull: true)
          .get();

      for (int i = 0; i < targetChat.docs.length; i++) {
        db
            .collection("chat")
            .doc(targetChat.docs[i].id)
            .update({"check": "check"});
      }
    });
  }

  void beForeTimer() async {
    final targetChat = await db
        .collection("chat")
        .where("sender_id", isEqualTo: widget.counterId)
        .where("receiver_id", isEqualTo: auth.currentUser!.email)
        .where("check", isNull: true)
        .get();

    for (int i = 0; i < targetChat.docs.length; i++) {
      db
          .collection("chat")
          .doc(targetChat.docs[i].id)
          .update({"check": "check"});
    }
    ;
  }

  @override
  void dispose() {
    timer!.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: [
          TextButton(
            onPressed: () {
              Navigator.of(context).push(MaterialPageRoute(
                  builder: (context) => ServiceCenterScreen()));
            },
            child: Image.asset(
              "asset/img/sirn.png",
              color: Colors.white,
              width: 20,
            ),
          )
        ],
        backgroundColor: MAIN_COLOR,
        title: Text(widget.counterId),
      ),
      body: (myData == null || counterData == null)
          ? Center(
        child: circularProgressIndicator(),
      )
          : Padding(
        padding: const EdgeInsets.symmetric(horizontal: 10),
        child: StreamBuilder(
          stream: db
              .collection("chat")
              .orderBy("date", descending: true)
              .snapshots(),
          builder: (BuildContext context,
              AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>>
              snapshot) {
            if (!snapshot.hasData) {
              return Center(
                child: CircularProgressIndicator(
                  color: Colors.grey,
                  strokeWidth: 2,
                ),
              );
            }
            return Column(
              children: [
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 5),
                    child: Align(
                      alignment: Alignment.topCenter,
                      child: ListView.builder(
                          reverse: true,
                          shrinkWrap: true,
                          itemCount: snapshot.data!.docs.length,
                          itemBuilder: (context, index) {
                            final data = snapshot.data!.docs[index];
                            final senderId = data["sender_id"];
                            final receiverId = data["receiver_id"];

                            if (auth.currentUser!.email == senderId ||
                                auth.currentUser!.email == receiverId) {
                              if (widget.counterId == senderId ||
                                  widget.counterId == receiverId) {
                                final message = data["message"];
                                final date = data["date"];
                                DateTime dateTime = date.toDate();
                                final check = data["check"];

                                if (senderId == auth.currentUser!.email) {
                                  return Row(
                                    mainAxisAlignment:
                                    MainAxisAlignment.end,
                                    children: [
                                      Text(
                                        "${dateTime.year}.${dateTime.month
                                            .toString().padLeft(
                                            2, "0")}.${dateTime.day.toString()
                                            .padLeft(2, "0")} ${dateTime.hour
                                            .toString().padLeft(
                                            2, "0")}:${dateTime.minute
                                            .toString().padLeft(2, "0")}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10),
                                      ),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      getSenderView(
                                          ChatBubbleClipper8(
                                              type:
                                              BubbleType.sendBubble),
                                          context,
                                          message)
                                    ],
                                  );
                                } else {
                                  return Row(
                                    children: [
                                      getReceiverView(
                                          ChatBubbleClipper8(
                                              type: BubbleType
                                                  .receiverBubble),
                                          context,
                                          message),
                                      SizedBox(
                                        width: 8,
                                      ),
                                      Text(
                                        "${dateTime.year}.${dateTime.month
                                            .toString().padLeft(
                                            2, "0")}.${dateTime.day.toString()
                                            .padLeft(2, "0")} ${dateTime.hour
                                            .toString().padLeft(
                                            2, "0")}:${dateTime.minute
                                            .toString().padLeft(2, "0")}",
                                        style: TextStyle(
                                            color: Colors.grey,
                                            fontSize: 10),
                                      )
                                    ],
                                  );
                                }
                              } else {
                                return Container();
                              }
                            } else {
                              return Container();
                            }
                          }),
                    ),
                  ),
                ),
                NewMessage(
                  receiver_id: widget.counterId,
                )
              ],
            );
          },
        ),
      ),
    );
  }
}

class NewMessage extends StatefulWidget {
  final String receiver_id;

  const NewMessage({super.key, required this.receiver_id});

  @override
  State<NewMessage> createState() => _NewMessageState();
}

class _NewMessageState extends State<NewMessage> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  TextEditingController controller = TextEditingController();
  String message = "";

  QuerySnapshot<Map<String, dynamic>>? data;
  QuerySnapshot<Map<String, dynamic>>? data2;


  void getData() async {
    data = await db.collection("conversations").where(
        "receiver_id", isEqualTo: auth.currentUser!.email).where(
        "sender_id", isEqualTo: widget.receiver_id)
        .get();

    setState(() {

    });
  }

  void getData2() async {
    data2 = await db.collection("conversations").where(
        "receiver_id", isEqualTo: widget.receiver_id).where(
        "sender_id", isEqualTo: auth.currentUser!.email)
        .get();

    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    getData();
    getData2();
  }

  @override
  Widget build(BuildContext context) {

    if(data==null || data2==null){
      return Container();
    }
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 5, bottom: 5),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 10),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20), color: Colors.grey[200]),
        child: Row(
          children: [
            Expanded(
              child: TextFormField(
                maxLines: null,
                decoration: InputDecoration(
                    hintText: "Please enter your message.",
                    border: InputBorder.none),
                controller: controller,
                onChanged: (value) {
                  setState(() {
                    message = value;
                  });
                },
              ),
            ),
            GestureDetector(
              behavior: HitTestBehavior.translucent,
              onTap: message
                  .trim()
                  .isEmpty
                  ? null
                  : () async {
                HashMap<String, dynamic> map = new HashMap();
                map.putIfAbsent("check", () => null);
                map.putIfAbsent("date", () => Timestamp.now());
                map.putIfAbsent("message", () => message);
                map.putIfAbsent("receiver_id", () => widget.receiver_id);
                map.putIfAbsent(
                    "sender_id", () => auth.currentUser!.email);


                db.collection("chat").add(map);


                if(data!.docs.isEmpty && data2!.docs.isEmpty){
                  db.collection("conversations").add(map);
                  data2 = await db.collection("conversations").where(
                      "receiver_id", isEqualTo: widget.receiver_id).where(
                      "sender_id", isEqualTo: auth.currentUser!.email)
                      .get();
                }else{
                  HashMap<String, dynamic> map2 = new HashMap();
                  map2.putIfAbsent("message", () => message);
                  map2.putIfAbsent("date", () => Timestamp.now());
                  if(data!.docs.isNotEmpty){
                    db.collection("conversations").doc(data!.docs[0].id).update(map2);
                  }else{
                    db.collection("conversations").doc(data2!.docs[0].id).update(map2);
                  }
                }


                setState(() {
                  controller.text = "";
                  message = "";
                });
              },
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Icon(
                  Icons.send,
                  color: message
                      .trim()
                      .isEmpty ? Colors.grey : MAIN_COLOR,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

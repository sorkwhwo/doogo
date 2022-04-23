import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/screen/chat_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class Message extends StatefulWidget {
  final data;
  final date;

  const Message({super.key, required this.data, required this.date});

  @override
  State<Message> createState() => _MessageState();
}

class _MessageState extends State<Message> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  String? counterId;
  int? dataLength;

  @override
  initState() {
    super.initState();
    discriminate();
  }

  void discriminate() {
    if (widget.data["sender_id"] == auth.currentUser!.email) {
      counterId = widget.data["receiver_id"];
    } else {
      counterId = widget.data["sender_id"];
    }
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder(
        stream: db
            .collection("chat")
            .where("sender_id", isEqualTo: counterId)
            .where("receiver_id", isEqualTo: auth.currentUser!.email)
            .where("check", isNull: true)
            .snapshots(),
        builder: (BuildContext context,
            AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
          if (!snapshot.hasData) {
            return Container();
          }
          dataLength = snapshot.data!.docs.length;
          return Material(
            child: InkWell(
              onTap: () {
                Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => ChatScreen(counterId: counterId!)));
              },
              child: Container(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 15),
                  child: Row(
                    children: [
                      Image.asset("asset/img/user.png", width: 50),
                      SizedBox(
                        width: 10,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Text(
                                        "$counterId",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w600),
                                      ),
                                      if (dataLength != 0)
                                        SizedBox(
                                          width: 5,
                                        ),
                                      if (dataLength != 0)
                                        Image.asset(
                                          "asset/img/dot.png",
                                          width: 5,
                                          color: Colors.red,
                                        )
                                    ],
                                  ),
                                ),
                                Text(
                                  "${widget.date.year}.${widget.date.month.toString().padLeft(2, "0")}.${widget.date.day.toString().padLeft(2, "0")} ${widget.date.hour.toString().padLeft(2, "0")}:${widget.date.minute.toString().padLeft(2, "0")}",
                                  style: TextStyle(
                                      fontSize: 10, color: Colors.grey),
                                ),
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("${widget.data["message"]}"),
                            SizedBox(
                              height: 5,
                            ),
                            Text(
                              "when accessing a chat room, the translation module works.",
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Container(
                              height: 1,
                              color: Colors.grey[300],
                            )
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );
        });
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/date_to_string.dart';
import 'package:doogo/screen/answer_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';

class AdminInquireListScreen extends StatefulWidget {
  const AdminInquireListScreen({Key? key}) : super(key: key);

  @override
  State<AdminInquireListScreen> createState() => _AdminInquireListScreenState();
}

class _AdminInquireListScreenState extends State<AdminInquireListScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  Widget yesIsList() {
    return StreamBuilder(
      stream: db
          .collection("inquire")
      .where("answer",isEqualTo: "null")
          .orderBy("date", descending: true)
          .snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: circularProgressIndicator()
          );
        }
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index];
              return Material(
                child:InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AnswerScreen(inquire : data["inquire"],theme: data["theme"], id: data["id"], dateTime: data["date"],admin: true,)));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Row(
                          children: [
                            Text("${index + 1}"),
                            SizedBox(
                              width: 16,
                            ),
                            Expanded(
                                child: Text(

                                  "${data["theme"]}",
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                )),
                            SizedBox(
                              width: 16,
                            ),
                            dateToString(data["date"].toDate()),
                          ],
                        ),
                      ),
                      Container(
                        height: 1,
                        color: Colors.grey[300],
                      )
                    ],
                  ),
                ),
              );
            });
      },
    );
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_COLOR,
        title: Text("문의내역"),
      ),
        body: yesIsList(),
    );
  }
}



import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/date_to_string.dart';
import 'package:doogo/screen/answer_screen.dart';
import 'package:doogo/screen/notice_screen.dart';
import 'package:doogo/screen/notice_write_screen.dart';
import 'package:doogo/main.dart';
import 'package:flutter/material.dart';

class NoticeDetailScreen extends StatefulWidget {
  const NoticeDetailScreen({Key? key}) : super(key: key);

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {

  FirebaseFirestore db = FirebaseFirestore.instance;

  Widget yesIsList() {
    return StreamBuilder(
      stream: db
          .collection("admin")
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
                    Navigator.of(context).push(MaterialPageRoute(builder: (context) =>NoticeScreen(date: data["date"],)));
                  },
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 20, horizontal: 16),
                        child: Row(
                          children: [
                            SizedBox(
                              width: 8,
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
        title: Text("공지사항"),
      ),
      body: yesIsList(),
    );
  }
}



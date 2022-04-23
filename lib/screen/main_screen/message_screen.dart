import 'package:doogo/component/message.dart';
import 'package:doogo/screen/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/start.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class MessageScreen extends StatelessWidget {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;



  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "Message",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                height: 1,
                color: Colors.grey[300],
              ),

            ])),
        Expanded(
          child: StreamBuilder(
              stream:
                  db.collection("conversations").orderBy("date",descending: true).snapshots(),
              builder: (BuildContext context,
                  AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(
                      color: Colors.grey,
                      strokeWidth: 2,
                    ),
                  );
                }
                return ListView.builder(
                    itemCount: snapshot.data!.docs.length,
                    itemBuilder: (context, index) {
                      final data = snapshot.data!.docs[index];
                      if (data["sender_id"] == auth.currentUser!.email ||
                          data["receiver_id"] == auth.currentUser!.email) {

                        DateTime date = data["date"].toDate();
                        return Message(data:data,date :date);
                      }
                      return Container();
                    });
              }),
        ),
      ],
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/date_to_string.dart';
import 'package:doogo/screen/answer_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';

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
              return AdminInquire(data: data, index: index);
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




class AdminInquire extends StatefulWidget {
  final data;
  final index;

  const AdminInquire({super.key, required this.data, required this.index});

  @override
  State<AdminInquire> createState() => _AdminInquireState();
}

class _AdminInquireState extends State<AdminInquire> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot<Map<String,dynamic>>? counterData;
  QuerySnapshot<Map<String,dynamic>>? myData;

  @override
  initState(){
    super.initState();

    getMyData();
    getCounterData();
  }

  getCounterData() async{
    counterData =  await db.collection("users").where("id",isEqualTo: widget.data["id"]).get();
    setState((){

    });
  }

  getMyData() async{
    myData =  await db.collection("users").where("id",isEqualTo: auth.currentUser!.email).get();
    setState((){

    });
  }


  @override
  Widget build(BuildContext context) {

    if(myData ==null || counterData==null){
      return Container();
    }
    return GoogleTranslatorInit(
        "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
        translateFrom: Locale('${counterData!.docs[0]["language"]}'),
    translateTo: Locale('${myData!.docs[0]["language"]}'),
    builder: () {
        return Material(
          child:InkWell(
            onTap: () {
              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AnswerScreen(inquire : widget.data["inquire"],theme: widget.data["theme"], id: widget.data["id"], dateTime: widget.data["date"],admin: true,)));
            },
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 20, horizontal: 16),
                  child: Row(
                    children: [
                      Text("${widget.index + 1}"),
                      SizedBox(
                        width: 16,
                      ),
                      Expanded(
                          child: Text(

                            "${widget.data["theme"]}",
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ).translate()),
                      SizedBox(
                        width: 16,
                      ),
                      dateToString(widget.data["date"].toDate()),
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
      }
    );
  }
}

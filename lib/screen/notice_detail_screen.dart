import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/admin_email.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/date_to_string.dart';
import 'package:doogo/screen/answer_screen.dart';
import 'package:doogo/screen/notice_screen.dart';
import 'package:doogo/screen/notice_write_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';

class NoticeDetailScreen extends StatefulWidget {
  const NoticeDetailScreen({Key? key}) : super(key: key);

  @override
  State<NoticeDetailScreen> createState() => _NoticeDetailScreenState();
}

class _NoticeDetailScreenState extends State<NoticeDetailScreen> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  QuerySnapshot<Map<String,dynamic>>? myData;

  @override
  initState(){
    super.initState();

    getMyData();

  }


  getMyData() async{
    myData =  await db.collection("users").where("id",isEqualTo: auth.currentUser!.email).get();
    setState((){

    });
  }
  Widget yesIsList() {
    return StreamBuilder(
      stream:
          db.collection("admin").orderBy("date", descending: true).snapshots(),
      builder: (BuildContext context,
          AsyncSnapshot<QuerySnapshot<Map<String, dynamic>>> snapshot) {
        if (!snapshot.hasData) {
          return Center(child: circularProgressIndicator());
        }
        return ListView.builder(
            itemCount: snapshot.data!.docs.length,
            itemBuilder: (context, index) {
              final data = snapshot.data!.docs[index];
              return GestureDetector(
                onLongPress: (auth.currentUser!.email!=ADMIN_1 && auth.currentUser!.email!=ADMIN_2) ? null :(){
                  showDialog(context: context,
                      builder:(context){

                    return AlertDialog(
                      title: Text("공지삭제").translate(),
                      content: Text("공지를 삭제하시겠습니까 ? "),
                      actions: [
                        TextButton(onPressed:() async{

                         await db.collection("admin").doc(data.id).delete();
                         Navigator.of(context).pop();
                        }, child: Text("확인")),
                        TextButton(onPressed: (){
                          Navigator.of(context).pop();

                        }, child: Text("취소"))
                      ],
                    );
                      });
                },
                child: Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => NoticeScreen(
                                date: data["date"],
                              )));
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
                              ).translate()),
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
                ),
              );
            });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    if(myData==null){
      return Scaffold(
        body: Center(
          child: circularProgressIndicator(),
        ),
      );
    }
    return GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
        translateFrom: Locale('ko'),
        translateTo: Locale('${myData!.docs[0]["language"]}'), builder: () {
      return Scaffold(
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          title: Text("공지").translate(),
        ),
        body: yesIsList(),
      );
    });
  }
}

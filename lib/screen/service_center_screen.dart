import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/date_to_string.dart';
import 'package:doogo/screen/answer_screen.dart';
import 'package:doogo/screen/main_screen/register_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';
import 'package:intl/intl.dart';

class ServiceCenterScreen extends StatefulWidget {
  const ServiceCenterScreen({Key? key}) : super(key: key);

  @override
  State<ServiceCenterScreen> createState() => _ServiceCenterScreenState();
}

class _ServiceCenterScreenState extends State<ServiceCenterScreen> {
  Widget customTextField(
      {required String hintText,
      int? maxLines,
      required final key,
      required final onSaved,
      required final validator}) {
    return TextFormField(
      keyboardType: key==ValueKey(2) ? TextInputType.number:null,
      validator: validator,
      onSaved: onSaved,
      key: key,
      maxLines: maxLines == null ? null : maxLines,
      cursorColor: Colors.black,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.all(8),
          hintText: hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(5),
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
          enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(5),
              borderSide: BorderSide(color: LIGHT_GRAY))),
    );
  }

  GlobalKey<FormState> key = GlobalKey();
  String? name;
  String? phone;
  String? theme;
  String? inquire;

  bool isList = false;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  void textButtonOnPressed() async {
    if (key.currentState!.validate()) {
      key.currentState!.save();

      HashMap<String, dynamic> map = new HashMap();
      map.putIfAbsent("name", () => name);
      map.putIfAbsent("phone", () => phone);
      map.putIfAbsent("theme", () => theme);
      map.putIfAbsent("inquire", () => inquire);

      map.putIfAbsent("date", () => Timestamp.now());
      map.putIfAbsent("id", () => auth.currentUser!.email);
      map.putIfAbsent("answer", () => "null");

      await db.collection("inquire").add(map);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(
              "You have been successfully registered. Please wait for a reply.")));
      Navigator.of(context).pop();
    }
  }

  void iconButtonOnPressed() {
    setState(() {
      isList = !isList;
    });
  }

  Widget notIsList() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SingleChildScrollView(
        child: Form(
          key: key,
          child: Column(
            children: [
              customTextField(
                  hintText: "Please enter your name.",
                  key: ValueKey(1),
                  onSaved: (value) {
                    name = value;
                  },
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter your details.";
                    }
                  }),
              SizedBox(
                height: 16,
              ),
              customTextField(
                  hintText: "Please enter your phone.",
                  key: ValueKey(2),
                  onSaved: (value) {
                    phone = value;
                  },
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter your details.";
                    }
                  }),
              SizedBox(
                height: 16,
              ),
              customTextField(
                  hintText: "Please enter the subject.",
                  key: ValueKey(3),
                  onSaved: (value) {
                    theme = value;
                  },
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter your details.";
                    }
                  }),
              SizedBox(
                height: 16,
              ),
              customTextField(
                  hintText: "Please enter your details.",
                  key: ValueKey(4),
                  maxLines: 20,
                  onSaved: (value) {
                    inquire = value;
                  },
                  validator: (value) {
                    if (value.toString().trim().isEmpty) {
                      return "Please enter your details.";
                    }
                  }),
              SizedBox(
                height: 16,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                      onPressed: textButtonOnPressed,
                      child: Text(
                        "문의하기",
                        style: TextStyle(color: Colors.indigo),
                      ).translate()),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget yesIsList() {
    return StreamBuilder(
      stream: db
          .collection("inquire")
          .where("id", isEqualTo: auth.currentUser!.email)
          .orderBy("date", descending: true)
          .snapshots(),
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
              return Material(
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (context) => AnswerScreen(
                            inquire: data["inquire"],
                            theme: data["theme"],
                            id: data["id"],
                            dateTime: data["date"])));
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
                            if (data["answer"] != "null")
                              Text(
                                "답변완료",
                                style: TextStyle(
                                    color: Colors.green, fontSize: 10),
                              ).translate(),
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
  QuerySnapshot<Map<String,dynamic>>? myData;

  getMyData() async{
    myData =  await db.collection("users").where("id",isEqualTo: auth.currentUser!.email).get();
    setState((){

    });
  }

  @override
  void initState(){
    super.initState();
  getMyData();
  }
  @override
  Widget build(BuildContext context) {

    if(myData ==null){
      return Scaffold(
        body: Center(
          child: circularProgressIndicator(),
        ),
      );
    }
    return  GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
        translateFrom: Locale('ko'),
        translateTo: Locale('${myData!.docs[0]["language"]}'),
      builder: () {
        return GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Scaffold(
              appBar: AppBar(
                actions: [
                  IconButton(
                      onPressed: iconButtonOnPressed,
                      icon: isList ? Icon(Icons.report) : Icon(Icons.list))
                ],
                backgroundColor: MAIN_COLOR,
                title: isList
                    ? Text("문의 및 신고내역").translate()
                    : Text("문의 및 신고하기").translate(),
              ),
              body: isList ? yesIsList() : notIsList()),
        );
      }
    );
  }
}

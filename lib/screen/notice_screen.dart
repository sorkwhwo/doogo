import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/date_to_string.dart';
import 'package:doogo/screen/answer_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';

class NoticeScreen extends StatefulWidget {
  final date;

  const NoticeScreen({super.key, required this.date});

  @override
  State<NoticeScreen> createState() => _NoticeScreenState();
}

class _NoticeScreenState extends State<NoticeScreen> {
  PageController controller = PageController();
  var photos = List.empty(growable: true);
  int currentPage = 1;
  int imgStart = 1;
  int imgEnd = 15;
  QuerySnapshot<Map<String, dynamic>>? data;
  QueryDocumentSnapshot<Map<String, dynamic>>? targetData;

  // String? member;
  FirebaseFirestore db = FirebaseFirestore.instance;

  FirebaseAuth auth = FirebaseAuth.instance;

  QuerySnapshot<Map<String, dynamic>>? myData;

  getMyData() async {
    myData = await db
        .collection("users")
        .where("id", isEqualTo: auth.currentUser!.email)
        .get();
    setState(() {});
  }

  Widget images() {
    return Stack(
      children: [
        Container(
          height: 300,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: PageView(
                allowImplicitScrolling: true,
                controller: controller,
                scrollDirection: Axis.horizontal,
                children: photos
                    .map(
                      (e) => Image.network(
                        e,
                        fit: BoxFit.fill,
                        width: MediaQuery.of(context).size.width - 20,
                        loadingBuilder: (BuildContext context, Widget child,
                            ImageChunkEvent? loadingProgress) {
                          if (loadingProgress == null) return child;
                          return Center(
                            child: CircularProgressIndicator(
                              color: Colors.grey,
                              strokeWidth: 2,
                              value: loadingProgress.expectedTotalBytes != null
                                  ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                  : null,
                            ),
                          );
                        },
                      ),
                    )
                    .toList()),
          ),
        ),
        Positioned(
            bottom: 8,
            right: 16,
            child: Container(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 3),
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.black.withOpacity(0.4)),
                child: Text(
                  "$currentPage/${photos.length}",
                  style: TextStyle(color: Colors.white),
                )))
      ],
    );
  }

  @override
  initState() {
    super.initState();
    getMyData();
    controller.addListener(() {
      if (controller.page!.round() + 1 != currentPage) {
        setState(() {
          currentPage = controller.page!.round() + 1;
        });
      }
    });

    getData();
  }

  void getData() async {
    data = await db
        .collection("admin")
        .where("date", isEqualTo: widget.date)
        .get();
    targetData = data!.docs[0];
    for (int i = imgStart; i <= imgEnd; i++) {
      if (targetData!.data().containsKey("photo$i")) {
        photos.add(targetData!["photo$i"]);
      }
    }

    setState(() {});
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (myData == null) {
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
        body: targetData == null
            ? Center(
                child: circularProgressIndicator(),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 8,
                    ),
                    if (photos.length != 0) images(),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[200],
                      child: Text("공지제목").translate(),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(targetData!["theme"]).translate(),
                    ),
                    Container(
                      padding: EdgeInsets.all(16),
                      width: MediaQuery.of(context).size.width,
                      color: Colors.grey[200],
                      child: Text("공지내용").translate(),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(targetData!["notice"]).translate(),
                    ),
                  ],
                ),
              ),
      );
    });
  }
}

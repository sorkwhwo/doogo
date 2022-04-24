import 'dart:collection';
import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/date_to_string.dart';
import 'package:doogo/screen/answer_screen.dart';
import 'package:doogo/screen/main_screen/register_screen.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:uuid/uuid.dart';

class NoticeWriteScreen extends StatefulWidget {
  const NoticeWriteScreen({Key? key}) : super(key: key);

  @override
  State<NoticeWriteScreen> createState() => _NoticeWriteScreenState();
}

class _NoticeWriteScreenState extends State<NoticeWriteScreen> {
  String password = Uuid().v4().substring(0, 8);
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseStorage storage = FirebaseStorage.instance;
  List photos = new List.filled(15, null, growable: false);
  int photoLength = 0;
  PageController controller = PageController();
  GlobalKey<FormState> key = GlobalKey();
  String? notice;
  String? theme;

  Widget imagePick(int num) {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: 0,
          bottom: 0,
          child: IconButton(
            onPressed: () async {
              ImagePicker picker = ImagePicker();
              final file = await picker.pickImage(
                  source: ImageSource.gallery, imageQuality: 40);
              if (file != null) {
                setState(() {
                  photoLength = num + 1;
                  photos[num] = File(file.path);
                });
              }
            },
            icon: Icon(
              Icons.camera_alt_outlined,
              color: Colors.grey,
            ),
          ),
        ),
        if (photos[num] != null)
          GestureDetector(
            onTap: () async {
              ImagePicker picker = ImagePicker();
              final file = await picker.pickImage(source: ImageSource.gallery);
              setState(() {
                photos[num] = File(file!.path);
              });
            },
            child: Image.file(
              photos[num],
              width: double.infinity,
              height: 300,
              fit: BoxFit.fill,
            ),
          )
      ],
    );
  }

  Widget customTextField(
      {required String hintText,
      int? maxLines,
      required final key,
      required final onSaved,
      required final validator}) {
    return TextFormField(
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

  @override
  void initState() {
    super.initState();

    controller.addListener(() {
      if (controller.page!.round() > photoLength) {
        controller.animateToPage(photoLength,
            duration: Duration(milliseconds: 100), curve: Curves.linear);
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  void uploadStorage(int num) async {
    final store = storage
        .ref()
        .child("photos")
        .child("${auth.currentUser!.email}${password}$num");
    await store.putFile(photos[num - 1]);
    String uri = await store.getDownloadURL();

    HashMap<String, dynamic> map = new HashMap();
    map.putIfAbsent("photo${num}", () => uri);
    await db
        .collection("admin")
        .doc("$password")
        .update(map);

    if (num == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You have been successfully registered.")));
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_COLOR,
        title: Text("Notice"),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: key,
            child: Column(
              children: [
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  color: Colors.grey[200],
                  child: Text(
                    "사진 첨부 ($photoLength/15)",
                    textAlign: TextAlign.center,
                  ),
                ),
                Container(
                  height: 250,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
                    child: PageView(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      children: List.generate(15, (index) => index)
                          .map(
                            (e) => imagePick(e),
                      )
                          .toList(),
                    ),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                customTextField(
                    hintText: "공지 제목을 입력해주세요.",
                    key: ValueKey(1),
                    onSaved: (value) {
                      theme = value;
                    },
                    validator: (value) {
                      if(value.toString().trim().isEmpty){
                        return "내용을 입력해주세요.";
                      }
                    }),
                SizedBox(
                  height: 16,
                ),
                customTextField(
                    hintText: "공지 내용을 입력해주세요. (550자이내)",
                    key: ValueKey(2),
                    maxLines: 20,
                    onSaved: (value) {
                      notice = value;
                    },
                    validator: (value)  {
                      if(value.toString().trim().isEmpty){
                        return "내용을 입력해주세요.";
                      }
                    }),
                SizedBox(
                  height: 5,
                ),

                SizedBox(
                  height: 16,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    TextButton(onPressed: () async{

                      if(key.currentState!.validate()){
                        key.currentState!.save();

                        HashMap<String,dynamic> map = HashMap();
                        map.putIfAbsent("date", () => Timestamp.now());
                        map.putIfAbsent("notice", () => notice);
                        map.putIfAbsent("theme", () => theme);
                         await db.collection("admin").doc(password).set(map);

                         if(photoLength==0){
                           ScaffoldMessenger.of(context).showSnackBar(
                               SnackBar(content: Text("You have been successfully registered.")));
                           Navigator.of(context).pop();
                         }
                        for(int i=0; i <photoLength; i++){
                          uploadStorage(i+1);
                        }
                        
                      }
                    }, child: Text("등록하기",style: TextStyle(
                      color: Colors.indigo
                    ),)),
                  ],
                ),
                SizedBox(
                  height: 16,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

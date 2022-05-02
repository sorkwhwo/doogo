import 'dart:collection';
import 'dart:io';
import 'package:doogo/screen/buy_screen.dart';
import 'package:google_translator/google_translator.dart';
import 'package:uuid/uuid.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:country_picker/country_picker.dart';

const Color LIGHT_GRAY = Color(0xffdddddd);

class RegisterScreen extends StatefulWidget {
  final goHome;

  const RegisterScreen({super.key, required this.goHome});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  String password = Uuid().v4().substring(0, 8);

  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  FirebaseStorage storage = FirebaseStorage.instance;

  double height = 70;
  List photos = new List.filled(15, null, growable: false);
  int photoLength = 0;
  PageController controller = PageController();

  String? country;

  String? sitename;
  String? domainname;
  String? contentname;
  String? price;
  String? sort;
  String? detail;
  String? member;
  String? year;
  String? netprofit;
  String? day;
  String? managemonth;
  String? enrollname;
  String? enrollphone;
  String? enrollmail;

  String? contactchat;
  String? contactmessage;
  String? contactphone;
  String? dayopen;
  String? domainnameopen;
  String? managemonthopen;
  String? memberopen;
  String? monthopen;
  String? netprofitopen;
  String? phoneopen;
  String? pricestory;
  String? sitenameopen;

  bool checkSitename = false;
  bool checkDomainname = false;
  bool checkPrice = false;
  bool checkApp = false;
  bool checkWebsite = false;
  bool checkYoutube = false;
  bool checkMember = false;
  bool checkYear = false;
  bool checkNetprofit = false;
  bool checkDay = false;
  bool checkManagemonth = false;
  bool checkPhone = false;
  bool checkCall = false;
  bool checkMessage = false;
  bool checkChat = false;

  GlobalKey<FormState> key = GlobalKey();

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
        .collection("products")
        .doc("${auth.currentUser!.email}${password}")
        .update(map);

    if (num == 1) {
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("You have been successfully registered.")));
      widget.goHome();
    }
  }

  void registerPressed() async {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content:
            Text("Checking registration information. Please wait a moment.")));
    if (key.currentState!.validate()) {
      if (country !=null && sort != null && photoLength != 0) {
        if (checkChat == true || checkMessage == true || checkCall == true) {
          key.currentState!.save();
          final avoidData = await db
              .collection("products")
              .where("sitename", isEqualTo: sitename)
              .where("contentname", isEqualTo: contentname)
              .where("domainname", isEqualTo: domainname)
              .where("id", isEqualTo: auth.currentUser!.email)
              .get();

          if (avoidData.docs.length > 0) {
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                content: Text("This product has already been registered.")));
            return;
          }

          HashMap<String, dynamic> response = await Navigator.of(context).push(
              MaterialPageRoute(
                  builder: (context) => BuyScreen(price: price!)));

          if (response == null) {
            return;
          }

          if (checkSitename != false) {
            sitenameopen = "no";
          } else {
            sitenameopen = "ok";
          }
          if (checkDomainname != false) {
            domainnameopen = "no";
          } else {
            domainnameopen = "ok";
          }
          if (checkPrice != false) {
            pricestory = "no";
          } else {
            pricestory = "ok";
          }

          if (checkMember != false) {
            memberopen = "no";
          } else {
            memberopen = "ok";
          }
          if (checkYear != false) {
            monthopen = "no";
          } else {
            monthopen = "ok";
          }
          if (checkNetprofit != false) {
            netprofitopen = "no";
          } else {
            netprofitopen = "ok";
          }
          if (checkDay != false) {
            dayopen = "no";
          } else {
            dayopen = "ok";
          }
          if (checkManagemonth != false) {
            managemonthopen = "no";
          } else {
            managemonthopen = "ok";
          }

          if (checkPhone != false) {
            phoneopen = "no";
          } else {
            phoneopen = "ok";
          }

          if (checkCall == false) {
            contactphone = "no";
          } else {
            contactphone = "ok";
          }

          if (checkMessage == false) {
            contactmessage = "no";
          } else {
            contactmessage = "ok";
          }

          if (checkChat == false) {
            contactchat = "no";
          } else {
            contactchat = "ok";
          }



          HashMap<String, dynamic> map = new HashMap();

          map.putIfAbsent("country", () => country);

          map.putIfAbsent("sitename", () => sitename);
          map.putIfAbsent("domainname", () => domainname);
          map.putIfAbsent("contentname", () => contentname);
          map.putIfAbsent("price", () => price);
          map.putIfAbsent("sort", () => sort);
          map.putIfAbsent("detail", () => detail);

          map.putIfAbsent("member", () => member);
          map.putIfAbsent("month", () => year);
          map.putIfAbsent("netprofit", () => netprofit);
          map.putIfAbsent("day", () => day);
          map.putIfAbsent("managemonth", () => managemonth);

          map.putIfAbsent("enrollname", () => enrollname);
          map.putIfAbsent("enrollphone", () => enrollphone);
          map.putIfAbsent("enrollmail", () => enrollmail);

          map.putIfAbsent("contactchat", () => contactchat);
          map.putIfAbsent("contactmessage", () => contactmessage);
          map.putIfAbsent("contactphone", () => contactphone);

          map.putIfAbsent("sitenameopen", () => sitenameopen);
          map.putIfAbsent("domainnameopen", () => domainnameopen);
          map.putIfAbsent("pricestory", () => pricestory);

          map.putIfAbsent("memberopen", () => memberopen);
          map.putIfAbsent("monthopen", () => monthopen);
          map.putIfAbsent("netprofitopen", () => netprofitopen);
          map.putIfAbsent("dayopen", () => dayopen);
          map.putIfAbsent("managemonthopen", () => managemonthopen);

          map.putIfAbsent("phoneopen", () => phoneopen);

          map.putIfAbsent("id", () => auth.currentUser!.email);
          map.putIfAbsent("date", () => Timestamp.now());

          map.putIfAbsent("language", () => "ko");

          map.putIfAbsent("best", () => response["best"]);
          map.putIfAbsent("recommend", () => response["recommend"]);
          map.putIfAbsent("first", () => response["first"]);
          map.putIfAbsent("jump", () => response["jump"]);
          map.putIfAbsent("admin", () => response["admin"]);
          map.putIfAbsent("sum", () => response["sum"]);

          await db
              .collection("products")
              .doc("${auth.currentUser!.email}$password")
              .set(map);
          for (int i = 0; i < photoLength; i++) {
            uploadStorage(i + 1);
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Please enter your content.")));
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Please enter your content.")));
      }
    }
  }

  Widget customTextfeild({String? detail, required key, required onSaved}) {
    return Padding(
      padding: const EdgeInsets.only(left: 5, top: 5, bottom: 5),
      child: TextFormField(
        keyboardType: (key == ValueKey(4) ||
                key == ValueKey(6) ||
                key == ValueKey(7) ||
                key == ValueKey(8) ||
                key == ValueKey(9) ||
                key == ValueKey(10) ||
                key == ValueKey(12))
            ? TextInputType.number
            : null,
        key: key,
        validator: (value) {
          if (value!.isEmpty) {
            return "Please enter your content.";
          }
        },
        onSaved: onSaved,
        maxLines: detail != null ? 25 : 1,
        textAlignVertical: TextAlignVertical.center,
        cursorColor: Colors.black,
        decoration: InputDecoration(
          enabledBorder:
              OutlineInputBorder(borderSide: BorderSide(color: LIGHT_GRAY)),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: Colors.black, width: 1.5),
          ),
        ),
      ),
    );
  }

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
                  source: ImageSource.gallery, imageQuality: 50);
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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Column(
        children: [
          Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Text(
                        "판매등록",
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.w600),
                      ).translate(),
                    ),
                    Container(
                      width: double.infinity,
                      height: 1,
                      color: Colors.grey[300],
                    ),
                  ])),
          Expanded(
            child: SingleChildScrollView(
              child: Container(
                width: MediaQuery.of(context).size.width,
                child: Form(
                  key: key,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "기본정보",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ).translate(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 2,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                color: Colors.grey[200],
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("사이트 이름").translate()],
                                  ),
                                ),
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(1),
                                      onSaved: (value) {
                                        sitename = value!;
                                      })),
                              Checkbox(
                                  value: checkSitename,
                                  onChanged: (value) {
                                    setState(() {
                                      checkSitename = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "private",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("도메인 주소").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              SizedBox(
                                width: 5,
                              ),
                              Text(
                                "https://",
                                style: TextStyle(
                                    fontSize: 10, fontWeight: FontWeight.w600),
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(2),
                                      onSaved: (value) {
                                        domainname = value!;
                                      })),
                              Checkbox(
                                  value: checkDomainname,
                                  onChanged: (value) {
                                    setState(() {
                                      checkDomainname = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "private",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("콘텐츠 이름").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(3),
                                      onSaved: (value) {
                                        contentname = value!;
                                      })),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("가격").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(4),
                                      onSaved: (value) {
                                        price = value!;
                                      })),
                              Image.asset(
                                "asset/img/dallar.png",
                                width: 15,
                              ),
                              Checkbox(
                                  value: checkPrice,
                                  onChanged: (value) {
                                    setState(() {
                                      checkPrice = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "협상불가",
                                style: TextStyle(fontSize: 10),
                              ).translate()
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("판매 유형").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: Row(
                                children: [
                                  Checkbox(
                                      value: checkApp,
                                      onChanged: (value) {
                                        setState(() {
                                          checkApp = value!;
                                          if (checkApp == true) {
                                            this.sort = "app";
                                            checkWebsite = false;
                                            checkYoutube = false;
                                          }
                                        });
                                      },
                                      activeColor: MAIN_COLOR),
                                  Text(
                                    "App",
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Checkbox(
                                      value: checkWebsite,
                                      onChanged: (value) {
                                        setState(() {
                                          checkWebsite = value!;
                                          if (checkWebsite == true) {
                                            this.sort = "website";
                                            checkApp = false;
                                            checkYoutube = false;
                                          }
                                        });
                                      },
                                      activeColor: MAIN_COLOR),
                                  Text("Website",
                                      style: TextStyle(fontSize: 10)),
                                  Checkbox(
                                      value: checkYoutube,
                                      onChanged: (value) {
                                        setState(() {
                                          checkYoutube = value!;
                                          if (checkYoutube == true) {
                                            this.sort = "youtube";
                                            checkWebsite = false;
                                            checkApp = false;
                                          }
                                        });
                                      },
                                      activeColor: MAIN_COLOR),
                                  Text("Youtube",
                                      style: TextStyle(fontSize: 10)),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Column(
                          children: [
                            Container(
                              padding: EdgeInsets.all(20),
                              width: double.infinity,
                              child: Text(
                                "자세한 설명",
                                textAlign: TextAlign.center,
                              ).translate(),
                              color: Colors.grey[200],
                            ),
                            customTextfeild(
                                key: ValueKey(5),
                                detail: "detail",
                                onSaved: (value) {
                                  detail = value!;
                                }),
                          ],
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "작동정보",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ).translate(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 2,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("모든 회원 수").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(6),
                                      onSaved: (value) {
                                        member = value!;
                                      })),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  "number of people",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Checkbox(
                                  value: checkMember,
                                  onChanged: (value) {
                                    setState(() {
                                      checkMember = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Container(
                                child: Text(
                                  "private",
                                  style: TextStyle(fontSize: 10),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("연간 판매").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(7),
                                      onSaved: (value) {
                                        year = value!;
                                      })),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  "asset/img/dallar.png",
                                  width: 15,
                                ),
                              ),
                              Checkbox(
                                  value: checkYear,
                                  onChanged: (value) {
                                    setState(() {
                                      checkYear = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "private",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("순이익").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(8),
                                      onSaved: (value) {
                                        netprofit = value!;
                                      })),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Image.asset(
                                  "asset/img/dallar.png",
                                  width: 15,
                                ),
                              ),
                              Checkbox(
                                  value: checkNetprofit,
                                  onChanged: (value) {
                                    setState(() {
                                      checkNetprofit = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "private",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("하루에 시청자 수").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(9),
                                      onSaved: (value) {
                                        day = value!;
                                      })),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  "number of people",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Checkbox(
                                  value: checkDay,
                                  onChanged: (value) {
                                    setState(() {
                                      checkDay = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "private",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("운영 월").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(10),
                                      onSaved: (value) {
                                        managemonth = value!;
                                      })),
                              Padding(
                                padding: EdgeInsets.only(left: 5),
                                child: Text(
                                  "month",
                                  style: TextStyle(
                                      fontSize: 10,
                                      fontWeight: FontWeight.w600),
                                ),
                              ),
                              Checkbox(
                                  value: checkManagemonth,
                                  onChanged: (value) {
                                    setState(() {
                                      checkManagemonth = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "private",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: 350,
                          child: Column(
                            children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                width: double.infinity,
                                child: Text(
                                  "사진 첨부 ($photoLength/15)",
                                  textAlign: TextAlign.center,
                                ).translate(),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 5, top: 5, bottom: 5),
                                  child: PageView(
                                    controller: controller,
                                    scrollDirection: Axis.horizontal,
                                    children:
                                        List.generate(15, (index) => index)
                                            .map(
                                              (e) => imagePick(e),
                                            )
                                            .toList(),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Text(
                          "등록정보",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w600),
                        ).translate(),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 2,
                        color: Colors.black,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("이름").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(11),
                                      onSaved: (value) {
                                        enrollname = value!;
                                      })),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("전화").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(12),
                                      onSaved: (value) {
                                        enrollphone = value!;
                                      })),
                              Checkbox(
                                  value: checkPhone,
                                  onChanged: (value) {
                                    setState(() {
                                      checkPhone = value!;
                                    });
                                  },
                                  activeColor: MAIN_COLOR),
                              Text(
                                "private",
                                style: TextStyle(fontSize: 10),
                              )
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("이메일").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: customTextfeild(
                                      key: ValueKey(13),
                                      onSaved: (value) {
                                        enrollmail = value!;
                                      })),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("국가").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Row(
                                      children: [
                                        if (country != null) Expanded(child: Text("$country")),
                                        TextButton(
                                onPressed: () {
                                        showCountryPicker(
                                          context: context,
                                          showPhoneCode: false,
                                          // optional. Shows phone code before the country name.
                                          onSelect: (Country country) {
                                            this.country = country.displayNameNoCountryCode;
                                            setState(() {});
                                          },
                                        );
                                },
                                child: Row(
                                        children: [
                                          Text("선택하기").translate(),
                                        ],
                                ),
                              ),
                                      ],
                                    ),
                                  )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Container(
                          height: height,
                          child: Row(
                            children: [
                              Container(
                                width: 100,
                                height: height,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [Text("연락방법").translate()],
                                  ),
                                ),
                                color: Colors.grey[200],
                              ),
                              Expanded(
                                  child: Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Checkbox(
                                      value: checkCall,
                                      onChanged: (value) {
                                        setState(() {
                                          checkCall = value!;
                                        });
                                      },
                                      activeColor: MAIN_COLOR),
                                  Text(
                                    "call",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Checkbox(
                                      value: checkMessage,
                                      onChanged: (value) {
                                        setState(() {
                                          checkMessage = value!;
                                        });
                                      },
                                      activeColor: MAIN_COLOR),
                                  Text(
                                    "message",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                  Checkbox(
                                      value: checkChat,
                                      onChanged: (value) {
                                        setState(() {
                                          checkChat = value!;
                                        });
                                      },
                                      activeColor: MAIN_COLOR),
                                  Text(
                                    "chat",
                                    style: TextStyle(fontSize: 12),
                                  ),
                                ],
                              )),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 10),
                        width: MediaQuery.of(context).size.width - 20,
                        height: 1,
                        color: Colors.grey[300],
                      ),
                      Container(
                        margin: EdgeInsets.only(left: 25, top: 40),
                        width: MediaQuery.of(context).size.width - 50,
                        height: 45,
                        child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(40)),
                                primary: MAIN_COLOR),
                            onPressed: registerPressed,
                            child: Text(
                              "REGISTER",
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                            )),
                      ),
                      Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 10, top: 40),
                        width: MediaQuery.of(context).size.width - 20,
                        decoration: BoxDecoration(
                            border: Border.all(width: 1, color: LIGHT_GRAY)),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("판매자와 구매자를 연결하는 공간만 제공하고 거래에 개입하지 않으며 책임지지 않습니다.")
                                .translate(),
                            SizedBox(
                              height: 10,
                            ),
                            Text("인앱 충전 후에 판매하고 등록할 수 있습니다.").translate(),
                            SizedBox(
                              height: 10,
                            ),
                            Text("지불이 완료되면 즉시 광고가 진행되므로 지불 후 환불을 받을 수 없습니다.")
                                .translate(),
                            SizedBox(
                              height: 10,
                            ),
                            Text(
                                "(koreans only) 계좌이체를 할 경우, 입금자명과 등록자명이 같아야 합니다."),
                            SizedBox(
                              height: 10,
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Text("아래 등록 사이트는 환불없이 삭제됩니다.").translate(),
                            Text(
                              "도박,미니 홈페이지,페이스북,밴드,토토,말 경주,카지노, 성인 웹사이트",
                              style: TextStyle(color: Colors.grey[500]),
                            ).translate(),
                            Text(
                              "성인용 영화/ 방송/ 국내 극장 또는 방송에 보이지 않는 비디오 콘텐츠를 제공하는 사이트.",
                              style: TextStyle(color: Colors.grey[500]),
                            ).translate(),
                            Text(
                              "불법거래/ 복사와 같은 불법요소가 있는 사이트 및 토런트.",
                              style: TextStyle(color: Colors.grey[500]),
                            ).translate(),
                            Text(
                              "판매와 관련이 없는 교육 및 컨설팅의 내용",
                              style: TextStyle(color: Colors.grey[500]),
                            ).translate(),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

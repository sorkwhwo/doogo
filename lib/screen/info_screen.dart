import 'dart:collection';
import 'package:google_translator/google_translator.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:doogo/screen/chat_screen.dart';
import 'package:doogo/screen/service_center_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/main.dart';

class InfoScreen extends StatefulWidget {
  final String userId;
  final String siteName;
  final String domainName;
  final String contentName;
  final bool? admin;

  const InfoScreen(
      {super.key,
      required this.userId,
      required this.siteName,
      required this.domainName,
      required this.contentName,
      this.admin});

  @override
  State<InfoScreen> createState() => _InfoScreenState();
}

class _InfoScreenState extends State<InfoScreen> {
  QuerySnapshot<Map<String, dynamic>>? productData;
  double height = 70;
  int imgStart = 2;
  int imgEnd = 15;
  int currentPage = 1;

  String? country;
  String? sum;
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

  bool? check;
  GlobalKey<FormState> globalKey = GlobalKey();
  PageController controller = PageController();
  var photos = List.empty(growable: true);

  // String? member;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;

  void buttonOnPressed() async {
    if (widget.admin == true) {
      await db
          .collection("products")
          .doc(productData!.docs[0].id)
          .update({"admin": "ok"});
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text("승인하였습니다.")));
      Navigator.of(context).pop("ok");
      return;
    } else {
      if (widget.userId == auth.currentUser!.email) {
        if (globalKey.currentState!.validate()) {
          globalKey.currentState!.save();

          HashMap<String, dynamic> map = HashMap();
          map.putIfAbsent("sitename", () => sitename);
          map.putIfAbsent("domainname", () => domainname);
          map.putIfAbsent("contentname", () => contentname);
          map.putIfAbsent("detail", () => detail);

          map.putIfAbsent("member", () => member);
          map.putIfAbsent("month", () => year);
          map.putIfAbsent("netprofit", () => netprofit);
          map.putIfAbsent("day", () => day);
          map.putIfAbsent("managemonth", () => managemonth);

          map.putIfAbsent("enrollname", () => enrollname);
          map.putIfAbsent("enrollphone", () => enrollphone);
          map.putIfAbsent("enrollmail", () => enrollmail);
          await db
              .collection("products")
              .doc(productData!.docs[0].id)
              .update(map);

          ScaffoldMessenger.of(context)
              .showSnackBar(SnackBar(content: Text("Correction is complete.")));
          Navigator.of(context).pop("ok");
        }
      } else {
        Navigator.of(context).push(MaterialPageRoute(
            builder: (context) => ChatScreen(counterId: widget.userId)));
      }
    }
  }

  Widget customTextfield(
      {required String initialValue,
      required onSaved,
      required final key,
      int? maxline,
      bool? enabled,
      String? private,
      String? detail}) {
    return Padding(
      padding: key == ValueKey(2)
          ? EdgeInsets.zero
          : detail == null
              ? EdgeInsets.only(left: 10)
              : EdgeInsets.only(top: 10, bottom: 10),
      child: auth.currentUser!.email != widget.userId
          ? GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
              translateFrom: Locale('${counterData!.docs[0]["language"]}'),
              translateTo: Locale('${myData!.docs[0]["language"]}'),
              builder: () {
              if (private == "no") {
                return Text("private",
                    style: TextStyle(fontSize: 12, color: Colors.grey));
              }
              if (key == ValueKey(12) ||
                  key == ValueKey(13) ||
                  key == ValueKey(14)) {
                return Text(
                  initialValue,
                  style: detail != null
                      ? TextStyle(fontSize: 13, color: Colors.black)
                      : TextStyle(fontSize: 12, color: Colors.black),
                );
              }
              return Text(
                initialValue,
                style: detail != null
                    ? TextStyle(fontSize: 13, color: Colors.black)
                    : TextStyle(fontSize: 12, color: Colors.black),
              ).translate();
            })
          : TextFormField(
              validator: (value) {
                if (value!.trim().isEmpty) {
                  return "Please enter your details";
                }
              },
              keyboardType: (key == ValueKey(4) ||
                      key == ValueKey(11) ||
                      key == ValueKey(7) ||
                      key == ValueKey(8) ||
                      key == ValueKey(9) ||
                      key == ValueKey(10) ||
                      key == ValueKey(13))
                  ? TextInputType.number
                  : null,
              onSaved: private == "no" ? null : onSaved,
              key: key,
              cursorColor: Colors.black,
              maxLines: null,
              enabled: private == "no"
                  ? false
                  : enabled == false
                      ? false
                      : widget.userId == auth.currentUser!.email
                          ? true
                          : false,
              decoration: InputDecoration(border: InputBorder.none),
              initialValue: private == "no" ? "private" : initialValue,
              style: detail != null
                  ? TextStyle(
                      fontSize: 13,
                      color: private == "no" ? Colors.grey : Colors.black)
                  : TextStyle(
                      fontSize: 12,
                      color: private == "no" ? Colors.grey : Colors.black),
            ),
    );
  }

  void getData() async {
    productData = await db
        .collection("products")
        .where("sitename", isEqualTo: widget.siteName)
        .where("contentname", isEqualTo: widget.contentName)
        .where("domainname", isEqualTo: widget.domainName)
        .where("id", isEqualTo: widget.userId)
        .get();

    final data = productData!.docs[0];

    setState(() {
      if (data.data().containsKey("country")) {
        country = data["country"];
      }
      sum = data["sum"];
      sitename = data["sitename"];
      domainname = data["domainname"];
      contentname = data["contentname"];
      price = data["price"];
      sort = data["sort"];
      detail = data["detail"];
      member = data["member"];
      year = data["month"];
      netprofit = data["netprofit"];
      day = data["day"];
      managemonth = data["managemonth"];
      enrollname = data["enrollname"];
      enrollphone = data["enrollphone"];
      enrollmail = data["enrollmail"];
      contactchat = data["contactchat"];
      contactmessage = data["contactmessage"];
      contactphone = data["contactphone"];
      dayopen = data["dayopen"];
      domainnameopen = data["domainnameopen"];
      managemonthopen = data["managemonthopen"];
      memberopen = data["memberopen"];
      monthopen = data["monthopen"];
      netprofitopen = data["netprofitopen"];
      phoneopen = data["phoneopen"];
      pricestory = data["pricestory"];
      sitenameopen = data["sitenameopen"];

      photos.add(data["photo1"]);
      for (int i = imgStart; i <= imgEnd; i++) {
        if (data.data().containsKey("photo$i")) {
          photos.add(data["photo$i"]);
        }
      }
    });
  }

  void controllerOn() {}

  @override
  initState() {
    super.initState();

    getData();
    getMyData();
    getCounterData();
    controller.addListener(() {
      if (controller.page!.round() + 1 != currentPage) {
        setState(() {
          currentPage = controller.page!.round() + 1;
        });
      }
    });
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  QuerySnapshot<Map<String, dynamic>>? counterData;
  QuerySnapshot<Map<String, dynamic>>? myData;

  getCounterData() async {
    counterData = await db
        .collection("users")
        .where("id", isEqualTo: widget.userId)
        .get();
    setState(() {});
  }

  getMyData() async {
    myData = await db
        .collection("users")
        .where("id", isEqualTo: auth.currentUser!.email)
        .get();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (productData == null || myData == null || counterData == null) {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(
            strokeWidth: 3,
            color: Colors.grey,
          ),
        ),
      );
    }
    return GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
        translateFrom: Locale('ko'),
        translateTo: Locale('${myData!.docs[0]["language"]}'), builder: () {
      return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Scaffold(
          appBar: AppBar(
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => ServiceCenterScreen()));
                },
                child: Image.asset(
                  "asset/img/sirn.png",
                  color: Colors.white,
                  width: 20,
                ),
              )
            ],
            title: Text("상품정보").translate(),
            backgroundColor: MAIN_COLOR,
          ),
          body: productData == null
              ? Center(
                  child: CircularProgressIndicator(
                    strokeWidth: 3,
                    color: Colors.grey,
                  ),
                )
              : Form(
                  key: globalKey,
                  child: Column(
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: Container(
                            width: MediaQuery.of(context).size.width,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 16,
                                ),
                                Stack(
                                  children: [
                                    Container(
                                      height: 300,
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 10),
                                        child: PageView(
                                            allowImplicitScrolling: true,
                                            controller: controller,
                                            scrollDirection: Axis.horizontal,
                                            children: photos
                                                .map(
                                                  (e) => Image.network(
                                                    e,
                                                    fit: BoxFit.fill,
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width -
                                                            20,
                                                    loadingBuilder: (BuildContext
                                                            context,
                                                        Widget child,
                                                        ImageChunkEvent?
                                                            loadingProgress) {
                                                      if (loadingProgress ==
                                                          null) return child;
                                                      return Center(
                                                        child:
                                                            CircularProgressIndicator(
                                                          color: Colors.grey,
                                                          strokeWidth: 2,
                                                          value: loadingProgress
                                                                      .expectedTotalBytes !=
                                                                  null
                                                              ? loadingProgress
                                                                      .cumulativeBytesLoaded /
                                                                  loadingProgress
                                                                      .expectedTotalBytes!
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
                                            padding: EdgeInsets.symmetric(
                                                horizontal: 15, vertical: 3),
                                            decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                                color: Colors.black
                                                    .withOpacity(0.4)),
                                            child: Text(
                                              "$currentPage/${photos.length}",
                                              style: TextStyle(
                                                  color: Colors.white),
                                            )))
                                  ],
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(10.0),
                                  child: Text(
                                    "기본정보",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ).translate(),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 2,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          color: Colors.grey[200],
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("사이트 이름").translate()
                                              ],
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  sitename = value;
                                                },
                                                key: ValueKey(1),
                                                initialValue: sitename!,
                                                private: sitenameopen))
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("도메인 주소").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        SizedBox(
                                          width: 10,
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  domainname = value;
                                                },
                                                key: ValueKey(2),
                                                initialValue: domainname!,
                                                private: domainnameopen)),
                                        if (domainnameopen == "ok")
                                          TextButton(
                                              onPressed: () async {
                                                final url =
                                                    'https://$domainname';
                                                if (await canLaunch(url)) {
                                                  await launch(url);
                                                } else {
                                                  ScaffoldMessenger.of(context)
                                                      .showSnackBar(SnackBar(
                                                          content: Text(
                                                              "Invalid link.")));
                                                }
                                              },
                                              child: Text(
                                                "링크이동",
                                                style: TextStyle(
                                                    color: Colors.indigo,
                                                    fontSize: 12),
                                              ).translate())
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("콘텐츠 이름").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  contentname = value;
                                                },
                                                key: ValueKey(3),
                                                initialValue: contentname!))
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("가격").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  price = value;
                                                },
                                                key: ValueKey(4),
                                                enabled: false,
                                                initialValue: price!)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Image.asset(
                                          "asset/img/dallar.png",
                                          width: 15,
                                        ),
                                        SizedBox(
                                          width: 16,
                                        ),
                                        Text(
                                          pricestory == "ok" ? "협상가능" : "협상불가",
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("판매 유형").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  sort = value;
                                                },
                                                key: ValueKey(5),
                                                enabled: false,
                                                initialValue: sort!))
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Column(
                                    children: [
                                      Container(
                                        padding: EdgeInsets.all(20),
                                        child: Text(
                                          "자세한 설명",
                                          textAlign: TextAlign.center,
                                        ).translate(),
                                        width:
                                            MediaQuery.of(context).size.width -
                                                20,
                                        color: Colors.grey[200],
                                      ),
                                      customTextfield(
                                          onSaved: (value) {
                                            detail = value;
                                          },
                                          key: ValueKey(6),
                                          initialValue: detail!,
                                          maxline: 100,
                                          detail: "detail")
                                    ],
                                  ),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10, top: 10),
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
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ).translate(),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 2,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("모든 회원").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  member = value;
                                                },
                                                key: ValueKey(7),
                                                initialValue: member!,
                                                private: memberopen)),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "number of people",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
                                          ).translate(),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("연간 판매").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  year = value;
                                                },
                                                key: ValueKey(8),
                                                initialValue: year!,
                                                private: monthopen)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Image.asset(
                                          "asset/img/dallar.png",
                                          width: 15,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("순이익").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  netprofit = value;
                                                },
                                                key: ValueKey(9),
                                                initialValue: netprofit!,
                                                private: netprofitopen)),
                                        SizedBox(
                                          width: 8,
                                        ),
                                        Image.asset(
                                          "asset/img/dallar.png",
                                          width: 15,
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("하루에 시청자 수").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  day = value;
                                                },
                                                key: ValueKey(10),
                                                initialValue: day!,
                                                private: dayopen)),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "number of people",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
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
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("운영 월").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                key: ValueKey(11),
                                                onSaved: (value) {
                                                  managemonth = value;
                                                },
                                                initialValue: managemonth!,
                                                private: managemonthopen)),
                                        Padding(
                                          padding: EdgeInsets.only(left: 5),
                                          child: Text(
                                            "month",
                                            style: TextStyle(
                                                fontSize: 10,
                                                fontWeight: FontWeight.w600),
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
                                    "등록",
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600),
                                  ).translate(),
                                ),
                                Container(
                                  margin: EdgeInsets.only(left: 10),
                                  width: MediaQuery.of(context).size.width - 20,
                                  height: 2,
                                  color: Colors.black,
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("이름").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  enrollname = value;
                                                },
                                                key: ValueKey(12),
                                                initialValue: enrollname!)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("전화").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  enrollphone = value;
                                                },
                                                key: ValueKey(13),
                                                initialValue: enrollphone!,
                                                private: phoneopen)),
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
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("이메일").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: customTextfield(
                                                onSaved: (value) {
                                                  enrollmail = value;
                                                },
                                                key: ValueKey(14),
                                                initialValue: enrollmail!)),
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
                                if (country != null)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      height: height,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: height,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text("국가").translate()
                                                ],
                                              ),
                                            ),
                                            color: Colors.grey[200],
                                          ),
                                          Expanded(
                                              child: Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Text("$country"))),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (country != null)
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 10),
                                  child: Container(
                                    height: height,
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 100,
                                          height: height,
                                          child: Padding(
                                            padding:
                                                const EdgeInsets.only(left: 5),
                                            child: Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text("연락방법").translate()
                                              ],
                                            ),
                                          ),
                                          color: Colors.grey[200],
                                        ),
                                        Expanded(
                                            child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            Checkbox(
                                                value: contactphone == "ok"
                                                    ? true
                                                    : false,
                                                activeColor: MAIN_COLOR,
                                                onChanged: (value) {}),
                                            Text(
                                              "call",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Checkbox(
                                                value: contactmessage == "ok"
                                                    ? true
                                                    : false,
                                                activeColor: MAIN_COLOR,
                                                onChanged: (value) {}),
                                            Text(
                                              "message",
                                              style: TextStyle(fontSize: 10),
                                            ),
                                            Checkbox(
                                                value: contactchat == "ok"
                                                    ? true
                                                    : false,
                                                activeColor: MAIN_COLOR,
                                                onChanged: (value) {}),
                                            Text(
                                              "chat",
                                              style: TextStyle(fontSize: 10),
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
                                if (widget.admin == true)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 10),
                                    child: Container(
                                      height: height,
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 100,
                                            height: height,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [Text("입금금액")],
                                              ),
                                            ),
                                            color: Colors.grey[200],
                                          ),
                                          Expanded(
                                              child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Text(sum!),
                                          )),
                                        ],
                                      ),
                                    ),
                                  ),
                                if (widget.admin == true)
                                  Container(
                                    margin: EdgeInsets.only(left: 10),
                                    width:
                                        MediaQuery.of(context).size.width - 20,
                                    height: 1,
                                    color: Colors.grey[300],
                                  ),
                                Container(
                                  margin: EdgeInsets.only(left: 25, top: 40),
                                  width: MediaQuery.of(context).size.width - 50,
                                  height: 45,
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            40)),
                                                primary: MAIN_COLOR),
                                            onPressed: buttonOnPressed,
                                            child: widget.admin == true
                                                ? Text(
                                                    "승인하기",
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.w600),
                                                  )
                                                : widget.userId ==
                                                        auth.currentUser!.email
                                                    ? Text(
                                                        "수정하기",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ).translate()
                                                    : Text(
                                                        "문의하기",
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.w600),
                                                      ).translate()),
                                      ),
                                      if (widget.admin == true)
                                      SizedBox(
                                        width: 8,
                                      ),
                                      if (widget.admin == true)
                                        Expanded(
                                          child: ElevatedButton(
                                              style: ElevatedButton.styleFrom(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              40)),
                                                  primary: Colors.black),
                                              onPressed: () async{
                                               await db.collection("products").doc(productData!.docs[0].id).delete();
                                               ScaffoldMessenger.of(context)
                                                   .showSnackBar(SnackBar(content: Text("삭제하였습니다.")));
                                               Navigator.of(context).pop("ok");
                                              },
                                              child: Text(
                                                "삭제하기",
                                                style: TextStyle(
                                                    color: MAIN_COLOR,
                                                    fontWeight: FontWeight.w600),
                                              )),
                                        )
                                    ],
                                  ),
                                ),
                                SizedBox(
                                  height: 30,
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
        ),
      );
    });
  }
}

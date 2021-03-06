import 'package:doogo/component/product.dart';
import 'package:doogo/screen/info_screen.dart';
import 'package:doogo/screen/notice_detail_screen.dart';
import 'package:doogo/screen/search_screen.dart';
import 'package:doogo/screen/sort_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_translator/google_translator.dart';

import '../../component/circular_progress_indicator.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Widget getAppbar2(BuildContext context) {
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    return Column(
      children: [
        Container(
          color: MAIN_COLOR,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 15),
                child: Text(
                  "Doogo",
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 35,
                      fontWeight: FontWeight.w700),
                ),
              ),
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "해외 150개 국가의 어플, 유튜브 채널, 웹사이트 매매",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ).translate(),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("글로벌 판매자와 구매자 매매 중개플랫폼").translate(),
              ),
              const SizedBox(
                height: 30,
              ),
              Container(
                padding: EdgeInsets.all(16),
                color: Colors.white,
                child: Row(
                  children: [
                    Text(
                      "공지",
                      style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),
                    ).translate(),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("${notice!["theme"]}",
                        maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                        fontSize: 12
                      ),).translate(),
                    )),
                    GestureDetector(
                      behavior: HitTestBehavior.translucent,
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => NoticeDetailScreen()));
                      },
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Text(
                          "자세한 내용보기 ",
                          style: TextStyle(fontWeight: FontWeight.w700,fontSize: 12),
                        ).translate(),
                      ),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 2,
              ),
              Container(
                height: 50,
                color: Colors.white,
                child: LayoutBuilder(builder: (context, max) {
                  return Row(
                    children: [
                      Expanded(
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SortScreen(
                                            sort: "app",
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "APP",
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                ),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: MAIN_COLOR,
                        width: 2,
                        height: max.maxHeight,
                      ),
                      Expanded(
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SortScreen(
                                            sort: "youtube",
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "YouTube",
                                style: TextStyle(fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      ),
                      Container(
                        color: MAIN_COLOR,
                        width: 2,
                        height: max.maxHeight,
                      ),
                      Expanded(
                        child: Material(
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => SortScreen(
                                            sort: "website",
                                          )));
                            },
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Text(
                                "Website",
                                style: TextStyle(fontWeight: FontWeight.w700),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  );
                }),
              ),
              SizedBox(
                height: 30,
              ),
              Container(
                margin: EdgeInsets.symmetric(horizontal: 16),
                color: Colors.white,
                child: Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                        child: CupertinoSearchTextField(
                            placeholder: "search..",
                            onSubmitted: (value) {
                              if (value.isEmpty) {
                                return;
                              }
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) =>
                                      SearchScreen(search: value)));
                            },
                            backgroundColor: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 30,
              ),
            ],
          ),
        ),
        SizedBox(
          height: 8,
        )
      ],
    );
  }

  QuerySnapshot<Map<String, dynamic>>? jumpDatelist;
  QuerySnapshot<Map<String, dynamic>>? noJumpDatelist;

  void getData() async {
    jumpDatelist = await db
        .collection("products")
        .where("jumpdate", isNull: false)
        .orderBy("jumpdate", descending: true)
        .get();
    setState(() {});
  }

  void getData2() async {
    noJumpDatelist =
        await db.collection("products").orderBy("date", descending: true).get();

    setState(() {});
  }


  DocumentSnapshot<Map<String,dynamic>>? notice;
  void getNotice() async {
    final data = await db.collection("admin").orderBy("date", descending: true).get();

    notice = data.docs[0];
    setState(() {});
  }

  @override
  void initState() {
    super.initState();

    getData();
    getData2();
    getNotice();
  }

  Widget specialDateTime() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
          child: Column(
              children: jumpDatelist!.docs.map((e) {
        if (e["admin"] != "ok" || e["best"] == null) {
          return Container();
        }
        if (e["best"] == "8주") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(date.add(Duration(days: 56)))) {
            return Container();
          }
        } else if (e["best"] == "4달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 4, date.day, date.hour, date.minute))) {
            return Container();
          }
        } else if (e["best"] == "8달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 8, date.day, date.hour, date.minute))) {
            return Container();
          }
        }
        return product(
          url: e["photo1"],
          name: e["contentname"],
          sort: e["sort"],
          price: e["price"],
          priceNegotiate: e["pricestory"],
          allmMembers: e["member"],
          monthSales: e["month"],
          domainName: e["domainname"],
          siteName: e["sitename"],
          id: e["id"],
          memberopen: e["memberopen"],
          monthopen: e["monthopen"],
          reset: () {
            getData();
            getData2();
          },
        );
      }).toList())),
    );
  }

  Widget specail() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
          child: Column(
              children: noJumpDatelist!.docs.map((e) {
        if (e.data().containsKey("jumpdate")) {
          return Container();
        }

        if (e["admin"] != "ok" || e["best"] == null) {
          return Container();
        }
        if (e["best"] == "8주") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(date.add(Duration(days: 56)))) {
            return Container();
          }
        } else if (e["best"] == "4달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 4, date.day, date.hour, date.minute))) {
            return Container();
          }
        } else if (e["best"] == "8달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 8, date.day, date.hour, date.minute))) {
            return Container();
          }
        }
        return product(
          url: e["photo1"],
          name: e["contentname"],
          sort: e["sort"],
          price: e["price"],
          priceNegotiate: e["pricestory"],
          allmMembers: e["member"],
          monthSales: e["month"],
          domainName: e["domainname"],
          siteName: e["sitename"],
          id: e["id"],
          memberopen: e["memberopen"],
          monthopen: e["monthopen"],
          reset: () {
            getData();
            getData2();
          },
        );
      }).toList())),
    );
  }

  Widget recommendDateTime() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
          child: Column(
              children: jumpDatelist!.docs.map((e) {
        if (e["admin"] != "ok" || e["recommend"] == null) {
          return Container();
        }
        if (e["recommend"] == "8주") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(date.add(Duration(days: 56)))) {
            return Container();
          }
        } else if (e["recommend"] == "4달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 4, date.day, date.hour, date.minute))) {
            return Container();
          }
        } else if (e["recommend"] == "8달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 8, date.day, date.hour, date.minute))) {
            return Container();
          }
        }
        return product(
          url: e["photo1"],
          name: e["contentname"],
          sort: e["sort"],
          price: e["price"],
          priceNegotiate: e["pricestory"],
          allmMembers: e["member"],
          memberopen: e["memberopen"],
          monthopen: e["monthopen"],
          monthSales: e["month"],
          domainName: e["domainname"],
          siteName: e["sitename"],
          id: e["id"],
          reset: () {
            getData2();
            getData();
          },
        );
      }).toList())),
    );
  }

  Widget recommend() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
          child: Column(
              children: noJumpDatelist!.docs.map((e) {
        if (e.data().containsKey("jumpdate")) {
          return Container();
        }
        if (e["admin"] != "ok" || e["recommend"] == null) {
          return Container();
        }
        if (e["recommend"] == "8주") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(date.add(Duration(days: 56)))) {
            return Container();
          }
        } else if (e["recommend"] == "4달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 4, date.day, date.hour, date.minute))) {
            return Container();
          }
        } else if (e["recommend"] == "8달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 8, date.day, date.hour, date.minute))) {
            return Container();
          }
        }
        return product(
          url: e["photo1"],
          name: e["contentname"],
          sort: e["sort"],
          price: e["price"],
          priceNegotiate: e["pricestory"],
          allmMembers: e["member"],
          memberopen: e["memberopen"],
          monthopen: e["monthopen"],
          monthSales: e["month"],
          domainName: e["domainname"],
          siteName: e["sitename"],
          id: e["id"],
          reset: () {
            getData();
            getData2();
          },
        );
      }).toList())),
    );
  }

  Widget firstDateTime() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
          child: Column(
              children: jumpDatelist!.docs.map((e) {
        if (e["admin"] != "ok" || e["first"] == null) {
          return Container();
        }
        if (e["first"] == "8주") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(date.add(Duration(days: 56)))) {
            return Container();
          }
        } else if (e["first"] == "4달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 4, date.day, date.hour, date.minute))) {
            return Container();
          }
        } else if (e["first"] == "8달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 8, date.day, date.hour, date.minute))) {
            return Container();
          }
        }
        return product(
          url: e["photo1"],
          name: e["contentname"],
          sort: e["sort"],
          price: e["price"],
          priceNegotiate: e["pricestory"],
          allmMembers: e["member"],
          memberopen: e["memberopen"],
          monthopen: e["monthopen"],
          monthSales: e["month"],
          domainName: e["domainname"],
          siteName: e["sitename"],
          id: e["id"],
          reset: () {
            getData2();
            getData();
          },
        );
      }).toList())),
    );
  }

  Widget first() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
          child: Column(
              children: noJumpDatelist!.docs.map((e) {
        if (e.data().containsKey("jumpdate")) {
          return Container();
        }
        if (e["admin"] != "ok" || e["first"] == null) {
          return Container();
        }
        if (e["first"] == "8주") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(date.add(Duration(days: 56)))) {
            return Container();
          }
        } else if (e["first"] == "4달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 4, date.day, date.hour, date.minute))) {
            return Container();
          }
        } else if (e["first"] == "8달") {
          DateTime date = e["date"].toDate();
          if (DateTime.now().isAfter(DateTime(
              date.year, date.month + 8, date.day, date.hour, date.minute))) {
            return Container();
          }
        }
        return product(
          url: e["photo1"],
          name: e["contentname"],
          memberopen: e["memberopen"],
          monthopen: e["monthopen"],
          sort: e["sort"],
          price: e["price"],
          priceNegotiate: e["pricestory"],
          allmMembers: e["member"],
          monthSales: e["month"],
          domainName: e["domainname"],
          siteName: e["sitename"],
          id: e["id"],
          reset: () {
            getData();
            getData2();
          },
        );
      }).toList())),
    );
  }

  Widget normal() {
    return SliverToBoxAdapter(
      child: SingleChildScrollView(
          child: Column(
              children: noJumpDatelist!.docs.map((e) {
        if (e["admin"] != "ok") {
          return Container();
        }
        return normalProduct(
          url: e["photo1"],
          name: e["contentname"],
          memberopen: e["memberopen"],
          monthopen: e["monthopen"],
          sort: e["sort"],
          price: e["price"],
          priceNegotiate: e["pricestory"],
          allmMembers: e["member"],
          monthSales: e["month"],
          domainName: e["domainname"],
          siteName: e["sitename"],
          id: e["id"],
          reset: () {
            getData();
            getData2();
          },
        );
      }).toList())),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (jumpDatelist == null || noJumpDatelist == null || notice==null) {
      return Center(
        child: circularProgressIndicator(),
      );
    }
    return Column(
      children: [
        Container(
          color: MAIN_COLOR,
          height: MediaQuery.of(context).padding.top,
        ),
        Expanded(
          child: CustomScrollView(
            physics: ClampingScrollPhysics(),
            slivers: [
              SliverToBoxAdapter(
                child: getAppbar2(context),
              ),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 8),
                  child: Text(
                    "Special",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              specialDateTime(),
              specail(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    "Recommendation",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              recommendDateTime(),
              recommend(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    "Preferential",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              firstDateTime(),
              first(),
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.only(left: 8, top: 20),
                  child: Text(
                    "Normal",
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
              normal()
            ],
          ),
        ),
      ],
    );
  }
}

class normalProduct extends StatefulWidget {
  final String url;
  final String name;
  final String sort;
  final String price;
  final String priceNegotiate;
  final String allmMembers;
  final String monthSales;
  final String domainName;
  final String siteName;
  final String id;
  final bool? admin;
  final VoidCallback reset;
  final String memberopen;
  final String monthopen;

  const normalProduct(
      {super.key,
      required this.url,
      required this.name,
      required this.sort,
      required this.price,
      required this.priceNegotiate,
      required this.allmMembers,
      required this.monthSales,
      required this.domainName,
      required this.siteName,
      required this.id,
      this.admin,
      required this.reset,
      required this.memberopen,
      required this.monthopen});

  @override
  State<normalProduct> createState() => _normalProductState();
}

class _normalProductState extends State<normalProduct> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot<Map<String, dynamic>>? counterData;
  QuerySnapshot<Map<String, dynamic>>? myData;

  @override
  initState() {
    super.initState();

    getMyData();
    getCounterData();
  }

  getCounterData() async {
    counterData =
        await db.collection("users").where("id", isEqualTo: widget.id).get();
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
    if (myData == null || counterData == null) {
      return Container();
    }
    return GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
        translateFrom: Locale('${counterData!.docs[0]["language"]}'),
        translateTo: Locale('${myData!.docs[0]["language"]}'), builder: () {
      return Material(
        child: InkWell(
          onTap: () async {
            final response = await Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => InfoScreen(
                          userId: widget.id,
                          contentName: widget.name,
                          domainName: widget.domainName,
                          siteName: widget.siteName,
                        )));

            if (response == "ok") {
              widget.reset();
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Column(
              children: [
                SizedBox(
                  height: 8,
                ),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        widget.name,
                        style: TextStyle(
                            fontSize: 12, fontWeight: FontWeight.w400),
                      ).translate(),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Image.asset(
                      "asset/img/${widget.sort}.png",
                      width: 13,
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Text(
                      "${widget.price}",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                    ),
                    Image.asset("asset/img/dallar.png", width: 12),
                    SizedBox(
                      width: 8,
                    ),
                    widget.priceNegotiate == "ok"
                        ? Text(
                            "Negotiable",
                            style: TextStyle(
                                color: Colors.grey[500], fontSize: 12),
                          )
                        : Text("non Negotiable",
                            style: TextStyle(
                                fontSize: 12, color: Colors.grey[500])),
                    SizedBox(
                      width: 8,
                    ),
                    if (counterData!.docs[0]["on"] == "on")
                      Text(
                        "on",
                        style: TextStyle(fontSize: 10, color: Colors.green,fontWeight: FontWeight.w600),
                      ),
                    SizedBox(
                      width: 8,
                    ),
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(top: 8),
                  height: 1,
                  color: Colors.grey[300],
                )
              ],
            ),
          ),
        ),
      );
    });
  }
}

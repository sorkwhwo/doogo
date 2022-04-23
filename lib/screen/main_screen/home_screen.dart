import 'package:doogo/component/product.dart';
import 'package:doogo/screen/info_screen.dart';
import 'package:doogo/screen/notice_detail_screen.dart';
import 'package:doogo/screen/search_screen.dart';
import 'package:doogo/screen/sort_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/start.dart';
import 'package:firebase_auth/firebase_auth.dart';

class HomeScreen extends StatefulWidget {
  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;

  Widget getAppbar() {
    return SliverAppBar(
      backgroundColor: MAIN_COLOR,
      title: Text(
        "Doogo",
        style: TextStyle(
            color: Colors.black, fontSize: 35, fontWeight: FontWeight.w700),
      ),
    );
  }

  Widget getAppbar2() {
    return Column(
      children: [
        Container(
          color: MAIN_COLOR,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.only(left: 16, right: 16, top: 16),
                child: Text(
                  "해외 150개 국가의 어플, 유튜브 채널, 웹사이트 매매",
                  style: TextStyle(
                    fontSize: 20,
                  ),
                ),
              ),
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 16),
                child: Text("글로벌 판매자와 구매자 매매 중개플랫폼"),
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
                      "공지사항",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      child: Text("Doogo의 공지사항입니다.."),
                    )),
                    GestureDetector(
                      onTap: (){
                        Navigator.of(context).push(MaterialPageRoute(builder: (context) =>NoticeDetailScreen()));
                      },
                      child: Text(
                        "자세한 내용보기",
                        style: TextStyle(fontWeight: FontWeight.w700),
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
                        padding: EdgeInsets.symmetric(vertical: 5,horizontal: 8),
                        child: CupertinoSearchTextField(
                            placeholder: "키워드로 검색하십시오.",
                          onSubmitted: (value){
                              if(value.isEmpty){
                                return;
                              }
                              Navigator.of(context).push(MaterialPageRoute(builder: (context) =>SearchScreen(search : value)));
                          },
                          backgroundColor: Colors.white
                        ),
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


  Widget normalProduct(String url, String name, String sort, String price,
      String priceNegotiate, String allmMembers, String monthSales,String domainName,String siteName,String id) {
    return Material(
      child: InkWell(
        onTap: ()  async{
        final response = await  Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => InfoScreen(
                    userId: id,
                    contentName: name,
                    domainName: domainName,
                    siteName: siteName,
                  )));

        if(response=="ok"){
          getData2();
          getData();
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
                  Container(
                    width: 200,
                    child: Text(
                      name,
                      style:
                          TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Image.asset(
                    "asset/img/$sort.png",
                    width: 13,
                  ),
                  SizedBox(
                    width: 8,
                  ),
                  Text(
                    "$price",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
                  ),
                  Image.asset("asset/img/dallar.png", width: 12),
                  SizedBox(
                    width: 8,
                  ),
                  priceNegotiate == "ok"
                      ? Text(
                          "협상",
                          style:
                              TextStyle(color: Colors.grey[500], fontSize: 12),
                        )
                      : Text("비 협상",
                          style:
                              TextStyle(fontSize: 12, color: Colors.grey[500])),
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
  }

  QuerySnapshot<Map<String, dynamic>>? jumpDatelist;
  QuerySnapshot<Map<String, dynamic>>? noJumpDatelist;

  void getData() async {
    print("getdata");
    jumpDatelist = await db
        .collection("products")
        .where("jumpdate", isNull: false)
        .orderBy("jumpdate", descending: true)
        .get();
    setState(() {});
  }
  void getData2() async {
    print("getdata2");
    noJumpDatelist =
    await db.collection("products").orderBy("date", descending: true).get();

    setState(() {});
  }
  @override
  void initState() {
    super.initState();

    getData();
    getData2();
  }

  Widget specialDateTime() {
    return SliverList(
        delegate: SliverChildListDelegate(jumpDatelist!.docs.map((e) {
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
      return product(url:e["photo1"],name: e["contentname"], sort:e["sort"],price:e["price"],
          priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],memberopen: e["memberopen"],monthopen: e["monthopen"],reset: (){
        getData();
        getData2();
        },);
    }).toList()));
  }

  Widget specail() {
    return SliverList(
        delegate: SliverChildListDelegate(noJumpDatelist!.docs.map((e) {
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
      return product(url:e["photo1"],name: e["contentname"], sort:e["sort"],price:e["price"],
          priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],memberopen: e["memberopen"],monthopen: e["monthopen"],reset: (){
        getData();
        getData2();
        },);   }).toList()));
  }

  Widget recommendDateTime() {
    return SliverList(
        delegate: SliverChildListDelegate(jumpDatelist!.docs.map((e) {
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
      return product(url:e["photo1"],name: e["contentname"], sort:e["sort"],price:e["price"],
          priceNegotiate:  e["pricestory"],allmMembers: e["member"],memberopen: e["memberopen"],monthopen: e["monthopen"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: (){
        getData2();
          getData();
        },);  }).toList()));
  }

  Widget recommend() {
    return SliverList(
        delegate: SliverChildListDelegate(noJumpDatelist!.docs.map((e) {
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
      return product(url:e["photo1"],name: e["contentname"], sort:e["sort"],price:e["price"],
          priceNegotiate:  e["pricestory"],allmMembers: e["member"],memberopen: e["memberopen"],monthopen: e["monthopen"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: (){
        getData();
        getData2();
        },); }).toList()));
  }

  Widget firstDateTime() {
    return SliverList(
        delegate: SliverChildListDelegate(jumpDatelist!.docs.map((e) {
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
      return product(url:e["photo1"],name: e["contentname"], sort:e["sort"],price:e["price"],
          priceNegotiate:  e["pricestory"],allmMembers: e["member"],memberopen: e["memberopen"],monthopen: e["monthopen"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: (){
        getData2();
        getData();
        },); }).toList()));
  }

  Widget first() {
    return SliverList(
        delegate: SliverChildListDelegate(noJumpDatelist!.docs.map((e) {
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
      return product(url:e["photo1"],name: e["contentname"],memberopen: e["memberopen"],monthopen: e["monthopen"], sort:e["sort"],price:e["price"],
          priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: (){
        getData();
        getData2();
        },); }).toList()));
  }

  Widget normal() {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
            childCount: noJumpDatelist!.docs.length, (context, index) {
      final e = noJumpDatelist!.docs[index];
      if (e["admin"] != "ok") {
        return Container();
      }
      return normalProduct(e["photo1"], e["contentname"], e["sort"], e["price"],
          e["pricestory"], e["member"], e["month"],e["domainname"],e["sitename"],e["id"]);
    }));
  }

  @override
  Widget build(BuildContext context) {
    if (jumpDatelist == null || noJumpDatelist == null) {
      return Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
          strokeWidth: 3,
        ),
      );
    }
    return CustomScrollView(
      slivers: [
        getAppbar(),
        SliverToBoxAdapter(
          child: getAppbar2(),
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
    );
  }
}

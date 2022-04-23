import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/product.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/start.dart';
import 'package:firebase_auth/firebase_auth.dart';


class SortScreen extends StatefulWidget {
  final String sort;

  const SortScreen(
      {super.key,
      required this.sort});

  @override
  State<SortScreen> createState() => _SortScreenState();
}

class _SortScreenState extends State<SortScreen> {
  FirebaseAuth auth = FirebaseAuth.instance;
FirebaseFirestore db = FirebaseFirestore.instance;

  QuerySnapshot<Map<String, dynamic>>? jumpDatelist;
  QuerySnapshot<Map<String, dynamic>>? noJumpDatelist;

  @override
  initState(){
    super.initState();
    getData();
    getData2();
  }

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

  Widget getJumpDateList() {
    return SliverList(
        delegate: SliverChildListDelegate(jumpDatelist!.docs.map((e) {
      if (e["sort"] == this.widget.sort && e["admin"] == "ok") {
        return product(url:e["photo1"],memberopen: e["memberopen"],monthopen: e["monthopen"],name: e["contentname"], sort:e["sort"],price:e["price"],
            priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: (){
          getData();
          getData2();
          },);
      }
      return Container();
    }).toList()));
  }

  Widget getNoJumpDateList() {
    return SliverList(
        delegate: SliverChildListDelegate(noJumpDatelist!.docs.map((e) {
      if (e.data().containsKey("jumpdate")) {
        return Container();
      }

      if (e["sort"] == this.widget.sort && e["admin"] == "ok") {
        return product(url:e["photo1"],memberopen: e["memberopen"],monthopen: e["monthopen"],name: e["contentname"], sort:e["sort"],price:e["price"],
            priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: (){
          getData();
          getData2();
          },);
      }
      return Container();
    }).toList()));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          title: Text(widget.sort),
        ),
        body:
        (noJumpDatelist !=null && jumpDatelist !=null)?

        CustomScrollView(
          slivers: [
            getJumpDateList(),
            getNoJumpDateList(),
          ],
        ) : Center(
          child: circularProgressIndicator(),
        ));
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/product.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class AllProductWaitingScreen extends StatefulWidget {
  const AllProductWaitingScreen({Key? key}) : super(key: key);

  @override
  State<AllProductWaitingScreen> createState() => _AllProductWaitingScreenState();
}

class _AllProductWaitingScreenState extends State<AllProductWaitingScreen> {

  FirebaseFirestore db =FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot<Map<String, dynamic>>? dataList;

  @override
  void initState(){
    super.initState();
    getData();
  }


  void getData() async{
    dataList = await db.collection("products").where("admin",isNull: true).orderBy("date",descending: true).get();
    setState((){
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          title: Text("승인대기매물"),

        ),
        body: dataList==null?Center(
          child: CircularProgressIndicator(
            color: Colors.grey,
            strokeWidth: 2,
          ),
        ):SingleChildScrollView(
          child: Column(
            children: dataList!.docs.map((e) => product(url:e["photo1"],memberopen: e["memberopen"],monthopen: e["monthopen"],name: e["contentname"], sort:e["sort"],price:e["price"],
                priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],admin : true,reset:getData)).toList(),
          ),
        )
    );
  }
}



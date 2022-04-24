import 'dart:collection';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/admin_email.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/product.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class SearchScreen extends StatefulWidget {

  final String search;

  const SearchScreen({super.key, required this.search});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {

  QuerySnapshot<Map<String, dynamic>>? data;
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;


  @override
  initState() {
    super.initState();

    getData();
  }

  void getData() async {
    data = await db.collection("products").orderBy("date").get();

    setState((){

    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_COLOR,
        title: Text("검색결과"),
      ),
      body: data == null ? Center(
        child: circularProgressIndicator(),
      ) : ListView(
        children: data!.docs.map((e) {
          if(e["contentname"].toString().contains(widget.search)){
            return product(url:e["photo1"],name: e["contentname"],memberopen: e["memberopen"],monthopen: e["monthopen"], sort:e["sort"],price:e["price"],
                priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: getData,);
          }else{
            return Container();
          }

        }).toList(),
      ),
    );
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/component/circular_progress_indicator.dart';
import 'package:doogo/component/product.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';

class MyWaitingProductScreen extends StatefulWidget {
  const MyWaitingProductScreen({Key? key}) : super(key: key);

  @override
  State<MyWaitingProductScreen> createState() => _MyWaitingProductScreenState();
}

class _MyWaitingProductScreenState extends State<MyWaitingProductScreen> {

  FirebaseFirestore db =FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot<Map<String, dynamic>>? dataList;

  @override
  void initState(){
    super.initState();
    getData();
    getMyData();
  }


  void getData() async{
    dataList = await db.collection("products").where("id",isEqualTo: auth.currentUser!.email).where("admin",isNull: true).orderBy("date",descending: true).get();
    setState((){
    });
  }


  QuerySnapshot<Map<String,dynamic>>? myData;
  getMyData() async{
    myData =  await db.collection("users").where("id",isEqualTo: auth.currentUser!.email).get();
    setState((){

    });
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: MAIN_COLOR,
        title: GoogleTranslatorInit("AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
            translateFrom: Locale('ko'),
            translateTo: Locale('${myData!.docs[0]["language"]}'),
          builder: () {
            return Text("승인대기").translate();
          }
        ),

      ),
      body: dataList==null?Center(
        child: CircularProgressIndicator(
          color: Colors.grey,
          strokeWidth: 2,
        ),
      ):SingleChildScrollView(
        child: Column(
          children: dataList!.docs.map((e) => product(url:e["photo1"],memberopen: e["memberopen"],monthopen: e["monthopen"],name: e["contentname"], sort:e["sort"],price:e["price"],
              priceNegotiate:  e["pricestory"],allmMembers: e["member"],monthSales: e["month"],domainName:e["domainname"],siteName: e["sitename"],id:e["id"],reset: getData,)).toList(),
        ),
      )
    );
  }
}



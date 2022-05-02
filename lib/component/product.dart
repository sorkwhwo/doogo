import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/screen/info_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_translator/google_translator.dart';

class product extends StatefulWidget {
  final bool? jumpAndDelete;
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

  const product({Key? key,
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
    this.jumpAndDelete,
    required this.reset,
    required this.memberopen,
    required this.monthopen})
      : super(key: key);

  @override
  State<product> createState() => _productState();
}

class _productState extends State<product> {
  FirebaseFirestore db = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  QuerySnapshot<Map<String,dynamic>>? counterData;
  QuerySnapshot<Map<String,dynamic>>? myData;
  QuerySnapshot<Map<String,dynamic>>? productData;

  @override
  initState(){
    super.initState();

    getMyData();
    getCounterData();
    getProductData();
  }


  @override

  getCounterData() async{
    counterData =  await db.collection("users").where("id",isEqualTo: widget.id).get();
    setState((){

    });
  }

  getMyData() async{
    myData =  await db.collection("users").where("id",isEqualTo: auth.currentUser!.email).get();
    setState((){

    });
  }

  getProductData() async{
    productData = await db.collection("products").where("id",isEqualTo: widget.id).where("contentname",isEqualTo: widget.name)
        .where("domainname",isEqualTo: widget.domainName)
        .where("sitename",isEqualTo: widget.siteName).get();

    setState((){

    });

  }
  @override
  Widget build(BuildContext context) {

    if(myData ==null || counterData ==null || productData==null){

      return Container();
    }
    return GoogleTranslatorInit(
        "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
        translateFrom: Locale('ko'),
        translateTo: Locale('${myData!.docs[0]["language"]}'),
        builder: () {
          return Material(
            child: InkWell(
              onTap: () async {
                final response = await Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) =>
                            InfoScreen(
                                userId: widget.id,
                                contentName: widget.name,
                                domainName: widget.domainName,
                                siteName: widget.siteName,
                                admin: widget.admin)));

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
                        Image.network(
                          widget.url,
                          fit: BoxFit.fill,
                          width: 130,
                          height: 110,
                          loadingBuilder: (BuildContext context, Widget child,
                              ImageChunkEvent? loadingProgress) {
                            if (loadingProgress == null) return child;
                            return Container(
                              width: 140,
                              height: 110,
                              child: Center(
                                child: CircularProgressIndicator(
                                  color: Colors.grey,
                                  strokeWidth: 2,
                                  value: loadingProgress.expectedTotalBytes !=
                                      null
                                      ? loadingProgress.cumulativeBytesLoaded /
                                      loadingProgress.expectedTotalBytes!
                                      : null,
                                ),
                              ),
                            );
                          },
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              GoogleTranslatorInit(
                                  "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
                                  translateFrom: Locale('${counterData!.docs[0]["language"]}'),
                                  translateTo: Locale('${myData!.docs[0]["language"]}'),
                                builder: () {
                                  return Text(
                                    widget.name,
                                    style: TextStyle(
                                        fontSize: 15, fontWeight: FontWeight.w400),
                                  ).translate();
                                }
                              ),
                              SizedBox(
                                height: 16,
                              ),
                              Row(
                                children: [
                                  Image.asset(
                                    "asset/img/${widget.sort}.png",
                                    width: 15,
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  Text(
                                    "${widget.price}",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold),
                                  ),
                                  Image.asset(
                                      "asset/img/dallar.png", width: 13),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  widget.priceNegotiate == "ok"
                                      ? GoogleTranslatorInit(
                                      "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
                                      translateFrom: Locale('ko'),
                                      translateTo: Locale('${myData!.docs[0]["language"]}'),
                                        builder: () {
                                          return Text(
                                    "협상가능",
                                    style: TextStyle(
                                            color: Colors.grey[500], fontSize: 12),
                                  ).translate();
                                        }
                                      )
                                      : GoogleTranslatorInit(
                                      "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
                                      translateFrom: Locale('ko'),
                                      translateTo: Locale('${myData!.docs[0]["language"]}'),
                                      builder: () {
                                        return Text(
                                          "협상불가",
                                          style: TextStyle(
                                              color: Colors.grey[500], fontSize: 12),
                                        ).translate();
                                      }
                                  ),
                                  SizedBox(
                                    width: 8,
                                  ),
                                  if(counterData!.docs[0]["on"] =="on")
                                  Text("on", style: TextStyle(
                                      fontSize: 10, color: Colors.green,fontWeight: FontWeight.w600
                                  ),)
                                ],
                              ),
                              SizedBox(
                                height: 10,
                              ),
                              widget.memberopen == "ok"
                                  ? Text("모든 회원 수 : ${widget.allmMembers}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey[500])).translate()
                                  : Row(
                                    children: [
                                      Text("모든 회원 수 : ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey[500])).translate(),
                                      Text("private",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey[500]))
                                    ],
                                  ),
                              widget.monthopen == "ok"
                                  ? Row(
                                children: [
                                  Text("연간 판매 : ${widget.monthSales}",
                                      style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[500])).translate(),
                                  Image.asset(
                                    "asset/img/dallar.png",
                                    width: 10,
                                  )
                                ],
                              )
                                  : Row(
                                    children: [
                                      Text("연간 판매 : ",
                                      style: TextStyle(
                                          fontSize: 12, color: Colors.grey[500])).translate(),
                                      Text("private",
                                          style: TextStyle(
                                              fontSize: 12, color: Colors.grey[500]))
                                    ],
                                  ),

                              if(widget.jumpAndDelete!=null)
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  if(widget.jumpAndDelete!=null &&(productData!.docs[0]["jump"] !="0" &&productData!.docs[0]["jump"] !=null))
                                  TextButton(onPressed: (){
                                    showDialog(context: context,
                                        builder: (context){

                                      return GoogleTranslatorInit(
                                          "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
                                          translateFrom: Locale('ko'),
                                          translateTo: Locale('${myData!.docs[0]["language"]}'),
                                        builder: () {
                                          return AlertDialog(
                                            title: Text("점프기능").translate(),
                                            content: Text("점프기능을 사용하시겠습니까 ? \n현재${productData!.docs[0]["jump"]}번의 점프기능을 사용할 수 있습니다.").translate(),
                                            actions: [
                                              TextButton(onPressed: () async{
                                              await db.collection("products").doc(productData!.docs[0].id).update(
                                                    {"jumpdate":Timestamp.now(),
                                                    "jump":(int.parse(productData!.docs[0]["jump"])-1).toString()});
                                              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("jump is complete.")));
                                              widget.reset();
                                              getProductData();
                                              Navigator.of(context).pop();
                                              }, child: Text("확인").translate()),
                                              TextButton(onPressed: (){
                                                Navigator.of(context).pop();

                                              }, child: Text("취소").translate())
                                            ],
                                          );
                                        }
                                      );
                                        });
                                  }, child: Text(
                                    "Jump"
                                  )),
                                  TextButton(onPressed: (){
                                    showDialog(context: context,
                                        builder: (context){

                                          return GoogleTranslatorInit(
                                              "AIzaSyByt9uRm_-J13b3Uyo7F-PQD9z2ECqSxtQ",
                                              translateFrom: Locale('ko'),
                                              translateTo: Locale('${myData!.docs[0]["language"]}'),
                                            builder: () {
                                              return AlertDialog(

                                                title: Text("상품삭제").translate(),
                                                content: Text("이 상품을 삭제하시겠습니까 ?").translate(),
                                                actions: [
                                                  TextButton(onPressed: () async{

                                                  await db.collection("products").doc(productData!.docs[0].id).delete();
                                                  widget.reset();
                                                  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Deletion is complete.")));
                                                  Navigator.of(context).pop();

                                                  }, child: Text("확인").translate()),
                                                  TextButton(onPressed: (){
                                                    Navigator.of(context).pop();
                                                  }, child: Text("취소").translate())
                                                ],
                                              );
                                            }
                                          );
                                        });
                                  }, child: Text(
                                      "Delete"
                                  )),
                                ],
                              )
                            ],
                          ),
                        )
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
    );
  }
}

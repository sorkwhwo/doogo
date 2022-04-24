import 'dart:collection';

import 'package:doogo/main.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class BuyScreen extends StatefulWidget {
  final String price;

  const BuyScreen({super.key, required this.price});
  @override
  State<BuyScreen> createState() => _BuyScreenState();
}

class _BuyScreenState extends State<BuyScreen> {
  double height = 70;
  bool checkSpecial = true;
  bool checkRecommend = true;
  bool checkPreferential = true;
  bool checkJump = true;


  bool checkSpecial8week = true;
  bool checkSpecial4month = false;
  bool checkSpecial8moth = false;

  bool checkRecommend8week = true;
  bool checkRecommend4month = false;
  bool checkRecommend8moth = false;

  bool checkFirst8week = true;
  bool checkFirst4month = false;
  bool checkFirst8moth = false;

  bool checkJump8week = true;
  bool checkJump4month = false;
  bool checkJump8moth = false;

  bool checkBuyTransfer = false;
  bool checkBuyApp = true;

  int base = 0;
  int special = 50000;
  int recommend = 40000;
  int preferential = 30000;
  int jump = 40000;
  int sum = 0 ;





  @override
  initState(){
    super.initState();

setState((){
  setBasePrice();
});

  }



  String intToMoney(int price){


    return NumberFormat('###,###,###,###').format(price);
  }



  void resetSum(){
    sum = base+special+recommend+preferential+jump;
  }
  void setBasePrice(){

    if(int.parse(widget.price)<1000000){
      base =30000;
    }else if(int.parse(widget.price)<10000000){
      base=50000;
    }else if(int.parse(widget.price)<50000000){
      base=70000;
    }else if(int.parse(widget.price)<100000000){
      base=100000;
    }else{
      base=150000;
    }

    sum = base+special+recommend+preferential+jump;
  }

  AppBar customAppbar() {
    return AppBar(
      backgroundColor: MAIN_COLOR,
      title: Text("결제"),
    );
  }


  Widget customText2({required String text,String? bank}){

    return Text(text,style: TextStyle(
        fontSize: 12,fontWeight: bank!=null?FontWeight.w600:FontWeight.normal
    ));
  }

  Widget customText(String text){

    return Padding(
      padding: EdgeInsets.only(left: 5),
      child: Text(text,style: TextStyle(
        fontSize: 10
      ),),
    );
  }
  Widget customPrice(String price){

    return Text(price,style: TextStyle(
      fontWeight: FontWeight.w700
    ),);
  }

  Widget customCheckbox(
      {required bool val, required final onChanged, required String string}) {
    return Row(
      children: [
        Checkbox(value: val, onChanged: onChanged, activeColor: MAIN_COLOR),
        Text(
          string,
          style: TextStyle(fontSize: 9),
        ),
      ],
    );
  }

  Widget top() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10),
          child: Text(
            "결제정보",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
          ),
        ),
        Container(
          width: MediaQuery.of(context).size.width - 20,
          height: 2,
          color: Colors.black,
        )
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: customAppbar(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: SingleChildScrollView(
            child: Column(
                children: [
          top(),

          Container(
            width: MediaQuery.of(context).size.width - 20,
            child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Text(
                  "서비스 유형",
                  textAlign: TextAlign.center,
                )),
            color: Colors.grey[200],
          ),
          Row(
            children: [
              customCheckbox(
                  val: checkSpecial,
                  string: "specail",
                  onChanged: (value) {
                    setState(() {
                      checkSpecial = value;
                      if(checkSpecial ==false){
                        special = 0;
                        resetSum();

                      }else{
                        special = 50000;
                        resetSum();
                        checkSpecial8week = true;
                        checkSpecial4month = false;
                        checkSpecial8moth= false;
                      }
                    });
                  }),
              customCheckbox(
                  val: checkRecommend,
                  string: "recommend",
                  onChanged: (value) {
                    setState(() {
                      checkRecommend = value;
                      if(checkRecommend ==false){
                        recommend = 0;
                        resetSum();
                      }else{
                        recommend = 40000;
                        resetSum();
                        checkRecommend8moth = false;
                        checkRecommend4month = false;
                        checkRecommend8week= true;
                      }
                    });
                  }),
              customCheckbox(
                  val: checkPreferential,
                  string: "preferential",
                  onChanged: (value) {
                    setState(() {
                      checkPreferential = value;
                      if(checkPreferential ==false){
                        preferential = 0;
                        resetSum();
                      }else{
                        preferential = 30000;
                        resetSum();
                        checkFirst8moth = false;
                        checkFirst4month = false;
                        checkFirst8week= true;
                      }
                    });
                  }),
              customCheckbox(
                  val: checkJump,
                  string: "jump",
                  onChanged: (value) {
                    setState(() {
                      checkJump = value;
                      if(checkJump ==false){
                        jump = 0;
                        resetSum();
                      }else{
                        jump = 40000;
                        resetSum();

                        checkJump8moth = false;
                        checkJump4month = false;
                        checkJump8week= true;
                      }
                    });
                  }),
            ],
          ),



                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "지불 포인트",
                          textAlign: TextAlign.center,
                        )),
                    color: Colors.grey[200],
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(vertical: 10),
                    child: Row(
                      children: [
                        Expanded(child: customText("등록")),
                        customPrice("${intToMoney(base)}"),
                      ],
                    ),
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[500],
                  ),
                  if(checkSpecial)
                  Row(
                    children: [
                      customText("special"),

                      Expanded(
                        child: Row(
                          children: [
                            customCheckbox(
                                val: checkSpecial8week,
                                string: "8weeks",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkSpecial8week){
                                      return;
                                    }
                                    checkSpecial8week = value;
                                    special = 50000;
                                    checkSpecial8moth=false;
                                    checkSpecial4month = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkSpecial4month,
                                string: "4months",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkSpecial4month){
                                      return;
                                    }
                                    checkSpecial4month = value;
                                    special = 80000;
                                    checkSpecial8moth=false;
                                    checkSpecial8week = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkSpecial8moth,
                                string: "8months",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkSpecial8moth){
                                      return;
                                    }
                                    checkSpecial8moth = value;
                                    special = 120000;
                                    checkSpecial4month=false;
                                    checkSpecial8week = false;
                                    resetSum();
                                  });
                                }),
                          ],
                        ),
                      ),


                      customPrice("${intToMoney(special)}"),
                    ],
                  ),
                  if(checkSpecial)
                  Container(
                    height: 1,
                    color: Colors.grey[500],
                  ),
                  if(checkRecommend)
                  Row(
                    children: [
                      customText("recommend"),

                      Expanded(
                        child: Row(
                          children: [
                            customCheckbox(
                                val: checkRecommend8week,
                                string: "8weeks",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkRecommend8week){
                                      return;
                                    }
                                    checkRecommend8week = value;
                                    recommend = 40000;
                                    checkRecommend4month=false;
                                    checkRecommend8moth = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkRecommend4month,
                                string: "4months",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkRecommend4month){
                                      return;
                                    }
                                    checkRecommend4month = value;
                                    recommend = 50000;
                                    checkRecommend8week=false;
                                    checkRecommend8moth = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkRecommend8moth,
                                string: "8months",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkRecommend8moth){
                                      return;
                                    }
                                    checkRecommend8moth = value;
                                    recommend = 90000;
                                    checkRecommend8week=false;
                                    checkRecommend4month = false;
                                    resetSum();
                                  });
                                }),
                          ],
                        ),
                      ),


                      customPrice("${intToMoney(recommend)}"),
                    ],
                  ),
                  if(checkRecommend)
                  Container(
                    height: 1,
                    color: Colors.grey[500],
                  ),
                  if(checkPreferential)
                  Row(
                    children: [
                      customText("preferential"),

                      Expanded(
                        child: Row(
                          children: [
                            customCheckbox(
                                val: checkFirst8week,
                                string: "8weeks",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkFirst8week){
                                      return;
                                    }
                                    checkFirst8week = value;
                                    preferential = 30000;
                                    checkFirst4month=false;
                                    checkFirst8moth = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkFirst4month,
                                string: "4months",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkFirst4month){
                                      return;
                                    }
                                    checkFirst4month = value;
                                    preferential = 40000;
                                    checkFirst8week=false;
                                    checkFirst8moth = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkFirst8moth,
                                string: "8months",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkFirst8moth){
                                      return;
                                    }
                                    checkFirst8moth = value;
                                    preferential = 70000;
                                    checkFirst4month=false;
                                    checkFirst8week = false;
                                    resetSum();
                                  });
                                }),
                          ],
                        ),
                      ),


                      customPrice("${intToMoney(preferential)}"),
                    ],
                  ),
                  if(checkPreferential)
                  Container(
                    height: 1,
                    color: Colors.grey[500],
                  ),
                  if(checkJump)
                  Row(
                    children: [
                      customText("jump"),

                      Expanded(
                        child: Row(
                          children: [
                            customCheckbox(
                                val: checkJump8week,
                                string: "6cases",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkJump8week){
                                      return;
                                    }
                                    checkJump8week = value;
                                    jump = 40000;
                                    checkJump4month=false;
                                    checkJump8moth = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkJump4month,
                                string: "12cases",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkJump4month){
                                      return;
                                    }
                                    checkJump4month = value;
                                    jump = 50000;
                                    checkJump8week=false;
                                    checkJump8moth = false;
                                    resetSum();
                                  });
                                }),


                            customCheckbox(
                                val: checkJump8moth,
                                string: "20cases",
                                onChanged: (value) {
                                  setState(() {
                                    if(checkJump8moth){
                                      return;
                                    }
                                    checkJump8moth = value;
                                    jump = 70000;
                                    checkJump4month=false;
                                    checkJump8week= false;
                                    resetSum();
                                  });
                                }),
                          ],
                        ),
                      ),


                      customPrice("${intToMoney(jump)}"),
                    ],
                  ),
                  if(checkJump)
                  Container(
                    height: 1,
                    color: Colors.grey[500],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width - 20,
                    child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        child: Text(
                          "지불 유형",
                          textAlign: TextAlign.center,
                        )),
                    color: Colors.grey[200],
                  ),
                  Row(
                    children: [
                      customText("preferential"),

                      Expanded(
                        child: Row(
                          children: [
                            customCheckbox(
                                val: checkBuyTransfer,
                                string: "(Koreans only)계좌이체",
                                onChanged: (value) {
                                  setState(() {
                                    checkBuyTransfer  = value;
                                    checkBuyApp = !checkBuyTransfer;
                                  });
                                }),


                            customCheckbox(
                                val: checkBuyApp,
                                string: "앱 지불",
                                onChanged: (value) {
                                  setState(() {
                                    checkBuyApp = value;
                                    checkBuyTransfer = !checkBuyApp;
                                  });
                                }),



                          ],
                        ),
                      ),


                      customPrice("${intToMoney(sum)}"),
                    ],
                  ),
                  Container(
                    height: 1,
                    color: Colors.grey[500],
                  ),
                  
                  Column(

                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(
                        height: 16,
                      ),
                      customText2(text: "점프서비스를 다른 서비스와 함께 구매하십시오."),
                      SizedBox(
                        height: 16,
                      ),
                      customText2(text:"계좌이체를 원하실 경우, 아래계좌로 입금 하신 후 결제 버튼을 누르시면 됩니다."),
                      customText2(text:"국민은행 817801-01-562784 제이에이치기획 하진훈",bank: "ok"),
                      SizedBox(
                        height: 16,
                      ),
                      customText2(text:"매물 등록자의 이름과 예금자의 이름은 동일해야 확인이 쉽습니다."),
                      SizedBox(
                        height: 30,
                      ),
                    ],
                  ),
                  Container(
                    width: MediaQuery.of(context).size.width-20,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        primary: MAIN_COLOR
                      ),
                        onPressed: (){


                        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Registering. Please wait a moment.")));
                        HashMap<String,dynamic> map = new HashMap();

                        map.putIfAbsent("sum", () => sum.toString());
                        if(checkSpecial){
                          if(checkSpecial8week){
                            map.putIfAbsent("best", () =>"8주");
                          }else if(checkSpecial4month){
                            map.putIfAbsent("best", () =>"4달");
                          }else{
                            map.putIfAbsent("best", () =>"8달");
                          }
                        }else{
                          map.putIfAbsent("best", () =>null);
                        }

                        if(checkRecommend){
                          if(checkRecommend8week){
                            map.putIfAbsent("recommend", () =>"8주");
                          }else if(checkRecommend4month){
                            map.putIfAbsent("recommend", () =>"4달");
                          }else{
                            map.putIfAbsent("recommend", () =>"8달");
                          }
                        }else{
                          map.putIfAbsent("recommend", () =>null);
                        }

                        if(checkPreferential){
                          if(checkFirst8week){
                            map.putIfAbsent("first", () =>"8주");
                          }else if(checkFirst4month){
                            map.putIfAbsent("first", () =>"4달");
                          }else{
                            map.putIfAbsent("first", () =>"8달");
                          }
                        }else{
                          map.putIfAbsent("first", () =>null);
                        }

                        if(checkJump){
                          if(checkJump8week){
                            map.putIfAbsent("jump", () =>"6");
                          }else if(checkJump4month){
                            map.putIfAbsent("jump", () =>"12");
                          }else{
                            map.putIfAbsent("jump", () =>"20");
                          }
                        }else{
                          map.putIfAbsent("jump", () =>null);
                        }


                        if(checkBuyApp){
                          map.putIfAbsent("admin", () =>"ok");
                        }else{
                          map.putIfAbsent("admin", () =>null);
                        }


                        Navigator.of(context).pop(map);

                        },
                        child: Text("결제하기")),
                  ),
                  SizedBox(
                    height: 16,
                  ),
        ])),
      ),
    );
  }
}

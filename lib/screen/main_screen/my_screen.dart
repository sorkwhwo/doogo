
import 'package:doogo/screen/admin_inquire_list_screen.dart';
import 'package:doogo/screen/all_product_waiting_screen.dart';
import 'package:doogo/screen/my_product_screen.dart';
import 'package:doogo/screen/my_product_waiting_screen.dart';
import 'package:doogo/screen/notice_write_screen.dart';
import 'package:doogo/screen/service_center_screen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:doogo/main.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';


Container bb = Container(
  color: Colors.black,
  height: 2,
);
class MyScreen extends StatelessWidget {
  double height = 70;

  FirebaseAuth auth = FirebaseAuth.instance;
  FirebaseFirestore db = FirebaseFirestore.instance;
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
            width: MediaQuery.of(context).size.width,
            child:
            Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Text(
                  "My",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                ),
              ),
              Container(
                width: double.infinity,
                height: 1,
                color: Colors.grey[300],
              ),


            ])),

        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset("asset/img/user.png", width: 90),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "sorkwhwo@naver.com",
                      style: TextStyle(fontWeight: FontWeight.w700),
                    ),
                    SizedBox(
                      width: 10,
                    ),
                    Text(
                      "80000",
                      style: TextStyle(color: MAIN_COLOR),
                    ),
                    SizedBox(
                      width: 3,
                    ),
                    Image.asset(
                      "asset/img/point.png",
                      width: 15,
                      color: MAIN_COLOR,
                    ),
                  ],
                ),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: double.infinity,
                  height: 20,
                  color: Colors.grey[200],
                ),
                Material(
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(MaterialPageRoute(builder: (context) =>MyProductScreen()));
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      height: height,
                      child: Row(
                        children: [
                          Image.asset(
                            "asset/img/product.png",
                            width: 20,
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(child: Text("내 제품")),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                Material(
                    child: InkWell(
                        onTap: () {},
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height,
                          child: Row(
                            children: [
                              Image.asset(
                                "asset/img/point.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("요금 충전")),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ))),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                Material(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>MyWaitingProductScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height,
                          child: Row(
                            children: [
                              Image.asset(
                                "asset/img/admin.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("승인 대기")),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ))),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                Material(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ServiceCenterScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height,
                          child: Row(
                            children: [
                              Image.asset(
                                "asset/img/support.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("서비스 센터")),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ))),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                Material(
                    child: InkWell(
                        onTap: () {
                          auth.signOut();
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height,
                          child: Row(
                            children: [
                              Image.asset(
                                "asset/img/logout.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("로그아웃")),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ))),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                Material(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>NoticeWriteScreen()));

                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height,
                          child: Row(
                            children: [
                              Image.asset(
                                "asset/img/notice.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("공지(운영자에게만 보입니다.)")),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ))),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                Material(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AdminInquireListScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height,
                          child: Row(
                            children: [
                              Image.asset(
                                "asset/img/inquire.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("문의내역(운영자에게만 보입니다.)")),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ))),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
                Material(
                    child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(builder: (context) =>AllProductWaitingScreen()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 20),
                          height: height,
                          child: Row(
                            children: [
                              Image.asset(
                                "asset/img/admin.png",
                                width: 20,
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Expanded(child: Text("승인대기매물(운영자에게만 보입니다.)")),
                              Icon(Icons.arrow_forward),
                            ],
                          ),
                        ))),
                Container(
                  color: Colors.grey[300],
                  height: 1,
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

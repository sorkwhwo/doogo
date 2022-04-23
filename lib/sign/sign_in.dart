import 'package:doogo/play.dart';
import 'package:doogo/sign/sign_up.dart';
import 'package:doogo/start.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignIn extends StatelessWidget {
  TextEditingController controller1 = TextEditingController();
  TextEditingController controller2 = TextEditingController();
  @override
  Widget build(BuildContext context) {

    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        backgroundColor: MAIN_COLOR,
        body: SafeArea(
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: Column(
              children: [
                SizedBox(
                  height: 50,
                ),
                Image.asset("asset/img/iconcut.png", width: 90),
                Text(
                  "Doogo",
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                ),
                Text(
                  "APP YouTubeChannel Website \nbuy and sell Sales Exchange",
                  style: TextStyle(fontSize: 15),
                  textAlign: TextAlign.center,
                ),
                SizedBox(
                  height: 20,
                ),
                Expanded(
                  child: Container(
                      padding: EdgeInsets.symmetric(vertical: 16),
                      width: MediaQuery.of(context).size.width,
                      decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.only(
                              topRight: Radius.circular(30),
                              topLeft: Radius.circular(30))),
                      child: SingleChildScrollView(
                        child: Column(
                          children: [
                            SizedBox(
                              height: 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Material(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(40),
                                elevation: 2,
                                child: InkWell(
                                  borderRadius: BorderRadius.circular(40),
                                  onTap: () {},
                                  child: Container(
                                      margin: EdgeInsets.all(15),
                                      child: Row(
                                        children: [
                                          Image.asset(
                                            "asset/img/google.png",
                                            width: 25,
                                          ),
                                          SizedBox(
                                            width: 20,
                                          ),
                                          Text(
                                            "Play with Google",
                                            style: TextStyle(
                                                fontWeight: FontWeight.w600,
                                                fontSize: 15),
                                          )
                                        ],
                                      )),
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 16),
                              child: TextField(

                                controller: controller1,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Email",
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(16),
                              child: TextField(
                                controller: controller2,
                                obscureText: true,
                                cursorColor: Colors.black,
                                decoration: InputDecoration(
                                  hintText: "Password",
                                  filled: true,
                                  fillColor: Colors.grey[100],
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(40),
                                    borderSide: BorderSide(
                                      width: 0,
                                      style: BorderStyle.none,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(right: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  TextButton(
                                      onPressed: () {},
                                      child: Text(
                                        "Forgot Password?",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontSize: 12,
                                            color: Colors.black),
                                      ))
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 40,
                            ),
                            Container(
                              height: 45,
                              margin: EdgeInsets.all(16),
                              width: double.infinity,
                              child: ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                    primary: MAIN_COLOR,
                                    shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(40))),
                                onPressed: () async {
                                  FirebaseAuth auth = FirebaseAuth.instance;
                                  try {
                                    final login =
                                        await auth.signInWithEmailAndPassword(
                                            email: controller1.text,
                                            password: controller2.text);
                                  } catch (e) {
                                    int a = 0;
                                    List<String> list = e.toString().split("");
                                    for (int i = 0; i < list.length; i++) {
                                      if (list[i] == "]") {
                                        a = i + 1;
                                      }
                                    }
                                    ScaffoldMessenger.of(context).showSnackBar(
                                        SnackBar(
                                            content: Text(
                                                e.toString().substring(a))));
                                  }
                                },
                                child: Text(
                                  "Login",
                                  style: TextStyle(
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                ),
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Don't have a account?",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(
                                  width: 10,
                                ),
                                TextButton(
                                    onPressed: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => SignUp()));
                                    },
                                    child: Text(
                                      "Sign up Now?",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 12,
                                          color: Colors.black),
                                    ))
                              ],
                            ),
                          ],
                        ),
                      )),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

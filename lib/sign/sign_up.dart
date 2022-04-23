import 'package:doogo/start.dart';
import 'package:doogo/play.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_auth/firebase_auth.dart';
class SignUp extends StatefulWidget{

  @override
  State<SignUp> createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
   GlobalKey<FormState> key = GlobalKey();
   FirebaseAuth auth = FirebaseAuth.instance;
   FirebaseFirestore db = FirebaseFirestore.instance;
   String email="";
   String password="";
   String chckPassword="";

   void check () async{

    bool isValid = key.currentState!.validate();

    if(isValid){
      key.currentState!.save();
      if(password!=chckPassword){
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Passwords do not match.")));
        return;
      }else{

        try{

          final singUp =  await auth.createUserWithEmailAndPassword(email: email, password: password);
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Sign up is complete.")));
          Navigator.of(context).pop();

        }catch(e){
          ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(e.toString())));
        }



      }

    }

   }

   // void sendAuthentication(){
   //
   //   auth.currentUser.
   // }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return GestureDetector(
      onTap: (){
        FocusScope.of(context).requestFocus(FocusNode());
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: MAIN_COLOR,
          title: Text("Sign Up",style: TextStyle(
            color: Colors.white,
          ),),
        ),
        body:  SingleChildScrollView(
              child: Form(
                key: key,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 50,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        key: ValueKey(1),
                        validator: (value){
                          if(value!.isEmpty || !value!.contains("@")){
                            return "Please enter a valid email format.";
                          }
                        },
                        onSaved: (value){
                          this.email = value!;
                        },
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
                    SizedBox(
                      height: 10,
                    ),

                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        key: ValueKey(2),
                        validator: (value){
                          if(value!.isEmpty || value!.length<8){
                            return "Please enter a valid password format.";
                          }
                        },
                        onSaved: (value){
                          this.password = value!;
                        },
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
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("For the password, please entet at least 8 characters in combination of letters and special characters",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                        ),),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: TextFormField(
                        key: ValueKey(3),
                        validator: (value){
                          if(value!.isEmpty || value!.length<8){
                            return "Please enter a valid password format.";
                          }
                        },
                        onSaved: (value){
                          this.chckPassword = value!;
                        },
                        obscureText: true,
                        cursorColor: Colors.black,
                        decoration: InputDecoration(
                          hintText: "Confirm Password",
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
                    SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: Text("if the password does not match, subscription will be restricted",
                        style: TextStyle(
                            color: Colors.grey,
                            fontSize: 12
                        ),),
                    ),
                    SizedBox(
                      height: 30,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          // Expanded(
                          //   child: Container(
                          //     height: 45,
                          //     child: ElevatedButton(
                          //       style: ElevatedButton.styleFrom(
                          //         primary: Colors.black,
                          //         shape: RoundedRectangleBorder(
                          //           borderRadius: BorderRadius.circular(40)
                          //         )
                          //       ),
                          //         onPressed: (){},
                          //         child: Text("EMAIL AUTEHNTICATION",style: TextStyle(
                          //           color: MAIN_COLOR,
                          //           fontSize: 12,
                          //             fontWeight: FontWeight.w700
                          //
                          //         ),)),
                          //   ),
                          // ),
                          SizedBox(
                            width: 10,
                          ),
                          Expanded(
                            child: Container(
                              height: 45,
                              child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      primary: Colors.black,
                                      shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(40)
                                      )
                                  ),
                                  onPressed: (){
                                    check();
                                  },
                                  child: Text("Sign Up",style: TextStyle(
                                    color: MAIN_COLOR,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700

                                  ),)),
                            ),
                          )
                        ],
                      ),

                    ),
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Row(
                        children: [
                          Checkbox(

                            activeColor: MAIN_COLOR,
                              value: true,
                              onChanged: (value){

                              }),
                          Text(
                            "Accept the terms of use and user policy\n이용약관 및 사용자 정책동의",
                          style:TextStyle(
                            fontSize: 12
                          ),),

                        ],
                      ),
                    )
                  ],

                ),
              ),
            )
          
        
      ),
    );
  }
}
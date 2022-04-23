import 'package:flutter/material.dart';


Widget dateToString(DateTime dateTime){
  return Text("${dateTime.year}.${dateTime.month.toString().padLeft(2,"0")}.${dateTime.day.toString().padLeft(2,"0")} ${dateTime.hour.toString().padLeft(2,"0")}:${dateTime.minute.toString().padLeft(2,"0")}",style: TextStyle(
      color: Colors.grey,fontSize: 10
  ),);
}

import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

void showToast({required String message, String? type}){
  Fluttertoast.showToast(msg: message,
  toastLength: Toast.LENGTH_SHORT,
    gravity: ToastGravity.BOTTOM,
    timeInSecForIosWeb: 1,
    backgroundColor: type == "error" ?  Colors.red : Colors.lightBlueAccent,
    textColor: type == "error" ? Colors.white : Colors.black,
    fontSize: 16,
  );
}
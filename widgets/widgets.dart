import 'package:flutter/material.dart';

Widget constantAppBar() {
  return AppBar(
    backgroundColor: Colors.orange,
    title: Text("Say It"),
  );
}

InputDecoration inputTextDecoration(String hintText) {
  return InputDecoration(
      hintText: hintText,
      hintStyle: TextStyle(color: Colors.black45),
      focusedBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black),
      ),
      enabledBorder: UnderlineInputBorder(
        borderSide: BorderSide(color: Colors.black45),
      ),
      errorBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.deepOrange)));
}

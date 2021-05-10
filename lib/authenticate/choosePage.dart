import 'package:flutter/material.dart';
import 'package:sayit/authenticate/register.dart';
import 'package:sayit/authenticate/signIn.dart';

class ChoosePage extends StatefulWidget {
  @override
  _ChoosePageState createState() => _ChoosePageState();
}

class _ChoosePageState extends State<ChoosePage> {
  bool toggle = false;

  void toggleView() {
    setState(() {
      toggle = !toggle;
    });
  }

  @override
  Widget build(BuildContext context) {
    return toggle == true ? Register() : SignIn();
  }
}

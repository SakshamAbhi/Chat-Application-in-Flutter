import 'dart:io';

import 'package:flutter/material.dart';
import 'package:sayit/authenticate/choosePage.dart';
import 'package:sayit/authenticate/helperFunctions.dart';
import 'package:sayit/chat/chatroom.dart';
import 'package:sayit/widgets/notConnected.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  bool userIsLoggedIn = false;
  bool connected = false;

  @override
  void initState() {
    getLoggedInState();
    check();
    super.initState();
  }

  getLoggedInState() async {
    await HelperFunctions.getUserLoggedInSharedPreference().then((val) {
      setState(() {
        if (val != null) userIsLoggedIn = val;
      });
    });
  }

  check() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        setState(() {
          connected = true;
        });
      }
    } on SocketException catch (_) {
      setState(() {
        connected = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 5,
      navigateAfterSeconds: connected
          ? userIsLoggedIn
              ? ChatRoom()
              : ChoosePage()
          : NotConnected(),
      imageBackground: AssetImage("assets/back.jpg"),
      photoSize: 100.0,
      useLoader: false,
    );
  }
}

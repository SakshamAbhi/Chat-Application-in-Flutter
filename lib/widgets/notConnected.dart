import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';

class NotConnected extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/finalNotConnected.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Phoenix.rebirth(context);
          },
          child: Icon(Icons.restore),
          backgroundColor: Colors.grey[800],
        ),
      ),
    );
  }
}

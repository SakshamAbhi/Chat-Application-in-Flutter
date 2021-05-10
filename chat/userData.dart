import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:sayit/authenticate/auth.dart';
import 'package:sayit/authenticate/database.dart';
import 'package:sayit/authenticate/helperFunctions.dart';
import 'package:sayit/authenticate/user.dart';

class UserData extends StatefulWidget {
  final bool value;
  final String userName;
  UserData(this.value, this.userName);

  @override
  _UserDataState createState() => _UserDataState();
}

class _UserDataState extends State<UserData> {
  String userEmail = "";
  final AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  QuerySnapshot searchSnapshot;

  @override
  void initState() {
    databaseMethods.getUserByUsername(widget.userName).then((val) {
      setState(() {
        searchSnapshot = val;

        if (searchSnapshot != null) {
          userEmail = searchSnapshot.docs[0].data()["email"];
        }
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.brown[900],
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Profile",
            style: TextStyle(fontSize: 22.0),
          ),
          backgroundColor: Colors.brown[700],
          actions: widget.value
              ? [
                  IconButton(
                    onPressed: () {
                      print("Your request to logout has been processed!!");
                      HelperFunctions.saveUserLoggedInSharedPreference(false);
                      authMethods.signOut();
                      Phoenix.rebirth(context);
                    },
                    icon: Icon(Icons.logout),
                    color: Colors.white,
                  )
                ]
              : null,
        ),
        body: Center(
          child: Container(
            padding: EdgeInsets.symmetric(horizontal: 30.0, vertical: 20.0),
            color: Colors.white70,
            child: Column(
              children: [
                SizedBox(height: 40.0),
                CircleAvatar(
                  radius: 150.0,
                  backgroundImage: AssetImage("assets/splash.jpg"),
                ),
                SizedBox(height: 30.0),
                Divider(thickness: 2.0),
                SizedBox(height: 10.0),
                Text(widget.userName != "" ? widget.userName : Constants.myName,
                    style: TextStyle(fontSize: 30.0)),
                SizedBox(height: 3.0),
                Text(userEmail != "" ? userEmail : Constants.email,
                    style: TextStyle(fontSize: 18.0)),
                SizedBox(height: 20.0),
              ],
            ),
          ),
        ),
        floatingActionButton: widget.value
            ? FloatingActionButton(
                onPressed: () {
                  print("Your request to delete account has been processed!!");
                },
                backgroundColor: Colors.brown,
                child: Icon(Icons.delete),
              )
            : null,
      ),
    );
  }
}

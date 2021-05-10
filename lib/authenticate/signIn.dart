import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sayit/authenticate/auth.dart';
import 'package:sayit/authenticate/database.dart';
import 'package:sayit/authenticate/forgotPassword.dart';
import 'package:sayit/authenticate/helperFunctions.dart';
import 'package:sayit/authenticate/register.dart';
import 'package:sayit/authenticate/wrongCredentials.dart';
import 'package:sayit/chat/chatroom.dart';
import 'package:sayit/widgets/widgets.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final _formKey = GlobalKey<FormState>();
  QuerySnapshot snapshotUserInfo;
  bool loading = false;

  signIn() {
    if (_formKey.currentState.validate()) {
      setState(() {
        loading = true;
      });

      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);

      databaseMethods
          .getUserByUserEmail(emailTextEditingController.text)
          .then((val) {
        snapshotUserInfo = val;
        HelperFunctions.saveUserNameSharedPreference(
            snapshotUserInfo.docs[0].data()["name"]);
      });

      authMethods
          .signInWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) {
        if (val != null) {
          setState(() {
            loading = false;
          });
          HelperFunctions.saveUserLoggedInSharedPreference(true);
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => ChatRoom()));
        } else {
          setState(() {
            loading = false;
          });
          Navigator.push(context,
              MaterialPageRoute(builder: (context) => WrongCredentials()));
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: loading
          ? Container(
              child: Center(
                  child: CircularProgressIndicator(
                backgroundColor: Colors.white,
              )),
            )
          : SingleChildScrollView(
              child: Container(
                alignment: Alignment.bottomCenter,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image(image: AssetImage("assets/back.jpg")),
                    SizedBox(height: 10),
                    Container(
                      padding:
                          EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                      child: Column(
                        children: [
                          Form(
                            child: Form(
                              key: _formKey,
                              child: Column(children: [
                                TextFormField(
                                  validator: (val) =>
                                      RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                              .hasMatch(val)
                                          ? null
                                          : "Please provide valid Email ID",
                                  controller: emailTextEditingController,
                                  decoration: inputTextDecoration("Email"),
                                ),
                                TextFormField(
                                  validator: (val) =>
                                      val.trim().isEmpty || val.length < 8
                                          ? "Please provide valid Password"
                                          : null,
                                  controller: passwordTextEditingController,
                                  obscureText: true,
                                  decoration: inputTextDecoration("Password"),
                                ),
                              ]),
                            ),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              authMethods.forgotPassword(
                                  emailTextEditingController.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ForgotPassword()));
                            },
                            child: Container(
                                padding: EdgeInsets.symmetric(vertical: 16),
                                child: Text(
                                  "Forgot Password?",
                                  style: TextStyle(
                                      decoration: TextDecoration.underline),
                                )),
                          ),
                          SizedBox(height: 10),
                          GestureDetector(
                            onTap: () {
                              if (_formKey.currentState.validate()) {
                                signIn();
                              }
                            },
                            child: Container(
                              alignment: Alignment.center,
                              width: MediaQuery.of(context).size.width,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(colors: [
                                  Colors.orange,
                                  Colors.orangeAccent
                                ]),
                                borderRadius: BorderRadius.circular(40),
                              ),
                              padding: EdgeInsets.symmetric(vertical: 24),
                              child: Text(
                                "Sign In",
                                style: TextStyle(fontSize: 17),
                              ),
                            ),
                          ),
                          SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text("Don't have an account? "),
                              GestureDetector(
                                onTap: () {
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => Register()));
                                },
                                child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 16),
                                    child: Text(
                                      "Register",
                                      style: TextStyle(
                                          decoration: TextDecoration.underline),
                                    )),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
    );
  }
}

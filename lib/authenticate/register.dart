import 'package:flutter/material.dart';
import 'package:sayit/authenticate/auth.dart';
import 'package:sayit/authenticate/database.dart';
import 'package:sayit/authenticate/helperFunctions.dart';
import 'package:sayit/authenticate/signIn.dart';
import 'package:sayit/chat/chatroom.dart';
import 'package:sayit/widgets/widgets.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  final _formKey = GlobalKey<FormState>();

  TextEditingController usernameTextEditingController =
      new TextEditingController();
  TextEditingController emailTextEditingController =
      new TextEditingController();
  TextEditingController passwordTextEditingController =
      new TextEditingController();

  register() {
    Map<String, String> userInfoMap = {
      "name": usernameTextEditingController.text,
      "email": emailTextEditingController.text
    };

    if (_formKey.currentState.validate()) {
      HelperFunctions.saveUserEmailSharedPreference(
          emailTextEditingController.text);
      HelperFunctions.saveUserNameSharedPreference(
          usernameTextEditingController.text);

      authMethods
          .registerWithEmailAndPassword(emailTextEditingController.text,
              passwordTextEditingController.text)
          .then((val) => print("${val.uid}"));

      databaseMethods.uploadUserInfo(userInfoMap);
      HelperFunctions.saveUserLoggedInSharedPreference(true);

      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => ChatRoom()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          alignment: Alignment.bottomCenter,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Image(image: AssetImage("assets/back.jpg")),
              SizedBox(height: 10),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 24, vertical: 8),
                child: Column(
                  children: [
                    Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          TextFormField(
                            validator: (value) {
                              return value.isEmpty || value.length > 12
                                  ? "Username must be 1 to 12 characters long"
                                  : null;
                            },
                            controller: usernameTextEditingController,
                            decoration: inputTextDecoration("Username"),
                          ),
                          TextFormField(
                            validator: (value) {
                              return RegExp(
                                          r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                                      .hasMatch(value)
                                  ? null
                                  : "Please provide valid Email ID";
                            },
                            controller: emailTextEditingController,
                            decoration: inputTextDecoration("Email"),
                          ),
                          TextFormField(
                            validator: (value) {
                              return value.trim().isEmpty || value.length < 8
                                  ? "Please provide valid Password"
                                  : null;
                            },
                            controller: passwordTextEditingController,
                            obscureText: true,
                            decoration: inputTextDecoration("Password"),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: 20),
                    GestureDetector(
                      onTap: () {
                        if (_formKey.currentState.validate()) {
                          register();
                        }
                      },
                      child: Container(
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                              colors: [Colors.orange, Colors.orangeAccent]),
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: EdgeInsets.symmetric(vertical: 24),
                        child: Text(
                          "Sign Up",
                          style: TextStyle(fontSize: 17),
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? "),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushReplacement(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SignIn()));
                          },
                          child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16),
                              child: Text(
                                "Sign In",
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

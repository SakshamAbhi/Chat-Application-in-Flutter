import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:sayit/authenticate/database.dart';
import 'package:sayit/authenticate/user.dart';
import 'package:sayit/chat/conversationScreen.dart';

class Search extends StatefulWidget {
  @override
  _SearchState createState() => _SearchState();
}

class _SearchState extends State<Search> {
  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController tec = TextEditingController();
  QuerySnapshot searchSnapshot;

  initiateSearch() {
    databaseMethods.getUserByUsername(tec.text).then((val) {
      setState(() {
        searchSnapshot = val;
      });
    });
  }

  createChatRoomAndStartConversation({String userName, String userEmail}) {
    if (userName != Constants.myName) {
      String chatRoomId = getChatRoomId(userName, Constants.myName);

      //print(userName + " " + Constants.myName + " " + chatRoomId);

      List<String> users = [userName, Constants.myName];
      Map<String, dynamic> chatRoomMap = {
        "users": users,
        "chatRoomId": chatRoomId,
      };

      databaseMethods.createChatRoom(chatRoomId, chatRoomMap);
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ConversationScreen(chatRoomId, userName)));
    } else {
      print("You can't send message to yourself...");
    }
  }

  Widget createList() {
    return searchSnapshot != null
        ? ListView.builder(
            padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
            itemCount: searchSnapshot.docs.length,
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return searchTile(
                  userName: searchSnapshot.docs[index].data()["name"],
                  userEmail: searchSnapshot.docs[index].data()["email"]);
            },
          )
        : Container();
  }

  Widget searchTile({String userName, String userEmail}) {
    return GestureDetector(
      onTap: () {
        print(userName);
        createChatRoomAndStartConversation(
            userName: userName, userEmail: userEmail);
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        alignment: Alignment.centerLeft,
        height: 80,
        decoration: BoxDecoration(
          color: Colors.white10,
          borderRadius: BorderRadius.all(Radius.circular(25)),
        ),
        child: Row(
          children: [
            CircleAvatar(
              backgroundImage: AssetImage("assets/splash.jpg"),
            ),
            SizedBox(width: 15.0),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(userName,
                    style: TextStyle(color: Colors.white, fontSize: 18.0)),
                Text(
                  userEmail,
                  style: TextStyle(color: Colors.white70, fontSize: 16.0),
                )
              ],
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Container(
        decoration: BoxDecoration(
            image: DecorationImage(
          image: AssetImage("assets/back.jpg"),
          fit: BoxFit.cover,
          colorFilter: ColorFilter.srgbToLinearGamma(),
        )),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Container(
            child: Column(
              children: [
                SizedBox(height: 40),
                Row(
                  children: [
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 12.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white12),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                        child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                      child: TextFormField(
                        validator: (val) => val.trim().isEmpty
                            ? "Please enter valid input"
                            : null,
                        controller: tec,
                        style: TextStyle(color: Colors.white),
                        decoration: InputDecoration(
                            hintText: "Search",
                            hintStyle: TextStyle(
                                color: Colors.white60, fontSize: 18.0),
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.white)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.white),
                            ),
                            errorBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.deepOrange))),
                      ),
                    )),
                    GestureDetector(
                      onTap: () {
                        print("You pressed me!");
                        initiateSearch();
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 24.0, vertical: 12.0),
                        decoration: BoxDecoration(
                            shape: BoxShape.circle, color: Colors.white12),
                        alignment: Alignment.topRight,
                        child: Icon(
                          Icons.search,
                          color: Colors.white,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                createList()
              ],
            ),
          ),
        ),
      ),
    );
  }
}

getChatRoomId(String a, String b) {
  if (a.substring(0, 1).codeUnitAt(0) > b.substring(0, 1).codeUnitAt(0)) {
    return "$b\_$a";
  } else {
    return "$a\_$b";
  }
}

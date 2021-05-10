import 'package:flutter/material.dart';
import 'package:sayit/authenticate/auth.dart';
import 'package:sayit/authenticate/database.dart';
import 'package:sayit/authenticate/helperFunctions.dart';
import 'package:sayit/authenticate/user.dart';
import 'package:sayit/chat/conversationScreen.dart';
import 'package:sayit/chat/search.dart';
import 'package:sayit/chat/userData.dart';

class ChatRoom extends StatefulWidget {
  @override
  _ChatRoomState createState() => _ChatRoomState();
}

class _ChatRoomState extends State<ChatRoom> {
  AuthMethods authMethods = new AuthMethods();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  Stream chatRoomsStream;

  Widget createList() {
    return StreamBuilder(
        stream: chatRoomsStream,
        builder: (context, snapshot) {
          return snapshot.hasData
              ? ListView.builder(
                  shrinkWrap: true,
                  padding: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  itemCount: snapshot.data.docs.length,
                  itemBuilder: (context, index) {
                    return ChatRoomTile(
                        snapshot.data.docs[index]
                            .data()["chatRoomId"]
                            .toString()
                            .replaceAll(Constants.myName, "")
                            .replaceAll("_", ""),
                        snapshot.data.docs[index].data()["chatRoomId"]);
                  },
                )
              : Container();
        });
  }

  @override
  void initState() {
    getUserInfo();
    super.initState();
  }

  getUserInfo() async {
    Constants.myName = await HelperFunctions.getUserNameSharedPreference();
    Constants.email = await HelperFunctions.getUserEmailSharedPreference();
    databaseMethods.getChatRooms(Constants.myName).then((val) {
      setState(() {
        chatRoomsStream = val;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          image: DecorationImage(
        image: AssetImage("assets/back.jpg"),
        fit: BoxFit.cover,
        colorFilter: ColorFilter.srgbToLinearGamma(),
      )),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: Column(
          children: [
            SizedBox(height: 45),
            Row(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 24),
                  child: Text("Messages",
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      )),
                ),
                Expanded(child: Container()),
                GestureDetector(
                  onTap: () {
                    Navigator.push(
                        context,
                        MaterialPageRoute(
                            builder: (context) => UserData(true, "")));
                  },
                  child: Container(
                    padding:
                        EdgeInsets.symmetric(horizontal: 24, vertical: 12.0),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.settings,
                      color: Colors.white,
                    ),
                  ),
                ),
                SizedBox(width: 8)
              ],
            ),
            SizedBox(height: 20),
            Container(
              child: createList(),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => Search()));
          },
          backgroundColor: Colors.white12,
          child: Icon(Icons.message),
        ),
      ),
    );
  }
}

class ChatRoomTile extends StatelessWidget {
  final String userName;
  final String chatRoomId;
  ChatRoomTile(this.userName, this.chatRoomId);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        print(chatRoomId);
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) =>
                    ConversationScreen(chatRoomId, userName)));
      },
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        margin: EdgeInsets.symmetric(vertical: 4),
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
            SizedBox(width: 10.0),
            Text("$userName",
                style: TextStyle(color: Colors.white, fontSize: 16.0)),
            Expanded(child: Container()),
            Text(
              "20:30",
              style: TextStyle(color: Colors.white38),
            ),
          ],
        ),
      ),
    );
  }
}

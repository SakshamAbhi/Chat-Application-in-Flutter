import 'package:flutter/material.dart';
import 'package:sayit/authenticate/database.dart';
import 'package:sayit/authenticate/user.dart';
import 'package:sayit/chat/userData.dart';

class ConversationScreen extends StatefulWidget {
  final String chatRoomId;
  final String userName;
  ConversationScreen(this.chatRoomId, this.userName);

  @override
  _ConversationScreenState createState() => _ConversationScreenState();
}

class _ConversationScreenState extends State<ConversationScreen> {
  Map<String, dynamic> messageMap;
  Stream chatMessageStream;

  DatabaseMethods databaseMethods = new DatabaseMethods();
  TextEditingController message = TextEditingController();

  Widget chatRoomList() {
    return StreamBuilder(
      stream: chatMessageStream,
      builder: (context, snapshot) {
        return snapshot.hasData
            ? ListView.builder(
                shrinkWrap: true,
                itemCount: snapshot.data.docs.length,
                itemBuilder: (context, index) {
                  return MessageTile(
                      snapshot.data.docs[index].data()["message"],
                      snapshot.data.docs[index].data()["sendBy"] ==
                          Constants.myName);
                },
              )
            : Container();
      },
    );
  }

  sendMessage() {
    if (message.text.trim().isNotEmpty) {
      messageMap = {
        "message": message.text,
        "sendBy": Constants.myName,
        "time": DateTime.now().millisecondsSinceEpoch
      };
    }

    if (widget.chatRoomId != null)
      databaseMethods.addConversationMessages(widget.chatRoomId, messageMap);
    else
      print(widget.chatRoomId);
    message.text = "";
  }

  @override
  void initState() {
    if (widget.chatRoomId != null)
      databaseMethods.getConversationMessages(widget.chatRoomId).then((val) {
        setState(() {
          chatMessageStream = val;
        });
      });
    else
      print(widget.chatRoomId);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.brown[200],
        body: Container(
          child: Column(
            children: [
              SizedBox(height: 40.0),
              Row(
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 15.0, vertical: 10.0),
                        child: Icon(
                          Icons.arrow_back,
                          size: 28.0,
                        ),
                      )),
                  CircleAvatar(
                      backgroundImage: AssetImage("assets/splash.jpg")),
                  SizedBox(width: 8.0),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) =>
                                  UserData(false, widget.userName)));
                    },
                    child: Container(
                      padding: EdgeInsets.all(5.0),
                      child: Text(
                        widget.userName,
                        style: TextStyle(
                            fontSize: 24.0, fontWeight: FontWeight.bold),
                      ),
                    ),
                  ),
                  Expanded(child: Container()),
                  GestureDetector(
                    onTap: () {
                      print("Chat will be deleted!!");
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                          horizontal: 15.0, vertical: 12.0),
                      child: Icon(Icons.delete_forever, size: 28.0),
                    ),
                  )
                ],
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.topCenter,
                  children: [
                    chatRoomList(),
                  ],
                ),
              ),
              Container(
                padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 13.0),
                width: MediaQuery.of(context).size.width,
                height: 70.0,
                decoration: BoxDecoration(
                  color: Colors.brown,
                ),
                child: Row(
                  children: [
                    GestureDetector(
                        onTap: () {
                          print("Emoji's will be availabel!!");
                        },
                        child: Icon(Icons.emoji_emotions)),
                    SizedBox(width: 12.0),
                    Expanded(
                      child: TextField(
                        maxLines: 2,
                        cursorColor: Colors.black,
                        controller: message,
                        decoration: InputDecoration(
                            hintText: "Type Here..",
                            hintStyle: TextStyle(color: Colors.black),
                            focusedBorder: UnderlineInputBorder(
                                borderSide:
                                    BorderSide(color: Colors.transparent)),
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Colors.transparent),
                            ),
                            errorBorder: UnderlineInputBorder(
                                borderSide: BorderSide(color: Colors.red))),
                      ),
                    ),
                    SizedBox(width: 12.0),
                    GestureDetector(
                        onTap: () {
                          print("Message will be sent!!");
                          sendMessage();
                        },
                        child: Icon(Icons.send)),
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

class MessageTile extends StatelessWidget {
  final String message;
  final bool isSendByMe;
  MessageTile(this.message, this.isSendByMe);

  @override
  Widget build(BuildContext context) {
    return Container(
      //padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 15.0),
      margin: EdgeInsets.symmetric(vertical: 5, horizontal: 5),
      width: MediaQuery.of(context).size.width,
      alignment: isSendByMe ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 40, vertical: 10),
        decoration: BoxDecoration(
          color: isSendByMe ? Colors.brown[100] : Colors.brown[800],
          borderRadius: isSendByMe
              ? BorderRadius.only(
                  topLeft: Radius.circular(25),
                  bottomLeft: Radius.circular(25),
                  topRight: Radius.circular(25))
              : BorderRadius.only(
                  topRight: Radius.circular(25),
                  topLeft: Radius.circular(25),
                  bottomRight: Radius.circular(25)),
        ),
        child: Text(
          message,
          style: TextStyle(
            fontSize: 16.0,
            color: isSendByMe ? Colors.black : Colors.white,
          ),
        ),
      ),
    );
  }
}

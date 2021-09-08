import 'dart:ui';
import 'package:flutter/services.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flash_chat/components/text_field.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/components/constants.dart';
import 'dart:async';

final _firestore = FirebaseFirestore.instance;
User loggedInUser;

class ChatScreen extends StatefulWidget {
  static String id = 'chat_screen';
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final messageTextController = TextEditingController();
  final _auth = FirebaseAuth.instance;

  String textMessage;

  @override
  void initState() {
    super.initState();
    getCurrentUser();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
    ));
  }

  void getCurrentUser() {
    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        print(loggedInUser.email);
      }
    } catch (e) {
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          flexibleSpace: ClipRect(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 8.0, sigmaY: 8.0),
              child: Container(
                decoration: BoxDecoration(color: Colors.black.withOpacity(0.4)),
              ),
            ),
          ),
          automaticallyImplyLeading: false,
          title: Text('Octa'),
          centerTitle: false,
          actions: [
            IconButton(
              icon: Icon(Icons.logout),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              },
            )
          ],
        ),
        body: Stack(
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                MessageStream(),
                Container(
                  width: double.infinity,
                  height: 10.0,
                  decoration: BoxDecoration(boxShadow: [
                    BoxShadow(
                      color: Colors.grey[850],
                      blurRadius: 10.0,
                      spreadRadius: 5.0,
                      offset: Offset(0, 0.0),
                    )
                  ]),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 8,
                      child: TextFieldBar(
                        controller: messageTextController,
                        fieldText: 'Type Your text',
                        onChanged: (value) {
                          textMessage = value;
                        },
                        obscureText: false,
                        margin: EdgeInsets.only(
                            top: 1.0, right: 10.0, left: 10.0, bottom: 10.0),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: FlatButton(
                        padding: EdgeInsets.only(right: 10.0, bottom: 10.0),
                        child: Icon(Icons.send),
                        onPressed: () {
                          String _onTimer(Timer timer) {
                            var nowHour = DateTime.now().hour;
                            var nowMin = DateTime.now().minute;
                            // var nowSecond = DateTime.now().second;
                            var nowTime = '$nowHour:$nowMin';
                            return nowTime;
                          }

                          if (textMessage != '') {
                            setState(() {
                              _firestore.collection('messages').add({
                                'text': textMessage,
                                'sender': loggedInUser.email,
                                'time': _onTimer(Timer.periodic(
                                  Duration(seconds: 1),
                                  _onTimer,
                                )).toString(),
                                'order': DateTime.now().microsecondsSinceEpoch
                              });
                            });
                          }
                          messageTextController.clear();
                          textMessage = '';
                        },
                      ),
                    )
                  ],
                )
              ],
            ),
          ],
        ));
  }
}

class MessageStream extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('time');
    print(kTimeNow);

    return StreamBuilder<QuerySnapshot>(
      stream: _firestore.collection('messages').orderBy('order').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
        final messages = snapshot.data.docs.reversed;
        List<MessageBubble> messageBubbles = [];
        for (var message in messages) {
          final messageText = message.data()['text'];
          final messageSender = message.data()['sender'];
          final messageTime = message.data()['time'];

          final currentUser = loggedInUser.email;

          final messageBubble = MessageBubble(
            sender: messageSender,
            text: messageText,
            isMe: currentUser == messageSender,
            time: messageTime,
          );

          messageBubbles.add(messageBubble);
        }

        return Expanded(
          child: ListView(
            reverse: true,
            padding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
            children: messageBubbles,
          ),
        );
      },
    );
  }
}

class MessageBubble extends StatelessWidget {
  final String sender;
  final String text;
  final bool isMe;
  final String time;

  MessageBubble({this.sender, this.text, this.isMe, this.time});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment:
            isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Material(
            borderRadius: isMe
                ? BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.zero,
                    bottomLeft: Radius.circular(30.0),
                  )
                : BorderRadius.only(
                    topLeft: Radius.circular(30.0),
                    topRight: Radius.circular(30.0),
                    bottomRight: Radius.circular(30.0),
                    bottomLeft: Radius.zero,
                  ),
            color: isMe
                ? Colors.teal.withOpacity(0.2)
                : Colors.indigo.withOpacity(0.5),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.0, vertical: 10.0),
              child: Column(
                crossAxisAlignment:
                    isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                children: [
                  // Padding(
                  //   padding: const EdgeInsets.only(
                  //     bottom: 2.0,
                  //   ),
                  //   child: Text(
                  //     sender,
                  //     style: TextStyle(fontSize: 12.0),
                  //   ),
                  // ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 2.0),
                    child: Text(
                      text,
                      style: TextStyle(
                        fontSize: 18.0,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              time,
              style: TextStyle(
                  fontSize: 9.0, color: Colors.white.withOpacity(0.5)),
            ),
          )
        ],
      ),
    );
  }
}

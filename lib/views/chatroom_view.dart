import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onechat/const.dart';
import 'package:onechat/main.dart';
import 'package:onechat/model/chat_model.dart';
import 'package:onechat/model/message_model.dart';

import '../model/user_models.dart';

class ChatRoomView extends StatefulWidget {
  const ChatRoomView(
      {super.key,
      required this.targettedUser,
      required this.currentUserModel,
      required this.currentUser,
      required this.chatRoomModel});

  final UserModel targettedUser;
  final UserModel currentUserModel;
  final User currentUser;
  final ChatRoomModel chatRoomModel;

  @override
  State<ChatRoomView> createState() => _ChatRoomViewState();
}

class _ChatRoomViewState extends State<ChatRoomView> {
  TextEditingController _messageController = TextEditingController();

  void sendMessage() async {
    String message = _messageController.text.trim();
    if (message != null) {
      MessageModel messageModel = MessageModel(
        messageid: uuid.v1(),
        sender: widget.currentUserModel.uid,
        createdon: DateTime.now(),
        text: message,
        seen: false,
      );
      await firebaseFirestore
          .collection('chatrooms')
          .doc(widget.chatRoomModel.chatroomID)
          .collection('messages')
          .doc(messageModel.messageid)
          .set(messageModel.toMap());

      widget.chatRoomModel.lastMessage = message;

      await firebaseFirestore
          .collection("chatrooms")
          .doc(widget.chatRoomModel.chatroomID)
          .set(widget.chatRoomModel.toMap());
      log('Message Sent');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[800],
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFC7C7CC),
              Color(0xFFE5E5EA),
            ],
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          icon: const Icon(
                            Icons.arrow_back_ios,
                            color: Colors.black,
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(4.0),
                          child: Row(
                            children: [
                              CircleAvatar(
                                foregroundImage: CachedNetworkImageProvider(
                                  widget.targettedUser.profilepictureURL
                                      .toString(),
                                ),
                              ),
                              const SizedBox(
                                width: 12,
                              ),
                              Text(
                                widget.targettedUser.name.toString(),
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Icon(
                            Icons.info_outline,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: StreamBuilder(
                    stream: firebaseFirestore
                        .collection('chatrooms')
                        .doc(widget.chatRoomModel.chatroomID)
                        .collection('messages')
                        .orderBy(
                          'createdon',
                          descending: true,
                        )
                        .snapshots(),
                    builder: (context, snapshot) {
                      QuerySnapshot? querySnapshot =
                          snapshot.data as QuerySnapshot?;
                      if (snapshot.hasError) {
                        return Center(
                          child: Text('Error: ${snapshot.error}'),
                        );
                      }
                      if (!snapshot.hasData) {
                        return const Center(
                          child: CircularProgressIndicator(),
                        );
                      }

                      if (querySnapshot!.size == 0) {
                        return const Center(
                          child: Text('No messages found.'),
                        );
                      }

                      return ListView.builder(
                        reverse: true,
                        itemCount: querySnapshot.docs.length,
                        itemBuilder: (context, index) {
                          MessageModel newMessage = MessageModel.fromMap(
                              querySnapshot.docs[index].data()
                                  as Map<String, dynamic>);

                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: newMessage.sender ==
                                      widget.currentUserModel.uid
                                  ? CrossAxisAlignment.end
                                  : CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment: newMessage.sender ==
                                          widget.currentUserModel.uid
                                      ? MainAxisAlignment.end
                                      : MainAxisAlignment.start,
                                  children: [
                                    if (newMessage.sender !=
                                        widget.currentUserModel.uid)
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(widget
                                            .targettedUser.profilepictureURL!),
                                      ),
                                    const SizedBox(width: 8),
                                    Container(
                                      constraints: BoxConstraints(
                                        maxWidth:
                                            MediaQuery.of(context).size.width *
                                                0.7,
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 16, vertical: 12),
                                      decoration: BoxDecoration(
                                        color: newMessage.sender ==
                                                widget.currentUserModel.uid
                                            ? Colors.blue[800]
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(20),
                                        boxShadow: [
                                          BoxShadow(
                                            color:
                                                Colors.black.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 3,
                                            offset: const Offset(0, 2),
                                          ),
                                        ],
                                      ),
                                      child: Text(
                                        newMessage.text.toString(),
                                        style: TextStyle(
                                          color: newMessage.sender ==
                                                  widget.currentUserModel.uid
                                              ? Colors.white
                                              : Colors.black,
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(
                                      width: 8,
                                    ),
                                    if (newMessage.sender ==
                                        widget.currentUserModel.uid)
                                      CircleAvatar(
                                        radius: 24,
                                        backgroundImage: NetworkImage(widget
                                            .currentUserModel
                                            .profilepictureURL!),
                                      ),
                                  ],
                                ),
                                SizedBox(height: 8),
                                Text(
                                  newMessage.sender ==
                                          widget.currentUserModel.uid
                                      ? 'You'
                                      : widget.targettedUser.name.toString(),
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    color: Colors.white.withOpacity(0.8),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          onPressed: () {},
                          icon:
                              Icon(Icons.attach_file, color: Colors.grey[800]),
                        ),
                      ),
                      Expanded(
                        child: TextField(
                          maxLength: 122,
                          controller: _messageController,
                          decoration: InputDecoration(
                            counterText: '',
                            hintText: "Type a message",
                            border: InputBorder.none,
                            contentPadding:
                                EdgeInsets.symmetric(horizontal: 16),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        child: IconButton(
                          onPressed: () {
                            sendMessage();
                            _messageController.clear();
                            // Handle sending the message
                          },
                          icon: Icon(Icons.send, color: Colors.purple),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

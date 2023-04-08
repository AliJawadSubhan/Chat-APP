import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onechat/const.dart';
import 'package:onechat/main.dart';
import 'package:onechat/model/chat_model.dart';
import 'package:onechat/model/user_models.dart';
import 'package:onechat/views/chatroom_view.dart';
// import 'package:onechat/views/chatroom_view.dart';
// import 'package:cached_network_image/cached_network_image.dart';
import 'package:onechat/widgets/usercard.dart';

class SearchView extends StatefulWidget {
  final UserModel userModel;
  final User currentUser;
  const SearchView(
      {super.key, required this.userModel, required this.currentUser});

  @override
  State<SearchView> createState() => _SearchViewState();
}

class _SearchViewState extends State<SearchView> {
  TextEditingController name = TextEditingController();

  Future<ChatRoomModel?> getChatroomModel(UserModel targetUser) async {
    ChatRoomModel? chatRoom;

    QuerySnapshot snapshot = await FirebaseFirestore.instance
        .collection("chatrooms")
        .where("participants.${widget.userModel.uid}", isEqualTo: true)
        .where("participants.${targetUser.uid}", isEqualTo: true)
        .get();

    if (snapshot.docs.isNotEmpty) {
      // Fetch the existing one
      var docData = snapshot.docs[0].data();
      ChatRoomModel existingChatroom =
          ChatRoomModel.fromMap(docData as Map<String, dynamic>);

      chatRoom = existingChatroom;
    } else {
      // Create a new one
      ChatRoomModel newChatroom = ChatRoomModel(
        chatroomID: uuid.v1(),
        lastMessage: "",
        participants: {
          widget.userModel.uid.toString(): true,
          targetUser.uid.toString(): true,
        },
      );

      await FirebaseFirestore.instance
          .collection("chatrooms")
          .doc(newChatroom.chatroomID)
          .set(newChatroom.toMap());

      chatRoom = newChatroom;

      log("New Chatroom Created!");
    }

    return chatRoom;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(
              height: 80,
            ),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Search',
                    style: TextStyle(
                      fontSize: 32,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(50),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey.withOpacity(0.5),
                          spreadRadius: 2,
                          blurRadius: 5,
                          offset: Offset(0, 3),
                        ),
                      ],
                    ),
                    child: Row(
                      children: [
                        const SizedBox(
                          width: 10,
                        ),
                        Expanded(
                          child: TextField(
                            controller: name,
                            style: const TextStyle(
                              color: Colors.black,
                              fontSize: 18,
                            ),
                            decoration: const InputDecoration(
                              hintText: 'Enter keywords',
                              hintStyle: TextStyle(
                                color: Colors.grey,
                                fontSize: 18,
                              ),
                              border: InputBorder.none,
                              contentPadding: EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 10),
                            ),
                            onChanged: (va) {
                              setState(() {});
                            },
                          ),
                        ),
                        IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.search,
                            color: Colors.black,
                          ),
                        )
                      ],
                    ),
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
            Expanded(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(30),
                    topRight: Radius.circular(30),
                  ),
                ),
                child: StreamBuilder<QuerySnapshot>(
                  stream: name.text.trim().isNotEmpty
                      ? firebaseFirestore
                          .collection("users")
                          .where(
                            "name",
                            isGreaterThanOrEqualTo: name.text.trim(),
                          )
                          .where('name', isNotEqualTo: widget.userModel.name)
                          .snapshots()
                      : firebaseFirestore
                          .collection("users")
                          .where('name', isNotEqualTo: widget.userModel.name)
                          .snapshots(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.active &&
                        snapshot.hasData) {
                      if (snapshot.data!.docs.isNotEmpty) {
                        // List<UserModel> searchedUsers = [];
                        // for (var data in snapshot.data!.docs) {
                        //   var datas = data.data() as Map<String, dynamic>;
                        //   UserModel users = UserModel.fromMap(datas);
                        //   searchedUsers.add(users);
                        // }
                        // for single user
                        QuerySnapshot dataSnapshot =
                            snapshot.data as QuerySnapshot;
                        if (dataSnapshot.docs.isNotEmpty) {
                          Map<String, dynamic> userMap = dataSnapshot.docs[0]
                              .data() as Map<String, dynamic>;
                          UserModel searchedUser = UserModel.fromMap(userMap);
                          return name.text.trim().isEmpty
                              ? ListView(
                                  children: snapshot.data!.docs
                                      .map((DocumentSnapshot document) {
                                    Map<String, dynamic> data = document.data()!
                                        as Map<String, dynamic>;
                                    UserModel searchedUserData =
                                        UserModel.fromMap(data);
                                    return Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: UserCard(
                                        imageUrl: searchedUserData
                                            .profilepictureURL
                                            .toString(),
                                        username:
                                            searchedUserData.name.toString(),
                                        email:
                                            searchedUserData.email.toString(),
                                        goToChatRoomButton: () async {
                                          ChatRoomModel? chatRoomModel =
                                              await getChatroomModel(
                                                  searchedUserData);
                                          if (chatRoomModel != null) {
                                            // ignore: use_build_context_synchronously
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (ctx) => ChatRoomView(
                                                  chatRoomModel: chatRoomModel,
                                                  targettedUser:
                                                      searchedUserData,
                                                  currentUserModel:
                                                      widget.userModel,
                                                  currentUser:
                                                      widget.currentUser,
                                                ),
                                              ),
                                            );
                                          }
                                        },
                                      ),
                                    );
                                  }).toList(),
                                )
                              : Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: UserCard(
                                    goToChatRoomButton: () async {
                                      ChatRoomModel? chatRoomModel =
                                          await getChatroomModel(searchedUser);
                                      if (chatRoomModel != null) {
                                        // ignore: use_build_context_synchronously
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (ctx) => ChatRoomView(
                                              chatRoomModel: chatRoomModel,
                                              targettedUser: searchedUser,
                                              currentUserModel:
                                                  widget.userModel,
                                              currentUser: widget.currentUser,
                                            ),
                                          ),
                                        );
                                      }
                                    },
                                    imageUrl: searchedUser.profilepictureURL
                                        .toString(),
                                    username: searchedUser.name.toString(),
                                    email: searchedUser.email.toString(),
                                  ),
                                );
                        } else {
                          return const Text("No results found!");
                        }
                      } else if (snapshot.hasError) {
                        return const Center(child: Text("An error occured!"));
                      } else {
                        return const Center(child: Text("No results found!"));
                      }
                    }
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}




/* 
ChatRoomModel? chatRoomModel =
                                            await getChatroomModel(
                                                searchedUserData);
                                        if (chatRoomModel != null) {
                                          // ignore: use_build_context_synchronously
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (ctx) => ChatRoomView(
                                                chatRoomModel: chatRoomModel,
                                                targettedUser: searchedUserData,
                                                currentUserModel:
                                                    widget.userModel,
                                                currentUser: widget.currentUser,
                                              ),
                                            ),
                                          );
                                        }
                                        */
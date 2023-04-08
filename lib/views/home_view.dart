import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onechat/const.dart';
import 'package:onechat/helpers/firebase_helper.dart';
import 'package:onechat/model/chat_model.dart';
import 'package:onechat/views/chatroom_view.dart';
import 'package:onechat/views/login_view.dart';
import 'package:onechat/views/search_view.dart';
import '../model/user_models.dart';

class HomeView extends StatefulWidget {
  const HomeView({
    super.key,
    required this.userModel,
    required this.user,
  });
  final UserModel userModel;
  final User? user;

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Chats",
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        centerTitle: true,
        backgroundColor: Colors.deepPurple,
        elevation: 0,
        actions: [
          IconButton(
            onPressed: () async {
              await firebaseAuth.signOut();
              // ignore: use_build_context_synchronously
              Navigator.push(context, MaterialPageRoute(builder: (ctx) {
                return const LoginView();
              }));
            },
            icon: const Icon(
              Icons.logout,
              color: Colors.white,
            ),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            CircleAvatar(
              foregroundImage: NetworkImage(
                widget.userModel.profilepictureURL.toString(),
              ),
            ),
            Expanded(
              child: StreamBuilder(
                stream: firebaseFirestore
                    .collection('chatrooms')
                    .where('participants.${widget.userModel.uid}',
                        isEqualTo: true)
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.active) {
                    if (snapshot.hasData) {
                      QuerySnapshot chatRoomSnapshot =
                          snapshot.data as QuerySnapshot;

                      return ListView.builder(
                        itemCount: chatRoomSnapshot.docs.length,
                        itemBuilder: (context, index) {
                          ChatRoomModel chatRoomModel = ChatRoomModel.fromMap(
                              chatRoomSnapshot.docs[index].data()
                                  as Map<String, dynamic>);
                          Map<String, dynamic> participants =
                              chatRoomModel.participants!;
                          List<String> participantsKey =
                              participants.keys.toList();
                          participantsKey.remove(widget.userModel.uid);
                          return FutureBuilder<UserModel?>(
                            future: FireBaseHelper.getUserModelById(
                              participantsKey[0],
                            ),
                            builder: (context, snapshot) {
                              if (!snapshot.hasData) {
                                return Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircularProgressIndicator(),
                                  ],
                                );
                              }
                              UserModel? targettedUser = snapshot.data;
                              if (targettedUser == null) {
                                return const Text('User not found');
                              }
                              return ListTile(
                                onTap: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(builder: (context) {
                                      return ChatRoomView(
                                        chatRoomModel: chatRoomModel,
                                        currentUser: widget.user!,
                                        currentUserModel: widget.userModel,
                                        targettedUser: targettedUser,
                                      );
                                    }),
                                  );
                                },
                                leading: CircleAvatar(
                                  backgroundImage: NetworkImage(
                                      targettedUser.profilepictureURL!),
                                ),
                                title: Text(targettedUser.name!),
                                subtitle: (chatRoomModel.lastMessage
                                                .toString() !=
                                            "" ||
                                        chatRoomModel.lastMessage.toString() !=
                                            null)
                                    ? Text(chatRoomModel.lastMessage!)
                                    : Text(
                                        "Say hi to your new friend!",
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .colorScheme
                                              .secondary,
                                        ),
                                      ),
                              );
                            },
                          );
                        },
                      );
                    } else if (snapshot.hasError) {
                      return Center(
                        child: Text(snapshot.error.toString()),
                      );
                    } else {
                      return const Center(
                        child: Text("No Chats"),
                      );
                    }
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.all(8.0),
        child: FloatingActionButton(
          backgroundColor: Colors.purple,
          onPressed: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (ctz) => SearchView(
                    userModel: widget.userModel, currentUser: widget.user!),
              ),
            );
            // do something when the button is pressed
          },
          child: const Icon(Icons.search),
        ),
      ),
      // floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
    );
  }
}

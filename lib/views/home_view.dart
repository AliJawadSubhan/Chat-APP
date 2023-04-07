import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onechat/const.dart';
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
      body: Column(
        children: const [
          // Expanded(
          //   child: StreamBuilder<QuerySnapshot>(
          //     stream: firebaseFirestore.collection('users').snapshots(),
          //     builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
          //       List<UserModel> users = [];
          //       if (snapshot.data?.docs != null) {
          //         for (var documentSnapshot in snapshot.data!.docs) {
          //           var data = documentSnapshot.data() as Map<String, dynamic>;
          //           UserModel user = UserModel.fromMap(data);
          //           users.add(user);
          //         }
          //       }
          //       if (!snapshot.hasData ||
          //           snapshot.data == null ||
          //           snapshot.data!.docs.isEmpty) {
          //         return const Center(
          //           child: CircularProgressIndicator(
          //             color: Colors.amber,
          //           ),
          //         );
          //       }
          //       if (snapshot.connectionState == ConnectionState.waiting) {
          //         return const Center(
          //           child: CircularProgressIndicator(
          //             color: Colors.amber,
          //           ),
          //         );
          //       }
          //       return ListView.builder(
          //           itemCount: users.length,
          //           itemBuilder: (context, index) {
          //             if (index < 0 || index >= users.length) {
          //               return Container();
          //             }
          //             return Container(
          //               margin: const EdgeInsets.symmetric(
          //                 horizontal: 16,
          //                 vertical: 8,
          //               ),
          //               decoration: BoxDecoration(
          //                 color: Colors.white,
          //                 borderRadius: BorderRadius.circular(16),
          //                 boxShadow: [
          //                   BoxShadow(
          //                     color: Colors.grey.shade300,
          //                     offset: Offset(1, 1),
          //                     blurRadius: 5,
          //                   ),
          //                 ],
          //               ),
          //               child: ListTile(
          //                 leading: CircleAvatar(
          //                   backgroundColor: Colors.deepPurple,
          //                   child: Text(
          //                     users[index].name![0],
          //                     style: const TextStyle(
          //                       color: Colors.white,
          //                       fontWeight: FontWeight.bold,
          //                     ),
          //                   ),
          //                 ),
          //                 title: Text(
          //                   users[index].name.toString(),
          //                   style: const TextStyle(
          //                     fontWeight: FontWeight.bold,
          //                     fontSize: 20,
          //                   ),
          //                 ),
          //                 subtitle: Text(
          //                   "Last message from ${users[index].name}",
          //                 ),
          //                 trailing: const Text(
          //                   "10:30 AM",
          //                   style: TextStyle(
          //                     color: Colors.grey,
          //                   ),
          //                 ),
          //                 onTap: () {
          //                   // navigate to chat room
          //                 },
          //               ),
          //             );
          //           });
          //     },
          //   ),
          // ),
        ],
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

import 'dart:developer';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:onechat/const.dart';
import 'package:onechat/helpers/firebase_helper.dart';
import 'package:onechat/model/user_models.dart';
import 'package:onechat/views/home_view.dart';
import 'package:onechat/views/login_view.dart';

class AuthView extends StatelessWidget {
  AuthView({super.key});

  User? currentUser = firebaseAuth.currentUser;
  Future<Widget?> checkAuth() async {
    Stream stateChange = firebaseAuth.authStateChanges();
    log('Current user: ${currentUser?.email}');
    // currentUser!.pro;
    if (stateChange != null) {
      UserModel? currentUserModel =
          await FireBaseHelper.getUserModelById(currentUser!.uid);
      return HomeView(
        user: currentUser,
        userModel: currentUserModel!,
      );
    }
    // user is NOT logged in
    else {
      return const LoginView();
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Widget?>(
      future: checkAuth(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Scaffold(
              body: Center(child: const CircularProgressIndicator()));
        } else {
          return snapshot.data ?? const LoginView();
        }
      },
    );
  }
}

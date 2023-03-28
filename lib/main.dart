import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:onechat/views/complete_profile.dart';
import 'package:onechat/views/home_view.dart';
import 'package:onechat/views/login_view.dart';

import 'firebase_options.dart';

void main() async {
  // TestWidgetsFlutterBinding.ensureInitialized();
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: CompleteProfileView(),
    );
  }
}
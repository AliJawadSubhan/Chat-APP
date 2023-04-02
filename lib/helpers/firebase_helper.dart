import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:onechat/const.dart';
import 'package:onechat/model/user_models.dart';

class FireBaseHelper {
  static Future<UserModel?> getUserModelById(String uid) async {
    UserModel? userModel;
    DocumentSnapshot documentSnapshot =
        await firebaseFirestore.collection("users").doc(uid).get();
    if (documentSnapshot.data() != null) {
      userModel =
          UserModel.fromMap(documentSnapshot.data() as Map<String, dynamic>);
    }
    return userModel;
  }
}

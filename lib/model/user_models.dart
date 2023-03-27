class UserModel {
  // unique ID = UID
  String? uid;
  String? name;
  String? email;
  // String password;
  String? profilepictureURL;

  UserModel({this.uid, this.email, this.name, this.profilepictureURL});

  UserModel.fromMap(Map<String, dynamic> map) {
    uid = map['uid'];
    name = map['name'];
    email = map['email'];
    profilepictureURL = map['profilepictureURL'];
  }
  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'name': name,
      'email': email,
      'profilepictureURL': profilepictureURL,
    };
  }
}

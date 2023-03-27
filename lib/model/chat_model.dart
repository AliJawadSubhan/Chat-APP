class ChatRoomModel {
  String? chatroomID;
  List<String>? participants;
  ChatRoomModel({this.chatroomID, this.participants});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomID = map['chatroomID'];
    participants = map['participants'];
  }
  Map<String, dynamic> toMap() {
    return {
      'chatroomID': chatroomID,
      'participants': participants,
    };
  }
}

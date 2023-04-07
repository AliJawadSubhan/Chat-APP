class ChatRoomModel {
  String? chatroomID;
  Map<String, dynamic>? participants;
  String? lastMessage;
  ChatRoomModel({this.chatroomID, this.participants, this.lastMessage});

  ChatRoomModel.fromMap(Map<String, dynamic> map) {
    chatroomID = map['chatroomID'];
    participants = map['participants'];
    lastMessage = map['lastMessage'];
  }
  Map<String, dynamic> toMap() {
    return {
      'chatroomID': chatroomID,
      'participants': participants,
      'lastMessage': lastMessage,
    };
  }
}

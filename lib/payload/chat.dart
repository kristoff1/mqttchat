class Chat {
  String? sender;
  String? content;
  String? room;

  Chat({this.sender, this.content, this.room});

  Chat.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    content = json['content'];
    room = json['room'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['content'] = this.content;
    data['room'] = this.room;
    return data;
  }
}
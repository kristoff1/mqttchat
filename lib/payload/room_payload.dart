class RoomPayload {
  List<Room>? room;

  RoomPayload({this.room});

  RoomPayload.fromJson(Map<String, dynamic> json) {
    if (json['room'] != null) {
      room = <Room>[];
      json['room'].forEach((v) {
        room!.add(new Room.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.room != null) {
      data['room'] = this.room!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Room {
  String? title;
  List<Chats>? chats;

  Room({this.title, this.chats});

  Room.fromJson(Map<String, dynamic> json) {
    title = json['title'];
    if (json['chats'] != null) {
      chats = <Chats>[];
      json['chats'].forEach((v) {
        chats!.add(new Chats.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['title'] = this.title;
    if (this.chats != null) {
      data['chats'] = this.chats!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Chats {
  String? sender;
  String? content;

  Chats({this.sender, this.content});

  Chats.fromJson(Map<String, dynamic> json) {
    sender = json['sender'];
    content = json['content'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['sender'] = this.sender;
    data['content'] = this.content;
    return data;
  }
}
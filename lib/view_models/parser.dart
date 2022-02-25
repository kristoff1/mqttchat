

import 'package:mqttchat/payload/room_payload.dart';
import 'package:mqttchat/view_models/room_model.dart';

import 'chat_item.dart';

List<RoomModel> parseSubscribedMessage(RoomPayload payload) {
  return payload.room!.map<RoomModel>((Room room) {
    return RoomModel(
        title: room.title!,
        isSubscribed: true,
        messages: room.chats!.map<ChatItem>((Chats chat) {
          return ChatItem(
              sender: chat.sender!, content: chat.content!, isMine: false);
        }).toList());
  }).toList();
}

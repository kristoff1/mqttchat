import 'dart:convert';

import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqttchat/global/connection_status.dart';
import 'package:mqttchat/payload/chat.dart';
import 'package:mqttchat/view_models/chat_item.dart';
import 'package:mqttchat/view_models/room_model.dart';

class ListenerLogic {
  ListenerLogic();

  void actionsAfterConnected({
    required Function() onActionFinished,
    required MqttServerClient client,
  }) {
    client.subscribe('chat/+/room', MqttQos.exactlyOnce);
    client.subscribe('will/#', MqttQos.atMostOnce);
    onActionFinished();
  }

  void onSubscribedToAChatRoom({
    required String topic,
    required MqttServerClient client,
    required List<RoomModel> chatRooms,
    required Function() onUpdateChatRoomState,
  }) {
    String subscribedTopic =
        topic.replaceFirst('chat/', '').replaceFirst('/message', '');
    for (int i = 0; i < chatRooms.length; i++) {
      if (chatRooms[i].title == subscribedTopic) {
        chatRooms[i].isSubscribed = true;
        print('=====CHANGED TO TRUE======');
        onUpdateChatRoomState();
      }

      ///Once subscription to chat room done, subscribe to its notification
      client.subscribe(
          'chat/$subscribedTopic/notification', MqttQos.exactlyOnce);
    }
  }

  void onUnsubscribeToChatRoom({
    required String topic,
    required MqttServerClient client,
    required List<RoomModel> chatRooms,
    required onUnsubscribed,
  }) {
    String unsubscribedTopic =
    topic.replaceFirst('chat/', '').replaceFirst('/message', '');
    for (int i = 0; i < chatRooms.length; i++) {
      if (chatRooms[i].title == unsubscribedTopic) {
        chatRooms[i].isSubscribed = false;
        onUnsubscribed();
      }
    }
    ///Once unsubscription to chat room done, unsubscribe to its notification
    client.unsubscribe('chat/$unsubscribedTopic/notification');
  }

  void initiateMqttMessageListener({
    required MqttServerClient client,
    required List<RoomModel> chatRooms,
    required String clientName,
    required Function(
      List<RoomModel> chatRooms,
      MqttServerClient client,
      String clientName,
      ConnectionStatus status,
      String notification,
    )
        onChatRoomsUpdated,
  }) {
    ///MAIN LISTENER EVERYTIME PUBLISHED DECLARED
    client.updates!.listen((List<MqttReceivedMessage<MqttMessage>> c) {

      final String content = receivedMessageContent(c);

      String notificationMessage = '';

      ///LISTEN TO ROOM UPDATES
      if (c[0].topic.endsWith('/room') && content.startsWith('ADD_')) {
        chatRooms.add(RoomModel(
            title: content.replaceFirst('ADD_', ''), isSubscribed: false));
      }

      ///LISTEN TO MESSAGE UPDATES
      if (c[0].topic.endsWith('/message')) {
        String topicName =
            c[0].topic.replaceFirst('chat/', '').replaceFirst('/message', '');
        for (int i = 0; i < chatRooms.length; i++) {
          if (chatRooms[i].title == topicName) {
            Chat receivedChat = Chat.fromJson(jsonDecode(content));
            chatRooms[i].messages = List.from(chatRooms[i].messages)
              ..add(ChatItem(
                  sender: receivedChat.sender ?? '',
                  content: receivedChat.content ?? '',
                  isMine: receivedChat.sender == clientName));
          }
        }
      }

      if (c[0].topic.endsWith('/notification')) {
        notificationMessage = content;
      }

      ///UPDATE ROOMS

      onChatRoomsUpdated(
        chatRooms,
        client,
        clientName,
        ConnectionStatus.connected,
        notificationMessage,
      );
    });
  }
  String receivedMessageContent(List<MqttReceivedMessage<MqttMessage>> c) {
    final receivedMessage = c[0].payload as MqttPublishMessage;
    return MqttPublishPayload.bytesToStringAsString(
        receivedMessage.payload.message);
  }
}

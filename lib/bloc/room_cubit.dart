import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqttchat/bloc/room_state.dart';
import 'package:mqttchat/global/connection_status.dart';

class RoomCubit extends Cubit<RoomState> {
  RoomCubit(RoomState initialState) : super(initialState);

  void setUpClient(String address, int port, String clientName) async {
    MqttServerClient client = state.initiationLogic.initiatedClient(
      address,
      port,
      clientName,
    );
    client.onConnected = () {
      state.listenerLogic.actionsAfterConnected(
          onActionFinished: () => emit(RoomState(
                rooms: state.rooms,
                client: client,
                clientName: clientName,
                status: ConnectionStatus.connected,
                notification: '',
              )),
          client: client);
    };

    client.onSubscribed = (String topic) {
      if (topic.endsWith('/message')) {
        state.listenerLogic.onSubscribedToAChatRoom(
            topic: topic,
            client: client,
            chatRooms: state.rooms,
            onUpdateChatRoomState: () => emit(RoomState(
                rooms: state.rooms,
                client: state.client,
                clientName: state.clientName,
                status: ConnectionStatus.connected)));
      }
    };

    client.onUnsubscribed = (String? topic) {
      if (topic!.endsWith('/message')) {
        state.listenerLogic.onUnsubscribeToChatRoom(
            topic: topic,
            client: client,
            chatRooms: state.rooms,
            onUnsubscribed: () {
              emit(RoomState(
                  rooms: state.rooms,
                  client: state.client,
                  clientName: state.clientName,
                  status: ConnectionStatus.connected));
            });
      }
    };

    client.onDisconnected = () {
      print('EXAMPLE::OnDisconnected client callback - Client disconnection');
      if (state.client.connectionStatus!.disconnectionOrigin ==
          MqttDisconnectionOrigin.solicited) {
        emit(RoomState(
            rooms: state.rooms,
            client: state.client,
            clientName: state.clientName,
            status: ConnectionStatus.disconnected));
        print('EXAMPLE::OnDisconnected callback is solicited, this is correct');
      } else {
        print(
            'EXAMPLE::OnDisconnected callback is unsolicited or none, this is incorrect - exiting');
      }
    };

    client.onAutoReconnect = () {
      emit(RoomState(
          rooms: state.rooms,
          client: state.client,
          clientName: state.clientName,
          status: ConnectionStatus.disconnected));
    };

    client.onAutoReconnected = () {
      print('AUTO RECONNECTED');
      emit(RoomState(
          rooms: state.rooms,
          client: state.client,
          clientName: state.clientName,
          status: ConnectionStatus.connected));
    };

    try {
      await client.connect();
      state.listenerLogic.initiateMqttMessageListener(
        client: client,
        chatRooms: state.rooms,
        clientName: clientName,
        onChatRoomsUpdated: (
            chatRooms,
            client,
            clientName,
            status,
            notification,
            ) =>
            emit(RoomState(
              rooms: chatRooms,
              client: client,
              clientName: clientName,
              status: status,
              notification: notification,
            )),
      );
    } on NoConnectionException catch (e) {
      print('EXAMPLE::client exception - $e');
      client.disconnect();
    } on SocketException catch (_) {
      client.disconnect();
      emit(RoomState(
          rooms: state.rooms,
          client: state.client,
          status: ConnectionStatus.failToConnect,
          clientName: '',
          notification:
          'Fail to Connect to Broker! (please check broker address and port)'));
    } on Exception catch (_) {
      client.disconnect();
      emit(RoomState(
          rooms: state.rooms,
          client: state.client,
          status: ConnectionStatus.failToConnect,
          clientName: '',
          notification:
          'Fail to Connect to Broker! Try to check your connection'));
    }
  }

  void startNewRoom(String roomName) {
    ///Added new topic with the topic name as its content
    final builder = MqttClientPayloadBuilder();
    builder.addString('ADD_');
    builder.addString(roomName);
    state.client.publishMessage(
        'chat/$roomName/room', MqttQos.exactlyOnce, builder.payload!);
  }

  void chatMessage(String message, String roomName) {
    final builder = MqttClientPayloadBuilder();
    builder.addString(
        "{\"sender\":\"${state.clientName}\",\"content\":\"$message\",\"room\":\"$roomName\"}");

    state.client.publishMessage(
        'chat/$roomName/message', MqttQos.exactlyOnce, builder.payload!);

    ///REVERT HERE ADDING /message at the end of the room failed IF Failed
    /*state.client.publishMessage(
        'chat/$roomName', MqttQos.exactlyOnce, builder.payload!);*/
  }

  void joinRoom(String roomName) {
    final builder = MqttClientPayloadBuilder();
    builder.addString('${state.clientName} joins $roomName');

    ///Add Notification
    state.client.publishMessage(
        'chat/$roomName/notification', MqttQos.exactlyOnce, builder.payload!);
  }

  void unsubscribeRoom(String roomName) {
    state.client.unsubscribe('chat/$roomName/message');
  }

  void subscribeRoom(String roomName) {
    print('=====SUBSCRIBE ROOM $roomName=======');

    ///Subscribe to room message updates
    state.client.subscribe('chat/$roomName/message', MqttQos.exactlyOnce);
  }

  void resetState() {
    emit(RoomState(
      client: MqttServerClient('', ''),
      status: ConnectionStatus.initial,
      rooms: [],
      clientName: '',
      notification: '',
    ));
  }
}

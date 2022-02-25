import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqttchat/global/connection_status.dart';
import 'package:mqttchat/view_models/room_model.dart';

import 'logics/initiation_logic.dart';
import 'logics/listener_logic.dart';


class RoomState {
  final List<RoomModel> rooms;

  final MqttServerClient client;

  final String clientName;

  final ConnectionStatus status;

  ///DI Function
  final InitiationLogic initiationLogic = InitiationLogic();

  final ListenerLogic listenerLogic = ListenerLogic();
  ///End of DI

  String? notification;

  RoomState({
    required this.rooms,
    required this.client,
    required this.status,
    required this.clientName,
    this.notification = '',
  });
}

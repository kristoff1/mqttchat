import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';

class InitiationLogic {
  InitiationLogic();

  MqttServerClient initiatedClient(
      String address,
      int port,
      String clientName,) {

    MqttServerClient client =
    MqttServerClient.withPort(address, clientName, port);

    client.useWebSocket = false;

    client.logging(on: false);

    /// Set the correct MQTT protocol for mosquito
    client.setProtocolV311();

    client.keepAlivePeriod = 20;

    client.autoReconnect = true;

    client.resubscribeOnAutoReconnect = true;

    client.connectionMessage = connectMessage(clientName);

    client.pongCallback = () {

    };

    return client;
  }

  MqttConnectMessage connectMessage(String clientName) {
    return MqttConnectMessage()
        .withClientIdentifier(clientName)
        .withWillTopic(
        'will/notification') // If you set this you must set a will message
        .withWillMessage('$clientName is Disconnected')
        .startClean() // Non persistent session for testing
        .withWillQos(MqttQos.atLeastOnce);
  }

}

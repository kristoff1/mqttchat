import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:mqttchat/bloc/room_cubit.dart';
import 'package:mqttchat/bloc/room_state.dart';
import 'package:mqttchat/landing.dart';

import 'global/connection_status.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<RoomCubit>(
          create: (BuildContext context) => RoomCubit(RoomState(
              rooms: [],
              status: ConnectionStatus.initial,
              clientName: '',
              notification: '',
              ///Only to place initial value
              client: MqttServerClient(
                  '', ''))),
        )
      ],
      child: MaterialApp(
        title: 'MQTT Chat',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: LandingPage(),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqttchat/global/connection_status.dart';
import 'package:mqttchat/home_page.dart';
import 'package:mqttchat/initial_setting_page.dart';

import 'bloc/room_cubit.dart';
import 'bloc/room_state.dart';

class LandingPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return LandingPageState();
  }
}

class LandingPageState extends State<LandingPage> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RoomCubit, RoomState>(
      bloc: BlocProvider.of<RoomCubit>(context),
      builder: (BuildContext context, RoomState state) {
        if (state.status == ConnectionStatus.connected ||
            state.status == ConnectionStatus.disconnected) {
          return HomePage(
            state: state,
          );
        } else {
          return InitialSettingPage(
            notification: state.notification ?? '',
            status: state.status,
          );
        }
      },
    );
  }
}

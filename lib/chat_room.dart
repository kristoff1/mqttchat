import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqttchat/view_models/room_model.dart';

import 'bloc/room_cubit.dart';
import 'bloc/room_state.dart';
import 'chat_tile.dart';
import 'global/connection_status.dart';
import 'global/notification_bar.dart';

class ChatRoom extends StatelessWidget {
  final String chatRoomName;

  final TextEditingController controller = TextEditingController();

  ChatRoom({
    required this.chatRoomName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(chatRoomName),
          actions: [
            BlocBuilder<RoomCubit, RoomState>(
                bloc: BlocProvider.of<RoomCubit>(context),
                builder: (BuildContext context, RoomState state) {
                  return ElevatedButton(
                    onPressed: () {},
                    child: state.status == ConnectionStatus.connected
                        ? const Text('Connected')
                        : const Text('Disconnected'),
                  );
                }),
          ],
        ),
        bottomNavigationBar: BlocBuilder<RoomCubit, RoomState>(
          bloc: BlocProvider.of<RoomCubit>(context),
          builder: (BuildContext context, RoomState state) {
            return NotificationBar(state.notification ?? 'No New Notification');
          },
        ),
        body: Column(
          children: [
            Expanded(
                flex: 8,
                child: BlocBuilder<RoomCubit, RoomState>(
                    buildWhen: (_, RoomState state) {
                      return updateIsForCurrentRoom(state);
                    },
                    bloc: BlocProvider.of<RoomCubit>(context),
                    builder: (BuildContext context, RoomState state) {
                      RoomModel currentRoomModel = getCurrentRoom(state);
                      return currentRoomModel.messages.isNotEmpty
                          ? ListView.builder(
                              shrinkWrap: true,
                              itemCount: currentRoomModel.messages.length,
                              itemBuilder: (BuildContext context, int index) {
                                return ChatTile(
                                  isMine:
                                      currentRoomModel.messages[index].isMine,
                                  sender:
                                      currentRoomModel.messages[index].sender,
                                  message:
                                      currentRoomModel.messages[index].content,
                                );
                              })
                          : const Center(
                              child: Text('Start Chatting'),
                            );
                    })),
            Expanded(
                flex: 2,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 7,
                        child: TextField(
                          controller: controller,
                          decoration:
                              const InputDecoration(hintText: 'Type Here'),
                        ),
                      ),
                      Expanded(
                        flex: 3,
                        child: ElevatedButton(
                          child: const Text('Send'),
                          onPressed: () {
                            BlocProvider.of<RoomCubit>(context)
                                .chatMessage(controller.text, chatRoomName);
                            controller.text = '';
                          },
                        ),
                      ),
                    ],
                  ),
                )),
          ],
        ));
  }

  RoomModel getCurrentRoom(RoomState state) {
    for (int i = 0; i < state.rooms.length; i++) {
      if (state.rooms[i].title == chatRoomName) {
        return state.rooms[i];
      }
    }
    return RoomModel(
        title: chatRoomName,
        messages: [],
        participants: [],
        isSubscribed: true);
  }

  bool updateIsForCurrentRoom(RoomState state) {
    for (int i = 0; i < state.rooms.length; i++) {
      if (state.rooms[i].title == chatRoomName) {
        return true;
      }
    }
    return false;
  }
}

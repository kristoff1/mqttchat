import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mqttchat/bloc/room_cubit.dart';
import 'package:mqttchat/bloc/room_state.dart';
import 'package:mqttchat/chat_room.dart';
import 'package:mqttchat/global/connection_status.dart';
import 'package:mqttchat/helpers/topic_to_title_helper.dart';
import 'package:mqttchat/room_list_item.dart';

class HomePage extends StatelessWidget {
  final RoomState state;

  HomePage({required this.state});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                TextEditingController _controller = TextEditingController();
                return AlertDialog(
                  title: Text('Add new Topic'),
                  content: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        'only lower case without spaces & no special characters allowed',
                        textAlign: TextAlign.center,
                      ),
                      const Text(
                        'example: room1',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontWeight: FontWeight.bold),
                      ),
                      TextField(
                        controller: _controller,
                        inputFormatters: <TextInputFormatter>[
                          FilteringTextInputFormatter.allow(RegExp("[a-z0-9]")),
                        ],
                      ),
                    ],
                  ),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text('Cancel')),
                    TextButton(
                        onPressed: () {
                          BlocProvider.of<RoomCubit>(context)
                              .startNewRoom(_controller.text);
                          Navigator.pop(context);
                        },
                        child: Text('Create')),
                  ],
                );
              });
        },
        child: const Icon(Icons.add),
      ),
      appBar: AppBar(
        title: const Text('Home Page'),
        bottom: Tab(
          text: state.status == ConnectionStatus.connected
              ? 'Connected'
              : 'Disconnected',
          icon: state.status == ConnectionStatus.connected
              ? const Icon(Icons.settings_input_antenna_outlined)
              : const Icon(Icons.signal_cellular_connected_no_internet_4_bar),
        ),
        actions: [
          state.status == ConnectionStatus.connected
              ? ElevatedButton(
                  onPressed: () {
                    BlocProvider.of<RoomCubit>(context).resetState();
                  },
                  child: const Text('Reset'))
              : const SizedBox(
                  height: 0,
                  width: 0,
                ),
        ],
      ),
      body: state.rooms.isNotEmpty
          ? ListView.builder(
              itemCount: state.rooms.length,
              itemBuilder: (BuildContext context, int index) {
                return RoomListItem(
                  isSubscribed: state.rooms[index].isSubscribed,
                  onSubscribe: () {
                    BlocProvider.of<RoomCubit>(context)
                        .subscribeRoom(state.rooms[index].title);
                  },
                  onGoToRoom: () {
                    BlocProvider.of<RoomCubit>(context)
                        .joinRoom(state.rooms[index].title);
                    Navigator.push(context,
                        MaterialPageRoute(builder: (BuildContext context) {
                      return ChatRoom(
                        chatRoomName: viewTitle(state.rooms[index].title),
                      );
                    }));
                  },
                  roomName: viewTitle(state.rooms[index].title),
                  onUnsubscribe: () {
                    BlocProvider.of<RoomCubit>(context)
                        .unsubscribeRoom(state.rooms[index].title);
                  },
                );
              })
          : const Center(
              child: Text('No Chat Room Yet, you can make the first one'),
            ),
    );
  }
}

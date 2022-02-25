import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RoomListItem extends StatelessWidget {
  String roomName;

  bool isSubscribed;

  Function() onGoToRoom;

  Function() onUnsubscribe;

  Function() onSubscribe;

  RoomListItem({
    required this.roomName,
    required this.onGoToRoom,
    required this.onUnsubscribe,
    required this.onSubscribe,
    required this.isSubscribed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: isSubscribed
          ? onGoToRoom
          : () {
              Fluttertoast.showToast(msg: 'Subscribe to room first!');
            },
      child: Ink(
        decoration: const BoxDecoration(
          border: Border.symmetric(
              vertical: BorderSide(color: Colors.black45, width: 1)),
        ),
        padding: EdgeInsets.all(8),
        child: Row(
          children: [
            Expanded(
                flex: 6,
                child: Text(
                  roomName,
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                )),
            Expanded(
              flex: 4,
              child: isSubscribed
                  ? ElevatedButton(
                      child: Text('Unsubscribe'),
                      onPressed: onUnsubscribe,
                    )
                  : ElevatedButton(
                      onPressed: onSubscribe, child: Text('Subscribe')),
            )
          ],
        ),
      ),
    );
  }
}

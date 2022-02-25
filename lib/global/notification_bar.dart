import 'package:flutter/material.dart';

class NotificationBar extends StatelessWidget {
  String notificationMessage;

  NotificationBar(this.notificationMessage);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      alignment: Alignment.center,
      padding: const EdgeInsets.all(8),
      color: Colors.amberAccent.withOpacity(0.5),
      child: notificationMessage.isEmpty
          ? const Text('No New Notifications', textAlign: TextAlign.center,)
          : Text(
              notificationMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
    );
  }
}

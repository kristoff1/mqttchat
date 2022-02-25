import 'package:flutter/material.dart';

class ChatTile extends StatelessWidget {
  bool isMine;

  String sender;

  String message;

  ChatTile({required this.isMine, required this.sender, required this.message});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8),
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.all(Radius.circular(8)),
          color: isMine ? Colors.lightGreen : Colors.white54),
      alignment: isMine ? Alignment.centerLeft : Alignment.centerRight,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            sender,
            textAlign: isMine ? TextAlign.start : TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
          ),
          Text(
            message,
            textAlign: isMine ? TextAlign.start : TextAlign.end,
            style: const TextStyle(fontSize: 18),
          ),
        ],
      ),
    );
  }
}

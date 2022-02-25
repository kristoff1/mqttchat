import 'package:equatable/equatable.dart';

import 'chat_item.dart';

class RoomModel extends Equatable {
  String title;

  bool isSubscribed;

  List<ChatItem> messages;

  List<String> participants;

  RoomModel(
      {required this.title,
      required this.isSubscribed,
      this.messages = const [],
      this.participants = const []});

  @override
  // TODO: implement props
  List<Object?> get props => [title];
}

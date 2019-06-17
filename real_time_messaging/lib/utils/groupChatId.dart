import 'package:real_time_messaging/models/user.dart';

String getGroupChatId({User sender, User recevier}) {
  return sender.userId.hashCode <= recevier.userId.hashCode
            ? '${sender.userId}-${recevier.userId}'
            : '${recevier.userId}-${sender.userId}';
}
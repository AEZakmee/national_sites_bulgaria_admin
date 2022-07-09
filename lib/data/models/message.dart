import 'package:firedart/firestore/models.dart';
import 'package:json_annotation/json_annotation.dart';

import '../../widgets/firestore_json.dart';

part 'message.g.dart';

@JsonSerializable()
class ChatMessage {
  String userId;
  @JsonKey(fromJson: firebaseDocRefFromJson, toJson: firebaseDocRefToJson)
  DocumentReference userReference;
  String message;
  DateTime sendTime;

  ChatMessage({
    required this.userId,
    required this.userReference,
    required this.message,
    required this.sendTime,
  });

  factory ChatMessage.fromJson(Map<String, dynamic> json) =>
      _$ChatMessageFromJson(json);
  Map<String, dynamic> toJson() => _$ChatMessageToJson(this);
}

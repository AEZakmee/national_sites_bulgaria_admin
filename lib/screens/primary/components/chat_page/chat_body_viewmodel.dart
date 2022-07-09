import 'package:firedart/firestore/models.dart';
import 'package:fluent_ui/fluent_ui.dart';

import '../../../../app/locator.dart';
import '../../../../data/models/app_user.dart';
import '../../../../data/models/chat_room.dart';
import '../../../../data/models/message.dart';
import '../../../../data/repos/data_repo.dart';
import '../../../../services/firestore_service.dart';

class ChatPageVM extends ChangeNotifier {
  final _firebase = locator<FirestoreService>();
  final _dataRepo = locator<DataRepo>();

  ChatRoom? selectedRoom;

  bool initialLoad = true;

  Stream<List<ChatRoom>> get rooms => _firebase.roomsStream();

  Future<void> loadRoom(String id) async {
    initialLoad = false;
    selectedRoom = null;
    chatUsers = {};
    notifyListeners();

    selectedRoom = await _firebase.fetchRoom(id);
    notifyListeners();
  }

  Stream<List<ChatMessage>> get messages {
    assert(selectedRoom != null);
    return _firebase.messagesStream(selectedRoom!.siteId);
  }

  Map<String, AppUser> chatUsers = {};

  Future<AppUser> getUserData(
    DocumentReference ref,
    String userId,
  ) async {
    AppUser? user = chatUsers[userId];
    if (user != null) {
      return user;
    }
    user = await ref.get().then(
          (value) => AppUser.fromJson(value.map),
        );
    chatUsers[user!.uniqueID!] = user;
    return user;
  }

  bool sendByUser(ChatMessage message) =>
      message.userId == _dataRepo.user.uniqueID;
}

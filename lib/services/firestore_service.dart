import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../data/models/app_user.dart';
import '../data/models/chat_room.dart';
import '../data/models/message.dart';
import '../data/models/site.dart';

const googleStorageApi = 'https://firebasestorage.googleapis.com/v0/b/';
const rootFolder = 'places_pictures';

class FirestoreService {
  final Firestore _db;
  final FirebaseAuth _auth;

  FirestoreService({
    required db,
    required auth,
  })  : _db = db,
        _auth = auth;

  String get _userId => _auth.userId;
  String get token => '';

  Future<AppUser> fetchUser() => _db
      .collection('users')
      .document(_userId)
      .get()
      .then((snapshot) => AppUser.fromJson(snapshot.map));

  Stream<AppUser> userStream() => _db
      .collection('users')
      .document(_userId)
      .stream
      .map((event) => AppUser.fromJson(event!.map));

  Future<List<Site>> fetchSites() async {
    final docs = await _db.collection('sites').get();
    return docs.map((e) => Site.fromJson(e.map)).toList();
  }

  Future<Site> fetchSite(String uid) => _db
      .collection('sites')
      .document(uid)
      .get()
      .then((snapshot) => Site.fromJson(snapshot.map));

  Future<void> createSite(Site site) =>
      _db.collection('sites').document(site.uid).set(site.toJson());

  Future<void> deleteSite(String uid) async {
    await _db.collection('sites').document(uid).delete();
    await _db.collection('rooms').document(uid).delete();
  }

  Future<ChatRoom> fetchRoom(String siteId) => _db
      .collection('rooms')
      .document(siteId)
      .get()
      .then((value) => ChatRoom.fromJson(value.map));

  Future<List<ChatRoom>> fetchRooms() async {
    final docs = await _db.collection('rooms').get();
    return docs.map((e) => ChatRoom.fromJson(e.map)).toList();
  }

  Future<List<ChatMessage>> fetchMessages(String siteId) async {
    final docs = await _db
        .collection('rooms')
        .document(siteId)
        .collection('messages')
        .get();
    return docs.map((e) => ChatMessage.fromJson(e.map)).toList();
  }

  Future<String?> uploadImage({
    required Uint8List imageBytes,
    String? imageName,
    String? folderName,
  }) async {
    final additionalFolder = folderName != null ? '%2F$folderName%2F' : '%2F';
    final imagePath = imageName ?? DateTime.now().millisecondsSinceEpoch;
    final imageRef = '$rootFolder$additionalFolder$imagePath.jpg';

    final projectPath = '${dotenv.get('PROJECT_ID')}.appspot.com/o/';
    final storageUrl = '$googleStorageApi$projectPath$imageRef';

    try {
      final response = await http.post(
        Uri.parse(storageUrl),
        body: imageBytes,
      );

      final downloadToken = jsonDecode(response.body)['downloadTokens'];

      if (downloadToken != null && downloadToken.toString().isNotEmpty) {
        return '$storageUrl?alt=media&token=$downloadToken';
      }
    } on Exception catch (e) {
      log('ImageUpload failed: $e');
    }
    return null;
  }
}

// ignore_for_file: avoid_catches_without_on_clauses

import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../data/api_response.dart';
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

  Future<ApiResponse<AppUser>> fetchUser() async {
    bool success = false;
    AppUser? user;

    try {
      user = await _db
          .collection('users')
          .document(_userId)
          .get()
          .then((snapshot) => AppUser.fromJson(snapshot.map));
      success = true;
    } catch (e) {
      log('fetchUser$e');
    }

    return ApiResponse(success: success, data: user);
  }

  Stream<AppUser> userStream() => _db
      .collection('users')
      .document(_userId)
      .stream
      .map((event) => AppUser.fromJson(event!.map));

  Future<ApiResponse<List<Site>>> fetchSites() async {
    bool success = false;
    List<Site>? sites;
    try {
      final docs = await _db.collection('sites').get();
      sites = docs.map((e) => Site.fromJson(e.map)).toList();

      success = true;
    } catch (e) {
      log('fetchSites$e');
    }

    return ApiResponse(success: success, data: sites);
  }

  Future<ApiResponse<Site>> fetchSite(String uid) async {
    bool success = false;
    Site? site;

    try {
      site = await _db
          .collection('sites')
          .document(uid)
          .get()
          .then((snapshot) => Site.fromJson(snapshot.map));

      success = true;
    } catch (e) {
      log('fetchUser$e');
    }

    return ApiResponse(success: success, data: site);
  }

  Future<bool> createSite(Site site) async {
    bool success = false;
    try {
      await _db.collection('sites').document(site.uid).set(site.toJson());
      success = true;
    } catch (e) {
      log('createSite$e');
    }

    return success;
  }

  Future<bool> deleteSite(String uid) async {
    bool success = false;
    try {
      await _db.collection('sites').document(uid).delete();
      await _db.collection('rooms').document(uid).delete();
      success = true;
    } catch (e) {
      log('fetchUser$e');
    }
    return success;
  }

  Future<ApiResponse<ChatRoom>> fetchRoom(String siteId) async {
    bool success = false;
    ChatRoom? room;

    try {
      room = await _db
          .collection('rooms')
          .document(siteId)
          .get()
          .then((value) => ChatRoom.fromJson(value.map));

      success = true;
    } catch (e) {
      log('fetchUser$e');
    }

    return ApiResponse(success: success, data: room);
  }

  Future<ApiResponse<List<ChatRoom>>> fetchRooms() async {
    bool success = false;
    List<ChatRoom>? rooms;
    try {
      final docs = await _db.collection('rooms').get();
      rooms = docs.map((e) => ChatRoom.fromJson(e.map)).toList();

      success = true;
    } catch (e) {
      log('fetchUser$e');
    }

    return ApiResponse(success: success, data: rooms);
  }

  Future<ApiResponse<List<ChatMessage>>> fetchMessages(String siteId) async {
    bool success = false;
    List<ChatMessage>? messages;
    try {
      final docs = await _db
          .collection('rooms')
          .document(siteId)
          .collection('messages')
          .get();
      messages = docs.map((e) => ChatMessage.fromJson(e.map)).toList();
      success = true;
    } catch (e) {
      log('fetchUser$e');
    }

    return ApiResponse(success: success, data: messages);
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
        headers: {
          HttpHeaders.authorizationHeader: await _auth.tokenProvider.idToken
        },
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

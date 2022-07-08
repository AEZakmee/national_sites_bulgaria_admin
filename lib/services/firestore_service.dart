import 'dart:convert';
import 'dart:developer';
import 'dart:typed_data';

import 'package:firedart/auth/firebase_auth.dart';
import 'package:firedart/firestore/firestore.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../data/models/app_user.dart';
import '../data/models/site.dart';

const googleStorageApi = 'https://firebasestorage.googleapis.com/v0/b/';
const rootFolder = 'places_pictures';

class FirestoreService {
  final _db = Firestore.instance;
  final _auth = FirebaseAuth.instance;

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

  Stream<List<Site>> sitesStream() => _db
      .collection('sites')
      .stream
      .map((doc) => doc.map((e) => Site.fromJson(e.map)).toList());

  Future<List<Site>> fetchSites() async {
    final docs = await _db.collection('sites').get();
    return docs.map((e) => Site.fromJson(e.map)).toList();
  }

  Future<Site> fetchSite(String uid) => _db
      .collection('sites')
      .document(uid)
      .get()
      .then((snapshot) => Site.fromJson(snapshot.map));

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
        headers: <String, String>{
          'Content-Type': 'image/png',
          "Authorization": "Bearer $token",
        },
        body: json.encode(imageBytes),
      );

      final downloadToken = json.decode(response.body)['downloadTokens'];

      if (downloadToken != null && downloadToken.toString().isNotEmpty) {
        return '$storageUrl?alt=media&token=$downloadToken';
      }
    } on Exception catch (e) {
      log('ImageUpload failed: ' + e.toString());
    }
    return null;
  }
}

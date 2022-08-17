import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

import '../../app/locator.dart';
import '../../services/firestore_service.dart';
import '../models/app_user.dart';
import '../models/site.dart';

class DataRepo extends ChangeNotifier {
  final FirestoreService _fireStoreService;

  late AppUser user;
  late List<Site> sites;
  late StreamSubscription<AppUser> _userSubscription;

  DataRepo({required FirestoreService fireStoreService})
      : _fireStoreService = fireStoreService;

  Future<void> init() async {
    user = await _fireStoreService.fetchUser();
    sites = await _fireStoreService.fetchSites();
  }

  Future<void> updateSites() async {
    sites = await _fireStoreService.fetchSites();
    notifyListeners();
  }

  void userListener() {
    _userSubscription = _fireStoreService.userStream().listen((value) {
      user = value;
      notifyListeners();
    });
  }

  void initListeners() {
    userListener();
  }

  void cancelListeners() {
    _userSubscription.cancel();
  }
}

import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

import '../../app/locator.dart';
import '../../services/firestore_service.dart';
import '../models/app_user.dart';
import '../models/site.dart';

class DataRepo extends ChangeNotifier {
  final FirestoreService _fireStoreService;

  late AppUser user;
  late StreamSubscription<AppUser> _userSubscription;

  DataRepo({required FirestoreService fireStoreService})
      : _fireStoreService = fireStoreService;

  Future<void> init() async {
    final userResponse = await _fireStoreService.fetchUser();
    if (userResponse.success) {
      user = userResponse.data;
    } else {
      await init();
    }
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

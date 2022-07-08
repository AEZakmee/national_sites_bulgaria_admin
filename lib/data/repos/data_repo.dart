import 'dart:async';

import 'package:fluent_ui/fluent_ui.dart';

import '../../app/locator.dart';
import '../../services/firestore_service.dart';
import '../models/app_user.dart';

class DataRepo extends ChangeNotifier {
  final FirestoreService _fireStoreService = locator<FirestoreService>();

  late AppUser user;
  late StreamSubscription<AppUser> _userSubscription;

  Future<void> init() async {
    user = await _fireStoreService.fetchUser();
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

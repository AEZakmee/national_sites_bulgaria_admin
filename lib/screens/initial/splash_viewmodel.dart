import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../app/locator.dart';
import '../../app/router.dart';
import '../../data/repos/data_repo.dart';

class InitialViewModel extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final DataRepo _dataRepo = locator<DataRepo>();
  bool userIsLogged = false;

  bool showLogin = false;

  Future checkUser(BuildContext context) async {
    await Future.delayed(const Duration(seconds: 1, milliseconds: 500));
    if (_auth.isSignedIn) {
      await _dataRepo.init();
      await Future.delayed(const Duration(seconds: 1));
      return Navigator.of(context).pushReplacementNamed(Routes.primary);
    } else {
      userIsLogged = true;
    }
    notifyListeners();
  }

  void goToAuthenticationScreen(BuildContext context) {
    showLogin = true;
    notifyListeners();
  }
}

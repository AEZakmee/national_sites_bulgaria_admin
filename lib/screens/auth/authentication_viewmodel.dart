import 'dart:developer';

import 'package:firedart/auth/exceptions.dart';
import 'package:firedart/auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../../app/router.dart';

final RegExp regExpEmail = RegExp(
    r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

class AuthVM extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  //final _dataRepo = locator<DataRepo>();

  AuthVM() {
    _loginType = LoginType.signUp;
    _email = ValidationItem();
    _password = ValidationItem();
  }

  LoginType _loginType = LoginType.signUp;
  LoginType get loginType => _loginType;

  bool get isSignUp => _loginType == LoginType.signUp;

  late ValidationItem _email;
  late ValidationItem _password;

  bool _buttonPressed = false;
  set buttonPressed(bool value) {
    _buttonPressed = value;
    notifyListeners();
  }

  bool get buttonPressed => _buttonPressed;

  //SignUpData methods
  bool hasError(DataField dataField) {
    if (_loginType == LoginType.login) return false;
    switch (dataField) {
      case DataField.email:
        return _email.error;
      case DataField.password:
        return _password.error;
      default:
        return false;
    }
  }

  void changeData(DataField dataField, String data) {
    _hasAuthError = false;
    switch (dataField) {
      case DataField.email:
        _email.data = data.trim();
        if (regExpEmail.hasMatch(data.trim())) {
          _email.error = false;
        } else {
          _email.error = true;
        }
        break;
      case DataField.password:
        _password.data = data.trim();
        if (data.trim().length >= 8) {
          _password.error = false;
        } else {
          _password.error = true;
        }
        break;
    }
    notifyListeners();
  }

  String getErrorMessage(DataField dataField, BuildContext context) {
    switch (dataField) {
      case DataField.email:
        if (_email.error) {
          return AppLocalizations.of(context)!.emailInvalid;
        }
        break;
      case DataField.password:
        if (_password.error) {
          return AppLocalizations.of(context)!.passwordMustLong;
        }
        break;
      default:
        return AppLocalizations.of(context)!.somethingWentWrong;
    }
    return AppLocalizations.of(context)!.somethingWentWrong;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;
  set isLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }

  //Authentication - Register/Login
  bool _hasAuthError = false;
  String? _authErrorString;
  bool get hasAuthError => _hasAuthError;

  String authErrorString(BuildContext context) {
    switch (_authErrorString) {
      case 'email-already-in-use':
        return AppLocalizations.of(context)!.emailInUse;
      case 'invalid-email':
        return AppLocalizations.of(context)!.emailInvalid;
      case 'operation-not-allowed':
        return AppLocalizations.of(context)!.invalidOperation;
      case 'weak-password':
        return AppLocalizations.of(context)!.weakPassword;
      case 'user-not-found':
        return AppLocalizations.of(context)!.userNotFound;
      case 'empty-fields':
        return AppLocalizations.of(context)!.emptyFields;
      case 'wrong-password':
        return AppLocalizations.of(context)!.wrongPass;
      default:
        return AppLocalizations.of(context)!.somethingWentWrong;
    }
  }

  void _authError({String error = ''}) {
    _hasAuthError = true;
    log('In _authError: $error');
    _authErrorString = error;
    notifyListeners();
  }

  Future<bool> _loginEmail() async {
    try {
      if (_email.data.isEmpty || _password.data.isEmpty) {
        _authError(error: 'empty-fields');
      } else {
        isLoading = true;
        await _auth.signIn(
          _email.data,
          _password.data,
        );
        return true;
      }
    } on AuthException catch (error) {
      _authError(error: error.errorCode);
    }
    return false;
  }

  bool loginClicked = false;

  Future<void> signUp(BuildContext context) async {
    if (loginClicked) {
      return;
    }
    _hasAuthError = false;
    loginClicked = true;
    buttonPressed = true;
    bool success = false;

    success = await _loginEmail();

    if (success && _auth.isSignedIn) {
      //await _dataRepo.init();
      await Navigator.of(context).pushReplacementNamed(
        Routes.primary,
      );
    }
    isLoading = false;
    loginClicked = false;
  }
}

enum LoginType { login, signUp }
enum DataField { email, password }

class ValidationItem {
  String data = '';
  bool error = true;
}

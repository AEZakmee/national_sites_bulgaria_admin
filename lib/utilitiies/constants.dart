import 'package:flutter/material.dart';

const kAnimTypeLogin = Curves.easeIn;
const kAnimDurationLogin = Duration(milliseconds: 400);

BoxShadow kBoxShadowLite(context) => BoxShadow(
      color: Theme.of(context).shadowColor.withOpacity(0.2),
      blurRadius: 5,
      spreadRadius: 2,
    );

BoxShadow kBoxShadow(context) => BoxShadow(
      color: Theme.of(context).shadowColor.withOpacity(0.5),
      blurRadius: 15,
      spreadRadius: 5,
    );

LinearGradient kArrowButtonGradient(context) => LinearGradient(
      colors: [
        Theme.of(context).primaryColor,
        Theme.of(context).secondaryHeaderColor
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

LinearGradient kLoginBackgroundGradient(context) => LinearGradient(
      colors: [
        Theme.of(context).secondaryHeaderColor,
        Theme.of(context).primaryColorDark,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

LinearGradient kSplashScreenGradient(context) => LinearGradient(
      colors: [
        Colors.black87,
        Theme.of(context).primaryColorDark,
      ],
      begin: Alignment.topLeft,
      end: Alignment.bottomRight,
    );

LinearGradient kOverImageGradient(Color? color) => LinearGradient(
      colors: [
        color ?? Colors.black,
        Colors.transparent,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

LinearGradient kUnderImageGradient(Color? color) => LinearGradient(
      colors: [
        Colors.transparent,
        color ?? Colors.black,
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

LinearGradient kOnRightImageGradient(Color? color) => LinearGradient(
      colors: [
        Colors.transparent,
        color ?? Colors.black,
      ],
    );

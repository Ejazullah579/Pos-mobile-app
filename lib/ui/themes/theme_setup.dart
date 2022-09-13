import 'dart:ui';

import 'package:flutter/material.dart';

List<ThemeData> getThemes() {
  return [
    ThemeData(
        backgroundColor: Colors.white,
        accentColor: Colors.white,
        bottomAppBarColor: Colors.blue,
        dialogBackgroundColor: Colors.white,
        primaryTextTheme: TextTheme(
            bodyText1: TextStyle(
          color: Colors.white,
        )),
        errorColor: Colors.red,
        primaryColorLight: Colors.black54,
        hintColor: Colors.black45,
        scaffoldBackgroundColor: Colors.white,
        primaryColorDark: Colors.black87,
        buttonTheme: ButtonThemeData(
          buttonColor: Colors.cyan,
        ),
        iconTheme: IconThemeData(
          color: Colors.black45,
        ))
  ];
}

ThemeData lightTheme() {
  return ThemeData(
      backgroundColor: Colors.white,
      bottomAppBarColor: Colors.blue,
      dialogBackgroundColor: Colors.white,
      primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
        color: Colors.white,
      )),
      errorColor: Colors.red,
      primaryColorLight: Colors.black54,
      hintColor: Colors.black45,
      scaffoldBackgroundColor: Colors.white,
      primaryColorDark: Colors.black87,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.cyan,
      ),
      iconTheme: IconThemeData(
        color: Colors.black45,
      ));
}

ThemeData darkTheme() {
  return ThemeData(
      backgroundColor: Colors.black,
      bottomAppBarColor: Colors.blue,
      dialogBackgroundColor: Colors.white,
      primaryTextTheme: TextTheme(
          bodyText1: TextStyle(
        color: Colors.white,
      )),
      errorColor: Colors.red,
      primaryColorLight: Colors.white54,
      hintColor: Colors.white60,
      scaffoldBackgroundColor: Colors.black,
      primaryColorDark: Colors.white70,
      buttonTheme: ButtonThemeData(
        buttonColor: Colors.cyan,
      ),
      iconTheme: IconThemeData(
        color: Colors.white54,
      ));
}

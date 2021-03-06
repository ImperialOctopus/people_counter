import 'package:flutter/material.dart';

/// Theme data for app.
final themeData = ThemeData(
  // This is the theme of your application.
  //
  // Try running your application with "flutter run". You'll see the
  // application has a blue toolbar. Then, without quitting the app, try
  // changing the primarySwatch below to Colors.green and then invoke
  // "hot reload" (press "r" in the console where you ran "flutter run",
  // or simply save your changes to "hot reload" in a Flutter IDE).
  // Notice that the counter didn't reset back to zero; the application
  // is not restarted.
  primarySwatch: Colors.amber,
  // This makes the visual density adapt to the platform that you run
  // the app on. For desktop platforms, the controls will be smaller and
  // closer together (more dense) than on mobile platforms.
  visualDensity: VisualDensity.adaptivePlatformDensity,

  textTheme: TextTheme(
      headline1: TextStyle(fontSize: 42),
      headline2: TextStyle(fontSize: 24, fontWeight: FontWeight.w500),
      headline6: TextStyle(color: Colors.black54)),

  elevatedButtonTheme: ElevatedButtonThemeData(
    style: ElevatedButton.styleFrom(
      //primary: Color.fromARGB(255, 181, 51, 70),
      textStyle: TextStyle(fontSize: 32),
      minimumSize: Size(200, 65),
    ),
  ),
  outlinedButtonTheme: OutlinedButtonThemeData(
    style: OutlinedButton.styleFrom(
      primary: Colors.black87,
      textStyle: TextStyle(fontSize: 32),
      minimumSize: Size(200, 65),
    ),
  ),
);

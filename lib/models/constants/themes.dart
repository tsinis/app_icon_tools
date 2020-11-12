import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

ThemeData get materialDark => _materialDark;
final ThemeData _materialDark = ThemeData(
    brightness: Brightness.dark,
    primarySwatch: Colors.grey,
    appBarTheme: AppBarTheme(color: Colors.grey[800]),
    primaryColor: Colors.grey[900],
    primaryColorLight: Colors.greenAccent[100],
    sliderTheme: SliderThemeData(thumbColor: Colors.grey[100]),
    accentColor: Colors.pink[300],
    errorColor: const Color(0xFFBB5B68),
    buttonColor: Colors.grey[800],
    selectedRowColor: Colors.pink[300],
    textButtonTheme: TextButtonThemeData(
      style: TextButton.styleFrom(primary: Colors.white, minimumSize: const Size(64, 35)),
    ));

ThemeData get materialLight => _materialLight;
final ThemeData _materialLight = ThemeData(
  brightness: Brightness.light,
  primarySwatch: Colors.grey,
  appBarTheme: AppBarTheme(color: Colors.white, iconTheme: IconThemeData(color: Colors.grey[700])),
  primaryColor: Colors.grey[200],
  primaryColorLight: Colors.greenAccent,
  sliderTheme: SliderThemeData(thumbColor: Colors.grey[600]),
  accentColor: Colors.greenAccent,
  errorColor: const Color(0xFFBB5B93),
  buttonColor: Colors.grey[350],
  selectedRowColor: const Color(0xFF51BB96),
  textButtonTheme:
      TextButtonThemeData(style: TextButton.styleFrom(primary: Colors.grey[800], minimumSize: const Size(64, 35))),
);

CupertinoThemeData get cupertinoDark => _cupertinoDark;
const CupertinoThemeData _cupertinoDark = CupertinoThemeData(
    brightness: Brightness.dark,
    primaryColor: CupertinoColors.systemGrey,
    primaryContrastingColor: CupertinoColors.white,
    barBackgroundColor: CupertinoColors.systemGrey5,
    scaffoldBackgroundColor: CupertinoColors.systemGrey6);

CupertinoThemeData get cupertinoLight => _cupertinoLight;
const CupertinoThemeData _cupertinoLight = CupertinoThemeData(
    brightness: Brightness.light,
    primaryColor: CupertinoColors.systemGrey,
    primaryContrastingColor: CupertinoColors.black,
    barBackgroundColor: CupertinoColors.systemGrey6,
    scaffoldBackgroundColor: CupertinoColors.systemGrey5);

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';

import 'widgets/drag_and_drop.dart';

class MyApp extends StatelessWidget {
  const MyApp({Key key}) : super(key: key);
  static final bool _isApple = platform.isCupertino;
  static const Text _buttonText = Text('Browse');

  static Widget button(Function() _onPressed) => _isApple
      ? CupertinoButton(color: const Color(0xFF008CFF), onPressed: _onPressed, child: _buttonText)
      : MaterialButton(color: const Color(0xFF008CFF), onPressed: _onPressed, child: _buttonText);
  @override
  Widget build(BuildContext context) {
    if (_isApple) {
      return CupertinoApp(
        theme: const CupertinoThemeData(brightness: Brightness.dark),
        home: CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: DragAndDrop()),
      );
    } else {
      return MaterialApp(
        theme: ThemeData(brightness: Brightness.dark),
        home: Scaffold(appBar: AppBar(), body: DragAndDrop()),
      );
    }
  }
}

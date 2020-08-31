import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../services/platform_detector.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => CurrentPlatform.isApple //TODO: Add app bar buttons.
      ? CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: SafeArea(child: child))
      : Scaffold(appBar: AppBar(), body: SafeArea(child: child));
}

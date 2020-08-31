import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../services/platform_detector.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => CurrentPlatform.isApple
      ? CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: child)
      : Scaffold(appBar: AppBar(), body: child);
}

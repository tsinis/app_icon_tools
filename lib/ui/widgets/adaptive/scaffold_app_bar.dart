import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';

import '../../../models/user_interface.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, Key key}) : super(key: key);

  final Widget child;

  @override
  Widget build(BuildContext context) => UserInterface.isApple //TODO: Add app bar buttons.
      ? CupertinoPageScaffold(navigationBar: const CupertinoNavigationBar(), child: SafeArea(child: child))
      : Scaffold(appBar: AppBar(), body: SafeArea(child: child));
}

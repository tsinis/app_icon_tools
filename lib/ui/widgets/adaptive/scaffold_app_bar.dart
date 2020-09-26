import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, this.uploadScreen = false, Key key}) : super(key: key);
  final bool uploadScreen;
  final Widget child;

  @override
  Widget build(BuildContext context) => UserInterface.isApple //TODO: Add app bar buttons.
      ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            leading: uploadScreen
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () => context.read<SetupIcon>().backButton(), child: const Icon(CupertinoIcons.back)),
          ),
          child: SafeArea(child: child))
      : Scaffold(
          appBar: AppBar(
              leading: uploadScreen
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.arrow_back), onPressed: () => context.read<SetupIcon>().backButton())),
          body: SafeArea(child: child));
}

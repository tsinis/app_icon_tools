import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import 'alert_dialog.dart';
import 'buttons/switch_button.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, this.uploadScreen = false, Key key}) : super(key: key);
  final bool uploadScreen;
  final Widget child;

  @override
  Widget build(BuildContext context) => UserInterface.isApple //TODO: Add app bar buttons.
      ? CupertinoPageScaffold(
          navigationBar: CupertinoNavigationBar(
            trailing: IconButton(
              icon: const Icon(CupertinoIcons.gear),
              onPressed: () => _showDialog(context),
            ),
            leading: uploadScreen
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () => context.read<SetupIcon>().backButton(), child: const Icon(CupertinoIcons.back)),
          ),
          child: SafeArea(child: child))
      : Scaffold(
          appBar: AppBar(
              actions: <IconButton>[
                IconButton(
                  icon: const Icon(Icons.settings),
                  onPressed: () => _showDialog(context),
                )
              ],
              leading: uploadScreen
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.arrow_back), onPressed: () => context.read<SetupIcon>().backButton())),
          body: SafeArea(child: child));

  Future<void> _showDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_context) => AdaptiveDialog(
            title: 'Settings',
            leftButton: 'Cancel',
            rightButton: 'Save',
            onPressedLeft: () => Navigator.of(context).pop(),
            onPressedRight: () => Navigator.of(context).pop(),
            content: Column(
              children: [
                AdaptiveSwitch(
                  text: 'Dark Mode',
                  value: _context.watch<UserInterface>().isDark,
                  onChanged: (_) => _context.read<UserInterface>().changeMode(),
                ),
              ],
            )),
      );
}

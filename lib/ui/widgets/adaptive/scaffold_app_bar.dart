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
            middle: uploadScreen
                ? const Text('Launcher Icon GUI')
                : Padding(
                    padding: const EdgeInsets.all(4),
                    child: CupertinoButton(
                        padding: const EdgeInsets.symmetric(horizontal: 64),
                        onPressed: () => print('Export pressed'),
                        color: CupertinoColors.systemYellow,
                        child: const Text('Export Icons')),
                  ),
            trailing: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                GestureDetector(
                    onTap: () => _showAboutDialog(context), child: const Icon(CupertinoIcons.info_circle, size: 26)),
                const SizedBox(width: 14),
                GestureDetector(
                    onTap: () => _showSettingsDialog(context), child: const Icon(CupertinoIcons.gear, size: 26))
              ],
            ),
            leading: uploadScreen
                ? const SizedBox.shrink()
                : GestureDetector(
                    onTap: () => context.read<SetupIcon>().backButton(),
                    child: const Icon(CupertinoIcons.back, size: 26)),
          ),
          child: SafeArea(child: child))
      : Scaffold(
          appBar: AppBar(
              centerTitle: true,
              title: uploadScreen
                  ? const Text('Launcher Icon GUI')
                  : MaterialButton(
                      colorBrightness: Brightness.light,
                      onPressed: () => context.read<SetupIcon>().archive(),
                      color: Colors.amber,
                      child: const Padding(padding: EdgeInsets.all(10), child: Text('Export Icons'))),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.info_outline), onPressed: () => _showAboutDialog(context)),
                IconButton(icon: const Icon(Icons.settings), onPressed: () => _showSettingsDialog(context))
              ],
              leading: uploadScreen
                  ? const SizedBox.shrink()
                  : IconButton(
                      icon: const Icon(Icons.arrow_back), onPressed: () => context.read<SetupIcon>().backButton())),
          body: SafeArea(child: child));

  void _showAboutDialog(BuildContext context) =>
      showAboutDialog(context: context, applicationName: 'Launcher Icons GUI');

  Future<void> _showSettingsDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_dialogContext) => AdaptiveDialog(
          title: 'Settings',
          leftButton: 'Cancel',
          rightButton: 'Save',
          onPressedLeft: () => Navigator.of(_dialogContext).pop(),
          onPressedRight: () => Navigator.of(_dialogContext).pop(),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AdaptiveSwitch(
                  text: 'Dark Mode',
                  value: _dialogContext.watch<UserInterface>().isDark,
                  onChanged: (_) => _dialogContext.read<UserInterface>().changeMode())
            ],
          ),
        ),
      );
}

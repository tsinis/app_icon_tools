import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import 'alert_dialog.dart';
import 'buttons/switch_button.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, this.uploadScreen = false, Key key}) : super(key: key);
  final bool uploadScreen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool _loading = context.select((SetupIcon icon) => icon.loading);
    return UserInterface.isApple
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              middle: uploadScreen
                  ? Text(S.of(context).appName)
                  : Padding(
                      padding: const EdgeInsets.all(4),
                      child: CupertinoButton(
                          disabledColor: CupertinoColors.systemGrey,
                          padding: const EdgeInsets.symmetric(horizontal: 64),
                          onPressed: _loading ? null : () => context.read<SetupIcon>().archive(),
                          color: CupertinoColors.activeOrange,
                          child: Text(_loading ? S.of(context).wait : S.of(context).export)),
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
                    ? Text(S.of(context).appName)
                    : MaterialButton(
                        colorBrightness: Brightness.light,
                        onPressed: _loading ? null : () => context.read<SetupIcon>().archive(),
                        color: Colors.amber,
                        child: Padding(
                            padding: const EdgeInsets.all(10),
                            child: Text(_loading ? S.of(context).wait : S.of(context).export))),
                actions: <Widget>[
                  IconButton(icon: const Icon(Icons.info_outline), onPressed: () => _showAboutDialog(context)),
                  IconButton(icon: const Icon(Icons.settings), onPressed: () => _showSettingsDialog(context))
                ],
                leading: uploadScreen
                    ? const SizedBox.shrink()
                    : IconButton(
                        icon: const Icon(Icons.arrow_back), onPressed: () => context.read<SetupIcon>().backButton())),
            body: SafeArea(child: child));
  }

  void _showAboutDialog(BuildContext context) =>
      showAboutDialog(context: context, applicationName: S.of(context).appName);

  Future<void> _showSettingsDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_dialogContext) => AdaptiveDialog(
          title: S.of(context).settings,
          leftButton: S.of(context).cancel,
          rightButton: S.of(context).save,
          onPressedLeft: () => Navigator.of(_dialogContext).pop(),
          onPressedRight: () => Navigator.of(_dialogContext).pop(),
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: [
              AdaptiveSwitch(
                  text: S.of(context).dark,
                  value: _dialogContext.watch<UserInterface>().isDark,
                  onChanged: (_) => _dialogContext.read<UserInterface>().changeMode())
            ],
          ),
        ),
      );
}

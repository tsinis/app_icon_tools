import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import '../../../services/show_dialog.dart';
import '../issues_info.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, this.uploadScreen = false, Key key}) : super(key: key);
  final bool uploadScreen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool _loading = context.select((SetupIcon icon) => icon.loading);
    final bool _isDark = context.select((UserInterface ui) => ui.isDark);
    final Color _exportButtonColor = _isDark ? Colors.pinkAccent : Colors.tealAccent[400];
    final bool _isWideScreen = MediaQuery.of(context).size.width > 560;
    return UserInterface.isApple
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              actionsForegroundColor: CupertinoTheme.of(context).textTheme.textStyle.color.withOpacity(0.7),
              middle: uploadScreen
                  ? Text(S.of(context).appName)
                  : ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(width: _isWideScreen ? 44 : 14),
                        const IssuesInfo(),
                        SizedBox(width: _isWideScreen ? 14 : 4),
                        if (_isWideScreen)
                          CupertinoButton(
                              disabledColor: CupertinoColors.systemGrey,
                              padding: const EdgeInsets.symmetric(horizontal: 64),
                              onPressed: _loading ? null : () => context.read<SetupIcon>().archive(),
                              color: _exportButtonColor,
                              child: Text(_loading ? S.of(context).wait : S.of(context).export,
                                  style: const TextStyle(color: CupertinoColors.black)))
                        else
                          GestureDetector(
                              onTap: () => context.read<SetupIcon>().archive(),
                              child: _loading
                                  ? const CupertinoActivityIndicator()
                                  : Icon(CupertinoIcons.tray_arrow_down, color: _exportButtonColor)),
                        SizedBox(width: _isWideScreen ? 10 : 3),
                        GestureDetector(
                            onTap: () => showPlatformsDialog(context),
                            child: const Icon(CupertinoIcons.ellipsis_circle)),
                      ],
                    ),
              trailing: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: () => showAbout(context), child: const Icon(CupertinoIcons.info_circle, size: 26)),
                  // const SizedBox(width: 2),
                  GestureDetector(
                      onTap: () => showSettingsDialog(context), child: const Icon(CupertinoIcons.gear, size: 26))
                ],
              ),
              // leading: uploadScreen
              //     ? const SizedBox.shrink()
              //     : GestureDetector(
              //         onTap: () => context.read<SetupIcon>().backButton(),
              //         child: const Icon(CupertinoIcons.back, size: 26)),
            ),
            child: SafeArea(child: child))
        : Scaffold(
            appBar: AppBar(
              centerTitle: true,
              title: uploadScreen
                  ? Text(S.of(context).appName)
                  : ButtonBar(
                      alignment: MainAxisAlignment.center,
                      children: [
                        const IssuesInfo(),
                        SizedBox(width: _isWideScreen ? 10 : 1),
                        if (_isWideScreen)
                          MaterialButton(
                              minWidth: 220,
                              // colorBrightness: Brightness.light,
                              onPressed: _loading ? null : () => context.read<SetupIcon>().archive(),
                              color: _exportButtonColor,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(_loading
                                      ? S.of(context).wait.toUpperCase()
                                      : S.of(context).export.toUpperCase())))
                        else
                          _loading
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  icon: Icon(Icons.download_outlined, color: _exportButtonColor),
                                  onPressed: () => context.read<SetupIcon>().archive()),
                        IconButton(icon: const Icon(Icons.menu), onPressed: () => showPlatformsDialog(context))
                      ],
                    ),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.info_outline), onPressed: () => showAbout(context)),
                IconButton(icon: const Icon(Icons.settings), onPressed: () => showSettingsDialog(context))
              ],
              // leading: uploadScreen
              //     ? const SizedBox.shrink()
              //     : IconButton(
              //         icon: const Icon(Icons.arrow_back), onPressed: () => context.read<SetupIcon>().backButton()))
            ),
            body: SafeArea(child: child));
  }
}

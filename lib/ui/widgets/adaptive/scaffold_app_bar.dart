import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import '../issues_info.dart';
import 'alert_dialog.dart';
import 'buttons/switch_button.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({this.child, this.uploadScreen = false, Key key}) : super(key: key);
  final bool uploadScreen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool _loading = context.select((SetupIcon icon) => icon.loading);
    final bool _isWideScreen = MediaQuery.of(context).size.width > 549;
    return UserInterface.isApple
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
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
                              color: CupertinoColors.activeOrange,
                              child: Text(_loading ? S.of(context).wait : S.of(context).export))
                        else
                          GestureDetector(
                              onTap: () => context.read<SetupIcon>().archive(),
                              child: _loading
                                  ? const CupertinoActivityIndicator()
                                  : const Icon(CupertinoIcons.tray_arrow_down, color: CupertinoColors.activeOrange)),
                        SizedBox(width: _isWideScreen ? 10 : 3),
                        GestureDetector(
                            onTap: () => _showPlatformsDialog(context),
                            child: const Icon(CupertinoIcons.ellipsis_circle)),
                      ],
                    ),
              trailing: ButtonBar(
                mainAxisSize: MainAxisSize.min,
                children: [
                  GestureDetector(
                      onTap: () => _showAboutDialog(context), child: const Icon(CupertinoIcons.info_circle, size: 26)),
                  // const SizedBox(width: 2),
                  GestureDetector(
                      onTap: () => _showSettingsDialog(context), child: const Icon(CupertinoIcons.gear, size: 26))
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
                              colorBrightness: Brightness.light,
                              onPressed: _loading ? null : () => context.read<SetupIcon>().archive(),
                              color: Colors.amber,
                              child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Text(_loading ? S.of(context).wait : S.of(context).export)))
                        else
                          _loading
                              ? const CircularProgressIndicator()
                              : IconButton(
                                  icon: const Icon(Icons.download_outlined, color: Colors.amber),
                                  onPressed: () => context.read<SetupIcon>().archive()),
                        IconButton(icon: const Icon(Icons.menu), onPressed: () => _showPlatformsDialog(context))
                      ],
                    ),
              actions: <Widget>[
                IconButton(icon: const Icon(Icons.info_outline), onPressed: () => _showAboutDialog(context)),
                IconButton(icon: const Icon(Icons.settings), onPressed: () => _showSettingsDialog(context))
              ],
              // leading: uploadScreen
              //     ? const SizedBox.shrink()
              //     : IconButton(
              //         icon: const Icon(Icons.arrow_back), onPressed: () => context.read<SetupIcon>().backButton()))
            ),
            body: SafeArea(child: child));
  }

  void _showAboutDialog(BuildContext context) =>
      showAboutDialog(context: context, applicationName: S.of(context).appName);

  Future<void> _showSettingsDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_dialogContext) {
          final List<String> _langList = _dialogContext.select((UserInterface ui) => ui.langList);
          print('_LANGLIST: ${_langList}');
          return AdaptiveDialog(
            title: S.of(context).settings,
            onPressedLeft: () => Navigator.of(_dialogContext).pop(),
            onPressedRight: () => Navigator.of(_dialogContext).pop(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                    width: 270,
                    height: 400,
                    child: ListView.builder(
                        itemCount: _langList.length, itemBuilder: (_, int i) => ListTile(title: Text(_langList[i])))),
                const Divider(),
                AdaptiveSwitch(
                    title: S.of(context).dark,
                    value: _dialogContext.watch<UserInterface>().isDark,
                    onChanged: (_isDark) => _dialogContext.read<UserInterface>().changeMode(_isDark))
              ],
            ),
          );
        },
      );

  Future<void> _showPlatformsDialog(BuildContext context) => showDialog<void>(
        context: context,
        builder: (_dialogContext) {
          final Map<String, bool> _platforms = _dialogContext.watch<SetupIcon>().platforms;
          return AdaptiveDialog(
            title: S.of(context).exportPlatforms,
            onPressedLeft: () => Navigator.of(_dialogContext).pop(),
            onPressedRight: () => Navigator.of(_dialogContext).pop(),
            content: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: _platforms.keys
                  .map((String platformName) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: AdaptiveSwitch(
                            title: platformName,
                            value: _platforms[platformName],
                            onChanged: (_exported) => _dialogContext.read<SetupIcon>().switchPlatform(
                                  platformNameKey: platformName,
                                  isExported: _exported,
                                )),
                      ))
                  .toList(),
            ),
          );
        },
      );
}

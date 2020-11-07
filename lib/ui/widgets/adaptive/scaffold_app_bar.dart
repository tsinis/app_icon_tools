import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import '../../../services/show_dialog.dart';
import '../issues_info.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({@required this.child, this.uploadScreen = false, this.deviceScreen = false, Key key})
      : super(key: key);
  final bool uploadScreen, deviceScreen;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    final bool _loading = context.select((SetupIcon icon) => icon.loading);
    final bool _isDark = context.select((UserInterface ui) => ui.isDark) ?? true;
    final Color _exportButtonColor = (_isDark ? Colors.pinkAccent : Colors.tealAccent[400]) ?? const Color(0xFF1DE9B6);
    final bool _isWideScreen = MediaQuery.of(context).size.width > 560;
    return UserInterface.isApple
        ? CupertinoPageScaffold(
            navigationBar: CupertinoNavigationBar(
              actionsForegroundColor: CupertinoTheme.of(context).textTheme.textStyle.color?.withOpacity(0.7),
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
                              disabledColor: Colors.transparent,
                              padding: EdgeInsets.symmetric(horizontal: (_loading && !kIsWeb) ? 10 : 64),
                              onPressed: _loading ? null : () => context.read<SetupIcon>().archive(),
                              color: _exportButtonColor,
                              child: _loading
                                  ? Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                          Text(
                                            S.of(context).wait,
                                            // style: const TextStyle(color: CupertinoColors.black)
                                          ),
                                          if (!kIsWeb)
                                            const Padding(
                                                padding: EdgeInsets.only(left: 16), child: CupertinoActivityIndicator())
                                        ])
                                  : Text(S.of(context).export, style: const TextStyle(color: CupertinoColors.black)))
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
              leading: uploadScreen
                  ? const SizedBox(width: 24)
                  : GestureDetector(
                      onTap: () => deviceScreen
                          ? context.read<SetupIcon>().setupScreen()
                          : context.read<SetupIcon>().initialScreen(),
                      child: Icon(deviceScreen ? CupertinoIcons.back : CupertinoIcons.house, size: 24)),
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
                                    child: _loading
                                        ? Row(
                                            mainAxisAlignment: MainAxisAlignment.center,
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                                Text(S.of(context).wait.toUpperCase()),
                                                if (!kIsWeb)
                                                  const Padding(
                                                      padding: EdgeInsets.only(left: 16),
                                                      child: SizedBox(
                                                          height: 16,
                                                          width: 16,
                                                          child: CircularProgressIndicator(strokeWidth: 2)))
                                              ])
                                        : Text(S.of(context).export.toUpperCase())))
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
                  Padding(
                    padding: const EdgeInsets.only(right: 6),
                    child: IconButton(icon: const Icon(Icons.settings), onPressed: () => showSettingsDialog(context)),
                  )
                ],
                leading: uploadScreen
                    ? const SizedBox(width: 24)
                    : IconButton(
                        icon: Icon(deviceScreen ? Icons.arrow_back : Icons.home),
                        onPressed: () => deviceScreen
                            ? context.read<SetupIcon>().setupScreen()
                            : context.read<SetupIcon>().initialScreen())),
            body: SafeArea(child: child));
  }
}

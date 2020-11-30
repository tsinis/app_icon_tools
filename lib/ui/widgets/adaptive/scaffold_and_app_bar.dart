import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:platform_info/platform_info.dart';
import 'package:provider/provider.dart';

import '../../../generated/l10n.dart';
import '../../../models/setup_icon.dart';
import '../../../models/user_interface.dart';
import '../../../services/dailogs_service.dart';
import '../issues_info.dart';

class AdaptiveScaffold extends StatelessWidget {
  const AdaptiveScaffold({
    @required this.child,
    this.uploadScreen = false,
    this.deviceScreen = false,
  });

  final Widget child;
  final bool uploadScreen, deviceScreen;

  @override
  Widget build(BuildContext context) {
    final bool isExporting = context.select((SetupIcon icon) => icon.loading) ?? false;
    final int exportProgress = context.select((SetupIcon icon) => icon.exportProgress.round()) ?? 0;
    // final bool isExporting = exportProgress > 0;
    final bool isDark = context.select((UserInterface ui) => ui.isDark) ?? true;
    final Color exportButtonColor = (isDark ? Colors.pinkAccent : Colors.tealAccent[400]) ?? const Color(0xFF1DE9B6);
    final bool isWideScreen = MediaQuery.of(context).size.width > 560;

    return MediaQuery(
      data: MediaQuery.of(context).copyWith(textScaleFactor: 1),
      child: UserInterface.isCupertino
          ? CupertinoPageScaffold(
              navigationBar: CupertinoNavigationBar(
                actionsForegroundColor: CupertinoTheme.of(context).textTheme.textStyle.color?.withOpacity(0.7),
                middle: uploadScreen
                    ? SelectableText(S.of(context).appName)
                    : ButtonBar(
                        buttonPadding: const EdgeInsets.symmetric(horizontal: 11),
                        alignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(width: isWideScreen ? 44 : 14),
                          const IssuesInfo(),
                          SizedBox(width: isWideScreen ? 14 : 4),
                          if (isWideScreen)
                            Tooltip(
                              message: S.of(context).saveAsZip,
                              child: CupertinoButton(
                                  disabledColor: Colors.transparent,
                                  padding: EdgeInsets.symmetric(horizontal: (isExporting && !kIsWeb) ? 10 : 64),
                                  onPressed: isExporting ? null : () => context.read<SetupIcon>().archive(),
                                  color: exportButtonColor,
                                  child: isExporting
                                      ? Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                              Text(
                                                (kIsWeb || platform.isWindows)
                                                    ? S.of(context).wait
                                                    : '${S.of(context).wait} $exportProgress%',
                                                // style: const TextStyle(color: CupertinoColors.black)
                                              ),
                                              if (!kIsWeb)
                                                const Padding(
                                                    padding: EdgeInsets.only(left: 16),
                                                    child: CupertinoActivityIndicator())
                                            ])
                                      : Text(S.of(context).export,
                                          style: const TextStyle(color: CupertinoColors.black))),
                            )
                          else
                            GestureDetector(
                                onTap: () => context.read<SetupIcon>().archive(),
                                child: isExporting
                                    ? const CupertinoActivityIndicator()
                                    : Tooltip(
                                        message: S.of(context).saveAsZip,
                                        child: Icon(CupertinoIcons.tray_arrow_down, color: exportButtonColor))),
                          SizedBox(width: isWideScreen ? 10 : 3),
                          GestureDetector(
                              onTap: () => showPlatformsDialog(context),
                              child: Tooltip(
                                  message: S.of(context).choosePlatforms,
                                  child: const Icon(CupertinoIcons.ellipsis_circle))),
                        ],
                      ),
                trailing: ButtonBar(
                  buttonPadding: const EdgeInsets.symmetric(horizontal: 10),
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    GestureDetector(
                        onTap: () => showAbout(context),
                        child: Tooltip(
                            message: S.of(context).about, child: const Icon(CupertinoIcons.info_circle, size: 26))),
                    // const SizedBox(width: 2),
                    GestureDetector(
                        onTap: () => showSettingsDialog(context),
                        child: Tooltip(
                            message: S.of(context).appSettings, child: const Icon(CupertinoIcons.gear, size: 26)))
                  ],
                ),
                leading: uploadScreen
                    ? const SizedBox(width: 24)
                    : GestureDetector(
                        onTap: () => deviceScreen
                            ? context.read<SetupIcon>().setupScreen()
                            : context.read<SetupIcon>().initialScreen(),
                        child: Tooltip(
                            message: S.of(context).backButton,
                            child: Icon(deviceScreen ? CupertinoIcons.back : CupertinoIcons.home, size: 24))),
              ),
              child: SafeArea(child: child))
          : Scaffold(
              appBar: AppBar(
                  centerTitle: true,
                  title: uploadScreen
                      ? SelectableText(S.of(context).appName)
                      : ButtonBar(
                          buttonPadding: const EdgeInsets.symmetric(horizontal: 7),
                          alignment: MainAxisAlignment.center,
                          children: [
                            const IssuesInfo(),
                            SizedBox(width: isWideScreen ? 10 : 1),
                            if (isWideScreen)
                              Tooltip(
                                message: S.of(context).saveAsZip,
                                child: MaterialButton(
                                    minWidth: 220,
                                    // colorBrightness: Brightness.light,
                                    onPressed: isExporting ? null : () => context.read<SetupIcon>().archive(),
                                    color: exportButtonColor,
                                    child: Padding(
                                        padding: const EdgeInsets.all(10),
                                        child: isExporting
                                            ? Row(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                    Text((kIsWeb || platform.isWindows)
                                                        ? S.of(context).wait.toUpperCase()
                                                        : '${S.of(context).wait.toUpperCase()} $exportProgress%'),
                                                    if (!kIsWeb)
                                                      const Padding(
                                                          padding: EdgeInsets.only(left: 16),
                                                          child: SizedBox(
                                                              height: 16,
                                                              width: 16,
                                                              child: CircularProgressIndicator(strokeWidth: 2)))
                                                  ])
                                            : Text(S.of(context).export.toUpperCase()))),
                              )
                            else
                              isExporting
                                  ? const SizedBox(
                                      height: 16, width: 16, child: CircularProgressIndicator(strokeWidth: 2))
                                  : IconButton(
                                      tooltip: S.of(context).saveAsZip,
                                      icon: Icon(Icons.download_outlined, color: exportButtonColor),
                                      onPressed: () => context.read<SetupIcon>().archive()),
                            IconButton(
                                tooltip: S.of(context).choosePlatforms,
                                icon: const Icon(Icons.menu),
                                onPressed: () => showPlatformsDialog(context))
                          ],
                        ),
                  actions: <Widget>[
                    IconButton(
                        tooltip: S.of(context).about,
                        icon: const Icon(Icons.info_outline),
                        onPressed: () => showAbout(context)),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 6),
                      child: IconButton(
                          tooltip: S.of(context).appSettings,
                          icon: const Icon(Icons.settings),
                          onPressed: () => showSettingsDialog(context)),
                    )
                  ],
                  leading: uploadScreen
                      ? const SizedBox(width: 24)
                      : IconButton(
                          tooltip: S.of(context).backButton,
                          icon: Icon(deviceScreen ? Icons.arrow_back : Icons.home_outlined),
                          onPressed: () => deviceScreen
                              ? context.read<SetupIcon>().setupScreen()
                              : context.read<SetupIcon>().initialScreen())),
              body: SafeArea(child: child)),
    );
  }
}

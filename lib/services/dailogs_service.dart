import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../models/setup_icon.dart';
import '../models/user_interface.dart';
import '../ui/widgets/adaptive/alert_dialog.dart';
import '../ui/widgets/adaptive/buttons/switch_button.dart';
import '../ui/widgets/adaptive/divider.dart';
import '../ui/widgets/adaptive/textfield.dart';

void showAbout(BuildContext context) => showAboutDialog(
        context: context,
        applicationName: S.of(context).appName,
        applicationLegalese: S.of(context).legalese,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Padding(
                  padding: const EdgeInsets.all(12),
                  child: Text(S.of(context).pleaseRate,
                      style: const TextStyle(fontSize: 14), textAlign: TextAlign.center)),
              Padding(
                padding: const EdgeInsets.all(10),
                child: SizedBox(
                  width: 180,
                  child: TextButton.icon(
                    icon: const Icon(CommunityMaterialIcons.github),
                    label: const Padding(padding: EdgeInsets.all(10), child: Text('GitHub')),
                    onPressed: () async => await context.read<UserInterface>().showRepository(),
                  ),
                ),
              ),
              if (kIsWeb)
                Padding(
                  padding: const EdgeInsets.all(12),
                  child: Opacity(
                      opacity: 0.7,
                      child: Text(S.of(context).pwaVersion,
                          style: const TextStyle(fontSize: 11), textAlign: TextAlign.center)),
                )
            ],
          ),
        ]);

Future showSettingsDialog(BuildContext _) {
  UserInterface.loadLocales();

  return showDialog<void>(
    barrierDismissible: false,
    context: _,
    builder: (context) {
      final List<String> languageList = context.watch<UserInterface>().langFilterList;
      final String selectedLanguage = context.select((UserInterface ui) => ui.locale) ?? 'en';
      final bool isDark = context.select((UserInterface ui) => ui.isDark) ?? true;
      final bool isCupertino = context.select((UserInterface ui) => ui.selectedCupertino) ?? false;

      return AdaptiveDialog(
        title: S.of(context).settings,
        onPressedSecondary: () =>
            UserInterface.loadSettings().whenComplete(() => context.read<UserInterface>().goBack()),
        onPressedMain: () => context.read<UserInterface>().saveSettings(),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            AdaptiveTextField(
                onChanged: (query) => context.read<UserInterface>().search(query),
                hint: S.of(context).findLang,
                autofillHints: languageList,
                label: S.of(context).search),
            SizedBox(
                width: 270,
                height: 170,
                child: _ScrollBar(
                  ListView.separated(
                      separatorBuilder: (_, __) => const AdaptiveDivider(),
                      itemCount: languageList.length,
                      itemBuilder: (_, int i) {
                        final bool isSelected = languageList[i].contains('${selectedLanguage.toUpperCase()}: ');

                        return UserInterface.isCupertino
                            ? GestureDetector(
                                onTap: () => context.read<UserInterface>().setLocale(languageList[i]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(languageList[i],
                                        style: CupertinoTheme.of(context)
                                            .textTheme
                                            .textStyle
                                            .copyWith(fontWeight: isSelected ? FontWeight.bold : FontWeight.normal)),
                                    Icon(CupertinoIcons.checkmark,
                                        color: isSelected ? CupertinoColors.systemGreen : Colors.transparent)
                                  ]),
                                ),
                              )
                            : ListTile(
                                selectedTileColor: Theme.of(context).accentColor.withOpacity(0.1),
                                selected: isSelected,
                                onTap: () => context.read<UserInterface>().setLocale(languageList[i]),
                                title: isSelected
                                    ? Text(languageList[i], style: TextStyle(color: Theme.of(context).selectedRowColor))
                                    : Text(languageList[i]));
                      }),
                )),
            const AdaptiveDivider(),
            AdaptiveSwitch(
                title: S.of(context).dark,
                value: isDark,
                onChanged: (isDarkMode) => context.read<UserInterface>().changeMode(isDark: isDarkMode)),
            const SizedBox(height: 10),
            Tooltip(
              preferBelow: false,
              message: S.of(context).restart,
              child: AdaptiveSwitch(
                  title: S.of(context).cupertino,
                  value: isCupertino,
                  toRestart: true,
                  onChanged: (isCupertino) =>
                      context.read<UserInterface>().changeStyle(selectedCupertino: isCupertino)),
            )
          ],
        ),
      );
    },
  );
}

Future showPlatformsDialog(BuildContext _) => showDialog<void>(
      context: _,
      builder: (context) {
        final Map<String, bool> exportedPlatforms = context.watch<SetupIcon>().platforms;

        return AdaptiveDialog(
          title: S.of(context).exportPlatforms,
          onPressedMain: () => context.read<SetupIcon>().goBack(),
          mainButtonTitle: S.of(context).done,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: exportedPlatforms.keys
                .map((String platformName) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AdaptiveSwitch(
                          title: platformName,
                          value: exportedPlatforms[platformName] ?? true,
                          onChanged: (bool isExported) => context
                              .read<SetupIcon>()
                              .switchPlatform(platformNameKey: platformName, isExported: isExported)),
                    ))
                .toList(),
          ),
        );
      },
    );

class _ScrollBar extends StatelessWidget {
  const _ScrollBar(this._child);

  final Widget _child;

  @override
  Widget build(BuildContext context) => UserInterface.isCupertino ? SizedBox(child: _child) : Scrollbar(child: _child);
}

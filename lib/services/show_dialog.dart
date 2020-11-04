import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../generated/l10n.dart';
import '../models/setup_icon.dart';
import '../models/user_interface.dart';
import '../ui/widgets/adaptive/alert_dialog.dart';
import '../ui/widgets/adaptive/buttons/switch_button.dart';
import '../ui/widgets/adaptive/divider.dart';
import '../ui/widgets/adaptive/textfield.dart';

void showAbout(BuildContext context) => showAboutDialog(context: context, applicationName: S.of(context).appName);

Future<void> showSettingsDialog(BuildContext context) {
  UserInterface.loadLocales();
  return showDialog<void>(
    context: context,
    builder: (_dialogContext) {
      final List<String> _langList = _dialogContext.select((UserInterface ui) => ui.langFilterList);
      final String _selectedocale = _dialogContext.select((UserInterface ui) => ui.locale);

      return AdaptiveDialog(
        title: S.of(context).settings,
        onPressedSecondary: () =>
            UserInterface.loadSettings().whenComplete(() => _dialogContext.read<UserInterface>().goBack()),
        onPressedMain: () => _dialogContext.read<UserInterface>().saveSettings(),
        content: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.max,
          children: [
            AdaptiveTextField(
                onChanged: (query) => context.read<UserInterface>().search(query),
                hint: S.of(context).findLang,
                autofillHints: _langList,
                label: S.of(context).search),
            SizedBox(
                width: 270,
                height: 300,
                child: _ScrollBar(
                  ListView.separated(
                      separatorBuilder: (_, __) => const AdaptiveDivider(),
                      itemCount: _langList.length,
                      itemBuilder: (_, int i) {
                        final bool _selected = _langList[i].contains('${_selectedocale.toUpperCase()}: ');
                        return UserInterface.isApple
                            ? GestureDetector(
                                onTap: () => _dialogContext.read<UserInterface>().setLocale(_langList[i]),
                                child: Padding(
                                  padding: const EdgeInsets.all(10),
                                  child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
                                    Text(
                                      _langList[i],
                                      style: CupertinoTheme.of(context)
                                          .textTheme
                                          .textStyle
                                          .copyWith(fontWeight: _selected ? FontWeight.bold : FontWeight.normal),
                                    ),
                                    Icon(CupertinoIcons.checkmark,
                                        color: _selected ? CupertinoColors.systemGreen : Colors.transparent)
                                  ]),
                                ),
                              )
                            : ListTile(
                                selectedTileColor: Theme.of(context).accentColor.withOpacity(0.1),
                                selected: _selected,
                                onTap: () => _dialogContext.read<UserInterface>().setLocale(_langList[i]),
                                title: _selected
                                    ? Text(_langList[i], style: TextStyle(color: Theme.of(context).selectedRowColor))
                                    : Text(_langList[i]));
                      }),
                )),
            const AdaptiveDivider(),
            AdaptiveSwitch(
                title: S.of(context).dark,
                value: _dialogContext.watch<UserInterface>().isDark,
                onChanged: (_isDark) => _dialogContext.read<UserInterface>().changeMode(_isDark))
          ],
        ),
      );
    },
  );
}

Future<void> showPlatformsDialog(BuildContext context) => showDialog<void>(
      context: context,
      builder: (_dialogContext) {
        final Map<String, bool> _platforms = _dialogContext.watch<SetupIcon>().platforms;
        return AdaptiveDialog(
          title: S.of(context).exportPlatforms,
          onPressedMain: () => _dialogContext.read<SetupIcon>().goBack(),
          mainButtonTitle: S.of(context).done,
          content: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: _platforms.keys
                .map((String platformName) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: AdaptiveSwitch(
                          title: platformName,
                          value: _platforms[platformName] ?? true,
                          onChanged: (_exported) => _dialogContext
                              .read<SetupIcon>()
                              .switchPlatform(platformNameKey: platformName, isExported: _exported)),
                    ))
                .toList(),
          ),
        );
      },
    );

class _ScrollBar extends StatelessWidget {
  final Widget _child;

  const _ScrollBar(this._child, {Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) => UserInterface.isApple ? SizedBox(child: _child) : Scrollbar(child: _child);
}

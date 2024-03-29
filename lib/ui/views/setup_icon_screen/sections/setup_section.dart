import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../../../generated/l10n.dart';
import '../../../../models/setup_icon.dart';
import '../../../../models/user_interface.dart';
import '../../../widgets/adaptive/buttons/button.dart';
import '../../../widgets/adaptive/buttons/switch_button.dart';
import '../../../widgets/drag_and_drop.dart';

class SetupSection extends StatelessWidget {
  const SetupSection({
    @required bool isAdaptive,
    @required bool isPortrait,
    @required bool pwaIcon,
    @required bool haveAdaptiveBg,
  })  : _isAdaptive = isAdaptive,
        _haveAdaptiveBg = haveAdaptiveBg,
        _isPortrait = isPortrait,
        _pwaIcon = pwaIcon;

  final bool _isAdaptive, _isPortrait, _pwaIcon, _haveAdaptiveBg;

  @override
  Widget build(BuildContext context) {
    final ThemeData materialTheme = context.select((UserInterface ui) => ui.materialTheme);

    // Regular part.
    final Color regularBgColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool colorIsEmpty = context.select((SetupIcon icon) => icon.bgColorIsEmpty);

    //Adaptive Part.
    final Color adaptiveColor = context.select((SetupIcon icon) => icon.adaptiveColor);
    final bool haveAdaptiveColor = context.select((SetupIcon icon) => icon.haveAdaptiveColor);
    final bool preferColorBg = context.select((SetupIcon icon) => icon.preferColorBg);

    return SizedBox(
      width: UserInterface.previewIconSize,
      height: UserInterface.isCupertino ? 510 : 571,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: _isPortrait ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (_isAdaptive) ...[
            Padding(
                padding: EdgeInsets.only(
                    bottom: 20,
                    top: (preferColorBg && !_isPortrait)
                        ? (UserInterface.isCupertino ? 52 : 68)
                        : (UserInterface.isCupertino ? (_haveAdaptiveBg ? 30 : 0) : 0)),
                child: SelectableText(S.of(context).uploadAdaptiveBg)),
            if (preferColorBg)
              ColorPicker(
                  // labelTextStyle: materialTheme.sliderTheme.valueIndicatorTextStyle,
                  pickerAreaHeightPercent: 0.84,
                  pickerColor:
                      haveAdaptiveColor ? adaptiveColor : (colorIsEmpty ? materialTheme.accentColor : regularBgColor),
                  onColorChanged: (newColor) => context.read<SetupIcon>().setAdaptiveColor(newColor),
                  displayThumbColor: true,
                  portraitOnly: true,
                  showLabel: !UserInterface.isCupertino)
            else
              const Hero(tag: 'global', child: DragAndDrop(background: true)),
            SizedBox(
                height: preferColorBg
                    ? 0
                    : UserInterface.isCupertino
                        ? 10
                        : _haveAdaptiveBg
                            ? 10
                            : 43),
            AdaptiveSwitch(
                title: S.of(context).colorAsBg,
                value: preferColorBg,
                onChanged: (preferColor) => context.read<SetupIcon>().switchBgColorPreference(preferColor: preferColor))
          ] else ...[
            Padding(
                padding: EdgeInsets.only(bottom: 20, top: UserInterface.isCupertino ? 14 : 20),
                child: SelectableText(_pwaIcon ? S.of(context).pwaColor : S.of(context).iconBgColor)),
            ColorPicker(
                // labelTextStyle: materialTheme.chipTheme.labelStyle,
                pickerAreaHeightPercent: 0.84,
                pickerColor: colorIsEmpty ? materialTheme.accentColor : regularBgColor,
                onColorChanged: (Color newColor) => context.read<SetupIcon>().setBackgroundColor(newColor),
                displayThumbColor: true,
                portraitOnly: true,
                enableAlpha: false, //TODO? Consider change to _supportTransparency sometime later.
                showLabel: !UserInterface.isCupertino),
          ],
          if (!colorIsEmpty && !_isAdaptive)
            AdaptiveButton(
                isDestructive: true,
                text: S.of(context).removeColor,
                // color: regularBgColor,
                onPressed: () => context.read<SetupIcon>().removeColor())
          else if (colorIsEmpty && !_isAdaptive)
            const SizedBox(height: 30),
          if (!preferColorBg && _isAdaptive && _haveAdaptiveBg)
            Padding(
              padding: EdgeInsets.only(top: UserInterface.isCupertino ? 0 : 6),
              child: AdaptiveButton(
                  text: S.of(context).removeBackground,
                  isDestructive: true,
                  onPressed: () => context.read<SetupIcon>().removeAdaptiveBackground()),
            ),
        ],
      ),
    );
  }
}

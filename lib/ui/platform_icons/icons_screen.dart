import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../generated/l10n.dart';
import '../../models/setup_icon.dart';
import '../../models/user_interface.dart';
import '../widgets/adaptive/buttons/button.dart';
import '../widgets/adaptive/buttons/icon_button.dart';
import '../widgets/adaptive/buttons/switch_button.dart';
import '../widgets/adaptive/slider.dart';
import '../widgets/drag_and_drop.dart';
import '../widgets/layout.dart';
import 'icons_types/apdative_icon.dart';
import 'icons_types/regular_icon.dart';

class IconPreview extends StatelessWidget {
  const IconPreview(this.platformID, this.name, this.icon, {@required this.cornerRadius, Key key}) : super(key: key);

  final int cornerRadius, platformID;
  final String name;
  final IconData icon;

  const IconPreview.oldAndroid()
      : cornerRadius = 0,
        platformID = 0,
        name = 'Android',
        icon = Icons.android_outlined;

  const IconPreview.newAndroid()
      : cornerRadius = 800,
        platformID = 1,
        name = 'Android 8+',
        icon = CommunityMaterialIcons.android;

  const IconPreview.iOS()
      : cornerRadius = 53,
        platformID = 2,
        name = 'iOS',
        icon = CommunityMaterialIcons.apple_ios;

  const IconPreview.web()
      : cornerRadius = 800,
        platformID = 3,
        name = 'Web',
        icon = CommunityMaterialIcons.google_chrome;

  const IconPreview.windows()
      : cornerRadius = 0,
        platformID = 4,
        name = 'Windows',
        icon = CommunityMaterialIcons.microsoft_windows;

  const IconPreview.macOS()
      : cornerRadius = 0,
        platformID = 5,
        name = 'macOS',
        icon = CommunityMaterialIcons.apple;

  // const IconPreview.linux()
  //     : cornerRadius = 0,
  //       platformID = 6,
  //       name = 'Linux',
  //       icon = CommunityMaterialIcons.linux;

  // const IconPreview.fuchsiaOS()
  //     : cornerRadius = 0,
  //       platformID = 7,
  //       name = 'Fuchsia',
  //       icon = CommunityMaterialIcons.linux;

  double get _staticCornerRadius => cornerRadius.toDouble();

  bool get _canChangeShape => platformID <= 1 || platformID == 3;

  bool get _isAdaptive => platformID == 1;

  bool get _supportTransparency => platformID != 2;

  @override
  Widget build(BuildContext context) {
    final bool isPortrait = (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) ||
        (MediaQuery.of(context).size.width <= 680);
    final bool haveAdaptiveBg = context.select((SetupIcon icon) => icon.haveAdaptiveBackground);

    return PreviewLayout(
      portraitOrientation: isPortrait,
      children: [
        _Preview(
            canChangeShape: _canChangeShape,
            isAdaptive: _isAdaptive,
            staticCornerRadius: _staticCornerRadius,
            supportTransparency: _supportTransparency,
            haveAdaptiveBg: haveAdaptiveBg),
        _Setup(
            isAdaptive: _isAdaptive, isPortrait: isPortrait, pwaIcon: platformID == 3, haveAdaptiveBg: haveAdaptiveBg)
      ],
    );
  }
}

class _Preview extends StatelessWidget {
  const _Preview({
    @required bool canChangeShape,
    @required bool isAdaptive,
    @required bool supportTransparency,
    @required bool haveAdaptiveBg,
    @required double staticCornerRadius,
    Key key,
  })  : _staticCornerRadius = staticCornerRadius,
        _haveAdaptiveBg = haveAdaptiveBg,
        _supportTransparency = supportTransparency,
        _isAdaptive = isAdaptive,
        _canChangeShape = canChangeShape,
        super(key: key);

  final bool _canChangeShape, _isAdaptive, _supportTransparency, _haveAdaptiveBg;
  final double _staticCornerRadius;

  @override
  Widget build(BuildContext context) {
    const double previewSize = UserInterface.previewIconSize;
    final double adjustableRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final bool adaptiveColorIsEmpty = context.select((SetupIcon icon) => icon.adaptiveColor) == null;
    final bool isDark = context.select((UserInterface ui) => ui.isDark);
    final bool haveAdaptiveFg = context.select((SetupIcon icon) => icon.haveAdaptiveForeground);
    final bool haveAdaptiveAssets = _haveAdaptiveBg && haveAdaptiveFg;

    return SizedBox(
      width: previewSize,
      height: 560,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        // mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 20),
              child: Text(_canChangeShape
                  ? (_isAdaptive ? S.of(context).uploadAdaptiveFg : S.of(context).previewShapes)
                  : S.of(context).iconPreview)),
          if (!haveAdaptiveFg && _isAdaptive)
            _haveAdaptiveBg
                ? Stack(children: [
                    Container(
                        clipBehavior: Clip.antiAlias,
                        height: previewSize,
                        width: previewSize,
                        decoration: const BoxDecoration(
                            color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(25))),
                        child: const Opacity(opacity: 0.5, child: AdaptiveIcon())),
                    const DragAndDrop(foreground: true)
                  ])
                : const DragAndDrop(foreground: true)
          else
            GestureDetector(
              onTap: () => context.read<SetupIcon>().devicePreview(),
              child: Container(
                clipBehavior: Clip.antiAlias,
                height: previewSize,
                width: previewSize,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: isDark ? Colors.black38 : Colors.black12,
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                    borderRadius:
                        BorderRadius.all(Radius.circular(_canChangeShape ? adjustableRadius : _staticCornerRadius))),
                child: _isAdaptive
                    ? const Hero(tag: 'adaptive', child: AdaptiveIcon())
                    : Hero(
                        tag: 'regular',
                        child: RegularIcon(
                          supportTransparency: _supportTransparency,
                          cornerRadius: -1,
                        )),
              ),
            ),
          if (_canChangeShape)
            SizedBox(
              width: 292,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Icon(CommunityMaterialIcons.square_outline, color: Color(0x80808080)),
                  AdaptiveSlider(
                      radius: adjustableRadius,
                      // label: adjustableRadius.round().toString(),
                      onChanged: (newRadius) => context.read<SetupIcon>().setRadius(newRadius)),
                  const Icon(CommunityMaterialIcons.circle_outline, color: Color(0x80808080)),
                ],
              ),
            )
          else
            const SizedBox(height: 48),
          ...[
            AdaptiveButton(
                text: S.of(context).devicePreview,
                onPressed: () => (_isAdaptive && (!haveAdaptiveAssets && adaptiveColorIsEmpty))
                    ? null
                    : context.read<SetupIcon>().devicePreview()),
            if (_isAdaptive) AdaptiveIconButtons(withAdaptives: haveAdaptiveAssets),
            // else
            // SizedBox(height: isPortrait ? 0 : 20),
            // if (_isAdaptive) const SizedBox(height: 44) else const SizedBox(height: 64),
            if (_isAdaptive && haveAdaptiveFg)
              AdaptiveButton(
                  text: S.of(context).removeForeground,
                  destructive: true,
                  onPressed: () => context.read<SetupIcon>().removeadaptiveForeground()),
          ]
        ],
      ),
    );
  }
}

class _Setup extends StatelessWidget {
  const _Setup(
      {@required bool isAdaptive,
      @required bool isPortrait,
      @required bool pwaIcon,
      @required bool haveAdaptiveBg,
      Key key})
      : _isAdaptive = isAdaptive,
        _haveAdaptiveBg = haveAdaptiveBg,
        _isPortrait = isPortrait,
        _pwaIcon = pwaIcon,
        super(key: key);

  final bool _isAdaptive, _isPortrait, _pwaIcon, _haveAdaptiveBg;

  @override
  Widget build(BuildContext context) {
    final ThemeData materialTheme = context.select((UserInterface ui) => ui.materialTheme);
    final Color regularBgColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final Color adaptiveColor = context.select((SetupIcon icon) => icon.adaptiveColor);
    final bool preferColorBg = context.select((SetupIcon icon) => icon.preferColorBg);
    final bool colorIsEmpty = regularBgColor == null;

    return SizedBox(
      width: UserInterface.previewIconSize,
      height: UserInterface.isApple ? 560 : 572,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: _isPortrait ? MainAxisAlignment.start : MainAxisAlignment.center,
        children: [
          if (_isAdaptive) ...[
            Padding(
                padding: EdgeInsets.only(
                    bottom: 20,
                    top: (preferColorBg && !_isPortrait)
                        ? (UserInterface.isApple ? 62 : 72)
                        : (UserInterface.isApple ? (_haveAdaptiveBg ? 36 : 10) : 4)),
                child: Text(S.of(context).uploadAdaptiveBg)),
            if (preferColorBg)
              ColorPicker(
                  // labelTextStyle: materialTheme.sliderTheme.valueIndicatorTextStyle,
                  pickerAreaHeightPercent: 0.84,
                  pickerColor: adaptiveColor ?? (regularBgColor ?? materialTheme.accentColor),
                  onColorChanged: (_newColor) => context.read<SetupIcon>().setAdaptiveColor(_newColor),
                  displayThumbColor: true,
                  portraitOnly: true,
                  showLabel: !UserInterface.isApple)
            else
              const Hero(tag: 'global', child: DragAndDrop(background: true)),
            SizedBox(
                height: preferColorBg
                    ? 0
                    : UserInterface.isApple
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
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(_pwaIcon ? S.of(context).pwaColor : S.of(context).iconBgColor)),
            ColorPicker(
                // labelTextStyle: materialTheme.chipTheme.labelStyle,
                pickerAreaHeightPercent: 0.84,
                pickerColor: colorIsEmpty ? materialTheme.accentColor : regularBgColor,
                onColorChanged: (Color newColor) => context.read<SetupIcon>().setBackgroundColor(newColor),
                displayThumbColor: true,
                portraitOnly: true,
                enableAlpha: false, //TODO: Consider change to _supportTransparency sometime later.
                showLabel: !UserInterface.isApple),
          ],
          if (!colorIsEmpty && !_isAdaptive)
            AdaptiveButton(
                destructive: true,
                text: S.of(context).removeColor,
                // color: regularBgColor,
                onPressed: () => context.read<SetupIcon>().removeColor())
          else if (colorIsEmpty && !_isAdaptive)
            const SizedBox(height: 27),
          if (!preferColorBg && _isAdaptive && _haveAdaptiveBg)
            Padding(
              padding: EdgeInsets.only(top: UserInterface.isApple ? 0 : 6),
              child: AdaptiveButton(
                  text: S.of(context).removeBackground,
                  destructive: true,
                  onPressed: () => context.read<SetupIcon>().removeAdaptiveBackground()),
            ),
        ],
      ),
    );
  }
}

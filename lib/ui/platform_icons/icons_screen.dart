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
  final int cornerRadius, platformID;
  final String name;
  final IconData icon;

  const IconPreview(this.platformID, this.name, this.icon, {@required this.cornerRadius, Key key}) : super(key: key);

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
    final bool _portrait = (MediaQuery.of(context).size.height > MediaQuery.of(context).size.width) ||
        (MediaQuery.of(context).size.width <= 640);

    return PreviewLayout(
      needsScroll: MediaQuery.of(context).size.height <= 760,
      portraitOrientation: _portrait,
      children: [
        _Preview(
            canChangeShape: _canChangeShape,
            isAdaptive: _isAdaptive,
            staticCornerRadius: _staticCornerRadius,
            supportTransparency: _supportTransparency),
        _Setup(isAdaptive: _isAdaptive, isPortrait: _portrait, pwaIcon: platformID == 3),
      ],
    );
  }
}

class _Preview extends StatelessWidget {
  final bool _canChangeShape, _isAdaptive, _supportTransparency;
  final double _staticCornerRadius;

  const _Preview({
    @required bool canChangeShape,
    @required bool isAdaptive,
    @required bool supportTransparency,
    @required double staticCornerRadius,
    Key key,
  })  : _staticCornerRadius = staticCornerRadius,
        _supportTransparency = supportTransparency,
        _isAdaptive = isAdaptive,
        _canChangeShape = canChangeShape,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final double _adjustableCornerRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final Color _adpativeColor = context.select((SetupIcon icon) => icon.adaptiveColor);
    final bool _haveAdaptiveBackground = context.select((SetupIcon icon) => icon.haveAdaptiveBackground);
    final bool _haveAdaptiveForeground = context.select((SetupIcon icon) => icon.haveAdaptiveForeground);
    final bool _isDark = context.select((UserInterface ui) => ui.isDark);
    const double _previewIconSize = UserInterface.previewIconSize;
    final bool _adaptiveColorNotSet = _adpativeColor == null;
    final bool _haveAdaptiveAssets = _haveAdaptiveBackground && _haveAdaptiveForeground;

    return SizedBox(
      width: _previewIconSize,
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
          if (!_haveAdaptiveForeground && _isAdaptive)
            _haveAdaptiveBackground
                ? Stack(children: [
                    Container(
                        clipBehavior: Clip.antiAlias,
                        height: _previewIconSize,
                        width: _previewIconSize,
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
                height: _previewIconSize,
                width: _previewIconSize,
                decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(
                          color: _isDark ? Colors.black38 : Colors.black12,
                          spreadRadius: 2,
                          blurRadius: 4,
                          offset: const Offset(0, 2))
                    ],
                    borderRadius: BorderRadius.all(
                        Radius.circular(_canChangeShape ? _adjustableCornerRadius : _staticCornerRadius))),
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
                      radius: _adjustableCornerRadius,
                      // label: _adjustableCornerRadius.round().toString(),
                      onChanged: (_newRadius) => context.read<SetupIcon>().setRadius(_newRadius)),
                  const Icon(CommunityMaterialIcons.circle_outline, color: Color(0x80808080)),
                ],
              ),
            )
          else
            const SizedBox(height: 48),
          ...[
            AdaptiveButton(
                text: S.of(context).devicePreview,
                onPressed: () => (_isAdaptive && (!_haveAdaptiveAssets && _adaptiveColorNotSet))
                    ? null
                    : context.read<SetupIcon>().devicePreview()),
            if (_isAdaptive) AdaptiveIconButtons(withAdaptives: _haveAdaptiveAssets),
            // else
            // SizedBox(height: _portrait ? 0 : 20),
            // if (_isAdaptive) const SizedBox(height: 44) else const SizedBox(height: 64),
            if (_isAdaptive && _haveAdaptiveForeground)
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
  final bool _isAdaptive, _isPortrait, _pwaIcon;

  const _Setup({@required bool isAdaptive, @required bool isPortrait, @required bool pwaIcon, Key key})
      : _isAdaptive = isAdaptive,
        _isPortrait = isPortrait,
        _pwaIcon = pwaIcon,
        super(key: key);

  @override
  Widget build(BuildContext context) {
    final ThemeData _materialTheme = context.select((UserInterface ui) => ui.materialTheme);
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final Color _adpativeColor = context.select((SetupIcon icon) => icon.adaptiveColor);
    final bool _haveAdaptiveBackground = context.select((SetupIcon icon) => icon.haveAdaptiveBackground);
    final bool _preferColorBg = context.select((SetupIcon icon) => icon.preferColorBg);
    final bool _colorNotSet = _backgroundColor == null;
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
                    top: (_preferColorBg && !_isPortrait)
                        ? (UserInterface.isApple ? 62 : 72)
                        : (UserInterface.isApple ? (_haveAdaptiveBackground ? 36 : 10) : 4)),
                child: Text(S.of(context).uploadAdaptiveBg)),
            if (_preferColorBg)
              ColorPicker(
                  // labelTextStyle: _materialTheme.sliderTheme.valueIndicatorTextStyle,
                  pickerAreaHeightPercent: 0.84,
                  pickerColor: _adpativeColor ?? (_backgroundColor ?? _materialTheme.accentColor),
                  onColorChanged: (_newColor) => context.read<SetupIcon>().setAdaptiveColor(_newColor),
                  displayThumbColor: true,
                  portraitOnly: true,
                  showLabel: !UserInterface.isApple)
            else
              const Hero(tag: 'global', child: DragAndDrop(background: true)),
            SizedBox(
                height: _preferColorBg
                    ? 0
                    : UserInterface.isApple
                        ? 10
                        : _haveAdaptiveBackground
                            ? 10
                            : 43),
            AdaptiveSwitch(
                title: S.of(context).colorAsBg,
                value: _preferColorBg,
                onChanged: (_preferColor) => context.read<SetupIcon>().switchBg(preferColor: _preferColor))
          ] else ...[
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(_pwaIcon ? S.of(context).pwaColor : S.of(context).iconBgColor)),
            ColorPicker(
                // labelTextStyle: _materialTheme.chipTheme.labelStyle,
                pickerAreaHeightPercent: 0.84,
                pickerColor: _colorNotSet ? _materialTheme.accentColor : _backgroundColor,
                onColorChanged: (_newColor) => context.read<SetupIcon>().setBackgroundColor(_newColor),
                displayThumbColor: true,
                portraitOnly: true,
                enableAlpha: false, //TODO: Consider change to _supportTransparency sometime later.
                showLabel: !UserInterface.isApple),
          ],
          if (!_colorNotSet && !_isAdaptive)
            AdaptiveButton(
                destructive: true,
                text: S.of(context).removeColor,
                // color: _backgroundColor,
                onPressed: () => context.read<SetupIcon>().removeColor())
          else if (_colorNotSet && !_isAdaptive)
            const SizedBox(height: 27),
          if (!_preferColorBg && _isAdaptive && _haveAdaptiveBackground)
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

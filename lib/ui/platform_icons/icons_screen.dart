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
  final String name, devicePicture;
  final IconData icon;

  const IconPreview(this.platformID, this.name, this.icon, this.devicePicture, {Key key, this.cornerRadius})
      : super(key: key);

  const IconPreview.oldAndroid()
      : cornerRadius = 0,
        platformID = 0,
        name = 'Android',
        icon = Icons.android_outlined,
        devicePicture = 'svg/nokia.svg';

  const IconPreview.newAndroid()
      : cornerRadius = 800,
        platformID = 1,
        name = 'Android 8+',
        icon = CommunityMaterialIcons.android,
        devicePicture = 'svg/pixel.svg';

  const IconPreview.iOS()
      : cornerRadius = 53,
        platformID = 2,
        name = 'iOS',
        icon = CommunityMaterialIcons.apple_ios,
        devicePicture = 'svg/iphone.svg';

  const IconPreview.web()
      : cornerRadius = 0,
        platformID = 3,
        name = 'Web',
        icon = CommunityMaterialIcons.google_chrome,
        devicePicture = 'svg/chrome.svg';

  const IconPreview.windows()
      : cornerRadius = 0,
        platformID = 4,
        name = 'Windows',
        icon = CommunityMaterialIcons.microsoft_windows,
        devicePicture = 'svg/surface.svg';

  const IconPreview.macOS()
      : cornerRadius = 0,
        platformID = 5,
        name = 'macOS',
        icon = CommunityMaterialIcons.apple,
        devicePicture = 'svg/macbook.svg';

  // const IconPreview.linux()
  //     : cornerRadius = 0,
  //       platformID = 6,
  //       name = 'Linux',
  //       icon = CommunityMaterialIcons.linux,
  //       devicePicture = 'svg/ubuntu.svg';

  // const IconPreview.fuchsiaOS()
  //     : cornerRadius = 0,
  //       platformID = 7,
  //       name = 'Fuchsia',
  //       icon = CommunityMaterialIcons.linux,
  //       devicePicture = 'svg/ubuntu.svg';

  double get _staticCornerRadius => cornerRadius.toDouble();

  bool get _canChangeShape => platformID <= 1;

  bool get _isAdaptive => platformID == 1;

  bool get _supportTransparency => platformID != 2;

  static const Color _pickColor = Color(0xFF418183);

  @override
  Widget build(BuildContext context) {
    final double _androidCornerRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final Color _adpativeColor = context.select((SetupIcon icon) => icon.adaptiveColor);
    final bool _haveAdaptiveBackground = context.select((SetupIcon icon) => icon.haveAdaptiveBackground);
    final bool _haveAdaptiveForeground = context.select((SetupIcon icon) => icon.haveAdaptiveForeground);
    final bool _preferColorBg = context.select((SetupIcon icon) => icon.preferColorBg);
    final bool _colorNotSet = _backgroundColor == null;
    final bool _adaptiveColorNotSet = _adpativeColor == null;
    final bool _portrait = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;
    final bool _haveAdaptiveAssets = _haveAdaptiveBackground && _haveAdaptiveForeground;

    return PreviewLayout(
      portraitOrientation: _portrait,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Text(_canChangeShape
                    ? (_haveAdaptiveForeground ? S.of(context).previewShapes : S.of(context).uploadAdaptiveFg)
                    : S.of(context).iconPreview)),
            if (!_haveAdaptiveForeground && _isAdaptive)
              _haveAdaptiveBackground
                  ? Stack(children: [
                      Container(
                          clipBehavior: Clip.hardEdge,
                          height: 300,
                          width: 300,
                          decoration: const BoxDecoration(
                              color: Colors.grey, borderRadius: BorderRadius.all(Radius.circular(25))),
                          child: const Opacity(opacity: 0.5, child: AdaptiveIcon())),
                      const DragAndDrop(foreground: true)
                    ])
                  : const DragAndDrop(foreground: true)
            else
              GestureDetector(
                onTap: context.watch<SetupIcon>().devicePreview,
                child: Container(
                  clipBehavior: Clip.hardEdge,
                  height: 300,
                  width: 300,
                  decoration: BoxDecoration(
                      color: Colors.grey,
                      borderRadius: BorderRadius.all(
                          Radius.circular(_canChangeShape ? _androidCornerRadius : _staticCornerRadius))),
                  child: _isAdaptive
                      ? const Hero(tag: 'adaptive', child: AdaptiveIcon())
                      : Hero(tag: 'regular', child: RegularIcon(supportTransparency: _supportTransparency)),
                ),
              ),
            if (_canChangeShape)
              SizedBox(
                width: 292,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Icon(CommunityMaterialIcons.square_outline),
                    AdaptiveSlider(
                        value: _androidCornerRadius,
                        // label: _androidCornerRadius.round().toString(),
                        onChanged: (_newRadius) => context.read<SetupIcon>().setRadius(_newRadius)),
                    const Icon(CommunityMaterialIcons.circle_outline),
                  ],
                ),
              )
            else
              const SizedBox(height: 48),
            ...[
              AdaptiveButton(
                  text: S.of(context).devicePreview,
                  onPressed: (_isAdaptive && (!_haveAdaptiveAssets && _adaptiveColorNotSet))
                      ? null
                      : context.watch<SetupIcon>().devicePreview),
              if (!_colorNotSet && !_isAdaptive)
                AdaptiveButton(
                    text: S.of(context).removeColor,
                    color: _backgroundColor,
                    onPressed: () => context.read<SetupIcon>().removeColor())
              else
                _isAdaptive
                    ? AdaptiveIconButtons(withAdaptives: _haveAdaptiveAssets)
                    : SizedBox(height: _portrait ? 0 : 56),
              // if (_isAdaptive) const SizedBox(height: 44) else const SizedBox(height: 64),
              if (_isAdaptive && _haveAdaptiveForeground)
                AdaptiveButton(
                    text: S.of(context).removeForeground,
                    destructive: true,
                    onPressed: () => context.read<SetupIcon>().removeadaptiveForeground()),
            ]
          ],
        ),
        SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (_isAdaptive) ...[
                Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Text(S.of(context).uploadAdaptiveBg)),
                if (_preferColorBg)
                  ColorPicker(
                      pickerAreaHeightPercent: 0.86,
                      pickerColor: _adpativeColor ?? (_backgroundColor ?? _pickColor),
                      onColorChanged: (_newColor) => context.read<SetupIcon>().setAdaptiveColor(_newColor),
                      displayThumbColor: true,
                      portraitOnly: true,
                      enableAlpha: true,
                      showLabel: !UserInterface.isApple)
                else
                  const Hero(tag: 'global', child: DragAndDrop(background: true)),
                SizedBox(height: _preferColorBg ? 0 : 16),
                AdaptiveSwitch(
                    text: S.of(context).colorAsBg,
                    value: _preferColorBg,
                    onChanged: (_value) => context.read<SetupIcon>().switchBg(newValue: _value))
              ] else ...[
                Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Text(S.of(context).iconBgColor)),
                ColorPicker(
                    pickerColor: _colorNotSet ? _pickColor : _backgroundColor,
                    onColorChanged: (_newColor) => context.read<SetupIcon>().setBackgroundColor(_newColor),
                    displayThumbColor: true,
                    portraitOnly: true,
                    enableAlpha: false, //TODO: Change to _supportTransparency sometime later.
                    showLabel: !UserInterface.isApple),
              ],
              const SizedBox(height: 48),
              if (!_preferColorBg && _isAdaptive && _haveAdaptiveBackground)
                AdaptiveButton(
                    text: S.of(context).removeBackground,
                    destructive: true,
                    onPressed: () => context.read<SetupIcon>().removeAdaptiveBackground()),
            ],
          ),
        ),
      ],
    );
  }
}

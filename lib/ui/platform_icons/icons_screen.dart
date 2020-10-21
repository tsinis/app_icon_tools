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
        devicePicture = 'platform_svgs/nokia.svg';

  const IconPreview.newAndroid()
      : cornerRadius = 800,
        platformID = 1,
        name = 'Android 8+',
        icon = CommunityMaterialIcons.android,
        devicePicture = 'platform_svgs/pixel.svg';

  const IconPreview.iOS()
      : cornerRadius = 53,
        platformID = 2,
        name = 'iOS',
        icon = CommunityMaterialIcons.apple_ios,
        devicePicture = 'platform_svgs/iphone.svg';

  const IconPreview.web()
      : cornerRadius = 0,
        platformID = 3,
        name = 'Web',
        icon = CommunityMaterialIcons.google_chrome,
        devicePicture = 'platform_svgs/chrome.svg';

  const IconPreview.windows()
      : cornerRadius = 0,
        platformID = 4,
        name = 'Windows',
        icon = CommunityMaterialIcons.microsoft_windows,
        devicePicture = 'platform_svgs/surface.svg';

  const IconPreview.macOS()
      : cornerRadius = 0,
        platformID = 5,
        name = 'macOS',
        icon = CommunityMaterialIcons.apple,
        devicePicture = 'platform_svgs/macbook.svg';

  // const IconPreview.linux()
  //     : cornerRadius = 0,
  //       platformID = 6,
  //       name = 'Linux',
  //       icon = CommunityMaterialIcons.linux,
  //       devicePicture = 'platform_svgs/ubuntu.svg';

  // const IconPreview.fuchsiaOS()
  //     : cornerRadius = 0,
  //       platformID = 7,
  //       name = 'Fuchsia',
  //       icon = CommunityMaterialIcons.linux,
  //       devicePicture = 'platform_svgs/ubuntu.svg';

  double get _staticCornerRadius => cornerRadius.toDouble();

  bool get _canChangeShape => platformID <= 1;

  bool get _isAdaptive => platformID == 1;

  bool get _supportTransparency => platformID != 2;

  static const Color _pickColor = Color(0xFF418183);

  @override
  Widget build(BuildContext context) {
    final double _androidCornerRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool _haveAdaptiveBackground = context.select((SetupIcon icon) => icon.haveAdaptiveBackground);
    final bool _haveAdaptiveForeground = context.select((SetupIcon icon) => icon.haveAdaptiveForeground);
    final bool _colorNotSet = _backgroundColor == null;
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
                  onPressed: (_isAdaptive && !_haveAdaptiveAssets) ? null : context.watch<SetupIcon>().devicePreview),
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
            ]
          ],
        ),
        Column(
          children: [
            if (_isAdaptive) ...[
              Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Text(S.of(context).uploadAdaptiveBg)),
              const Hero(tag: 'global', child: DragAndDrop(background: true))
            ] else ...[
              Padding(padding: const EdgeInsets.symmetric(vertical: 20), child: Text(S.of(context).iconBgColor)),
              SizedBox(
                width: 300,
                child: ColorPicker(
                    pickerColor: _colorNotSet ? _pickColor : _backgroundColor,
                    onColorChanged: (_newColor) => context.read<SetupIcon>().setBackgroundColor(_newColor),
                    displayThumbColor: true,
                    portraitOnly: true,
                    enableAlpha: false, //TODO: Change to _supportTransparency sometime later.
                    showLabel: !UserInterface.isApple),
              ),
            ],
            const SizedBox(height: 48),
            if (_isAdaptive && (_haveAdaptiveBackground || _haveAdaptiveForeground))
              AdaptiveButton(
                  text: _haveAdaptiveBackground ? S.of(context).removeBackground : S.of(context).removeForeground,
                  destructive: true,
                  onPressed: () => _haveAdaptiveBackground
                      ? context.read<SetupIcon>().removeAdaptiveBackground()
                      : context.read<SetupIcon>().removeadaptiveForeground()),
          ],
        ),
      ],
    );
  }
}

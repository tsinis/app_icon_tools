import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import '../../models/user_interface.dart';
import '../widgets/adaptive/buttons/button.dart';
import '../widgets/adaptive/buttons/icon_button.dart';
import '../widgets/adaptive/slider.dart';
import '../widgets/drag_and_drop.dart';
import '../widgets/layout.dart';
import 'icon.dart';

class IconPreview extends StatelessWidget {
  final int cornerRadius, platformID;
  final String name, devicePicture;
  final IconData icon;

  const IconPreview(this.platformID, this.name, this.icon, this.devicePicture, {Key key, this.cornerRadius})
      : super(key: key);

  const IconPreview.newAndroid({this.cornerRadius})
      : platformID = 0,
        name = 'Android',
        icon = Icons.android_outlined,
        devicePicture = 'platform_svgs/nexus.svg';

  const IconPreview.oldAndroid({this.cornerRadius})
      : platformID = 1,
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
        devicePicture = 'platform_svgs/nexus.svg';

  const IconPreview.windows()
      : cornerRadius = 0,
        platformID = 4,
        name = 'Windows',
        icon = CommunityMaterialIcons.microsoft_windows,
        devicePicture = 'platform_svgs/pixel.svg';

  const IconPreview.macOS()
      : cornerRadius = 0,
        platformID = 5,
        name = 'macOS',
        icon = CommunityMaterialIcons.apple,
        devicePicture = 'platform_svgs/macbook.svg';

  const IconPreview.linux()
      : cornerRadius = 0,
        platformID = 6,
        name = 'Linux',
        icon = CommunityMaterialIcons.linux,
        devicePicture = 'platform_svgs/iphone.svg';

  // const IconPreview.fuchsiaOS()
  //     : cornerRadius = 20,
  //       platformID = 7,
  //       name = 'Fuchsia',
  //       icon = CommunityMaterialIcons.linux,
  //       devicePicture = 'platform_svgs/iphone.svg';

  double get _staticCornerRadius => cornerRadius.toDouble();

  bool get _canChangeShape => cornerRadius == null;

  bool get _isAdaptive => platformID == 1;

  bool get _supportTransparency => platformID != 2;

  static const Color _pickColor = Color(0xFF418183);

  @override
  Widget build(BuildContext context) {
    final double _androidCornerRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool _haveAdaptiveBackground = context.select((SetupIcon icon) => icon.haveAdaptiveBackground());
    final bool _colorNotSet = _backgroundColor == null;
    final bool _portrait = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;

    return PreviewLayout(
      portraitOrientation: _portrait,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(_canChangeShape ? 'Preview possible shapes' : 'Icon Preview'),
            Container(
              clipBehavior: Clip.hardEdge,
              height: 300,
              width: 300,
              decoration: BoxDecoration(
                  color: Colors.grey,
                  borderRadius:
                      BorderRadius.all(Radius.circular(_canChangeShape ? _androidCornerRadius : _staticCornerRadius))),
              child: IconWithShape(supportTransparency: _supportTransparency, adaptiveIcon: platformID == 1),
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
              if (!_colorNotSet && !_isAdaptive)
                AdaptiveButton(
                    text: 'Remove Color',
                    color: _backgroundColor,
                    onPressed: () => context.read<SetupIcon>().removeColor())
              else if (_isAdaptive)
                ButtonBar(
                  buttonAlignedDropdown: false,
                  alignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if (_haveAdaptiveBackground)
                      AdaptiveButton(
                          text: 'Remove Background',
                          destructive: true,
                          onPressed: () => context.read<SetupIcon>().removeAdaptiveBackground()),
                    AdaptiveIconButton(
                        withAdaptiveBackground: _haveAdaptiveBackground,
                        onPressed: () => print('Testing Adaptive Background')), //TODO Add Adaptive animation.
                  ],
                )
              else
                const SizedBox(height: 72)
            ]
          ],
        ),
        if (_isAdaptive)
          Column(children: const [Text(''), Hero(tag: 'global', child: DragAndDrop(background: true))])
        else
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text('Icon Background Color'),
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
          ),
      ],
    );
  }
}

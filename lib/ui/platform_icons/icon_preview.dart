import 'package:community_material_icon/community_material_icon.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:provider/provider.dart';

import '../../models/setup_icon.dart';
import '../../models/user_interface.dart';
import '../widgets/adaptive/alert_dialog.dart';
import '../widgets/adaptive/button.dart';
import '../widgets/adaptive/slider.dart';
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

  bool get _isAdaptive => platformID == 0;

  bool get _supportTransparency => platformID != 2;

  static const Color _pickColor = Color(0xFF418183);

  @override
  Widget build(BuildContext context) {
    final double _androidCornerRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    final bool _colorNotSet = _backgroundColor == null;
    final bool _portrait = MediaQuery.of(context).size.height > MediaQuery.of(context).size.width;

    return PreviewLayout(portraitOrientation: _portrait, children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (_canChangeShape) const Text('Preview possible shapes') else const SizedBox(height: 20),
          Container(
            clipBehavior: Clip.hardEdge,
            height: 300,
            width: 300,
            decoration: BoxDecoration(
                color: Colors.grey,
                borderRadius:
                    BorderRadius.all(Radius.circular(_canChangeShape ? _androidCornerRadius : _staticCornerRadius))),
            child: IconWithShape(supportTransparency: _supportTransparency),
          ),
          if (_canChangeShape)
            SizedBox(
              width: 240,
              child: AdaptiveSlider(
                  value: _androidCornerRadius,
                  // label: _androidCornerRadius.round().toString(),
                  onChanged: (_newRadius) => context.read<SetupIcon>().setRadius(_newRadius)),
            )
          else
            const SizedBox(height: 42),
          ...[
            AdaptiveButton(
                text: 'Remove Color', color: _backgroundColor, onPressed: () => context.read<SetupIcon>().removeColor())
          ]
        ],
      ),
      // if (!_portrait) ...[
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
                  showLabel: !UserInterface.isApple)),
        ],
      )
    ]
        // else
        //   Container(
        //     // padding: const EdgeInsets.only(bottom: 10),
        //     height: 72,
        //     width: 240,
        //     color: Colors.transparent,
        //     child: AdaptiveButton(
        //       text: 'Background',
        //       onPressed: () {
        //         if (_isAdaptive) {
        //           print('Adaptive Background Pressed'); //TODO Add Adaptive Background func.
        //         } else {
        //           if (_colorNotSet) {
        //             context.read<SetupIcon>().setBackgroundColor(_pickColor);
        //           }
        //           showDialog<void>(
        //             barrierDismissible: true,
        //             context: context,
        //             builder: (context) => SingleChildScrollView(
        //               child: AdaptiveDialog(
        //                 title: 'Icon Background Color',
        //                 leftButton: 'Remove',
        //                 rightButton: 'OK',
        //                 onPressedLeft: () => context.read<SetupIcon>().removeColor(),
        //                 onPressedRight: () => Navigator.pop(context),
        //                 content: _PickColor(
        //                     colorNotSet: _colorNotSet, pickColor: _pickColor, backgroundColor: _backgroundColor),
        //               ),
        //             ),
        //           );
        //         }
        //       },
        //     ),
        //   ),
        // ]
        );
  }
}

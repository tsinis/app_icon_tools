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
import 'transparency_grid.dart';

class IconPreview extends StatelessWidget {
  final int cornerRadius, platformID;
  final String name;
  final IconData icon;

  const IconPreview(this.platformID, this.name, this.icon, {Key key, this.cornerRadius}) : super(key: key);

  const IconPreview.newAndroid({this.cornerRadius})
      : platformID = 0,
        name = 'Android',
        icon = Icons.android_outlined;

  const IconPreview.oldAndroid({this.cornerRadius})
      : platformID = 1,
        name = 'Android 8+',
        icon = CommunityMaterialIcons.android;

  const IconPreview.iOS()
      : cornerRadius = 39,
        platformID = 2,
        name = 'iOS',
        icon = CommunityMaterialIcons.apple_ios;

  const IconPreview.web()
      : cornerRadius = 0,
        platformID = 3,
        name = 'Web',
        icon = CommunityMaterialIcons.google_chrome;

  const IconPreview.windows()
      : cornerRadius = 0,
        platformID = 4,
        name = 'Windows',
        icon = CommunityMaterialIcons.microsoft_windows;

  const IconPreview.linux()
      : cornerRadius = 0,
        platformID = 5,
        name = 'Linux',
        icon = CommunityMaterialIcons.linux;

  const IconPreview.macOS()
      : cornerRadius = 0,
        platformID = 6,
        name = 'macOS',
        icon = CommunityMaterialIcons.apple;

  // const IconPreview.fuchsiaOS()
  //     : cornerRadius = 20,
  //       platformID = 7,
  //       name = 'Fuchsia';

  double get _staticCornerRadius => cornerRadius.toDouble();

  bool get _canChangeShape => cornerRadius == null;

  bool get _isAdaptive => platformID == 0;

  bool get _supportTransparency => platformID != 2;

  @override
  Widget build(BuildContext context) {
    final double _androidCornerRadius = context.select((SetupIcon icon) => icon.cornerRadius);
    final Color _backgroundColor = context.select((SetupIcon icon) => icon.backgroundColor);
    return Wrap(
        direction: Axis.vertical,
        crossAxisAlignment: WrapCrossAlignment.center,
        alignment: WrapAlignment.center,
        children: [
          Column(
            mainAxisSize: MainAxisSize.min,
            children: [
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
              Container(
                clipBehavior: Clip.hardEdge,
                height: 220,
                width: 220,
                decoration: BoxDecoration(
                    color: Colors.grey,
                    borderRadius: BorderRadius.all(
                        Radius.circular(_canChangeShape ? _androidCornerRadius : _staticCornerRadius))),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    const TransparencyGrid(),
                    Container(
                        color: (_backgroundColor == null)
                            ? _supportTransparency
                                ? Colors.transparent
                                : Colors.black
                            : _backgroundColor,
                        child: context.watch<SetupIcon>().icon)
                  ],
                ),
              )
            ],
          ),
          Container(
            padding: const EdgeInsets.only(bottom: 10),
            height: 72,
            width: 240,
            color: Colors.transparent,
            child: AdaptiveButton(
              text: 'Background',
              onPressed: () => _isAdaptive
                  ? context.read<SetupIcon>().goTo(3)
                  : showDialog<void>(
                      barrierDismissible: true,
                      context: context,
                      builder: (context) => SingleChildScrollView(
                        child: AdaptiveDialog(
                          title: 'Icon Background Color',
                          leftButton: 'Remove',
                          // rightButton: 'Add Background',
                          onPressedLeft: () => context.read<SetupIcon>().removeColor(),
                          // onPressedRight: () => print('Pressed Right Button'),
                          content: ColorPicker(
                              pickerColor: const Color(0xFF000000),
                              onColorChanged: (_newColor) => context.read<SetupIcon>().setBackgroundColor(_newColor),
                              pickerAreaHeightPercent: 0.8,
                              displayThumbColor: true,
                              portraitOnly: UserInterface.isApple,
                              enableAlpha: false, //TODO: Change to _supportTransparency sometime later.
                              showLabel: !UserInterface.isApple),
                        ),
                      ),
                    ),
            ),
          ),
        ]);
  }
}
